#!/usr/bin/env python3
"""
Layouts of the four lna_core sub-blocks, drawn after layout/floorplan/lna_core_floorplan.svg:

  lna_core_input_match.gds   xschem/lna_core_input_match.sch   XLEQ coil, C15 (series)
  lna_core_cg.gds            xschem/lna_core_cg.sch            M1 (+M3 dummies), R3, C3 (4x), XL1 + XLD4 coils, C2, R4
  lna_core_cs.gds            xschem/lna_core_cs.sch            M3 (+M5 dummies), M2 (+M4D dummies), XLD2 coil
  lna_core_output_match.gds  xschem/lna_core_output_match.sch  C1 (series), XLSHUNT_OUT coil

Run:  klayout -b -r make_lna_core_layouts.py          (all cells; main vs main_pex is which xschem files are
                                                        checked out -- see the main_layout / main_pex_layout
                                                        branches -- not a runtime flag)
      klayout -b -r make_lna_core_layouts.py -rd cells=cg,cs

All four cells share one coordinate system: the core (devices, from layout/floorplan/lna_core_floorplan, rf_in west,
rf_out north) keeps the coordinates of that floorplan, the macro spans x 0..MACRO_W, y Y_S..Y_N around it
(lna_core_parts moves it to (0, 0)).

Inductors: the team's EM-characterised coils (klayout/*_coil.gds, see COILS; schematic: *_model.sym instances X<name>),
cells <block>__<name>, placed around the core; their EM port bracket is dropped (lna_lib.coil).
RS_EQ1 (0.05 ohm, ideal res.sym) is a parasitic model of the simulation -> no layout, M3 source = vss.
Ideal capa.sym capacitors (C15 / C1 of the input / output match) are drawn as MIM caps of the same value.

Device type and size come from the schematics (M1, M2 + dummies: nfet_05v0 L=0.6u, 5V device with V5_XTOR marker).
"""
import json
import math
import os
import re
import sys

import pya

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import lna_lib as lib  # noqa: E402
from lna_lib import Cell, g, tbox  # noqa: E402

XSCHEM = os.path.join(HERE, "..", "xschem")

# ---------------------------------------------------------------- schematic values (read only)


def sch_params(sch):
    """{name: (symbol, {param: value})} of every instance of xschem/<sch>.sch"""
    out = {}
    txt = open(os.path.join(XSCHEM, sch + ".sch")).read()
    for sym, body in re.findall(r"^C \{([^}]*)\}[^{]*\{(.*?)\}", txt, re.S | re.M):
        p = dict(re.findall(r"(\w+)=(\S+)", body))
        if "name" in p:
            out[p["name"]] = (os.path.basename(sym)[:-4], p)
    return out


def um(v):
    return float(v[:-1]) if v.endswith("u") else float(v) * 1e6


def um_grid(v):
    """MIM W/L from the schematic rounded to 10 nm: values like 34.7078u are off the 5 nm grid, and the PDK cap_mim
    PCell (gdsfactory) rounds the plate to 10 nm anyway (58.215 -> 58.22); dC < 0.03 %"""
    return round(um(v), 2)


def series_cap(sch):
    """name of the (single) ideal capa.sym capacitor of a match block"""
    (cn,) = [n for n, (sym, _) in sch.items() if sym == "capa"]
    return cn


def cap_side(c_pf, w=None):
    """MIM plate (w, l) in um (10 nm grid) for an ideal capacitor value; square unless w is given"""
    if w is None:
        lo, hi = 1.0, 100.0
        for _ in range(60):
            mid = (lo + hi) / 2
            lo, hi = (mid, hi) if lib.c_mim_pf(mid, mid) < c_pf else (lo, mid)
        return round(lo, 2), round(lo, 2)
    l = (c_pf * 1000 - 0.2383 * 2 * w) / (1.99 * w + 0.2383 * 2)
    return w, round(l, 2)


def pf(v):
    return float(v[:-1]) if v.endswith("p") else float(v) * 1e12


# floorplan: coils, macro edges (core coordinates, see module doc)
SP_KO = 10.0  # keep-out around every inductor not yet converted to a coil_guard_ring() (see RING_SP/RING_W)
RING_SP, RING_W = 1.0, 2.0  # coil_guard_ring()'s own real clearance + wall thickness (pilot: LEQ only, see
# build_input_match) -- replaces SP_KO's empirical 10um margin with a real, grid-compliant vss ring a supply
# tile can directly abut (zero-gap, same net) instead of an empty keep-out. sp=1.0 is comfortably above the
# GF180 deck's own M#.2a min-space (0.23-0.28um per layer) with margin for the coil's own underpass bracket;
# w=2.0 is wide enough for a real Via2/Via3 cut row. Both numbers are provisional until verified against the
# real DRC/LVS deck (see check_lna_core_layouts.py) -- bisect upward, never assume.
RING_KO = RING_SP + RING_W  # total effective keep-out once a coil has its own ring (replaces SP_KO in that
# coil's own fit-assert)
COILS = {("lna_core_input_match", "LEQ"): "LEQ_coil.gds", ("lna_core_cg", "L1"): "L1_RECT_coil.gds",
         ("lna_core_cg", "LD4"): "LD4_RECT_coil.gds", ("lna_core_cs", "LD2"): "LD2_coil.gds",
         ("lna_core_output_match", "LSHUNT_OUT"): "LSHUNT_OUT_RECT_coil.gds"}
