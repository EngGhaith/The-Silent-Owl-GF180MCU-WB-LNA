#!/usr/bin/env python3
"""
klayout/lna_core_parts.gds: the four lna_core blocks + vss ring + supply tiles (top cell kept, e.g. TOP).

  klayout -b -r make_lna_core_parts.py

Blocks: lna_core_{input_match,cg,cs,output_match}.gds and the supply are built in the shared block coordinates
(macro x 0..W, y Y0..H, lna_core_layouts.json "frame") and placed at (0, -Y0): the macro starts at (0, 0).
Supply (cell lna_core_supply), layer plan of the team: M5 / M3 = vdd, M4 / M2 / M1 / SUB = vss
  ring   12 um band along the macro edge: P+ substrate tap + Metal1 + Metal2 + Metal4 (vss), Metal3 islands with
         Via2 / Via3 join Metal2 and Metal4; north, east and south band also carry the vdd rail on Metal5 (gap at
         rf_out_pad, bridged on Metal3, Metal4 cut out around the bridge stacks)
  tiles  20 x 20 um supply tiles (layout/floorplan/cells) on a grid flush with the north band, on every site that
         is >= KEEP from all block shapes and outside the inductor keep-outs (bbox + SPIRAL_KO, 10 um). Tiles abut ->
         continuous planes. Tile groups that touch the north / east / south band get vdd (rail) + vss (ring)
         there, all other enclosed groups (touching no band) are left out (re-floorplan: the old "group B" enclosed
         pocket's own vdd tap reached toward LD4's position, which moved away -- no longer special-cased, just
         dropped like any other enclosed group now).
  straps vss: CG guard ring -> west ring (Metal2), CS guard ring -> C3 bottom-plate bar (Metal2 + stack; the bar
         joins the CG guard ring inside lna_core_cg), LEQ port 2 -> west ring (Via4); L1 / LSHUNT_OUT port 2
         enter the south / north band on Metal4 (blocks)
  MIM decap tiles: PG_MIM (fixed tile, MIMTM.1 clean) on at most N_MIM_MAX sites so that the shared vss Metal4
         plane carries <= 10000 um^2 of MIM (MIMTM.11), PG_PLAIN elsewhere. Priority order (user-specified):
         (1) sites within RING_BAND of LD2 / LD4's own keep-out (the two low-Q, vdd-tied coils -- decoupling
         them costs nothing electrically), (2) the rest of the N_MIM_MAX budget spread evenly over every other
         free site instead of left bunched in the lowest-x columns (the old flat `sorted(sites)[:N_MIM_MAX]`).
Re-running replaces blocks and supply (idempotent); dbu 1 nm.
"""
import json
import os
import sys

import pya

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import lna_lib as lib  # noqa: E402
from lna_lib import Cell, g  # noqa: E402

