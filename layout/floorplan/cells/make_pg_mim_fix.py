#!/usr/bin/env python3
"""
Proposal: DRC-clean variant of the supply tile vss_m1m2m4_vdd_m3m5_dcpl_mim_20x20.gds (upstream/main_pex klayout/).

Problem in the original (MIMTM.1, already in a single tile): the two VDD via stacks M3 -> M4 island -> M5 sit at
x = -2..+2 um, y = +-4.25..+-8.25 um; the four MIM top plates (6.3 x 6.3 um) start at |x| = 3.1 um. MIMTM.1 wants
>= 1.2 um from any other Metal4 to the virtual bottom plate (top plate sized by 1.06 um) -> top plate inner edge at
|x| >= 2 + 1.2 + 1.06 = 4.26 um.

Fix: everything is kept (planes, via stacks, substrate taps, slots), only the 4 MIMs are replaced by narrower ones,
W x L = MIM_W x 6.3 um with the inner edge at |x| = X_IN (outer edges unchanged at |x|, |y| = 9.4 um).

Run with KLayout (the MIM PCell needs its python):   klayout -b -r make_pg_mim_fix.py
Writes vss_m1m2m4_vdd_m3m5_dcpl_mim_20x20_fix.gds next to this script, top cell TOP (origin = tile centre).
"""
import os, sys

import pya

HERE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(HERE, "vss_m1m2m4_vdd_m3m5_dcpl_mim_20x20.gds")
DST = os.path.join(HERE, "vss_m1m2m4_vdd_m3m5_dcpl_mim_20x20_fix.gds")
sys.path.insert(0, "/foss/pdks/gf180mcuD/libs.tech/klayout/tech/pymacros")
import cells  # noqa: E402  (gf180mcu PCell library)

X_IN, X_OUT, Y_IN, Y_OUT = 4.3, 9.4, 3.1, 9.4  # um, top plate edges (abs values) per quadrant
MIM_W, MIM_L = X_OUT - X_IN, Y_OUT - Y_IN


def main():
    cells.gf180mcu()
    ly = pya.Layout()
    ly.read(SRC)
    top = ly.top_cell()
    old = [i for i in top.each_inst() if i.cell.name.startswith("cap_mim")]
    assert len(old) == 4, f"expected 4 MIM instances, found {len(old)}"
    for i in old:
        i.delete()
    for c in list(ly.each_cell()):  # drop the now unused original MIM cells
        if c.name.startswith("cap_mim") and c.parent_cells() == 0:
            ly.delete_cell(c.cell_index())
    pc = ly.create_cell("cap_mim", "gf180mcu", {"mim_option": "MIM-B", "metal_level": "M5", "wc": MIM_W, "lc": MIM_L})
    mim = ly.create_cell(f"cap_mim_{MIM_W:.2f}x{MIM_L:.2f}")
    mim.insert(pya.CellInstArray(pc.cell_index(), pya.Trans()))
    mim.flatten(True)
    for c in list(ly.each_cell()):  # remove the PCell variant (flattened into mim)
        if c.cell_index() != mim.cell_index() and c.name.startswith("cap_mim") and c.parent_cells() == 0 \
                and c.cell_index() != top.cell_index():
            ly.delete_cell(c.cell_index())
    for sx in (-1, 1):  # top plate lower-left corner per quadrant
        for sy in (-1, 1):
            x0 = X_IN if sx > 0 else -X_OUT
            y0 = Y_IN if sy > 0 else -Y_OUT
            top.insert(pya.DCellInstArray(mim.cell_index(), pya.DTrans(x0, y0)))
    ly.write(DST)
    c1 = (1.99 * MIM_W * MIM_L + 0.2383 * 2 * (MIM_W + MIM_L)) / 1000
    print(f"wrote {os.path.basename(DST)}: 4 x MIM {MIM_W:g} x {MIM_L:g} um = {4 * c1:.4f} pF per tile "
          f"(original 4 x 6.3 x 6.3 = {4 * (1.99 * 6.3 * 6.3 + 0.2383 * 4 * 6.3) / 1000:.4f} pF)")


main()