# MACRO_W history: 1204 (original) -> 1434 (commit cc900b6, LEQ_MAIN_RECT's reshape pushed the chain further east)
# -> 1186 (L1_RECT + LEQ_MAIN_RECT2 jointly reshaped, see commit 76a36b3) -> 1070, the full 1070x1070 budget, via
# two more changes, neither a coil reshape alone:
#  1. LD4's own dedicated vdd lead (a fixed column, VDD4_X=(1158,1168), run all the way to the east rail) was
#     replaced with a short local lead off its own port -- VDD4_X was pinning MACRO_W >= 1185 on its own,
#     independent of any coil size (see build_cg's LD4 section).
#  2. LD4 itself reshaped rectangular (LD4_RECT_coil.gds: N=3/W=2/SC2 drain-coil family, distinct from the
#     N=2/W=26 spiral family LEQ/L1/LSHUNT_OUT share -- same tooling pattern generalised to it this session,
#     see /foss/designs/rapidpassives/try4/newflow/good_tries/LD4_RECT_CAND1_X216.0_Y93.0_N3_W2_SC2/), world-X
#     half-extent (local ry, since rot=90 swaps axes) shrunk 166 -> 109, world-Y half-extent (local rx) grown
#     166 -> 232 to conserve the 8.44nH target (L=8.4824nH confirmed, +0.50%). This brought LD4's own east edge
#     from 1151 down to 1037, under LSHUNT_OUT_RECT's own 1044 -- LSHUNT_OUT_RECT is now the sole binding
#     constraint on MACRO_W (its own "does not fit the macro width" assert requires MACRO_W >= ~1068.5).
# Removing LD4's old dedicated vdd column also broke a different thing: a separate enclosed tile group ("group B"
# in make_lna_core_parts.py's build_supply()) tapped its own vdd connection by landing a Metal3-5 via stack near
# that column's path, which incidentally guaranteed a real rail connection. Without the column, nothing near LD4
# is actually rail-connected, and landing a fresh via stack anywhere nearby ties straight into a vss M4 plane
# (either LD4_RECT's own SC2 shunt trace, M4 the whole way around its ring, or the east ring band's own M4) --
# see build_supply()'s own comment at that site for the full story and the fix (a plain M5-only bridge, no via,
# landing in the one M4-clear window between the coil and the ring).
MACRO_W, RING = 1100, 12  # grown from 1062 for the re-floorplan's LSHUNT_OUT SE relocation: the corridor east of
# L1's own east edge (779) to the old east edge was only 251um wide, 31um short of LSHUNT_OUT_RECT's own 282um
# diameter at rot=270 (ports south, axes swapped: world-X extent = local ry = 141). Tightened to 1100 (inductor-
# resize pass, SP_KO-based: 1098 exact minimum + 2um margin). Tried 1093 (RING_KO-based, once LSHUNT_OUT got its
# own coil_guard_ring(): its own "does not fit the east edge" assert drops to 1091) and reverted -- a NEW real
# DRC violation appeared (V2.1/V2.2a/V2.2b/V3.1/V3.2a/V3.2b, ~lna_core_supply's own Metal3-island construction
# at the SE corner, nowhere near LSHUNT_OUT itself (y~-367, LSHUNT_OUT is at cy=-30) -- a separate sensitivity
# of make_lna_core_parts.py's 40um island grid to the exact MACRO_W value, not something this coil's own ring
# touches. 1100 stays the safe, verified value; tightening further needs that island-grid interaction debugged
# on its own, not folded into the guard-ring plan. No pitch-grid alignment constraint on MACRO_W (unlike
# Y_N/Y_S): make_lna_core_parts.py's X tiling is flush with the WEST band only (GX0=RING fixed), the east side
# is just a floor-divided remainder, no analog of GY0's own "floor to the north band" trick.
Y_S, Y_N = -373, 751  # south edge grown from -353 (kept pitch-aligned: (Y_N-Y_S-2*RING) mod 20 == 0) for the same
# re-floorplan: LSHUNT_OUT's long rf_out return lead needs a clear east-west channel south of both its own and
# L1's keep-outs (L1 south edge -318, LSHUNT_OUT's own ~-326 at its new site) -- see LSH_CHANNEL_Y below.
# main_pex: bumped from main_layout's ported 731 -- main_pex's own output series cap
# (lna_core_output_match.sch) is larger than main's, needing more LSHUNT_OUT port clearance (q1_min_y). See LSH_CY below.
# reshaped rectangular (LSHUNT_OUT_RECT_coil.gds, same 2.5041nH target, ry 211.295 -> 141, rx -> 296 -- it was
# the sole remaining driver of the macro's Y-direction overflow, sitting almost exactly against the old
# Y_N=851 with ~0.7um margin). LSH_CY re-centred (602 -> 532) for the new ry.
#
# 751, not the 711 LSHUNT_OUT's OWN fit alone would allow: once LSHUNT_OUT stopped being the binding
# constraint, LD2 (lna_core_cs, square, untouched, ry=108.5) became the new one -- its own "LD2 does not fit"
# assert (cy + ry + SP_KO + RING <= Y_N, cy=LD2_CY=600 fixed by its own bias-lead keep-outs, ~6.5um of
# south-ward slack only, not enough to matter) needs Y_N >= 745.5, which rounds up to the nearest
# pitch-aligned value (Y_N mod 20 == 11, same tile-grid alignment constraint as commit 30e895b) of 751.
# (Y_N - Y_S) = 1104 -- back to this project's ORIGINAL pre-reshape height (coincidentally), still over the
# 1070 budget by 34um. Reshaping LD2 itself (same technique, different ~4.30nH target) is the next lever if
# this needs to go lower -- not attempted here. MACRO_W=1186 (116um over 1070, see its own comment above) is
# now the more binding dimension of the two either way.
# sitting almost exactly as tight against the north ring as it can (0.7 um margin on each side of its own Y-band)
# -- this is the pre-existing (independent of the LEQ/L1 work) Y overflow's root cause: LSHUNT_OUT cannot be
# reshaped (lna_core_output_match keeps the original square coil, per the task), so Y_N cannot be reduced below
# ~850 without restructuring lna_core_cg's internal C3/vm2 trace layout (out of scope here). Y_S: moved from -253
# to -345 (92 um more negative) to give L1 (and, to a lesser extent, LEQ) the extra world-Y room their X-shrinking
# reshape needs (see MACRO_W comment above), including L1's own one-iteration EM correction (outer_half_x 239.5 ->
# 244.5, to hit 2.5041nH within 0.07% instead of the first guess's 2.2% miss -- see L1_RECT_coil.gds's generation
# notes). This is the direct cost of the X-fix, and the reason (Y_N - Y_S) does not also land at <=1070: fixing X
# this way inherently costs Y headroom.
#
# -353 (not -345) specifically: make_lna_core_parts.py's tile grid is built top-down from Y_N (GY0 floors to the
# nearest 20 um pitch from the north band), so (Y_N - Y_S - 2*RING) landing on an exact multiple of the 20 um
# pitch is what makes the grid's southernmost row coincide with the south ring's own inner edge (Y_S + RING) --
# at -345 it does not (12 um remainder), which silently broke every tile group's "touches the south rail" check
# (groups() / touches_rail() in make_lna_core_parts.py) for the ENTIRE south portion of the macro -- confirmed by
# directly inspecting the built lna_core_parts.gds: only 500 of 1130 free sites got tiles, with real tiles
# starting no further south than y=249 (i.e. nothing at all below that, where L1 and LEQ now live, losing both
# decoupling coverage and the supply-tile fabric the grid-connection work depends on). -353 is the nearest
# pitch-aligned value that is still negative enough for L1's own fit assert to hold (-333 is the nearest aligned
# value overall, but L1 does not fit there) -- confirmed via the same "regenerate, let the assert catch it"
# empirical loop used throughout this file: regenerating at -353 restores tiles down to y=-331, 755 of the same
# 1130 free sites kept (vs. 500), and the "groups_dropped" list returns to its normal small entries (~20/12/4/4/4
# sites) instead of the ~630-site south-wide dropout -353 fixes. No DRC/LVS regression (re-verified clean).
#
# SP_KO 25 -> 10 (this phase, "bring coils closer to the grid tiles" pass): committed state (14380bc) had
# SP_KO=25 / MACRO_W=1070 / Y_N=751 (height 1104, 34 um over the 1070x1070 pad-tile budget). Shrinking SP_KO
# alone (no coil reshape) tightens MACRO_W/Y_N for free. SP_KO=8 looked clean (MACRO_W=1060, Y_N unchanged at
# 731 -- same binding constraint, LSHUNT_OUT's cy_floor+ry+SP_KO+RING pitch-rounds to the same 731 at both 8
# and 10) but produced a real, silent (DRC-clean) LVS short: lna_core_parts' vdd and vss merge into one net.
# Root-caused empirically (real gf180mcu.lvs deck as ground truth throughout, not just DRC) by bisecting
# SPIRAL_KO itself in make_lna_core_parts.py's build_supply() (same real-world margin as this SP_KO, must
# always move together) with everything else held fixed: SPIRAL_KO=25 and 16 and 12 and 10 all LVS-match,
# SPIRAL_KO=9 and 8 both LVS-mismatch, with the exact same 354-tile set at 8 and 9 (the critical ~70 extra
# tiles that make the difference only drop out between 9 and 10). This isolates the short to specific generic
# supply tiles landing within 9-10 um of a coil's own bbox -- close enough that DRC still sees legal spacing
# everywhere, but something in the standard tile cell's own stepping-stone via construction (Via2/Via3 M2<->M4
# and Via3/Via4 M3<->M5, see module doc) ends up on the same net as the nearby coil once that close (exact
# mechanism not fully traced to one shape -- a from-scratch connectivity probe's own bisection couldn't
# isolate it below ~5700 of 728k via4 shapes, "neither half alone reproduces it", pointing at a distributed/
# redundant short rather than one bad via -- but the SPIRAL_KO bisection above is fully conclusive and is what
# this fix is based on). SPIRAL_KO=10 kept as the safe value (one pitch-independent step above the confirmed-
# bad 9), SP_KO matched to 10 here. MACRO_W bumped 1060 -> 1062 (LSHUNT_OUT's own "does not fit the macro
# width" assert needs +SP_KO/2, i.e. +1 um for the +2 SP_KO; +2 taken for margin) -- re-verified DRC clean /
# LVS match on all 4 blocks + the full lna_core_parts assembly (ANT.16_ii_ANT.* antenna violations on
# lna_core_parts remain, pre-existing/benign per the module's own standalone-sub-assembly note). Net result:
# height still 1084 (20 um under the committed 1104), width 1062 (8 um under the 1070 budget, down from 1060's
# 10 um but still comfortably inside it) -- SPIRAL_KO could not safely go below 10 without reopening this short.
RFO_X = 725.0  # rf_out_pad lead column (centre). Moved from 415 (user request): the old position ran this
# column, and C1's own LD4-avoidance bridge feeding it, straight through lna_core_cg's own LD4 ring territory
# (x=[113,580]) -- a real, repeatedly-confirmed source of cross-block shorts. 725 sits in the open gap between
# LD4's east edge (~580) and LD2's west edge (~816.5, in lna_core_cs), matching the padframe's own rf_out_pad
# slot (moved to N,7 in make_lna_top.py, macro x~690..765) so the pad-to-core jog stays short. No crossing of
# LD4 (or anything else) is needed for this column at all now.
YSL = (256.78, 266.78)  # L1 lead (CG source -> L1 port 1), runs east above LEQ. Shifted +DY_CG_BULK=34.78
# (floorplan compaction, step 1): sourced from cg's own y_s (bridged by a connector that stretches to meet it
# regardless of the gap), so it moves with the rest of cg's bulk, not independently.
VM2_Y = (357.0, 365.0)  # vm2 trace (CG drains -> LD4 port 2) north of C3, east under LSHUNT_OUT
# coil placement: port edge position (the ports face the core) and centre on the other axis
LEQ_PORT_X, LEQ_CY = 36.0, -57.0  # LEQ south-west, ports west: port 1 -> rf_in lead column, port 2 -> west ring
# LEQ_CY re-centred for LEQ_MAIN_RECT2's ry=252 (feasible range [-59, -55] -- see "LEQ does not fit" assert below;
# narrow because LEQ's own Y-band is itself now tightly re-optimized for the X fit, not because of newly-added slop)
L1_PORT_Y = 200.0  # L1 south (east of LEQ), ports north: port 1 (east) -> YSL lead, port 2 -> vss (lead L1_VSS_X
# down to the south edge, narrowed to fit the smaller SP_KO gap -- see build_cg for why a north-reaching
# grid-tap route doesn't work here)
# L1_PORT_Y is UNCHANGED even though L1's own coil is reshaped: the port edge sits at L1_PORT_Y regardless of the
# coil's rx/ry (ports are always `pe` in from the coil's own edge, and pe tracks rx under the rot=90 axis swap --
# see build_cg's cy1 formula), so every lead/wire north of L1 (into YSL, the cg source bus, etc.) needed no changes
# at all -- only the coil's own south-ward bulk (down to Y_S) grew, which is exactly the Y-budget cost above.
LD4_PORT_Y = 330.0  # LD4 south-east (east of L1), ports north: port 2 (west) -> vm2 trace, port 1 -> vdd
LD2_PORT_X, LD2_CY = 340.0, 595.0  # LD2 north-west, ports east: port 2 -> vx column, port 1 -> vdd (north)
# Tried reshaping LD2 rectangular (LD2_RECT_coil.gds, rx 108.5 -> 146.2 / ry 108.5 -> 76.0, same 4.30nH target,
# see /foss/designs/rapidpassives/try4/newflow/good_tries/LD2_RECT_CAND2_X130.2_Y60.0_N3_W1.75/) to relax the
# "LD2 does not fit" assert below -- reverted. Two problems, either one fatal on its own: (1) it doesn't even
# help -- LSHUNT_OUT_RECT is the binding constraint on Y_N (needs Y_N >= ~745, pitch-rounds to 751 regardless of
# LD2's own margin), so a smaller LD2 ry buys nothing. (2) it doesn't fit the channel at all: LD2_PORT_X=340 is
# pinned by where port 1/2 must land to meet the fixed LD2_VDD_X=(350,360) / VX_X=(377,387) columns (vbias
# columns bound the west side at x<=90). The old square's east edge (cx+r=340.5) just clears those columns
# (340.5 < 350); growing rx to 146.2 pushes the bulk's east edge to 343 **at best** -- any PORT_X large enough
# to also clear the west-side vbias assert (needs >= 405.4) drags the whole coil (port included) past x=350/387,
# so the coil's own M5 turns end up physically UNDER the VDD_X/VX_X columns -- confirmed via a render showing
# both columns running straight through the coil body -- and that is exactly what produced the vdd/output_match
# LVS short (lna_core_parts net "output_cs|output_match|rf_out_pad|vdd"). The channel between the vbias columns
# and VDD_X/VX_X is only wide enough for rx <~ 110 (barely more than the square's 108.5): not worth it without a
# bigger rework (moving VDD_X/VX_X/vbias themselves, which has its own cascading guard-ring clearance issues --
# see build_cs). Back to the original square LD2_coil.gds.
# LSH_PORT_X/LSH_CY/LSH_VSS_X (old north-east-of-rf_out-lead site) and LD2_VDD_X (old north-west-of-core site)
# removed with those coils' own re-floorplan relocations (see LD2_NE_CX/CY in build_cs and LSH_SE_CX/CY below).
LSH_SE_CX, LSH_SE_CY = 935.0, -30.0  # LSHUNT_OUT relocated SE: east of L1 (east edge 779 + SP_KO margin), roughly
# at L1's own y level -- "due east" of it.
LSH_CHANNEL_Y = -350.0  # east-west return channel for LSHUNT_OUT's long rf_out lead, south of both L1's own
# keep-out (south edge -318) and LSHUNT_OUT's own (south edge ~-326), with real SP_KO clearance from each -- see
# Y_S's own comment above for why Y_S had to grow to fit this
GCG_Y, GCG_X = (464.78, 468.78), 41.0  # g_cg lead to the west edge (Metal4 from the gate join, Metal3 from x =
# GCG_X). Y shifted +DY_CG_BULK=34.78 (floorplan compaction step 1, tracks R3/R4 and the rest of cg's bulk).
# bias pins (Metal3, north edge): jog west below LD2 at y = jog, then north at x
VBIAS = {"vbias_cg": (479.78, 60.0), "vbias_cs": (483.0, 75.0), "vbias_cas": (720.0, 90.0)}
# jog heights (first element of each tuple) adjusted for floorplan compaction step 1: vbias_cg/vbias_cs are
# drawn in build_cg, starting from R3/R4 respectively. vbias_cg's own +DY_CG_BULK=34.78 shift is fine (R3 is far
# from LD4, 137um of room). vbias_cs is NOT a blind +DY_CG_BULK shift, though -- R4 sits much closer to LD4's
# ring (new R4 top 473.29 vs LD4 ring south 488, only 14.7um of window). A blind shift put the jog box's own
# edge only 0.22um from LD4's ring south wall (real DRC hit: M3.2a); the first re-fit (yj=481) cleared that but
# then overlapped vbias_cg's own jog (478.78..480.78) on the same Metal3 layer, merging the two nets (real LVS
# short). yj=483 clears both: >=1.22um from vbias_cg's jog, 4um from LD4's ring south, 6.71um above R4's own
# start (473.29). vbias_cas is drawn in build_cs off its own T4 gate strap (T4["G"]=472.40..473.40 after
# +DY_CS_BULK) -- a blind "plenty of room, unadjusted" guess at yj=515.52 (just clearing T4's own gate) was
# WRONG: that jog spans the full x=89..578 (vbias_column()'s own jog box, xn-1 to the column's starting x), and
# y=515.52 falls inside lna_core_cg's own LD4 ring (y=[488,712]) -- a real cross-block short (vbias_cas merged
# into vss, confirmed via NetTracer) invisible to cs's own standalone check since LD4 lives in a different
# block entirely. yj=720 clears LD4's ring (north edge 712) with real margin instead. xn (second element) is
# unrelated to Y, unchanged.