OUT = os.path.join(HERE, "lna_core_parts.gds")
BLOCKS = ["lna_core_input_match", "lna_core_cg", "lna_core_cs", "lna_core_output_match"]
SUPPLY = "lna_core_supply"
CELLS = os.path.join(HERE, "..", "layout", "floorplan", "cells")
TILES = {"PG_PLAIN": "vss_m1m2m4_vdd_m3m5_20x20.gds", "PG_MIM": "vss_m1m2m4_vdd_m3m5_dcpl_mim_20x20_fix.gds"}
TILE_10 = "vss_m1m2m4_vdd_m3m5_10x10.gds"  # half-pitch filler for narrow gaps the 20x20 grid can't reach
INFO = json.load(open(os.path.join(HERE, "lna_core_layouts.json")))
_, Y0, W, H = map(float, INFO["lna_core_output_match"]["frame"])  # macro x 0..W, y Y0..H (block coordinates)
RING = 12.0
PITCH, KEEP, SPIRAL_KO = 20.0, 4.0, 10.0
N_MIM_MAX = 70  # x 4 MIMs x 5.1 x 6.3 um = 9000 um^2 on the common vss Metal4 plane (MIMTM.11: <= 10000)
GRP_B_AT = (500.0, 300.0)  # a point inside tile group B (east of C3, below the vm2 trace)
CG_STRAP_Y = (266.0, 270.0)  # Metal2 vss strap CG guard ring -> west band (between LEQ and the input match C1)
CS_STRAP_X = 632.0  # Metal2 vss strap CS guard ring -> C3 bar (east of C3). Shifted +300 along with cs's own
# transistor/pad subsystem (cs re-floorplan, clearing LD4's new NW-corner placement) -- the bar itself (drawn
# in lna_core_cg) now reaches this x at y 270.78..274.78 (see vss_straps()'s own yb0/yb1 -- shifted along with
# C3_VSS_BAR for the floorplan compaction step 1, no longer the original 236..240).
GX0 = RING
GY0 = H - RING - PITCH * int((H - Y0 - 2 * RING) // PITCH)  # grid flush with the north band
um = lambda v: int(round(v * 1000))


def dbox(b):
    return pya.Box(um(b[0]), um(b[1]), um(b[2]), um(b[3]))


def import_tile(ly, name, fname):
    """TOP cell of cells/<fname> as cell <name> (sub cells renamed <name>__*); origin = tile centre"""
    src = pya.Layout()
    src.read(os.path.join(CELLS, fname))
    top = src.top_cell()
    for c in src.each_cell():
        if c.cell_index() != top.cell_index():
            c.name = f"{name}__{c.name}"
    dst = ly.create_cell(name)
    dst.copy_tree(top)
    return dst


RING_COILS = {"lna_core_input_match": ["LEQ"], "lna_core_cs": ["LD2"], "lna_core_cg": ["L1", "LD4"],
              "lna_core_output_match": ["LSHUNT_OUT"]}  # coils already converted to
# lib.coil_guard_ring() (pilot: LEQ; Phase 2 adds LD2/L1/LSHUNT_OUT here one at a time). For these, the coil's
# own JSON "ring_outer" bbox (a real, grid-abuttable vss ring) replaces the generic bbox+SPIRAL_KO keep-out --
# the ring's own drawn metal is already part of `blk` below, so a tile only needs the ordinary KEEP=4 clearance
# from it, not an extra SPIRAL_KO=10 margin on top of that. Un-converted coils keep the old bbox+SPIRAL_KO
# behaviour.


def block_geometry(ly, top):
    """all block shapes (merged, every drawn layer) and the spiral keep-out region"""
    blk = pya.Region()
    for li in ly.layer_indexes():
        if ly.get_info(li).datatype != 10:
            blk += pya.Region(top.begin_shapes_rec(li))
    blk.merge()
    ring_boxes = {}  # (block name, coil name) -> ko Region, for RING_COILS entries
    for blk_name, coils in RING_COILS.items():
        for coil in coils:
            ro = INFO[blk_name][coil]["ring_outer"]
            ring_boxes[(blk_name, coil)] = pya.Box(um(ro[0]), um(ro[1]), um(ro[2]), um(ro[3]))
    ko = pya.Region()
    it = top.begin_instances_rec()
    while not it.at_end():
        c = it.inst_cell()
        if "__" in c.name and c.name.split("__")[-1][:1] == "L":
            key = tuple(c.name.split("__")[:2])
            if key in ring_boxes:
                ko.insert(ring_boxes[key])
            else:
                ko.insert(c.bbox().transformed(it.trans() * it.inst_trans()).enlarged(um(SPIRAL_KO), um(SPIRAL_KO)))
        it.next()
    # output_match's C1 (not a coil, so the "L"-prefix heuristic above never catches it) plus its own
    # LD4-avoidance bridge (reaching north to y=713 on Metal5, carrying rf_out_pad) need a real keepout wider
    # than the generic KEEP=4um free_sites() check: confirmed via NetTracer that a tile placed only ~6um above
    # the bridge's own top still merged output_cs/rf_out_pad into vss (DRC-clean, since a same-layer overlap
    # between different nets is a physical-rules check, not a connectivity one -- LVS is what actually caught
    # this). pt (top plate) = INFO[...]["top_plate"]; the bridge's own reach (yr1b=713) isn't itself in INFO, so
    # it's accounted for here directly, with margin.
    pt = INFO["lna_core_output_match"]["top_plate"]
    ko.insert(pya.Box(um(pt[0] - 5), um(pt[1] - 5), um(pt[2] + 5), um(713.0 + 5)))
    return blk, ko


def free_sites(blk, ko):
    sites = set()
    nx, ny = int((W - RING - GX0) // PITCH), int((H - RING - GY0) // PITCH)
    for i in range(nx):
        for j in range(ny):
            x0, y0 = GX0 + i * PITCH, GY0 + j * PITCH
            b = pya.Box(um(x0), um(y0), um(x0 + PITCH), um(y0 + PITCH))
            if not pya.Region(b.enlarged(um(KEEP), um(KEEP))).interacting(blk).is_empty():
                continue
            if not pya.Region(b).overlapping(ko).is_empty():
                continue
            sites.add((x0, y0))
    return sites


def groups(sites, step=PITCH):
    left, out = set(sites), []
    while left:
        s = left.pop()
        st, comp = [s], {s}
        while st:
            x, y = st.pop()
            for n in ((x + step, y), (x - step, y), (x, y + step), (x, y - step)):
                if n in left:
                    left.remove(n)
                    comp.add(n)
                    st.append(n)
        out.append(comp)
    return out


def touches_rail(comp):
    """group reaches the north, east or south ring band (vdd rail on Metal5 there, the west band has none)"""
    return any(y + PITCH == H - RING or x + PITCH == W - RING or y == Y0 + RING for x, y in comp)


def group_at(comps, x, y):
    for c in comps:
        if any(sx <= x <= sx + PITCH and sy <= y <= sy + PITCH for sx, sy in c):
            return c
    raise SystemExit(f"no supply tile group at ({x}, {y}) - block layout changed, update the straps")


def vss_straps(S):
    """vss of the inner pieces -> ring: guard rings, LEQ port 2 (drawn before the tiles, which keep clear)"""
    cg, cs = INFO["lna_core_cg"], INFO["lna_core_cs"]
    # LEQ port 2 (vss, Metal5 into the west band) -> ring Metal4
    ly_ = INFO["lna_core_input_match"]["leq_vss_lead_y"]
    S.stack(2, ly_[0], 10, ly_[1], 4, 5)
    # CG guard ring -> west band (Metal2, below the input match C1 and above LEQ)
    R = cg["guard_ring"]
    ys = CG_STRAP_Y
    S.box("m2", R[0] + 1, ys[0], R[0] + 5, R[1] + 0.8)
    S.box("m2", 0, ys[0], R[0] + 5, ys[1])
    # CS guard ring -> C3 bottom-plate bar (Metal5, drawn in lna_core_cg and joined to the CG guard ring there):
    # bar extended east, Metal2 column up to the ring
    Rs = cs["guard_ring"]
    st = cg["c9_vss_straps"]  # lower left, upper left, lower right, upper right
    yb0, yb1 = 270.78, 274.78  # matches C3_VSS_BAR in make_lna_core_layouts.py -- shifted +DY_CG_BULK=34.78
    # (floorplan compaction step 1) from the old 236.0/240.0. This was a stale hardcoded literal, not derived
    # from `st`/INFO, so it didn't auto-track C3's move -- confirmed as a real short via NetTracer (the old,
    # now-disconnected strap at y=236..240 merged into a huge cross-macro vss net together with several signal
    # nets routed nearby at that height).
    x0 = CS_STRAP_X
    assert st[2][2] + 6 <= x0 and Rs[0] + 2 <= x0 and x0 + 4 <= Rs[2] - 2
    S.box("m5", st[2][0], yb0, x0 + 4, yb1)
    S.stack(x0, yb0, x0 + 4, yb1, 2, 5)
    S.box("m2", x0, yb0, x0 + 4, Rs[1] + 0.8)


def build_supply(ly, top):
    blk, ko = block_geometry(ly, top)
    m3_blk = pya.Region(top.begin_shapes_rec(ly.layer(42, 0)))
    m5_blk = pya.Region(top.begin_shapes_rec(ly.layer(81, 0)))
    cg, cs = INFO["lna_core_cg"], INFO["lna_core_cs"]
    ld4 = cg["ld4_vdd_lead"]
    S = Cell(ly, SUPPLY)
    vss_straps(S)
    for li in ly.layer_indexes():
        blk += pya.Region(S.c.begin_shapes_rec(li))
    blk.merge()
    comps = groups(free_sites(blk, ko))
    # group B (the old GRP_B_AT enclosed pocket near cg/cs, with its own dynamic-search vdd tap reaching toward
    # LD4's position) no longer applies: LD4 moved to the NW corner for this re-floorplan, so that tap's own
    # ld4[1]-based geometry now reaches toward a y that's 150+ um away in the wrong direction, failing its own
    # fit assert outright. Rather than re-derive a new bespoke strap for this one pocket, it's simply no longer
    # special-cased -- if it doesn't touch the rail on its own, it's dropped like any other enclosed group, same
    # as the existing "groups_dropped" accounting below. Real trade-off (less decoupling-tile coverage there),
    # not a correctness issue.
    keep = [c for c in comps if touches_rail(c)]
    sites = sorted(s for c in keep for s in c)

    # ---------------- ring
    band = pya.Region(pya.Box(0, um(Y0), um(W), um(H))) - pya.Region(pya.Box(um(RING), um(Y0 + RING), um(W - RING), um(H - RING)))
    for lay in ("m1", "m2"):
        S.c.shapes(S.li(lay)).insert(band)
    lib.guard_ring(S, 5.5, Y0 + 5.5, W - 5.5, H - 5.5, w=1.0)  # P+ tap, contacts, Via1 along the band centre
    # vdd rail (Metal5) in the north, east and south band, gaps around non-vdd Metal5 of the blocks (only in the
    # north band: rf_out), bridged on Metal3
    vdd_leads = pya.Region()
    for b in (ld4, cs["ld2_vdd_lead"]):
        vdd_leads.insert(dbox(b))
    north = pya.Region(dbox((RING, H - RING, W - RING, H - 2)))
    rail_box = north + pya.Region(dbox((W - RING, Y0 + 2, W - 2, H - 2))) + pya.Region(dbox((RING, Y0 + 2, W - RING, Y0 + RING)))
    foreign = (m5_blk & rail_box.sized(um(1))).merged().not_interacting(vdd_leads)
    assert (foreign - north.sized(um(1))).is_empty(), "non-vdd Metal5 crosses the east / south vdd rail"
    rail = rail_box.merged() - foreign.sized(um(6))
    S.c.shapes(S.li("m5")).insert(rail)
    holes = pya.Region()
    bridges = []
    for f in foreign.each():
        b = f.bbox().to_dtype(ly.dbu)
        xa, xb = g(b.left - 12), g(b.right + 6)  # stacks on the rail ends left / right of the gap
        bridges.append((xa, xb))
        S.box("m3", xa, H - 10, xb + 6, H - 4)
        for sx in (xa, xb):
            S.stack(sx, H - 11, sx + 6, H - 3, 3, 5)
            holes.insert(dbox((sx - 1, H - RING, sx + 7, H)))
    S.c.shapes(S.li("m4")).insert(band - holes)
    # Metal3 islands (Via2 + Via3) every 40 um along the band centre, clear of block Metal3 and the bridges.
    # The south/west loops both start their own k=0 at the same (6, Y0 + 6) corner point -- dedup via set() so
    # that shared corner isn't drawn (and via-cut) twice, which deep-mode DRC (no auto-merge) flags as a real
    # overlap violation rather than silently coinciding.
    # bridge_m3: the comment above has always promised "clear of... the bridges", but the check below only ever
    # tested `m3_blk` (captured from the core blocks BEFORE this function drew any bridge) and `holes` (the M4
    # cutouts, not the bridge's own M3) -- `bridges` was collected but never actually used. A real, pre-existing
    # gap, exposed now that rf_out_pad's own vdd-rail bridge moved (user request, no longer routed near LD4) to
    # a position where an island actually lands on it: confirmed via NetTracer, an island's own Via2 (vss, M2)
    # landed on the SAME Metal3 polygon as the vdd bridge, shorting vdd to vss.
    bridge_m3 = pya.Region()
    for xa, xb in bridges:
        bridge_m3.insert(dbox((xa, H - 10, xb + 6, H - 4)))
    isl = set()
    for k in range(int((W - 12) // 40) + 1):
        isl |= {(6 + 40 * k, Y0 + 6), (6 + 40 * k, H - 6)}
    for k in range(int((H - Y0 - 12) // 40) + 1):
        isl |= {(6, Y0 + 6 + 40 * k), (W - 6, Y0 + 6 + 40 * k)}
    isl = sorted(isl)
    n_isl = 0
    for x, y in isl:
        if not (3 <= x <= W - 3 and Y0 + 3 <= y <= H - 3):
            continue
        b = (x - 1.5, y - 1.5, x + 1.5, y + 1.5)
        near = pya.Region(dbox(b).enlarged(um(3), um(3)))
        if not near.interacting(m3_blk).is_empty() or not near.interacting(holes).is_empty() \
                or not near.interacting(bridge_m3).is_empty():
            continue
        S.box("m3", *b)
        S.cuts("v2", *b)
        S.cuts("v3", *b)
        n_isl += 1

    # ---------------- tiles: priority (1) near LD2/LD4 (2) evenly spread over the rest, capped at N_MIM_MAX
    cells = {k: import_tile(ly, k, f) for k, f in TILES.items()}
    ld4_c, ld4_r = cg["LD4"]["centre"], lib.coil_geom(os.path.join(HERE, "LD4_coil.gds"))["r"]
    ld2_c, ld2_r = cs["LD2"]["centre"], lib.coil_geom(os.path.join(HERE, "LD2_coil.gds"))["r"]

    def prox(site):
        """distance from a tile centre to the nearer of LD2 / LD4's own coil edge (negative = inside the coil)"""
        sx, sy = site[0] + PITCH / 2, site[1] + PITCH / 2
        d4 = ((sx - ld4_c[0]) ** 2 + (sy - ld4_c[1]) ** 2) ** 0.5 - ld4_r
        d2 = ((sx - ld2_c[0]) ** 2 + (sy - ld2_c[1]) ** 2) ** 0.5 - ld2_r
        return min(d4, d2)

    RING_BAND = 2 * PITCH  # tier 1: tiles within ~2 pitches of LD2 / LD4's keep-out edge
    near = sorted((s for s in sites if prox(s) <= RING_BAND), key=prox)[:N_MIM_MAX]
    near_set = set(near)
    far = [s for s in sites if s not in near_set]
    budget = N_MIM_MAX - len(near)
    spread = set()
    if budget > 0 and far:
        step = len(far) / budget
        spread = {far[int(i * step)] for i in range(budget)}
    mim_sites = near_set | spread
    for x0, y0 in sites:
        kind = "PG_MIM" if (x0, y0) in mim_sites else "PG_PLAIN"
        S.place(cells[kind], x0 + PITCH / 2, y0 + PITCH / 2)
    n_mim = len(mim_sites)

    # (old "group B" explicit vdd/vss strap removed here -- see the comment at keep=[...] above for why)

    S.label(1, "vss", 6, (Y0 + H) / 2)
    S.label(5, "vdd", W / 2, H - 7)

    # ---------------- half-pitch (10x10) fill: narrow leftover gaps the 20x20 grid can't reach -- e.g. the strip
    # between a coil's own SPIRAL_KO clearance and a block edge, too thin for a full 20x20 site but wide enough
    # for a 10x10 one. Same legality test as free_sites() (KEEP from every block shape, outside every coil's own
    # SPIRAL_KO), minus the sites already covered by a 20x20 tile, ring band, or strap (everything drawn into S
    # so far -- "placed" below). PITCH/2 grid on the SAME GX0/GY0 origin, so a 10x10 site boundary always lines
    # up with either a 20x20 site boundary or its midline -- no half-um-off alignment drift between the two grids.
    # Connectivity: rather than re-deriving a half-pitch touches_rail(), a 10x10 group is kept if it physically
    # touches the fabric already drawn into S (tiles + ring + straps, all of which are rail-connected by this
    # point) -- a strict superset of "touches the rail directly" and the same "drop isolated/floating groups"
    # discipline as the 20x20 grid's own keep = touches_rail(c) or c is grp_b filter above.
    placed = pya.Region()
    for li in ly.layer_indexes():
        placed += pya.Region(S.c.begin_shapes_rec(li))
    placed.merge()
    HALF = PITCH / 2
    nx10, ny10 = int((W - RING - GX0) // HALF), int((H - RING - GY0) // HALF)
    sites10 = set()
    for i in range(nx10):
        for j in range(ny10):
            x0, y0 = GX0 + i * HALF, GY0 + j * HALF
            b = pya.Box(um(x0), um(y0), um(x0 + HALF), um(y0 + HALF))
            if not pya.Region(b.enlarged(um(KEEP), um(KEEP))).interacting(blk).is_empty():
                continue
            if not pya.Region(b).overlapping(ko).is_empty():
                continue
            if not pya.Region(b).interacting(placed).is_empty():
                continue  # already covered by a 20x20 tile / ring / strap
            sites10.add((x0, y0))
    comps10 = groups(sites10, step=HALF)
    kept10 = []
    for c in comps10:
        region = pya.Region()
        for x0, y0 in c:
            region.insert(pya.Box(um(x0), um(y0), um(x0 + HALF), um(y0 + HALF)))
        if not region.sized(1).interacting(placed).is_empty():  # 1 dbu = touches, not just nearby
            kept10.append(c)
    sites10_kept = sorted(s for c in kept10 for s in c)
    if sites10_kept:  # only import the tile cell if it will actually be instantiated -- an imported-but-unplaced
        # cell has no parent, making it a SECOND top cell in the written GDS (same orphaned-cell gotcha this
        # project hit once already with PG_MIM at N_MIM_MAX=0: ly.top_cell() / lvs_layout()'s strip.py both
        # crash with "multiple top cells").
        cell10 = import_tile(ly, "PG_PLAIN_10", TILE_10)
        for x0, y0 in sites10_kept:
            S.place(cell10, x0 + HALF / 2, y0 + HALF / 2)

    stats = {"tiles": len(sites), "PG_MIM": n_mim, "PG_PLAIN": len(sites) - n_mim,
             "decap_pF": round(n_mim * 4 * lib.c_mim_pf(5.1, 6.3), 2), "ring_m3_islands": n_isl,
             "vdd_rail_bridges": bridges, "groups_dropped": [sorted(c)[:1] + [len(c)] for c in comps if c not in keep],
             "tiles_10x10": len(sites10_kept),
             "tiles_10x10_dropped": sum(len(c) for c in comps10 if c not in kept10)}
    return S, stats


TOP_PINS = ("vdd", "vss", "vbias_cg", "vbias_cs", "vbias_cas", "rf_out_pad", "rf_in_pad", "g_cg")  # lna_core_parts.sch


def top_pin_labels(ly, top):
    """pin labels of lna_core_parts in the top cell (needed for the top-level LVS): every block label whose text is
    a top-level pin is copied to the same place / layer; labels of a previous run are replaced"""
    lbl_layers = [li for li in ly.layer_indexes() if ly.get_info(li).datatype == 10]
    for li in lbl_layers:
        for s in list(top.shapes(li).each()):
            if s.is_text() and s.text.string in TOP_PINS:
                s.delete()
    n = 0
    for inst in top.each_inst():
        if inst.cell.name not in BLOCKS:
            continue
        for li in lbl_layers:
            for s in inst.cell.shapes(li).each():
                if s.is_text() and s.text.string in TOP_PINS:
                    top.shapes(li).insert(s.text.transformed(inst.trans))
                    n += 1
    print(f"top pin labels: {n}")


def main():
    ly = pya.Layout()
    ly.dbu = 0.001
    top_name = "lna_core_parts"
    if os.path.exists(OUT):
        old = pya.Layout()
        old.read(OUT)
        assert len(old.top_cells()) == 1, "lna_core_parts.gds must have exactly one top cell"
        top_name = old.top_cell().name
        if not old.top_cell().dbbox().empty():
            if abs(old.dbu - 0.001) > 1e-9:
                raise SystemExit(f"{OUT}: dbu {old.dbu} with content - convert to 0.001 um first")
            ly.read(OUT)  # keep own drawings in the top cell
    top = ly.cell(top_name) or ly.create_cell(top_name)
    gen = BLOCKS + [SUPPLY, "PG_PLAIN", "PG_MIM"]
    for i in list(top.each_inst()):
        if ly.cell(i.cell_index).name in gen:
            i.delete()
    for c in [c for c in ly.each_cell() if c.name in gen or any(c.name.startswith(b + "__") for b in gen)]:
        ly.delete_cell(c.cell_index())
    for b in BLOCKS:
        src = pya.Layout()
        src.read(os.path.join(HERE, b + ".gds"))
        cell = ly.create_cell(b)
        cell.copy_tree(src.top_cell())
        top.insert(pya.CellInstArray(cell.cell_index(), pya.Trans()))
    sup, stats = build_supply(ly, top)
    top.insert(pya.CellInstArray(sup.c.cell_index(), pya.Trans()))
    shift = pya.Trans(0, -um(Y0))  # macro lower-left -> (0, 0)
    for i in list(top.each_inst()):
        if ly.cell(i.cell_index).name in gen:
            i.transform(shift)
    top_pin_labels(ly, top)
    ly.write(OUT)
    print(f"wrote {OUT}: top cell {top_name}, bbox {top.dbbox()}")
    print("supply:", json.dumps(stats))



try:
    main()
except BaseException as e:  # KLayout -b swallows SystemExit / tracebacks of -r scripts silently
    import traceback
    traceback.print_exc()
    print("ERROR:", e)
    raise
