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
SP_KO = 10.0  # keep-out around every inductor
COILS = {("lna_core_input_match", "LEQ"): "LEQ_MAIN_RECT2_coil.gds", ("lna_core_cg", "L1"): "L1_RECT_coil.gds",
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
MACRO_W, RING = 1062, 12
Y_S, Y_N = -353, 751  # main_pex: bumped from main_layout's ported 731 -- main_pex's own output series cap
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
RFO_X = 415.0  # rf_out_pad lead column (centre)
YSL = (222.0, 232.0)  # L1 lead (CG source -> L1 port 1), runs east above LEQ
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
LSH_PORT_X, LSH_CY = 455.0, 583.0  # LSHUNT_OUT north-east, ports west: port 1 -> rf_out lead, port 2 -> vss (north)
# main_pex-specific retune (main_layout used 563 against its own, smaller output cap): feasible range here is
# (577.6, 588] -- low end from "rf_out port must clear the cap" (q1_min_y ~= 550.6 for main_pex's real cap size,
# bigger than main's ~534.9), high end from "LSHUNT_OUT does not fit" (cy+ry+SP_KO+RING <= Y_N=751). 583 mid-range.
# LSH_CY re-centred for LSHUNT_OUT_RECT's ry=141. Feasible range is actually (561.9, 573] with Y_N=751: the
# low end comes from the OTHER assert down in build_output_match ("rf_out port must be the lower one, clear of
# the cap") -- q1 (rf_out port) sits at local y in [-27,-1] pre-rotation, so world q1_bottom = cy-27 must clear
# the output cap's top plate + 20um margin (q1_min_y ~= 534.9 for the real cap geometry), i.e. cy > 561.9; the
# high end is the "LSHUNT_OUT does not fit" assert (cy + ry + SP_KO + RING <= Y_N = 751). 567 sits mid-range.
LD2_VDD_X = (350.0, 360.0)  # vdd lead of LD2 to the north edge
LSH_VSS_X = (440.0, 450.0)  # vss lead of LSHUNT_OUT between the rf_out lead and the coil (Metal4 into the north ring)
GCG_Y, GCG_X = (430.0, 434.0), 41.0  # g_cg lead to the west edge (Metal4 from the gate join, Metal3 from x = GCG_X)
# bias pins (Metal3, north edge): jog west below LD2 at y = jog, then north at x
VBIAS = {"vbias_cg": (445.0, 60.0), "vbias_cs": (452.0, 75.0), "vbias_cas": (459.0, 90.0)}


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
    assert cy + geo["ry"] + SP_KO <= YSL[0] and cy - geo["ry"] - RING >= Y_S + RING, "LEQ does not fit"
    (q1, q2), _, _ = place_coil(ly, top, P, "LEQ", cx, cy, rot=180, mirror=True)
    lead_x = 25.0  # rf_in lead column (centre)
    rf_y = 295.0
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
    INFO[P] = {"LEQ": {"coil": COILS[(P, "LEQ")], "centre": [cx, cy], "ports": "west"},
               **cap_info, "leq_vss_lead_y": [q2[1], q2[3]],
               "pins": {"rf_in_pad": "Metal5 west edge y=295", "input_cg": f"Metal5 east edge x={x_e} y=295",
                        "vss": "Metal5 west edge (LEQ port 2)"}}
    return top


# ---------------------------------------------------------------- interfaces between the cells (floorplan coords)
CS_GATE_PAD = (268.0, 399.5, 274.0, 405.5)  # input_cg of lna_core_cs = output_cs of lna_core_cg (Metal3..5 stack)
VX_X = (377.0, 387.0)  # output_match (vx) Metal5 column of lna_core_cs, east of the cascode
C_OUT_PLATE = (391.0, 466.0)  # lower-left of the output C1 top plate (rotated: x extent = L, y extent = W)
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
    LSHUNT_OUT: coil east of the rf_out lead, rotated 180 (ports west): port 1 (lower) -> rf_out lead, port 2 ->
    vss (Metal5 north between the rf_out lead and the coil, Metal4 into the north ring band)
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
    top.box("m5", OM_IN_X, yc - 5, pt[0] + 1, yc + 5)
    top.box("m5", bt[0], bt[1], bt[2], bt[3])
    top.box("m5", xr - 5, bt[1], xr + 5, Y_N)
    q1_min_y = pt[3] + 20  # rf_out port must clear the cap
    cap_info = {cn: {"W": w, "L": l, "pF": round(lib.c_mim_pf(w, l), 3), "schematic_pF": round(c_pf, 3)},
                "top_plate": list(pt)}
    top.label(5, "output_cs", OM_IN_X + 1, yc)
    top.label(5, "rf_out_pad", xr, Y_N - 1)
    # --- LSHUNT_OUT
    geo = coil_geom(P, "LSHUNT_OUT")
    cx, cy = g(LSH_PORT_X + geo["pe"]), LSH_CY
    assert cy - geo["ry"] - SP_KO >= VM2_Y[1] and cy + geo["ry"] + SP_KO + RING <= Y_N, "LSHUNT_OUT does not fit"
    assert cx + geo["rx"] + SP_KO / 2 <= MACRO_W - RING and LSH_VSS_X[1] + 2 <= LSH_PORT_X - 0.5, \
        "LSHUNT_OUT does not fit the macro width"
    (q1, q2), _, _ = place_coil(ly, top, P, "LSHUNT_OUT", cx, cy, rot=180)
    assert q1[3] < q2[1] and q1[1] > q1_min_y, "rf_out port must be the lower one, clear of the cap / through-wire"
    top.box("m5", xr + 5 - 1, q1[1], q1[2], q1[3])  # port 1 -> rf_out lead
    vx0, vx1 = LSH_VSS_X
    top.box("m5", vx0, q2[1], q2[2], q2[3])  # port 2 -> vss lead
    yv = g(Y_N - RING - 14)
    top.box("m5", vx0, q2[1], vx1, yv + 6)
    top.stack(vx0, yv, vx1, yv + 6, 4, 5)
    top.box("m4", vx0, yv, vx1, Y_N - 2)
    top.label(4, "vss", (vx0 + vx1) / 2, Y_N - 3)
    INFO[P] = {**cap_info, "output_cs_lead_y": yc,
               "rf_out_x": [xr - 5, xr + 5],
               "LSHUNT_OUT": {"coil": COILS[(P, "LSHUNT_OUT")], "centre": [cx, cy], "ports": "west"},
               "macro": [MACRO_W, Y_N - Y_S], "frame": [0, Y_S, MACRO_W, Y_N],
               "pins": {"output_cs": f"Metal5 x={OM_IN_X} y={yc}", "rf_out_pad": f"Metal5 north edge x={xr}",
                        "vss": f"Metal4 north edge x={vx0}..{vx1}"}}
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
    x_m1, y_m1 = 285.0, 400.0
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
    # vbias_cas: M4 gate strap -> west, Metal3 column north (jog west below LD2)
    xv = g(R[0] - 3.0)
    top.box("m3", xv - 1, T4["G"][1], T4["G"][0], T4["G"][3])
    xvn = vbias_column(top, "vbias_cas", xv, T4["G"][1])
    # vx: M4 drain bus -> east, Metal5 column
    yd0, yd1 = T4["D"][1], T4["D"][3]
    top.box("m3", T4["D"][2], yd0, VX_X[1], yd1)
    top.box("m2", T4["D"][2], yd0, ri[2] - 0.6, yd1)
    top.stack(VX_X[0], yd0, VX_X[1], yd1, 3, 5)
    # LD2: coil north-west of the core, ports east
    geo = coil_geom(P, "LD2")
    cx, cy = g(LD2_PORT_X - geo["pe"]), LD2_CY
    assert cx - geo["rx"] - SP_KO >= max(v[1] for v in VBIAS.values()) + 1, "LD2 over the bias leads"
    assert cy - geo["ry"] - SP_KO >= max(v[0] for v in VBIAS.values()) + 1, "LD2 over the bias jogs"
    assert cy + geo["ry"] + SP_KO + RING <= Y_N, "LD2 does not fit"
    (q1, q2), _, _ = place_coil(ly, top, P, "LD2", cx, cy)
    assert q2[3] < q1[1] and q2[1] - 10 > om_lead_y() + 5, "vx port must be the lower one, above the C1 lead"
    top.box("m5", *q2)
    top.box("m5", q2[2] - 0.5, q2[3] - 10, VX_X[1], q2[3])  # port 2 -> vx column
    top.box("m5", VX_X[0], yd0, VX_X[1], q2[3])  # vx column: C1 lead of lna_core_output_match, LD2 port 2
    top.label(5, "output_match", (VX_X[0] + VX_X[1]) / 2, om_lead_y())
    top.box("m5", *q1)
    top.box("m5", q1[2] - 0.5, q1[1], LD2_VDD_X[1], q1[1] + 10)  # port 1 -> vdd lead
    # vdd: short run just past LD2's own keep-out into the generic tile fabric (which is continuous/abutting
    # there, same convention as the macro's main vdd rail), instead of all the way to Y_N -- LD2's keep-out
    # boundary is at cy + ry + SP_KO; tiles start right after it, so a short margin past that reliably lands
    # inside a kept tile regardless of the grid's exact phase.
    ld2_vdd_y1 = g(cy + geo["ry"] + SP_KO + 12)
    assert ld2_vdd_y1 < Y_N, "LD2 vdd lead shortening computed past the macro edge"
    top.box("m5", LD2_VDD_X[0], q1[1], LD2_VDD_X[1], ld2_vdd_y1)
    assert LD2_VDD_X[1] + 5 <= VX_X[0]
    top.label(5, "vdd", (LD2_VDD_X[0] + LD2_VDD_X[1]) / 2, (q1[1] + ld2_vdd_y1) / 2)
    INFO[P] = {"M3": {"rows": 1, "fingers": m1["nf"], "wf": wf1, "L": l1, "sym": s1},
               "M2": {"rows": 1, "fingers": m4["nf"], "wf": wf4, "L": l4, "sym": s4},
               "bus_w_um": wb, "guard_ring": R, "LD2": {"coil": COILS[(P, "LD2")], "centre": [cx, cy], "ports": "east"},
               "ld2_vdd_lead": [LD2_VDD_X[0], q1[1], LD2_VDD_X[1], ld2_vdd_y1], "vx_column_x": list(VX_X),
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


C3_VSS_BAR = (236.0, 240.0)  # y of the Metal5 bar joining the C3 bottom plates (vss)


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
    y_s = 295.0  # centre of the shared source bus
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
    yg = (296.5, 300.5)  # g_cg Metal4 strip (C3 channel)
    # --- drains: buses east -> Metal5 column (vm2)
    dc = (g(x1 + 6), g(x1 + 10))
    for T in (A, B):
        top.box("m2", x1, T["D"][1], dc[1], T["D"][3])
        top.box("m3", x1, T["D"][1], dc[1], T["D"][3])
        top.stack(dc[0], T["D"][1], dc[1], T["D"][3], 3, 5)
    # --- C3: 2 x 2, left column tab west, right column rotated 180 (tab east), top plates joined in the middle
    w9, l9 = um_grid(sch["C3"][1]["W"]), um_grid(sch["C3"][1]["L"])
    n9 = int(sch["C3"][1].get("m", 1))
    assert n9 == 4
    gap9 = 8.0  # bottom plate to bottom plate (Metal4 g_cg strip in the gaps, >= 1.2 um from the plates)
    xl = g(x1 + 14)
    xr = g(xl + w9 + 2 * lib.MIM_ENC + gap9)
    yl = 244.0
    yu = g(yl + l9 + 2 * lib.MIM_ENC + gap9)
    assert yl + l9 + lib.MIM_ENC + 1.2 <= yg[0] and yu - lib.MIM_ENC - 1.2 >= yg[1]
    c9, t9 = lib.mim_tile(ly, f"{P}__C3", w9, l9)
    plates, straps = [], []
    for (px, py, rot) in ((xl, yl, 0), (xl, yu, 0), (xr, yl, 180), (xr, yu, 180)):
        tr = top.place(c9, px + (w9 if rot else 0), py + (l9 if rot else 0), rot=rot)
        plates.append(tbox(tr, t9["top"]))
        straps.append(tbox(tr, t9["bot"]))
    top.box("m5", plates[0][2] - 1, plates[0][1], plates[2][0] + 1, plates[1][3])  # top plates (g_cg)
    xm = (xl + w9 + lib.MIM_ENC + 1.2, xr - lib.MIM_ENC - 1.2)  # Metal4-free zone limits in the middle gap
    top.box("m4", gj[0], yg[0], xm[1], yg[1])
    top.stack(xm[0], yg[0], xm[1], yg[1], 4, 5)
    top.label(4, "g_cg", gj[1] + 3, (yg[0] + yg[1]) / 2)
    for sb in straps:
        top.label(5, "vss", (sb[0] + sb[2]) / 2, (sb[1] + sb[3]) / 2)
    # C3 bottom plates (vss) joined inside the block: Metal5 bar below C3 (y = C3_VSS_BAR), lower straps down to it,
    # across the C3 channel to the upper straps, bar -> guard ring (Metal2); lna_core_parts extends the bar to the tiles
    yb0, yb1 = C3_VSS_BAR
    assert yb1 + lib.MIM_HALO <= yl - lib.MIM_ENC
    top.box("m5", straps[0][0], yb0, straps[2][2], yb1)
    for lo, up in ((straps[0], straps[1]), (straps[2], straps[3])):
        top.box("m5", lo[0], yb0, lo[2], lo[1] + 1)  # lower strap down to the bar
        top.box("m5", lo[0], lo[3] - 1, lo[2], up[1] + 1)  # across the C3 channel to the upper strap
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
    cx1, cy1 = g(leq_east + SP_KO + g1["ry"]), g(L1_PORT_Y - g1["pe"])
    assert leq_east + 1 <= L1_VSS_X[0] and L1_VSS_X[1] + 1 <= cx1 - g1["ry"]
    assert cy1 - g1["rx"] - RING >= Y_S + RING, "L1 does not fit"
    (l1p, l1v), _, _ = place_coil(ly, top, P, "L1", cx1, cy1, rot=90, mirror=True)
    assert l1v[2] < l1p[0], "vss port must be the western one"
    ysl = YSL
    assert l1v[3] + 9.5 + 5 <= ysl[0]
    top.box("m5", xs[0], ysl[0], xs[1], y_s + 5)
    top.box("m5", xs[0], ysl[0], l1p[2], ysl[1])
    top.box("m5", *l1p)
    top.box("m5", l1p[0], l1p[3] - 0.5, l1p[2], ysl[1])
    top.box("m5", *l1v)
    top.box("m5", L1_VSS_X[0], l1v[3] - 0.5, l1v[2], l1v[3] + 9.5)
    # Metal5 down to just above the south ring band (vdd rail there), Metal4 into the band (vss)
    yb = Y_S + RING + 4
    top.box("m5", L1_VSS_X[0], yb, L1_VSS_X[1], l1v[3] + 9.5)
    top.stack(L1_VSS_X[0], yb, L1_VSS_X[1], yb + 6, 4, 5)
    top.box("m4", L1_VSS_X[0], Y_S + 2, L1_VSS_X[1], yb + 6)
    top.label(4, "vss", (L1_VSS_X[0] + L1_VSS_X[1]) / 2, Y_S + 3)
    # --- C2: plate east of the vm2 column; bottom plate (tab west, on the column) = vm2, top plate = output_cs
    w1, l1c = um_grid(sch["C2"][1]["W"]), um_grid(sch["C2"][1]["L"])
    c1, t1 = lib.mim_tile(ly, f"{P}__C2", w1, l1c)
    c1x, c1y = g(dc[1] + 0.9), 372.0
    assert c1x + w1 + lib.MIM_ENC + 1.2 <= CS_GATE_PAD[0], "C2 bottom plate too close to the CS gate pad (MIMTM.1)"
    trc = top.place(c1, c1x, c1y)
    p1, b1 = tbox(trc, t1["top"]), tbox(trc, t1["bot"])
    assert dc[0] <= b1[0] and b1[2] <= dc[1]
    top.box("m5", dc[0], A["D"][1], dc[1], p1[3])  # vm2 column (drains -> C2 strap)
    gp = CS_GATE_PAD
    top.box("m5", p1[2] - 1, gp[1], gp[2], gp[3])  # output_cs -> lna_core_cs input_cg pad
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
    # --- LD4: coil south-east (east of L1), ports north: port 2 (west) -> vm2 trace, port 1 (east) -> vdd, short
    # lead north past its own keep-out into the generic tile fabric (same convention as LD2's own vdd lead -- see
    # make_lna_core_parts.py's build_supply(), which reads ld4_vdd_lead below for its foreign-metal exclusion).
    # Previously ran a dedicated column all the way to a fixed east-edge rail (VDD4_X=(1158,1168)), which pinned
    # MACRO_W >= 1185 on its own regardless of what else needed the width -- removed, since the generic tile fabric
    # immediately north of LD4 already carries vdd (M5) and a short local reach is all that's needed.
    geo = coil_geom(P, "LD4")
    # LD4: rot=90 swaps axes too, same convention as L1 above
    cx4, cy4 = g(cx1 + g1["ry"] + SP_KO + geo["ry"]), g(LD4_PORT_Y - geo["pe"])
    assert cy4 - geo["rx"] - RING >= Y_S + RING, "LD4 does not fit"
    assert cx4 + geo["ry"] + RING <= MACRO_W, "LD4 does not fit the macro width"
    (q1, q2), _, _ = place_coil(ly, top, P, "LD4", cx4, cy4, rot=90, mirror=True)
    assert q2[2] < q1[0], "vm2 port must be the western one"
    yv = VM2_Y
    assert yv[0] - 4 >= plates[1][3] and q2[3] + 10 <= yv[1]
    top.box("m5", *q2)
    top.box("m5", q2[2] - 10, q2[3] - 0.5, q2[2], yv[1])
    top.box("m5", dc[0], yv[0], q2[2], yv[1])
    top.box("m5", *q1)
    ld4_vdd_y1 = g(q1[3] + 12)
    assert ld4_vdd_y1 < Y_N, "LD4 vdd lead shortening computed past the macro edge"
    top.box("m5", q1[0], q1[1], q1[2], ld4_vdd_y1)
    top.label(5, "vdd", (q1[0] + q1[2]) / 2, (q1[1] + ld4_vdd_y1) / 2)
    INFO[P] = {"M1": {"rows": rows, "fingers_per_row": ma["nf"], "wf": wf, "L": l2,
                      "sym": s2},
               "bus_w_um": {"source": ws, "drain": wd}, "guard_ring": R,
               "C3_pF": round(4 * lib.c_mim_pf(w9, l9), 3), "C2_pF": round(lib.c_mim_pf(w1, l1c), 3),
               "L1": {"coil": COILS[(P, "L1")], "centre": [cx1, cy1], "ports": "north"},
               "LD4": {"coil": COILS[(P, "LD4")], "centre": [cx4, cy4], "ports": "north"},
               "c9_vss_straps": straps, "c9_plates": plates, "l1_vss_lead_x": list(L1_VSS_X),
               "ld4_vdd_lead": [q1[0], q1[1], q1[2], ld4_vdd_y1],
               "vm2_column_x": list(dc),
               "pins": {"input_match": "Metal5 x=82 y=290..300", "output_cs": list(gp), "g_cg": f"Metal3 west edge y={GCG_Y}",
                        "vbias_cg": f"Metal3 north edge x={xvb:.2f}", "vbias_cs": f"Metal3 north edge x={xvc:.2f}",
                        "vdd": "Metal5 north edge", "vss": "guard ring, C3 straps, L1 port 2 (south edge)"}}
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