def coil_geom(sch, name):
    return lib.coil_geom(os.path.join(HERE, COILS[(sch, name)]))


def place_coil(ly, top, sch, name, cx, cy, rot=0, mirror=False):
    """coil of sch / name at (cx, cy); returns (port 1, port 2) stubs (lib.coil_ports), placement, geometry"""
    c, geo = lib.coil(ly, f"{sch}__{name}", os.path.join(HERE, COILS[(sch, name)]))
    tr = top.place(c, cx, cy, rot=rot, mirror=mirror)
    return lib.coil_ports(tr, geo), tr, geo


def vbias_column(top, pin, x, y0):
    """bias pin lead (Metal3, 2 um) from (x, y0) north to the jog, west, then north to the macro edge"""
    yj, xn = VBIAS[pin]
    assert y0 < yj - 3, (pin, y0, yj)
    top.box("m3", x - 1, y0, x + 1, yj + 1)
    top.box("m3", xn - 1, yj - 1, x + 1, yj + 1)
    top.box("m3", xn - 1, yj - 1, xn + 1, Y_N)
    top.label(3, pin, xn, Y_N - 1)
    return xn


INFO = {}  # per cell: notes for the json report


def c_in_wl(sch):
    """(W, L, pF, name) of the input series cap -- capa.sym (main_pex, squares itself to its ideal pF) or main's
    fixed cap_mim_2f0fF named C15 (exact schematic W/L, like c_out_wl's cap_mim_2f0fF path)"""
    capas = [n for n, (sym, _) in sch.items() if sym == "capa"]
    if capas:
        cn = capas[0]
        c_pf = pf(sch[cn][1]["value"])
        w_, l_ = cap_side(c_pf)
        return w_, l_, c_pf, cn
    cn = "C15"
    p = sch[cn][1]
    w_, l_ = um_grid(p["W"]), um_grid(p["L"])
    return w_, l_, lib.c_mim_pf(w_, l_), cn


def cpi_wl(sch):
    """(W, L, pF) of CPI, main's extra input shunt cap (input_cg -> vss) with no main_pex equivalent, or None"""
    if "CPI" not in sch:
        return None
    p = sch["CPI"][1]
    w_, l_ = um_grid(p["W"]), um_grid(p["L"])
    return w_, l_, lib.c_mim_pf(w_, l_)


# ================================================================ lna_core_input_match
def build_input_match(ly):
    """
    rf_in_pad (Metal5, west edge, y = 295) -> series cap bottom plate; top plate -> input_cg (east edge, x = 82)
    (see c_in_wl: main_pex's single idealized cap, or main's fixed-size C15)
    LEQ (coil, south-west, mirrored: ports west): port 1 (upper) -> rf_in lead column (x = 20 .. 30) north to
    rf_in_pad, port 2 -> vss (Metal5 into the west ring band)
    CPI (main only, see cpi_wl): extra shunt cap input_cg -> vss, placed in the free band above LEQ (y 196..290,
    unused by main_pex's simpler network) -- not present in main_pex at all.
    """
    P = "lna_core_input_match"
    sch = sch_params(P)
    top = Cell(ly, P)
    # --- LEQ
    geo = coil_geom(P, "LEQ")
    cx, cy = g(LEQ_PORT_X + geo["pe"]), LEQ_CY
    # RING_KO (coil_guard_ring, pilot coil) replaces SP_KO here -- LEQ's own guard ring takes over the margin
    # a generic supply tile needs to keep from it; see RING_SP/RING_W/RING_KO's own comment above.
    assert cy + geo["ry"] + RING_KO <= YSL[0] and cy - geo["ry"] - RING >= Y_S + RING, "LEQ does not fit"
    (q1, q2), _, _ = place_coil(ly, top, P, "LEQ", cx, cy, rot=180, mirror=True)
    ring_in, ring_out = lib.coil_guard_ring(top, cx, cy, geo, rot=180, w=RING_W, sp=RING_SP)
    lead_x = 25.0  # rf_in lead column (centre)
    rf_y = 329.78  # shifted +DY_CG_BULK=34.78 from 295.0: same net as cg's own y_s (build_cg draws the matching
    # "input_match"/"input_cg" box at the identical height) -- floorplan compaction step 1, must co-shift.
    x_e = 82.0
    # --- series cap
    w1, l1, c_pf, cn = c_in_wl(sch)
    px = 36.4
    c1, t1 = lib.mim_tile(ly, f"{P}__C1", w1, l1)
    tr1 = top.place(c1, px, g(rf_y - l1 / 2))
    b1, p1 = tbox(tr1, t1["bot"]), tbox(tr1, t1["top"])
    # --- rf_in_pad: west edge -> capacitor bottom-plate strap; LEQ lead column joins it
    top.box("m5", 0, rf_y - 5, b1[2], rf_y + 5)
    rf_e = p1[2] - 1  # capacitor top plate -> east edge
    cap_info = {cn: {"W": w1, "L": l1, "pF": round(lib.c_mim_pf(w1, l1), 3), "schematic_pF": round(c_pf, 3)}}
    top.box("m5", lead_x - 5, q1[1], q1[2], q1[3])  # LEQ port 1 -> lead column
    top.box("m5", lead_x - 5, q1[1], lead_x + 5, rf_y + 5)
    top.label(5, "rf_in_pad", 1, rf_y)
    # --- input_cg: east edge
    top.box("m5", rf_e, rf_y - 5, x_e, rf_y + 5)
    top.label(5, "input_cg", x_e - 1, rf_y)
    # --- vss: LEQ port 2 -> west ring band (lna_core_parts stacks it onto the ring Metal4)
    top.box("m5", 2, q2[1], q2[2], q2[3])
    top.label(5, "vss", 3, (q2[1] + q2[3]) / 2)
    # --- CPI (main only): free band above LEQ (y ~196..290), strapped up to input_cg and down to vss
    cpi = cpi_wl(sch)
    if cpi:
        w2, l2, cpi_pf = cpi
        cpx, cpy = 60.0, 220.0  # x spans the input_cg bus (rf_e..82); y clear of LEQ (top ~196.4) and the bus (290)
        c2, t2 = lib.mim_tile(ly, f"{P}__CPI", w2, l2)
        tr2 = top.place(c2, cpx, cpy)
        top2, bot2 = tbox(tr2, t2["top"]), tbox(tr2, t2["bot"])
        assert top2[3] + lib.MIM_HALO <= rf_y - 5 and bot2[1] - lib.MIM_HALO >= cy + geo["ry"], "CPI does not fit"
        assert top2[0] <= rf_e and top2[2] >= x_e, "CPI top plate must span the input_cg bus (x = rf_e..x_e)"
        top.box("m5", top2[0], top2[3] - 0.5, top2[2], rf_y - 5)  # top plate -> input_cg bus
        # bottom-plate strap -> vss: cross under the rf_in lead_x column (x = 20..36, y >= q1[1]) on Metal4 (not
        # Metal5, which would short the LEQ port-1 riser there), then tie into a west-edge Metal5 column that
        # overlaps LEQ's own port-2 vss box -- one continuous vss net within the block, same as q2 alone today
        yb0, yb1 = bot2[1] - 5, bot2[1]
        top.stack(bot2[0], yb0, bot2[2], yb1, 4, 5)
        top.box("m4", 10, yb0, bot2[2], yb1)
        top.stack(10, yb0, 14, yb1, 4, 5)
        top.box("m5", 2, q2[1], 14, yb1)  # west column: overlaps q2's own vss box (x 2..36, y q2[1]..q2[3])
        cap_info["CPI"] = {"W": w2, "L": l2, "pF": round(cpi_pf, 3)}
    INFO[P] = {"LEQ": {"coil": COILS[(P, "LEQ")], "centre": [cx, cy], "ports": "west",
                       "ring_inner": list(ring_in), "ring_outer": list(ring_out)},
               **cap_info, "leq_vss_lead_y": [q2[1], q2[3]],
               "pins": {"rf_in_pad": "Metal5 west edge y=295", "input_cg": f"Metal5 east edge x={x_e} y=295",
                        "vss": "Metal5 west edge (LEQ port 2)"}}
    return top


# ---------------------------------------------------------------- interfaces between the cells (floorplan coords)
CS_X_SHIFT = 300.0  # cs re-floorplan: shift the whole transistor/pad subsystem east by this much to clear
# LD4's new NW-corner placement (LD4 occupies local x 329..547 at this same y-band) -- LD2 itself is unaffected,
# already independently placed at its own NE-corner target (LD2_NE_CX/CY) regardless of this shift.
CS_GATE_PAD = (268.0 + CS_X_SHIFT, 456.02, 274.0 + CS_X_SHIFT, 462.02)  # input_cg of lna_core_cs = output_cs of
# lna_core_cg (Metal3..5 stack). Y shifted +DY_CS_BULK=56.52 (floorplan compaction step 1 -- tracks cs's own
# FET row, the tighter side of this shared interface; margin on the cg side re-verified, not just assumed).
VX_X = (377.0 + CS_X_SHIFT, 387.0 + CS_X_SHIFT)  # output_match (vx) Metal5 column of lna_core_cs, east of the cascode
C_OUT_PLATE = (585.0, 466.0)  # lower-left of the output C1 top plate (rotated: x extent = L, y extent = W).
# X moved east from 391 (re-floorplan, user request): the original site put C1's own plate body (x=391..445,
# y=466..530.61, a real MIM cap, not reroutable) directly inside lna_core_cg's own LD4 ring once LD4 moved to
# the NW corner (world x=[113,577], y=[491,709] -- C1's old x-range sat entirely within LD4's new footprint,
# confirmed via direct GDS inspection, not a formula guess). Y is unchanged (OM_LEAD_Y stays valid, no lna_core_cs
# changes needed) -- only X moves, clear east of LD4's ring with margin.
C_OUT_L = 54.0  # x extent of the output C1 plate (between the vx column and the LSHUNT_OUT vss lead)
OM_IN_X = 380.0  # west end of the output_cs lead of lna_core_output_match


OM_LEAD_Y = 498.305  # output_cs lead y, fixed across variants (= main_pex's own C_OUT_PLATE[1] + W/2) so
# lna_core_cs (which also calls om_lead_y()) never needs to change based on which cap this block draws


