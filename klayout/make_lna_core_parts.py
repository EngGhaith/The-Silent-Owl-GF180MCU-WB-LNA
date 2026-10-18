#!/usr/bin/env python3
"""
klayout/lna_core_parts.gds: the four lna_core blocks + vss ring + supply tiles (top cell kept, e.g. TOP).

  klayout -b -r make_lna_core_parts.py

Blocks: lna_core_{input_match,cg,cs,output_match}.gds, all at (0, 0) (shared floorplan coordinates).
Supply (cell lna_core_supply, at (0, 0)), layer plan of the team: M5 / M3 = vdd, M4 / M2 / M1 / SUB = vss
  macro  747 x 765 um (size from lna_core_layouts.json, written by make_lna_core_layouts.py)
  ring   12 um band along the macro edge: P+ substrate tap + Metal1 + Metal2 + Metal4 (vss), Metal3 islands with
         Via2 / Via3 join Metal2 and Metal4; north band also carries the vdd rail on Metal5 (gap at rf_out_pad,
         bridged on Metal3, Metal4 cut out around the bridge stacks)
  tiles  20 x 20 um supply tiles (layout/floorplan/cells) on a grid flush with the north band, on every site that
         is >= KEEP from all block shapes and outside the spiral keep-outs (spiral bbox + 25 um). Tiles abut ->
         continuous planes. Tile groups that touch the ring get vss / vdd from it; the two inner groups east of C9
         (F) and east of the CS stage (E) get explicit straps, other inner groups are left out.
  straps vss: CG guard ring -> tiles above (Metal2), CS guard ring -> tiles above and -> group E (Metal2),
         C9 bottom-plate straps -> Metal5 bar below C9 -> CG guard ring (Metal2) and group F (Metal4),
         L1 inner end -> ring (Via4); vdd: group E (Metal5) and group F (Metal3 under vm2) -> LD4 vdd lead
  MIM decap tiles: PG_MIM (fixed tile, MIMTM.1 clean) on at most N_MIM_MAX sites so that the shared vss Metal4
         plane carries <= 10000 um^2 of MIM (MIMTM.11), PG_PLAIN elsewhere.
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
W, H = map(float, INFO["lna_core_output_match"]["macro"])  # 747 x 765 (floorplan + LSHUNT_OUT1 box on top)
RING = 12.0
PITCH, KEEP, SPIRAL_KO = 20.0, 4.0, 25.0
N_MIM_MAX = 70  # x 4 MIMs x 5.1 x 6.3 um = 9000 um^2 on the common vss Metal4 plane (MIMTM.11: <= 10000)
GX0 = RING
GY0 = H - RING - PITCH * int((H - 2 * RING) // PITCH)  # grid flush with the north band
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


def touches_ring(comp):
    return any(x == RING or y == RING or x + PITCH == W - RING or y + PITCH == H - RING for x, y in comp)


def group_at(comps, x, y):
    for c in comps:
        if any(sx <= x <= sx + PITCH and sy <= y <= sy + PITCH for sx, sy in c):
            return c
    raise SystemExit(f"no supply tile group at ({x}, {y}) - block layout changed, update the straps")


def lowest_site_above(comp, x0, x1, y):
    """y0 of the lowest site of comp covering x0..x1 and starting above y"""
    ys = [sy for sx, sy in comp if sx <= x0 and x1 <= sx + PITCH and sy >= y]
    assert ys, (x0, x1, y)
    return min(ys)


def build_supply(ly, top):
    blk, ko = block_geometry(ly, top)
    m3_blk = pya.Region(top.begin_shapes_rec(ly.layer(42, 0)))
    m5_blk = pya.Region(top.begin_shapes_rec(ly.layer(81, 0)))
    comps = groups(free_sites(blk, ko))
    cg, cs = INFO["lna_core_cg"], INFO["lna_core_cs"]
    ld4 = cg["ld4_vdd_lead"]
    grp_e = group_at(comps, 440, 400)  # east of the CS stage
    grp_f = group_at(comps, 440, 330)  # east of C9
    keep = [c for c in comps if touches_ring(c) or c is grp_e or c is grp_f]
    sites = sorted(s for c in keep for s in c)
    S = Cell(ly, SUPPLY)

    # ---------------- ring
    band = pya.Region(pya.Box(0, 0, um(W), um(H))) - pya.Region(pya.Box(um(RING), um(RING), um(W - RING), um(H - RING)))
    for lay in ("m1", "m2"):
        S.c.shapes(S.li(lay)).insert(band)
    lib.guard_ring(S, 5.5, 5.5, W - 5.5, H - 5.5, w=1.0)  # P+ tap, contacts, Via1 along the band centre
    # vdd rail (Metal5) in the north band, gaps around non-vdd Metal5 of the blocks, bridged on Metal3
    vdd_leads = pya.Region()
    for b in (ld4, cs["ld2_vdd_lead"]):
        vdd_leads.insert(dbox(b))
    rail_box = pya.Region(dbox((RING, H - RING, W - RING, H - 2)))
    foreign = (m5_blk & rail_box.sized(um(1))).merged().not_interacting(vdd_leads)
    rail = rail_box - foreign.sized(um(6))
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
    # Metal3 islands (Via2 + Via3) every 40 um along the band centre, clear of block Metal3 and the bridges
    isl = []
    for k in range(int((W - 12) // 40) + 1):
        isl += [(6 + 40 * k, 6), (6 + 40 * k, H - 6)]
    for k in range(int((H - 12) // 40) + 1):
        isl += [(6, 6 + 40 * k), (W - 6, 6 + 40 * k)]
    n_isl = 0
    for x, y in isl:
        if not (3 <= x <= W - 3 and 3 <= y <= H - 3):
            continue
        b = (x - 1.5, y - 1.5, x + 1.5, y + 1.5)
        near = pya.Region(dbox(b).enlarged(um(3), um(3)))
        if not near.interacting(m3_blk).is_empty() or not near.interacting(holes).is_empty():
            continue
        S.box("m3", *b)
        S.cuts("v2", *b)
        S.cuts("v3", *b)
        n_isl += 1

    # ---------------- tiles
    cells = {k: import_tile(ly, k, f) for k, f in TILES.items()}
    n_mim = 0
    for x0, y0 in sites:
        kind = "PG_MIM" if n_mim < N_MIM_MAX else "PG_PLAIN"
        n_mim += kind == "PG_MIM"
        S.place(cells[kind], x0 + PITCH / 2, y0 + PITCH / 2)

    # ---------------- straps
    # L2 inner end (vss, Metal5 into the south band) -> ring Metal4
    lx = cg["l1_vss_lead_x"]
    S.stack(lx[0], 2, lx[1], 10, 4, 5)
    # LSHUNT_OUT1 inner end (vss, Metal5 into the east band) -> ring Metal4
    ly_ = INFO["lna_core_output_match"]["lsh_vss_lead_y"]
    S.stack(W - 10, ly_[0], W - 2, ly_[1], 4, 5)
    # CG guard ring -> group above (Metal2)
    R = cg["guard_ring"]
    grp_b = group_at(comps, 180, R[3] + 30)
    yb = lowest_site_above(grp_b, 176, 180, R[3])
    S.box("m2", 176, R[3] - 0.8, 180, yb + 1)
    # CS guard ring -> group above (Metal2) and -> group E (Metal2)
    Rs = cs["guard_ring"]
    grp_d = group_at(comps, 302, Rs[3] + 30)
    yd = lowest_site_above(grp_d, 300, 304, Rs[3])
    S.box("m2", 300, Rs[3] - 0.8, 304, yd + 1)
    xe = min(sx for sx, sy in grp_e)
    ye = [sy for sx, sy in grp_e if sx == xe and Rs[1] + 2 <= sy + 10 <= Rs[3] - 2]
    assert ye, "group E does not face the CS guard ring"
    yc = ye[0] + 10
    S.box("m2", Rs[2] - 0.8, yc - 2, xe + 1, yc + 2)
    # group E vdd -> LD4 vdd lead (Metal5)
    xe1 = max(sx for sx, sy in grp_e) + PITCH
    ye5 = [sy for sx, sy in grp_e if sx + PITCH == xe1 and ld4[1] < sy and sy + 14 < 428][0]
    S.box("m5", xe1 - 1, ye5 + 6, ld4[0] + 1, ye5 + 14)
    # C3 bottom plates (vss): their Metal5 bar (drawn in lna_core_cg, joined to the CG guard ring there) is
    # extended east to group F (Metal4)
    st = cg["c9_vss_straps"]  # lower left, upper left, lower right, upper right
    yb0, yb1 = 236.0, 240.0
    xf = min(sx for sx, sy in grp_f)
    yf = min(sy for sx, sy in grp_f if sx == xf)
    assert yf - 1 <= yb1 + 4 and xf - 2 > st[2][2] + 4
    S.box("m5", st[2][0], yb0, xf - 1, yb1)
    S.stack(xf - 5, yb0, xf - 1, yb1, 4, 5)
    S.box("m4", xf - 5, yb0, xf + 1, yf + 2)
    # group F vdd -> LD4 vdd lead (Metal3 under vm2, stack onto the lead)
    xf1 = max(sx for sx, sy in grp_f) + PITCH
    yf3 = [sy for sx, sy in grp_f if sx + PITCH == xf1 and sy > ld4[1] + 2][0]
    S.box("m3", xf1 - 1, yf3 + 8, ld4[2] - 1, yf3 + 12)
    S.stack(ld4[0] + 1, yf3 + 6, ld4[2] - 1, yf3 + 14, 3, 5)

    S.label(1, "vss", 6, H / 2)
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
