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
         is >= KEEP from all block shapes and outside the inductor keep-outs (bbox + 25 um). Tiles abut ->
         continuous planes. Tile groups that touch the north / east / south band get vdd (rail) + vss (ring)
         there; enclosed groups and groups touching only the west band are left out.
  straps vss: CG guard ring -> west ring (Metal2), CS guard ring -> C3 bottom-plate bar (Metal2 + stack; the bar
         joins the CG guard ring inside lna_core_cg), LEQ port 2 -> west ring (Via4); L1 / LSHUNT_OUT port 2
         enter the south / north band on Metal4 (blocks)
  MIM decap tiles: PG_MIM (fixed tile, MIMTM.1 clean) on the N_MIM_MAX sites nearest the LD4 vdd lead (RF return
         of the drain coils) so that the shared vss Metal4 plane carries <= 10000 um^2 of MIM (MIMTM.11), PG_PLAIN
         elsewhere.
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
INFO = json.load(open(os.path.join(HERE, "lna_core_layouts.json")))
_, Y0, W, H = map(float, INFO["lna_core_output_match"]["frame"])  # macro x 0..W, y Y0..H (block coordinates)
RING = 12.0
PITCH, KEEP, SPIRAL_KO = 20.0, 4.0, 25.0
N_MIM_MAX = 70  # x 4 MIMs x 5.1 x 6.3 um = 9000 um^2 on the common vss Metal4 plane (MIMTM.11: <= 10000)
CG_STRAP_Y = (266.0, 270.0)  # Metal2 vss strap CG guard ring -> west band (between LEQ and the input match C1)
CS_STRAP_X = 332.0  # Metal2 vss strap CS guard ring -> C3 bar (east of C3)
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


def block_geometry(ly, top):
    """all block shapes (merged, every drawn layer) and the spiral keep-out region"""
    blk = pya.Region()
    for li in ly.layer_indexes():
        if ly.get_info(li).datatype != 10:
            blk += pya.Region(top.begin_shapes_rec(li))
    blk.merge()
    ko = pya.Region()
    it = top.begin_instances_rec()
    while not it.at_end():
        c = it.inst_cell()
        if "__" in c.name and c.name.split("__")[-1][:1] == "L":
            ko.insert(c.bbox().transformed(it.trans() * it.inst_trans()).enlarged(um(SPIRAL_KO), um(SPIRAL_KO)))
        it.next()
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


def groups(sites):
    left, out = set(sites), []
    while left:
        s = left.pop()
        st, comp = [s], {s}
        while st:
            x, y = st.pop()
            for n in ((x + PITCH, y), (x - PITCH, y), (x, y + PITCH), (x, y - PITCH)):
                if n in left:
                    left.remove(n)
                    comp.add(n)
                    st.append(n)
        out.append(comp)
    return out


def touches_rail(comp):
    """group reaches the north, east or south ring band (vdd rail on Metal5 there, the west band has none)"""
    return any(y + PITCH == H - RING or x + PITCH == W - RING or y == Y0 + RING for x, y in comp)


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
    yb0, yb1 = 236.0, 240.0
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
    bridge_m3 = pya.Region()  # vdd bridges: no vss island (Via2 / Via3 to the ring) on them
    bridges = []
    for f in foreign.each():
        b = f.bbox().to_dtype(ly.dbu)
        xa, xb = g(b.left - 12), g(b.right + 6)  # stacks on the rail ends left / right of the gap
        bridges.append((xa, xb))
        S.box("m3", xa, H - 10, xb + 6, H - 4)
        bridge_m3.insert(dbox((xa, H - 10, xb + 6, H - 4)))
        for sx in (xa, xb):
            S.stack(sx, H - 11, sx + 6, H - 3, 3, 5)
            holes.insert(dbox((sx - 1, H - RING, sx + 7, H)))
    S.c.shapes(S.li("m4")).insert(band - holes)
    # Metal3 islands (Via2 + Via3) every 40 um along the band centre, clear of block Metal3 and the bridges
    isl = []
    for k in range(int((W - 12) // 40) + 1):
        isl += [(6 + 40 * k, Y0 + 6), (6 + 40 * k, H - 6)]
    for k in range(int((H - Y0 - 12) // 40) + 1):
        isl += [(6, Y0 + 6 + 40 * k), (W - 6, Y0 + 6 + 40 * k)]
    n_isl = 0
    for x, y in isl:
        if not (3 <= x <= W - 3 and Y0 + 3 <= y <= H - 3):
            continue
        b = (x - 1.5, y - 1.5, x + 1.5, y + 1.5)
        near = pya.Region(dbox(b).enlarged(um(3), um(3)))
        if not near.interacting(m3_blk + bridge_m3).is_empty() or not near.interacting(holes).is_empty():
            continue
        S.box("m3", *b)
        S.cuts("v2", *b)
        S.cuts("v3", *b)
        n_isl += 1

    # ---------------- tiles
    cells = {k: import_tile(ly, k, f) for k, f in TILES.items()}
    # the MIM decaps go to the sites nearest the lower end of the LD4 vdd lead (RF return of the drain coils)
    tx, ty = (ld4[0] + ld4[2]) / 2, ld4[1]
    near = sorted(sites, key=lambda s: (s[0] + PITCH / 2 - tx) ** 2 + (s[1] + PITCH / 2 - ty) ** 2)
    mim = set(near[:N_MIM_MAX])
    n_mim = 0
    for x0, y0 in sites:
        kind = "PG_MIM" if (x0, y0) in mim else "PG_PLAIN"
        n_mim += kind == "PG_MIM"
        S.place(cells[kind], x0 + PITCH / 2, y0 + PITCH / 2)

    S.label(1, "vss", 6, (Y0 + H) / 2)
    S.label(5, "vdd", W / 2, H - 7)
    stats = {"tiles": len(sites), "PG_MIM": n_mim, "PG_PLAIN": len(sites) - n_mim,
             "decap_pF": round(n_mim * 4 * lib.c_mim_pf(5.1, 6.3), 2), "ring_m3_islands": n_isl,
             "vdd_rail_bridges": bridges, "groups_dropped": [sorted(c)[:1] + [len(c)] for c in comps if c not in keep]}
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