def c_out_wl(sch):
    """(W, L) of the output series cap, from whichever symbol this schematic uses: main_pex's idealized capa.sym
    (retuned freely -- sized to fit the fixed-L C_OUT_L slot, as today) or main's fixed cap_mim_2f0fF (C11, W/L
    already chosen in the schematic -- LVS needs those exact dimensions, not a re-derived shape of equal pF)"""
    capas = [n for n, (sym, _) in sch.items() if sym == "capa"]
    if capas:
        cn = capas[0]
        l_, w_ = cap_side(pf(sch[cn][1]["value"]), C_OUT_L)
        return w_, l_, pf(sch[cn][1]["value"]), cn
    (cn,) = [n for n, (sym, _) in sch.items() if sym == "cap_mim_2f0fF"]
    p = sch[cn][1]
    w_, l_ = um_grid(p["W"]), um_grid(p["L"])
    return w_, l_, lib.c_mim_pf(w_, l_), cn


def om_lead_y():
    """centre of the output_cs lead (= vx column top of lna_core_cs) -- fixed, see OM_LEAD_Y"""
    return g(OM_LEAD_Y)


# ================================================================ lna_core_output_match
def build_output_match(ly):
    """
    C1 (series, sized to whichever cap this schematic specifies -- see c_out_wl): top plate = output_cs (lead to
    the west, x = 380), bottom plate (tab rotated to the north) = rf_out_pad (Metal5 lead to the north edge, x =
    415). Same single-series-cap structure for both main and main_pex (only the target size/source symbol
    differs) -- om_lead_y() and every pin/frame coordinate stay identical either way (the cap is re-centred on
    the fixed OM_LEAD_Y regardless of its own size), so lna_core_cs needs no changes between variants.
    LSHUNT_OUT: coil relocated SE (re-floorplan, east of L1, rot=270, ports south): port 1 (q1, east) -> rf_out,
    a long jog south-then-west-then-north back to the rf_out_pad column; port 2 (q2, west) -> vss, a short run
    south to the (now much closer) south ring.
    """
    P = "lna_core_output_match"
    sch = sch_params(P)
    top = Cell(ly, P)
    xr = RFO_X
    yc = om_lead_y()
    w, l, c_pf, cn = c_out_wl(sch)
    c, t = lib.mim_tile(ly, f"{P}__C1", w, l)
    x0 = C_OUT_PLATE[0]
    y0 = g(yc - w / 2)  # re-centre the cap (whatever its own W) on the fixed interface y
    tr = top.place(c, x0, y0 + w, rot=270)  # tab (bottom plate) west -> north
    pt, bt = tbox(tr, t["top"]), tbox(tr, t["bot"])
    assert abs(yc - g((pt[1] + pt[3]) / 2)) < 1e-6
    # output_cs lead (OM_IN_X -> C1's own top plate): dip to Metal3 (not Metal4 -- that's xe's own column dip
    # layer just below, and this horizontal lead crosses xe's vertical one at x=456, y~498; using the same
    # intermediate layer for both merged output_cs into rf_out_pad there, confirmed live via LVS) across
    # lna_core_cg's own LD4 ring (world x=[113,577], y=[491,709]) -- this lead's own y (yc +-5 = 493.3..503.3)
    # sits inside the ring's y-range for its entire x-span now that C1 moved east of it.
    xb0 = OM_IN_X + 3.0  # short Metal5 buffer so the "output_cs" label (OM_IN_X+1) stays clearly on Metal5
    xd0, xd1 = 578.0, 580.0  # 1-3um margin east of LD4's ring (577)
    top.box("m5", OM_IN_X, yc - 5, xb0, yc + 5)
    top.stack(xb0, yc - 5, xb0 + 2, yc + 5, 3, 5)
    top.box("m3", xb0 + 2, yc - 5, xd0, yc + 5)
    top.stack(xd0, yc - 5, xd1, yc + 5, 3, 5)
    top.box("m5", xd1, yc - 5, pt[0] + 1, yc + 5)
    top.box("m5", bt[0], bt[1], bt[2], bt[3])
    # rf_out_pad's own north-reaching column: a plain, direct Metal5 run, no dip needed. RFO_X moved to 725
    # (user request) specifically so this column never enters lna_core_cg's own LD4 ring (x=[113,580]) or
    # lna_core_cs's own FET block (x<=674.54) or LD2 (x>=816.5) at all -- the whole reason the old x=415 column
    # needed two separate Metal3/Metal4 dips (one for LD4's ring, one for a CG q2/vm2 lead crossing that doesn't
    # even apply at this new x) is gone by construction. Confirm via the real deck, not just by this reasoning,
    # per this project's own standing rule -- but there is no known obstacle left to dip around here.
    # bridge from bt (585..639) east to this column (720..730) -- without this, the column and bt are two
    # separate, non-touching boxes and "rf_out_pad" ends up a floating net (confirmed via LVS: the label's own
    # net had zero terminals, device $13's own bottom-plate terminal landed on a separate, unnamed net $2).
    top.box("m5", bt[0], bt[1], xr + 5, bt[3])
    top.box("m5", xr - 5, bt[1], xr + 5, Y_N)
    q1_min_y = pt[3] + 20  # rf_out port must clear the cap
    cap_info = {cn: {"W": w, "L": l, "pF": round(lib.c_mim_pf(w, l), 3), "schematic_pF": round(c_pf, 3)},
                "top_plate": list(pt)}
    top.label(5, "output_cs", OM_IN_X + 1, yc)
    top.label(5, "rf_out_pad", xr, Y_N - 1)
    # --- LSHUNT_OUT: relocated SE, decoupled from its old north-east-of-rf_out-lead site (re-floorplan request).
    # rot=270 ("-90 deg" per request): ports face south -- confirmed by direct probe of coil_ports() under this
    # rotation. q1 (rf_out, port1) lands east of q2 (vss, port2).
    geo = coil_geom(P, "LSHUNT_OUT")
    cx, cy = LSH_SE_CX, LSH_SE_CY
    L1_EAST = 779.0  # lna_core_cg's own L1 east edge (build_cg, unchanged by this re-floorplan -- L1 itself did
    # not move); cross-block constant since LSHUNT_OUT's new site must clear L1's own keep-out
    # RING_KO (coil_guard_ring, Phase 2) replaces SP_KO here -- see LEQ's own comment for the full rationale.
    # LSH_SE_CX/CY are fixed constants (not derived from SP_KO like L1's cx1 was), so this only relaxes the
    # fit-check -- LSHUNT_OUT itself does not move.
    assert cx - geo["ry"] - RING_KO >= L1_EAST, "LSHUNT_OUT (SE) does not clear L1's own keep-out"  # rot=270:
    # world-X extent is local ry
    assert cx + geo["ry"] + RING_KO + RING <= MACRO_W, "LSHUNT_OUT (SE) does not fit against the east edge"
    assert cy - geo["rx"] - RING_KO >= Y_S + RING, "LSHUNT_OUT (SE) does not fit against the south edge"  # world-Y
    # extent is local rx
    (q1, q2), _, _ = place_coil(ly, top, P, "LSHUNT_OUT", cx, cy, rot=270)
    ring_in, ring_out = lib.coil_guard_ring(top, cx, cy, geo, rot=270, w=RING_W, sp=RING_SP)
    assert q1[0] > q2[0], "q1 (rf_out) must be the eastern port, q2 (vss) the western one"
    top.box("m5", *q1)
    top.box("m5", *q2)
    # vss (q2): the long rf_out channel below is a solid M5 bar spanning x=xr..q1[2], which includes q2's own x,
    # at y=LSH_CHANNEL_Y..+6 -- any M5 path from q2 down to the ring crosses it, and q1's own M5 lead-in (q1's x,
    # down to the channel) fills in the rest of that y-band too, so there is no x-jog that dodges both on the
    # same layer (confirmed by two real LVS mismatches from the first, wrong-branch attempt at this same
    # relocation). Fixed properly: drop q2 to Metal4 just above the channel and cross under it on M4 -- a
    # different layer, so no via means no connection even where the two geometrically overlap -- then continue
    # on M4 the rest of the way into the ring (which is M4=vss anyway, so this needs no further transition).
    assert Y_S + RING <= LSH_CHANNEL_Y <= min(cy - geo["rx"] - SP_KO, -318.0 - SP_KO), \
        "LSH_CHANNEL_Y must clear both L1's and LSHUNT_OUT's own keep-outs, and stay inside the south edge"
    # y_m4 must leave a real gap above the channel's own top (LSH_CHANNEL_Y+6) for the stack()'s own M5 portion --
    # same-layer shapes that only touch still merge into one polygon (same net), reproducing the same mismatch.
    y_m4 = g(LSH_CHANNEL_Y + 6 + 5)
    top.box("m5", q2[0], y_m4, q2[2], q2[3])
    top.stack(q2[0], y_m4 - 2, q2[2], y_m4, 4, 5)
    top.box("m4", q2[0], Y_S + 2, q2[2], y_m4)
    top.label(4, "vss", (q2[0] + q2[2]) / 2, Y_S + 3)
    # rf_out (q1): jog south below both LSHUNT_OUT's and L1's own keep-outs (LSH_CHANNEL_Y, asserted above), west
    # all the way to a point east of pt (output_cs's own top plate -- bt sits only ~1um above pt at the same
    # x-range, so a straight run up to bt[1] inside pt's own x-range would short rf_out to output_cs, confirmed
    # by a real LVS mismatch from the first attempt), then north clear of pt, then a final jog west to meet bt.
    # xe nudged from pt[2]+6 to 456.0: the straight run up to bt was found (via NetTracer) to cross
    # lna_core_cg's own L1 coil at several points along its winding -- not a uniform block, but real metal on
    # every turn at x 449..453 for most of L1's own height. x=456..460 threads between turns for most of that
    # span (confirmed empirically, not assumed), leaving only the 6 narrow bands below where L1 (or its own
    # port leads) still has metal -- Cell.dipped_column() crosses each on Metal4 with real clearance on both
    # sides, same technique as every other cross-block crossing fixed in this re-floorplan.
    xe = 456.0
    # xe used to need to clear C1's own plate from the WEST (pt[2]+6<=xe); C1 moved east past LD4's new ring (see
    # C_OUT_PLATE), so the relationship flips -- xe now needs to stay clear of the plate from the EAST instead.
    assert xe + 6 <= pt[0], "xe must still clear output_cs's own top plate (pt)"
    top.box("m5", q1[0], LSH_CHANNEL_Y, q1[2], q1[1])
    top.box("m5", xe, LSH_CHANNEL_Y, q1[2], LSH_CHANNEL_Y + 6)
    # (254.78, 286) merges what used to be three separate bands into one: the Metal5-only vbias/YSL bus (now
    # 256.78..266.78, shifted +DY_CG_BULK=34.78 in floorplan compaction step 1) and the supply-level vss strap
    # (CS guard ring -> C3 bottom-plate bar, also +DY_CG_BULK) that used to sit just east of it at 236..240, PLUS
    # L1's own unmoved winding-gap bands at 258..264 and 272..286 (L1 itself doesn't move until step 2) -- the
    # shifted cg-bulk band now overlaps both of those, so all three merge into one wider dip zone rather than
    # three overlapping ones (dipped_column() requires non-overlapping, margin-separated bands). Will need
    # re-splitting/re-measuring once L1 moves in step 2 and its own bands shift by a different delta.
    # The column ends right after this last L1/bulk band (y=288, +2um margin) instead of continuing straight up
    # through lna_core_cg's own LD4 ring (user request: never route rf_out under LD4 at all, not even via a
    # layer dip -- a previous version of this code threaded x=456 all the way up through LD4's y-range on a
    # Metal3/Metal4 dip, which is exactly the pattern being removed here). From here the path jogs EAST to clear
    # LD4's ring (east edge ~580) while still well south of it (y~288-290, LD4 starts at y=488), then runs
    # straight north at that x, entirely outside LD4's footprint, to meet bt directly.
    ye0 = 288.0
    top.dipped_column(xe, LSH_CHANNEL_Y, ye0,
                       dip_bands=[(-318, -312), (197, 213), (254.78, 286)])
    # jog east, clearing BOTH LD4's ring (east edge ~580) and pt (output_cs's own top plate, x=585..639,
    # y=466..530.61) -- a straight run up at any x inside pt's own range would cut through it and short it to
    # rf_out, confirmed by a real LVS mismatch the first time this exact mistake was made in this file. Going
    # all the way to xg=645 (6um east of pt) avoids threading the tight ~5um gap between LD4 and pt altogether;
    # the run north at xg stays clear of pt for its whole height since xg > pt[2]=639, then a short final jog
    # west at bt's own height (above pt entirely) reaches into bt.
    xg = pt[2] + 6.0
    top.box("m5", xe, ye0, xg + 1, ye0 + 2)
    top.box("m5", xg - 1, ye0, xg + 1, bt[1])
    top.box("m5", bt[0], bt[1], xg + 1, bt[3])
    # bt's own north-reaching column to the pad is the separate, direct run below (rf_out_pad / RFO_X=725).
    INFO[P] = {**cap_info, "output_cs_lead_y": yc,
               "rf_out_x": [xr - 5, xr + 5],
               "LSHUNT_OUT": {"coil": COILS[(P, "LSHUNT_OUT")], "centre": [cx, cy], "ports": "south",
                              "ring_inner": list(ring_in), "ring_outer": list(ring_out)},
               "macro": [MACRO_W, Y_N - Y_S], "frame": [0, Y_S, MACRO_W, Y_N],
               "pins": {"output_cs": f"Metal5 x={OM_IN_X} y={yc}", "rf_out_pad": f"Metal5 north edge x={xr}",
                        "vss": f"Metal4 south edge x={q2[0]}..{q2[2]}"}}
    return top


# ================================================================ lna_core_cs
def fet_params(sch, name, dummy):
    """(wf, L, active fingers) of a FET instance + dummy fingers per row end of its dummy instance"""
    s, p = sch[name]
    nf, mm = int(p["nf"]), int(p["m"])
    sd, pd = sch[dummy]
    return um(p["W"]) / nf, um(p["L"]), nf * mm, int(pd["nf"]) * int(pd["m"]) // 2, s


def volt_of(sym):
    return {"nfet_03v3": "3.3V", "nfet_05v0": "5V", "nfet_06v0": "6V"}[sym]


def build_cs(ly):
    """
    cascode stack in one P+ guard ring: M3 row (nfet_03v3, bottom, M5 dummies) and M2 row (nfet_05v0, on top,
    M4D dummies) share the vm1 bus (M3 drain = M2 source). M3 source bus -> guard ring (vss, RS_EQ1 = 0).
      input_cg  : M3 gate strap (Metal3) -> west to CS_GATE_PAD (Metal3..5 stack, met by C2 / R4 of lna_core_cg)
      vbias_cas : M2 gate strap (Metal3) -> west, Metal3 column north, west below LD2, on to the north edge
      output_match (vx): M2 drain bus -> east, Metal5 column VX_X -> C1 lead (lna_core_output_match) and on north
                  to LD2 port 2
      LD2       : coil LD2_coil.gds north-west of the core, ports east: port 2 -> vx, port 1 -> vdd (Metal5 lead
                  LD2_VDD_X to the north edge)
    """
    P = "lna_core_cs"
    sch = sch_params(P)
    top = Cell(ly, P)
    wf1, l1, na1, nd1, s1 = fet_params(sch, "M3", "M5")
    wf4, l4, na4, nd4, s4 = fet_params(sch, "M2", "M4D")
    i_ma = 13.2  # drain current (ngspice OP, typ) -> bus width at 1 mA/um on Metal2 + Metal3
    wb = math.ceil(i_ma / 2 * 2) / 2
    m1t, m1 = lib.fet_tile(ly, f"{P}__M1", volt_of(s1), wf1, l1, na1, nd1, ws=wb, wd=wb)
    m4t, m4 = lib.fet_tile(ly, f"{P}__M4", volt_of(s4), wf4, l4, na4, nd4, ws=wb, wd=wb, draw_s=False)
    x_m1, y_m1 = 285.0 + CS_X_SHIFT, 456.52  # y_m1 shifted +DY_CS_BULK=56.52 from 400.0 (floorplan compaction
    # step 1: close the gap to LD2's ring, 426.98 (old R top) -> 503.5 (LD2 ring south) - 20um routing margin)
    tr1 = top.place(m1t, x_m1 - m1["row"][0], y_m1)
    T1 = {k: tbox(tr1, v) for k, v in m1.items() if k != "nf"}
    xc = (T1["row"][0] + T1["row"][2]) / 2
    tr4 = top.place(m4t, xc - (m4["row"][0] + m4["row"][2]) / 2, T1["D"][1] - m4["S"][1])
    T4 = {k: tbox(tr4, v) for k, v in m4.items() if k != "nf"}
    assert abs(T4["S"][1] - T1["D"][1]) < 1e-6 and abs(T4["S"][3] - T1["D"][3]) < 1e-6
    # guard ring
    gw, gm = 0.8, 1.5
    R = (g(T1["S"][0] - gm - gw), g(T1["S"][1] - gm - gw), g(T1["S"][2] + gm + gw), g(T4["D"][3] + gm + gw))
    lib.guard_ring(top, *R, w=gw)
    ri = (R[0] + gw, R[1] + gw, R[2] - gw, R[3] - gw)  # inner edge
    top.box("m2", T1["S"][0], R[1], T1["S"][2], T1["S"][1])  # M1 source bus -> ring (vss)
    for T in (T1, T4):  # dummy gates -> ring (Metal1)
        top.box("m1", ri[0] - 0.1, T["DGL"][1], T["DGL"][2], T["DGL"][3])
        top.box("m1", T["DGR"][0], T["DGR"][1], ri[2] + 0.1, T["DGR"][3])
    top.label(1, "vss", R[0] + gw / 2, (R[1] + R[3]) / 2)
    # input_cg: M1 gate strap -> CS_GATE_PAD
    gp = CS_GATE_PAD
    top.box("m3", gp[0], T1["G"][1], T1["G"][0], T1["G"][3])
    top.stack(*gp, 3, 5)
    top.label(5, "input_cg", (gp[0] + gp[2]) / 2, (gp[1] + gp[3]) / 2)
    # vbias_cas: M4 gate strap -> west, Metal3 column north (jog west below LD2). xv used to be R[0]-3 (just
    # west of cs's own guard ring, x~576.7) -- that put the column's own PRE-JOG vertical run (T4['s gate height
    # 472.4 up to the jog, ~249um) directly inside lna_core_cg's own LD4 ring (x=[110,580], y=[488,712]) for its
    # entire length (real cross-block short, confirmed via NetTracer: merged vbias_cas into vss even after
    # fixing the jog height alone -- the jog clearing LD4 wasn't enough since the column below it was still
    # inside the ring). T4["G"][0]=582 is already just east of LD4's ring; bridge east to xv=585 instead of west,
    # clearing LD4 with real margin for the column's whole vertical run.
    xv = 585.0
    top.box("m3", T4["G"][0], T4["G"][1], xv + 1, T4["G"][3])
    xvn = vbias_column(top, "vbias_cas", xv, T4["G"][1])
    # vx: M4 drain bus -> east, Metal5 column
    yd0, yd1 = T4["D"][1], T4["D"][3]
    top.box("m3", T4["D"][2], yd0, VX_X[1], yd1)
    top.box("m2", T4["D"][2], yd0, ri[2] - 0.6, yd1)
    top.stack(VX_X[0], yd0, VX_X[1], yd1, 3, 5)
    # --- LD2: relocated to the NE corner, decoupled from its old north-west-of-the-core site (re-floorplan
    # request). rot=180: ports face west, back toward the core -- confirmed by direct probe of coil_ports()
    # under this rotation. q1 (vdd, port1) lands south of q2 (vx/output_match, port2) -- opposite of the old
    # (rot=0) placement's own "q2 below q1" arrangement.
    LD2_NE_CX, LD2_NE_CY = 925.0, 615.0
    geo = coil_geom(P, "LD2")
    cx, cy = LD2_NE_CX, LD2_NE_CY
    # RING_KO (coil_guard_ring, Phase 2) replaces SP_KO here -- see LEQ's own comment for the full rationale.
    assert cx + geo["rx"] + RING_KO + RING <= MACRO_W, "LD2 (NE) does not fit against the east edge"
    assert cy + geo["ry"] + RING_KO + RING <= Y_N, "LD2 (NE) does not fit against the north edge"
    (q1, q2), _, _ = place_coil(ly, top, P, "LD2", cx, cy, rot=180)
    ring_in, ring_out = lib.coil_guard_ring(top, cx, cy, geo, rot=180, w=RING_W, sp=RING_SP)
    assert q1[1] < q2[1], "q1 (vdd) must be the southern port, q2 (vx) the northern one"
    top.box("m5", *q1)
    top.box("m5", *q2)
    # vx (q2): extend the existing vx column (already reaches up to yd1 for cs's own transistor drain) straight
    # north then east -- a long run now that LD2 sits far from the core.
    top.box("m5", VX_X[0], yd1, VX_X[1], q2[1] + 0.5)
    top.box("m5", VX_X[0], q2[1], q2[2], q2[3])
    top.label(5, "output_match", (VX_X[0] + VX_X[1]) / 2, om_lead_y())
    # vdd (q1): reach EAST into the generic tile fabric (east edge is close at this corner) -- NOT a straight box
    # at q1's own y (crosses the coil's own body, picks up an MT.2a violation) and NOT a straight run north
    # (crosses q2's own position, shorts vdd to output_match -- both earlier, real mistakes from the first,
    # wrong-branch attempt at this same relocation). Jog WEST of the coil's own edge first, south below the
    # coil's own south edge, then east, clearing the coil's own winding entirely on both axes.
    xw = g(q1[0] - 5)
    yd_vdd = g(cy - geo["ry"] - 9)
    top.box("m5", xw, q1[1], q1[2], q1[3])  # bridge from q1 west to xw, at q1's own height
    top.box("m5", xw, yd_vdd, xw + 2, q1[3])  # vertical run down at xw, clear of the coil's edge
    top.box("m5", xw, yd_vdd, MACRO_W - RING + 2, yd_vdd + 5)  # horizontal run east, south of the coil
    top.label(5, "vdd", MACRO_W - RING - 5, yd_vdd + 2.5)
    INFO[P] = {"M3": {"rows": 1, "fingers": m1["nf"], "wf": wf1, "L": l1, "sym": s1},
               "M2": {"rows": 1, "fingers": m4["nf"], "wf": wf4, "L": l4, "sym": s4},
               "bus_w_um": wb, "guard_ring": R,
               "LD2": {"coil": COILS[(P, "LD2")], "centre": [cx, cy], "ports": "west",
                       "ring_inner": list(ring_in), "ring_outer": list(ring_out)},
               "ld2_vdd_lead": [xw, yd_vdd, MACRO_W - RING + 2, yd_vdd + 5], "vx_column_x": list(VX_X),
               "pins": {"input_cg": list(gp), "vbias_cas": f"Metal3 north edge x={xvn}", "vdd": "Metal5 north edge",
                        "output_match": f"Metal5 column x={VX_X}", "vss": "guard ring"}}
    return top


# ================================================================ lna_core_cg
def resistor(ly, name, sch, inst):
    s, p = sch[inst]
    return lib.pcell(ly, name, "ppolyf_u_high_Rs_resistor",
                     {"volt": "5/6V" if "6p0" in s else "3.3V", "w_res": um(p["W"]), "l_res": um(p["L"])})


def res_terms(c, ly):
    """(west terminal, east terminal, tap) Metal1 boxes of a ppolyf resistor PCell, sorted west -> east"""
    m1 = sorted(lib.merged_boxes(c, "m1", ly), key=lambda b: b.left)
    assert len(m1) == 3, m1
    f = lambda b: (g(b.left), g(b.bottom), g(b.right), g(b.top))
    return f(m1[1]), f(m1[2]), f(m1[0])


C3_VSS_BAR = (270.78, 274.78)  # y of the Metal5 bar joining the C3 bottom plates (vss). Shifted +DY_CG_BULK=
# 34.78 (floorplan compaction step 1, tracks C3/the rest of cg's bulk).


def build_cg(ly):
    """
    M1 (CG, 2 rows of 70 + 2x2 M3 dummy fingers) in a P+ guard ring: row A (mirrored, bottom) and row B share the
    source bus in the middle (y = 295, straight to input_cg of lna_core_input_match);
      drains   : outer buses, joined east on a Metal5 column = vm2 -> C2 (bottom plate) and LD4
      gates    : inner straps (Metal3), joined east on Metal4 = g_cg -> C3 (4 MIM, 2x2, top plates) and R3
      source s : Metal5 west -> x = 82 (input_cg of the input match) and on south / east (YSL) to L1
    L1: coil L1_RECT_coil.gds south (east of LEQ), ports north: port 1 -> source, port 2 -> vss (lead L1_VSS_X
        down to the south edge, narrowed to fit the SP_KO gap). Rectangular reshape of LSHUNT_OUT's own square coil (same 2.5041nH target,
        deliberately reused value -- see the floorplan-fit report), shrunk in world-X / grown in world-Y to fit
        the 1070x1070 macro budget.
    LD4: coil LD4_coil.gds south-east, ports north: port 2 -> vm2 (trace VM2_Y), port 1 -> vdd (short Metal5 lead
         north past its own keep-out into the generic tile fabric, same convention as LD2's vdd lead).
    C2 top plate = output_cs -> CS_GATE_PAD; R4: vbias_cs -> output_cs. Bias pins: see vbias_column.
    """
    P = "lna_core_cg"
    sch = sch_params(P)
    top = Cell(ly, P)
    wf, l2, na, nd, s2 = fet_params(sch, "M1", "M3")
    rows = 2
    ws, wd = 2.5, 4.5  # um, Metal2+3 buses at 1 mA/um per layer: 4.4 mA per row (source bus shared by both rows)
    ta, ma = lib.fet_tile(ly, f"{P}__M2A", volt_of(s2), wf, l2, na // rows, nd // rows, ws=ws, wd=wd)
    tb, mb = lib.fet_tile(ly, f"{P}__M2B", volt_of(s2), wf, l2, na // rows, nd // rows, ws=ws, wd=wd, draw_s=False)
    x1_target = 196.0  # east end of the row buses
    y_s = 329.78  # centre of the shared source bus. Shifted +DY_CG_BULK=34.78 from 295.0 (floorplan compaction
    # step 1: close the gap to LD4's ring, 438.22 (old R4 top) -> 488 (LD4 ring south) - 15um routing margin).
    # Everything downstream (FET rows, guard ring, drain/gate buses) is formula-derived from this, no separate
    # edit needed there. input_match's own rf_y must co-shift by the identical delta (same net, see rf_y).
    ox = x1_target - ma["S"][2]
    oya = g(y_s - (-(ma["S"][1] + ma["S"][3]) / 2))  # row A mirrored: local y -> -y
    tra = top.place(ta, ox, oya, mirror=True)
    A = {k: tbox(tra, v) for k, v in ma.items() if k != "nf"}
    trb = top.place(tb, ox, A["S"][1] - mb["S"][1])
    B = {k: tbox(trb, v) for k, v in mb.items() if k != "nf"}
    assert abs(B["S"][1] - A["S"][1]) < 1e-6 and abs(B["S"][3] - A["S"][3]) < 1e-6, (A["S"], B["S"])
    x0, x1 = A["S"][0], A["S"][2]
    # guard ring: room for the gate / drain joins on the east side
    gw = 0.8
    R = (g(x0 - 1.5 - gw), g(A["D"][1] - 1.5 - gw), g(x1 + 11.5 + gw), g(B["D"][3] + 1.5 + gw))
    lib.guard_ring(top, *R, w=gw)
    ri = (R[0] + gw, R[1] + gw, R[2] - gw, R[3] - gw)
    for T in (A, B):
        top.box("m1", ri[0] - 0.1, T["DGL"][1], T["DGL"][2], T["DGL"][3])
        top.box("m1", T["DGR"][0], T["DGR"][1], ri[2] + 0.1, T["DGR"][3])
    top.label(1, "vss", R[0] + gw / 2, R[1] + 5)
    # --- gates: straps east -> Metal4 join, g_cg Metal4 east (C3 channel), Metal4 up to R3
    gj = (x1 + 1, x1 + 4)
    for T in (A, B):
        top.box("m3", x1, T["G"][1], gj[1], T["G"][3])
        top.cuts("v3", gj[0], T["G"][1], gj[1], T["G"][3])
    yg = (331.28, 335.28)  # g_cg Metal4 strip (C3 channel). Shifted +DY_CG_BULK=34.78 (floorplan compaction
    # step 1, tracks yl/C3 below it).
    # --- drains: buses east -> Metal5 column (vm2)
    dc = (g(x1 + 6), g(x1 + 10))
    for T in (A, B):
        top.box("m2", x1, T["D"][1], dc[1], T["D"][3])
        top.box("m3", x1, T["D"][1], dc[1], T["D"][3])
        top.stack(dc[0], T["D"][1], dc[1], T["D"][3], 3, 5)
    # --- C3: 4 x 1 (single row, re-arranged from the original 2x2 -- "free space in y direction" request).
    # Two mirrored PAIRS side by side: cap1(rot=0,tab west) cap2(rot=180,tab east) | cap3(rot=0,tab west)
    # cap4(rot=180,tab east). Each pair's own gap (cap1-cap2, cap3-cap4) has NEITHER cap's tab in it (both tabs
    # point away from their own pair's gap, same as the old 2x2's left/right columns) -- these two gaps are
    # where the g_cg top-plate join lives, same role as the old 2x2's single middle gap. The MIDDLE gap
    # (cap2-cap3) is different: cap2's tab (east) and cap3's tab (west) both point INTO it -- this is a real,
    # new adjacency the 2x2 never had (it only ever had one tab-free middle gap). A naive single M5 box spanning
    # the whole row for g_cg would physically run through this middle gap's own y-band and merge with both
    # tabs' own vss metal there -- caught here by hand-tracing the geometry, not by DRC, but still only trusted
    # once the real deck confirms it (see this project's own session-long rule on this). Avoided below by using
    # TWO separate join boxes, one per pair, never spanning the middle gap at the plates' own y-band at all.
    w9, l9 = um_grid(sch["C3"][1]["W"]), um_grid(sch["C3"][1]["L"])
    n9 = int(sch["C3"][1].get("m", 1))
    assert n9 == 4
    gapA = 8.0  # cap1-cap2 / cap3-cap4 gap (no tabs in it, hosts a g_cg join -- same value/role as the old gap9)
    gap_vss = 2.0  # cap2-cap3 gap: real clearance between the two tabs' own M4 reach (TAB_M4=-3.4 each side)
    xc1 = g(x1 + 14)
    xc2 = g(xc1 + w9 + 2 * lib.MIM_ENC + gapA)
    xc3 = g(xc2 + w9 + 3.4 + gap_vss + 3.4)
    xc4 = g(xc3 + w9 + 2 * lib.MIM_ENC + gapA)
    yl = 278.78  # shifted +DY_CG_BULK=34.78 from 244.0 (floorplan compaction step 1, tracks cg's bulk)
    assert yl + l9 + lib.MIM_ENC + 1.2 <= yg[0], "C3 row must clear the g_cg gate channel from below"
    c9, t9 = lib.mim_tile(ly, f"{P}__C3", w9, l9)
    plates, straps = [], []
    for (px, rot) in ((xc1, 0), (xc2, 180), (xc3, 0), (xc4, 180)):
        tr = top.place(c9, px + (w9 if rot else 0), yl + (l9 if rot else 0), rot=rot)
        plates.append(tbox(tr, t9["top"]))
        straps.append(tbox(tr, t9["bot"]))
    # g_cg: two separate top-plate join boxes (one per pair), fed from ABOVE the row (same technique the old
    # 2x2 code already used -- yg sits 2.6um above the row's own top edge yl+l9, well clear of every tab, which
    # all live at the row's own y-band, not above it) via one shared M4 run + two separate M4->M5 transitions,
    # one per join box. This never shares a y-band with the vss strap drops below the row at all.
    # Join boxes extend up to yg[0] (not just yl+l9): the old 2x2's own join spanned both rows and so reached
    # (and passed) yg's own height for free; this single row's join box is only l9 tall on its own, leaving a
    # real 2.6um gap to the M4-M5 stack above with nothing bridging it -- confirmed live via LVS (2 of the 4 C3
    # caps' top plates came back on floating/anonymous nets, not joined to g_cg at all).
    joins = [(plates[0][2] - 1, plates[1][0] + 1), (plates[2][2] - 1, plates[3][0] + 1)]
    for j0, j1 in joins:
        top.box("m5", j0, yl, j1, yg[0])
    top.box("m4", gj[0], yg[0], joins[1][1], yg[1])
    for j0, j1 in joins:
        xm = (j0 + lib.MIM_ENC + 1.2, j1 - lib.MIM_ENC - 1.2)
        top.stack(xm[0], yg[0], xm[1], yg[1], 4, 5)
    top.label(4, "g_cg", gj[1] + 3, (yg[0] + yg[1]) / 2)
    for sb in straps:
        top.label(5, "vss", (sb[0] + sb[2]) / 2, (sb[1] + sb[3]) / 2)
    # C3 bottom plates (vss): 4 independent short drops straight onto C3_VSS_BAR -- simpler than the old 2x2's
    # two-tier scheme (lower strap -> bar -> across the channel -> upper strap), since a single row has no
    # "across the channel" case at all; bar -> guard ring (Metal2); lna_core_parts extends the bar to the tiles.
    yb0, yb1 = C3_VSS_BAR
    assert yb1 + lib.MIM_HALO <= yl - lib.MIM_ENC
    top.box("m5", straps[0][0], yb0, straps[3][2], yb1)
    for sb in straps:
        top.box("m5", sb[0], yb0, sb[2], sb[1] + 1)
    top.stack(straps[0][0], yb0, straps[0][2], yb1, 2, 5)
    top.box("m2", R[2] - 0.8, yb0, straps[0][2], R[1] + 0.8)
    # --- R3 above the ring: west = vbias_cg (Metal3 north), east = g_cg (Metal4 -> gate join)
    r1 = resistor(ly, f"{P}__R3", sch, "R3")
    rw, re_, rt = res_terms(r1, ly)
    r1x, r1y = g(x0 + 6 - rt[0]), g(R[3] + 4)
    trr = top.place(r1, r1x, r1y)
    rw, re_ = tbox(trr, rw), tbox(trr, re_)
    yr = (re_[1] + re_[3]) / 2
    top.box("m1", re_[0], yr - 0.9, re_[2] + 2.0, yr + 0.9)
    top.stack(re_[2] + 0.2, yr - 0.9, re_[2] + 2.0, yr + 0.9, 1, 4)
    top.box("m4", re_[2] + 0.2, yr - 0.9, gj[1], yr + 0.9)
    top.box("m4", gj[0], A["G"][1], gj[1], yr + 0.9)
    # g_cg pin -> west edge (pad): Metal4 on up beside C2, west below the bias jogs, Metal3 across the west ring band
    yc = GCG_Y
    assert yc[1] + 4 < min(v[0] for v in VBIAS.values()) - 1
    top.box("m4", gj[0], yr, gj[1], yc[1])
    top.box("m4", GCG_X, yc[0], gj[1], yc[1])
    top.stack(GCG_X, yc[0], GCG_X + 6, yc[1], 3, 4)
    top.box("m3", 0, yc[0], GCG_X + 6, yc[1])
    top.label(3, "g_cg", 1, (yc[0] + yc[1]) / 2)
    top.box("m1", rw[0], rw[1], rw[2], rw[3] + 2.5)
    top.stack(rw[0] - 0.4, rw[3] + 1.0, rw[2] + 0.4, rw[3] + 2.5, 1, 3)
    xvb = vbias_column(top, "vbias_cg", (rw[0] + rw[2]) / 2, rw[3] + 1.0)
    # --- source s: middle bus west -> Metal5 -> x = 82 (input match) and south to L1
    ys0, ys1 = A["S"][1], A["S"][3]
    top.stack(x0, ys0, x0 + 6, ys1, 3, 5)
    top.box("m5", R[0] - 1.0, ys0, x0 + 6, ys1)
    xs = (84.0, 92.0)
    top.box("m5", 82.0, y_s - 5, R[0] - 1.0, y_s + 5)
    top.label(5, "input_match", 83.0, y_s)
    # L1: coil east of LEQ (lna_core_input_match), ports north: port 1 (east) -> YSL lead -> source,
    # port 2 (west) -> vss lead between LEQ and L1 down to the south ring band (Metal4 into the band)
    g1 = coil_geom(P, "L1")
    leq = coil_geom("lna_core_input_match", "LEQ")
    leq_east = LEQ_PORT_X + leq["pe"] + leq["rx"]  # LEQ: rot=180, no axis swap
    L1_VSS_X = (g(leq_east + 1.0), g(leq_east + 6.0))  # centred in the SP_KO=8 gap between LEQ and L1: narrow
    # (5um wide, 1um margin each side) to fit the smaller gap. A north-reaching grid-tap route (like LD2/LD4's
    # vdd leads) was tried first and reverted: l1v sits inside the X-span of the horizontal "source" bus (xs ->
    # l1p, CG source -> L1 port 1, drawn at y=YSL=(222,232) all the way from x=84 to l1p[2]), so ANY lead
    # reaching north from l1v merges with that bus on M5 regardless of which layer the via transition itself
    # uses -- confirmed via LVS (vss shorted straight to source/input_match). South, through this narrow gap
    # and down to the south ring, stays clear of that bus's X/Y footprint entirely.
    # L1: rot=90 swaps axes -- its world-space X-extent is its local ry, world-space Y-extent is its local rx
    # cx1 keeps the SP_KO-based formula (not RING_KO) deliberately: L1_VSS_X's own vss lead already lives in
    # this exact gap (leq_east+1..leq_east+6, tuned against the CURRENT cx1), and L1's own downstream routing
    # (YSL crossing dip-bands, output_match's xe column threading L1's spiral gaps) was hand-tuned against L1's
    # CURRENT position -- moving cx1 west would shift all of that and need the same re-verification cascade as
    # last session's LVS-short hunting. Phase 2 adds L1's ring at its current site (real DRC/LVS safety win,
    # same as LEQ/LD2) without yet reclaiming this gap's area; revisit only as a deliberate, separate follow-up.
    cx1, cy1 = g(leq_east + SP_KO + g1["ry"]), g(L1_PORT_Y - g1["pe"])
    assert leq_east + 1 <= L1_VSS_X[0] and L1_VSS_X[1] + 1 <= cx1 - g1["ry"]
    assert cy1 - g1["rx"] - RING >= Y_S + RING, "L1 does not fit"
    (l1p, l1v), _, _ = place_coil(ly, top, P, "L1", cx1, cy1, rot=90, mirror=True)
    # avoid: output_match's own rf_out_pad crossing (build_output_match's xe=456 dipped_column, dip_bands
    # [(-318,-312),(197,213),(220,244),(258,264),(272,286)], each with its own +-2um transition margin) tunnels
    # through M3/M4 at x=456..458 to get past L1 at several points. Checked every band's own margin-extended
    # range against BOTH ring walls it could reach (south wall y -321..-319, north wall y 204..206) -- exactly
    # two overlaps, confirmed via LVS (the first found live, as a real "rf_out_pad merges with vss" short; the
    # second found by the same overlap check before it could cause one): (197,213)+-2 = 195..215 hits the north
    # wall; (-318,-312)+-2 = -320..-310 hits the south wall (only 1um of actual overlap, -320..-319, but real
    # overlap all the same). The other 3 bands (all y>=220) don't reach either wall.
    ring_in, ring_out = lib.coil_guard_ring(top, cx1, cy1, g1, rot=90, w=RING_W, sp=RING_SP,
                                             avoid=[(454.0, 195.0, 460.0, 215.0), (454.0, -322.0, 460.0, -308.0)])
    assert l1v[2] < l1p[0], "vss port must be the western one"
    ysl = YSL
    assert l1v[3] + 9.5 + 5 <= ysl[0]
    top.box("m5", xs[0], ysl[0], xs[1], y_s + 5)
    # YSL bus (CG source -> L1 port 1) crosses lna_core_output_match's own rf_out return lead on the same layer:
    # a tall Metal5 column at x 451..453 running almost the full macro height (LSHUNT_OUT's rf_out detour around
    # its own C1 cap, routed independently and unaware of this bus). Confirmed via NetTracer as the actual bridge
    # behind the "input_cg merges with vdd/vss" LVS mismatch found after the re-floorplan (the rf_out lead itself
    # ties further up into the vdd rail construction). Drop to Metal4 for just the crossing span, same fix
    # pattern as LSHUNT_OUT's own vss-under-rf_out crossing.
    # Single dip zone 446..466 covering both obstructions at once -- L1's own west-edge area and
    # lna_core_output_match's own rf_out return column (x 456..460, moved there to thread L1's winding gaps --
    # see build_output_match), close enough together to share one crossing. Confirmed via NetTracer as the
    # actual bridge behind the "input_cg merges with vdd/vss" LVS mismatch found after the re-floorplan.
    # Crosses on Metal3, not Metal4: output_match's own column dips to Metal4 at this exact same y-band (same
    # dip_bands list, same underlying L1 feature) at x 456..460 -- using Metal4 here too would merge the two
    # independent dips with each other on that shared layer (confirmed: that was the actual bug behind this
    # crossing still merging after Metal4 was first tried). The transition stacks (3..5, so Metal4 appears only
    # narrowly at their own 2um width, outside 456..460) must clear the column with real margin, not just end
    # at its edge -- confirmed empirically that stopping a run exactly at another same-layer shape's edge still
    # merges them (KLayout: touching, zero gap or not, is still one net). Metal3 confirmed clear here by direct
    # GDS inspection.
    xo0, xo1 = 446.0, 466.0
    assert xs[0] < xo0 and xo1 < l1p[2]
    top.box("m5", xs[0], ysl[0], xo0, ysl[1])
    top.stack(xo0, ysl[0], xo0 + 2, ysl[1], 3, 5)
    top.box("m3", xo0 + 2, ysl[0], xo1 - 2, ysl[1])
    top.stack(xo1 - 2, ysl[0], xo1, ysl[1], 3, 5)
    top.box("m5", xo1, ysl[0], l1p[2], ysl[1])
    top.box("m5", *l1p)
    top.box("m5", l1p[0], l1p[3] - 0.5, l1p[2], ysl[1])
    top.box("m5", *l1v)
    # L1's own vss lead (reaching east to its own port, l1v[2]) crosses lna_core_output_match's own rf_out_pad
    # "xe" column (Metal5, x 451..453) on the same layer -- a third instance of the same cross-block M5 crossing
    # class (confirmed via NetTracer as the bridge behind the residual "rf_out_pad merges with vss" LVS
    # mismatch, after the first two crossings -- YSL bus and q2 -- were fixed above). No nearby via content
    # here (confirmed by direct inspection, unlike q2's crossing next to LD4's own dense edge array), so dip
    # cleanly: Metal4 for the crossing span, real clearance on both approaches.
    # dip on Metal3, not Metal4: output_match's own column dips to Metal4 across this entire y-band too (same
    # underlying L1 feature, its own dip_band (197, 213) with its own +-2um transition margin, so its Metal4
    # usage really runs 197..213 and its own Metal4<->Metal5 transition stacks sit right at 197..199 and
    # 211..213) -- Metal4 here would merge the two independent dips with each other, and a plain Metal5 strip
    # anywhere in 211..213 would land squarely on output_match's own transition's Metal5 portion there, same
    # lesson as the YSL-bus fix above, just discovered one layer later. So this dip's own upper edge is pinned
    # to y_hi (no "above the dip" plain run at all) to swallow output_match's entire 197..213 Metal4 range;
    # below, it starts clear of a separate, unrelated multi-layer (M1/M2/M3) feature at y 200..203.
    y_lo, y_hi = l1v[3] - 0.5, l1v[3] + 9.5
    yd0 = 204.0
    xv0, xv1 = 446.0, 466.0  # clear of output_match's own column (456..460) with real margin on both sides
    assert L1_VSS_X[0] < xv0 and xv1 < l1v[2] and y_lo < yd0 < y_hi
    top.box("m5", L1_VSS_X[0], y_lo, l1v[2], yd0)
    top.box("m5", L1_VSS_X[0], yd0, xv0, y_hi)
    top.stack(xv0, yd0, xv0 + 2, y_hi, 3, 5)
    top.box("m3", xv0 + 2, yd0, xv1 - 2, y_hi)
    top.stack(xv1 - 2, yd0, xv1, y_hi, 3, 5)
    top.box("m5", xv1, yd0, l1v[2], y_hi)
    # Metal5 down to just above the south ring band (vdd rail there), Metal4 into the band (vss)
    yb = Y_S + RING + 4
    top.box("m5", L1_VSS_X[0], yb, L1_VSS_X[1], l1v[3] + 9.5)
    top.stack(L1_VSS_X[0], yb, L1_VSS_X[1], yb + 6, 4, 5)
    top.box("m4", L1_VSS_X[0], Y_S + 2, L1_VSS_X[1], yb + 6)
    top.label(4, "vss", (L1_VSS_X[0] + L1_VSS_X[1]) / 2, Y_S + 3)
    # --- C2: plate east of the vm2 column; bottom plate (tab west, on the column) = vm2, top plate = output_cs
    w1, l1c = um_grid(sch["C2"][1]["W"]), um_grid(sch["C2"][1]["L"])
    c1, t1 = lib.mim_tile(ly, f"{P}__C2", w1, l1c)
    c1x, c1y = g(dc[1] + 0.9), 406.78  # c1y shifted +DY_CG_BULK=34.78 from 372.0 (floorplan compaction step 1)
    assert c1x + w1 + lib.MIM_ENC + 1.2 <= CS_GATE_PAD[0], "C2 bottom plate too close to the CS gate pad (MIMTM.1)"
    trc = top.place(c1, c1x, c1y)
    p1, b1 = tbox(trc, t1["top"]), tbox(trc, t1["bot"])
    assert dc[0] <= b1[0] and b1[2] <= dc[1]
    top.box("m5", dc[0], A["D"][1], dc[1], p1[3])  # vm2 column (drains -> C2 strap)
    gp = CS_GATE_PAD
    # output_cs -> lna_core_cs input_cg pad. CS_GATE_PAD moved ~300um east (cs re-floorplan, clearing LD4's
    # new NW-corner placement): a straight Metal5 reach at this wire's own y would now run directly through
    # LD4's own west/east edge via-stack busbars (local x 329..547, y 258..722 -- via1..via4 solid the whole
    # height, confirmed by the deep-mode DRC short this exact straight reach produced) and, further east,
    # through L1's own coil footprint too (occupies roughly x 436..779 below y~213). Route on Metal3 through
    # the one confirmed-clear path instead: down through the narrow gap between C3's own east edge (322) and
    # LD4's west edge (329), east at y~240 through the gap between L1 (ends ~213) and LD4 (starts 258) -- clear
    # of both coils and of the Metal5-only vbias/YSL bus at y 222..232 (different layer, no via = no connection)
    # -- then back up to Metal5 east of LD4's east edge (547). Every segment confirmed clear by direct GDS
    # inspection, not assumed from geometry alone (same lesson as the C2/C3 collision found during LD4's own
    # placement).
    xd, yg_lo, xr = 324.0, 240.0, 558.0
    top.box("m5", p1[2] - 1, gp[1], xd + 2, gp[3])  # M5 run from C2 east to the drop point (still west of LD4)
    top.stack(xd, gp[1], xd + 2, gp[3], 3, 5)  # M5 -> M3, in the C3/LD4 gap
    top.box("m3", xd, yg_lo, xd + 2, gp[3])  # drop to the L1/LD4 gap
    top.box("m3", xd, yg_lo, xr + 2, yg_lo + 2)  # east under LD4, in the L1/LD4 gap (y 213..258)
    top.box("m3", xr, yg_lo, xr + 2, gp[3])  # rise back up, east of LD4
    top.stack(xr, gp[1], xr + 2, gp[3], 3, 5)  # M3 -> M5, east of LD4
    top.box("m5", xr, gp[1], gp[2], gp[3])  # final run east into the pad
    top.label(5, "output_cs", (gp[0] + gp[2]) / 2, (gp[1] + gp[3]) / 2)
    # --- R4 above C2: west = vbias_cs (Metal3 north), east = output_cs (Metal5 down to the C2 top plate)
    r2 = resistor(ly, f"{P}__R4", sch, "R4")
    rw2, re2, rt2 = res_terms(r2, ly)
    trr2 = top.place(r2, g(c1x - rt2[0] + 1.0), g(p1[3] + lib.MIM_ENC + 6.0))
    rw2, re2 = tbox(trr2, rw2), tbox(trr2, re2)
    yr2 = (re2[1] + re2[3]) / 2
    top.box("m1", re2[0], yr2 - 0.9, re2[2] + 2.0, yr2 + 0.9)
    top.stack(re2[2] + 0.2, yr2 - 0.9, re2[2] + 2.0, yr2 + 0.9, 1, 5)
    top.box("m5", re2[2] + 0.2, p1[3] - 1.0, re2[2] + 2.0, yr2 + 0.9)
    top.box("m1", rw2[0], rw2[1], rw2[2], rw2[3] + 2.5)
    top.stack(rw2[0] - 0.4, rw2[3] + 1.0, rw2[2] + 0.4, rw2[3] + 2.5, 1, 3)
    xvc = vbias_column(top, "vbias_cs", (rw2[0] + rw2[2]) / 2, rw2[3] + 1.0)
    # --- LD4: rotated to landscape (rot=180, no swap: world-X extent = rx = 232, world-Y extent = ry = 109) --
    # user requirement, also the fix for a real collision found by direct GDS inspection: the OLD portrait
    # placement (rot=90, cx4=438, cy4=490) had world-Y extent = rx = 232 -> world span y=[258,722], and its own
    # x=[329,547] ring/winding territory directly overlapped the new 4x1 C3 row's east cap (cap3/cap4, x up to
    # 436.76). Landscape shrinks LD4's own Y reach to only 218 total, freeing that space.
    # Site: NW corner (user's explicit instruction -- "bring it to the left, fit to the NW edge, not under LD2"),
    # not the first candidate tried (far east, in the LSHUNT_OUT/LD2 Y-gap). At cx4=345, cy4=600, world-X=[113,577]
    # clears cg's own vbias_cg/vbias_cs columns (x=59..61 / 74..76, both reaching north to Y_N) with 22um real
    # margin, and world-Y=[491,709] stays well clear of every south-side cg structure (LEQ/L1/C3 all y<=300ish)
    # and well under Y_N=751 with RING_KO+RING margin. Confirmed empirically (probe_ld4_nw.py / begin_shapes_rec
    # on the regenerated GDS) that this patch of cg is genuinely open on its own -- the only real obstacle is
    # output_match's own rf_out_pad column (x=410..420, world y up to 714), which lands dead centre of this new
    # footprint; see the detour added in build_output_match below, not fixed here (cross-block).
    geo = coil_geom(P, "LD4")
    cx4, cy4 = 345.0, 600.0
    assert cx4 - geo["rx"] - RING_KO >= 91.0 + 3.0, "LD4 (NW) does not clear the vbias_cg/cs/cas columns (x<=91)"
    assert cy4 + geo["ry"] + RING_KO + RING <= Y_N, "LD4 (NW) does not fit against the north edge"
    (q1, q2), _, _ = place_coil(ly, top, P, "LD4", cx4, cy4, rot=180)
    ring_in4, ring_out4 = lib.coil_guard_ring(top, cx4, cy4, geo, rot=180, w=RING_W, sp=RING_SP)
    # ports: both face WEST here (confirmed by direct probe), stacked close in Y (q1 south, q2 north, ~4um apart)
    # but never turn toward each other -- q1 (vdd) only needs a short local stub, q2 (vm2) runs a short way east
    # to "dc" at its own, different Y the whole way, so the two paths stay parallel and never cross.
    assert q1[1] < q2[1] and q1[0] == q2[0], "q1 (vdd) must be the southern port, q2 (vm2) the northern one"
    top.box("m5", *q1)
    top.box("m5", *q2)
    # vdd (q1): short reach further west into open space (clear of the vbias columns at x<=91) -- Phase 4's
    # supply-grid rework will tie this into the tile fabric; a clean, DRC-legal stub is all LVS needs for now.
    top.box("m5", q1[0] - 15.0, q1[1], q1[2], q1[3])
    top.label(5, "vdd", q1[0] - 14.0, (q1[1] + q1[3]) / 2)
    # vm2 (q2): short run east back to the drain-bus "dc" column (same destination as before the rotation) --
    # extend the existing dc column (drawn above, currently reaching only p1[3]=430.22) further north to q2's own
    # y=601..603, then jog west to meet q2. This y-band is well above C2's own top plate (372..430.22), so unlike
    # the first candidate's own routing, no dip around C2 is needed here at all.
    top.box("m5", dc[0], p1[3], dc[1], q2[3])
    top.box("m5", q2[0], q2[1], dc[1], q2[3])
    INFO[P] = {"M1": {"rows": rows, "fingers_per_row": ma["nf"], "wf": wf, "L": l2,
                      "sym": s2},
               "bus_w_um": {"source": ws, "drain": wd}, "guard_ring": R,
               "C3_pF": round(4 * lib.c_mim_pf(w9, l9), 3), "C2_pF": round(lib.c_mim_pf(w1, l1c), 3),
               "L1": {"coil": COILS[(P, "L1")], "centre": [cx1, cy1], "ports": "north",
                      "ring_inner": list(ring_in), "ring_outer": list(ring_out)},
               "LD4": {"coil": COILS[(P, "LD4")], "centre": [cx4, cy4], "ports": "west",
                       "ring_inner": list(ring_in4), "ring_outer": list(ring_out4)},
               "c9_vss_straps": straps, "c9_plates": plates, "l1_vss_lead_x": list(L1_VSS_X),
               "ld4_vdd_lead": [q1[0] - 15.0, q1[1], q1[2], q1[3]],
               "vm2_column_x": list(dc),
               "pins": {"input_match": "Metal5 x=82 y=290..300", "output_cs": list(gp), "g_cg": f"Metal3 west edge y={GCG_Y}",
                        "vbias_cg": f"Metal3 north edge x={xvb:.2f}", "vbias_cs": f"Metal3 north edge x={xvc:.2f}",
                        "vdd": "Metal5 stub west of LD4", "vss": "guard ring, C3 straps, L1 port 2 (south edge)"}}
    return top


BUILDERS = {"input_match": build_input_match, "cg": build_cg, "cs": build_cs, "output_match": build_output_match}
# No more variant switch needed: input_match and output_match each read whichever cap symbol (capa.sym or
# cap_mim_2f0fF) the checked-out xschem/lna_core_{input,output}_match.sch uses and size/draw accordingly -- the
# main vs main_pex choice lives entirely in which xschem files are checked out (see the main_layout /
# main_pex_layout branches), not in a runtime flag here.


def main():
    want = [c for c in (globals().get("cells") or ",".join(BUILDERS)).split(",") if c]
    for key in want:
        ly = pya.Layout()
        ly.dbu = 0.001
        top = BUILDERS[key](ly)
        for c in list(ly.each_cell()):  # drop the PCell variant cells
            if c.parent_cells() == 0 and c.cell_index() != top.c.cell_index():
                ly.delete_cell(c.cell_index())
        name = top.c.name
        path = os.path.join(HERE, name + ".gds")
        ly.write(path)
        b = top.c.dbbox()
        print(f"wrote {path}  bbox {b.left:.1f},{b.bottom:.1f} .. {b.right:.1f},{b.top:.1f}")
    rep = os.path.join(HERE, "lna_core_layouts.json")
    old = json.load(open(rep)) if os.path.exists(rep) else {}
    old.update(INFO)
    json.dump(old, open(rep, "w"), indent=1)


main()
