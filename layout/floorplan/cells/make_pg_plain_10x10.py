#!/usr/bin/env python3
"""
vss_m1m2m4_vdd_m3m5_10x10.gds: half-pitch (10x10 um) generic supply filler tile, same layer convention as
vss_m1m2m4_vdd_m3m5_20x20.gds (M5/M3 = vdd, M4/M2/M1 = vss) and meant to abut it / itself for narrow leftover
gaps the 20x20 grid can't reach (see make_lna_core_parts.py's free_sites()).

Recipe reverse-engineered directly from the real, DRC-clean 20x20 tile (no generator for that one exists in this
repo) rather than derived from DRC rule text from scratch -- same "reuse the proven real pattern" philosophy as
the coil reshaping work in klayout/make_lna_core_layouts.py:
  - full M1..M5 planes across the whole tile (continuous when tiles abut)
  - 2 "VSS stepping-stone" columns (west/east): a 4x4 um Metal3 island (NOT the main Metal3=vdd plane -- a
    separate net) with a Via2 array down from Metal2 and a Via3 array down to Metal4 (main, vss) -- passes vss
    vertically without ever touching the Metal3=vdd plane along the way
  - 2 "VDD stepping-stone" columns (north/south): a 4x4 um Metal4 island (separate from the main Metal4=vss
    plane) with a Via3 array down from Metal3 (main, vdd) and a Via4 array up to Metal5 (main, vdd)
  - substrate tap (comp + contact array -> Metal1): co-located with the west/east columns, same 4x4 um footprint
    as their Metal3 island, exactly like the real 20x20 tile (different layer, same xy box)
  - via/contact pitch: Cell.cuts()'s own defaults (VIA=0.26, VIA_SP=0.36 um) already match the real tile's
    measured 0.62 um via pitch exactly (confirmed by direct GDS inspection) -- enc=0.32 on a 4x4 um box gives the
    identical 6x6 array the real tile uses, so no DRC rule re-derivation was needed, just the right enclosure.

Halved from the 20x20 tile's own column placement (offset 6.25 um from tile centre, inside a 10 um half-width)
to 2.5 um from centre (inside this tile's 5 um half-width): columns span -4.5..-0.5 / 0.5..4.5 on their axis,
leaving a 0.5 um margin to both the tile edge and the tile centre on every side -- not a rule-derived number,
just symmetric clearance; adjust from direct DRC feedback if this run finds otherwise.

Run:  klayout -b -r make_pg_plain_10x10.py
Writes vss_m1m2m4_vdd_m3m5_10x10.gds next to this script, top cell TOP (origin = tile centre).
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
KLAYOUT_DIR = os.path.join(HERE, "..", "..", "..", "klayout")
sys.path.insert(0, KLAYOUT_DIR)
import lna_lib as lib  # noqa: E402
from lna_lib import Cell  # noqa: E402

import pya  # noqa: E402

OUT = os.path.join(HERE, "vss_m1m2m4_vdd_m3m5_10x10.gds")
HALF = 5.0  # tile half-extent (10x10 um total)
# Column half-size shrunk from the real 20x20 tile's own 4x4 um (COL_HALF=2.0) islands: at that size, 4 columns
# (W/E on the x-axis, N/S on the y-axis) around this tile's own centre geometrically overlap at the corners --
# each column spans the FULL cross-axis range [-COL_HALF, COL_HALF] through the centre, so avoiding overlap needs
# COL_OFF >= 2*COL_HALF, which at COL_HALF=2.0 pushes the column's outer edge (COL_OFF+COL_HALF) past the tile's
# own 5.0 um half-width. Confirmed by a first attempt at (2.5, 2.0): DRC found 64 V3.1 (min/max via size)
# violations from merged, non-square via shapes where the W/E and N/S columns' via arrays touched. Shrinking to
# COL_HALF=1.5 (3x3 um island -- still comfortably holds a 4x4 via array, see cuts()) with COL_OFF=3.2 (> 2*1.5,
# 0.2 um margin) clears the corner overlap while keeping 0.3 um margin to the tile edge.
COL_OFF = 3.2  # stepping-stone column centre offset from tile centre
COL_HALF = 1.5  # column half-size (3x3 um)


def um(v):
    return int(round(v * 1000))


def dbox(b):
    """integer-DBU pya.Box for Region ops -- pya.Region() needs DBU boxes, not pya.DBox (float, um)"""
    return pya.Box(um(b[0]), um(b[1]), um(b[2]), um(b[3]))


def main():
    ly = pya.Layout()
    ly.dbu = 0.001
    top = Cell(ly, "TOP")

    we_boxes = [(sx * COL_OFF - COL_HALF, -COL_HALF, sx * COL_OFF + COL_HALF, COL_HALF) for sx in (-1, 1)]
    ns_boxes = [(-COL_HALF, sy * COL_OFF - COL_HALF, COL_HALF, sy * COL_OFF + COL_HALF) for sy in (-1, 1)]

    # full planes, full tile -- m3/m4 get holes punched where the OTHER polarity's island sits (see module doc:
    # a first attempt drew m3/m4's island boxes directly ON TOP of a solid full-tile plane on the SAME layer,
    # which just merges into one shape -- no separate net -- confirmed by a direct net probe showing vdd/vss
    # fully merged. The real 20x20 tile's own main m3/m4 planes are NOT solid full-tile boxes for exactly this
    # reason: each has the two islands of its OWN stepping-stone cut out, keeping them geometrically disjoint.
    # SECOND bug, also net-probe-confirmed: punching a hole the EXACT size of the island (zero gap) still merges
    # them -- same-layer shapes that only TOUCH at a shared edge, with no real gap, are one net just like real
    # metal would be. The hole must be island-size PLUS a real spacing margin. M3/M4's own min same-layer spacing
    # (metal.rb: M#.2a = 0.28um) plus the "space to wide metal (>10um both dims)" rule M#.2b = 0.3um (this tile's
    # own main plane is exactly 10x10, at that wide-metal threshold) -- 0.3um covers both with a hair of margin.
    GAP = 0.3
    for lay in ("m1", "m2", "m5"):
        top.box(lay, -HALF, -HALF, HALF, HALF)
    we_region, ns_region = pya.Region(), pya.Region()
    for b in we_boxes:
        we_region.insert(dbox(b).enlarged(um(GAP)))
    for b in ns_boxes:
        ns_region.insert(dbox(b).enlarged(um(GAP)))
    m3_main = pya.Region(dbox((-HALF, -HALF, HALF, HALF))) - we_region
    m4_main = pya.Region(dbox((-HALF, -HALF, HALF, HALF))) - ns_region
    top.c.shapes(top.li("m3")).insert(m3_main)
    top.c.shapes(top.li("m4")).insert(m4_main)
    top.box("pplus", -HALF, -HALF, HALF, HALF)  # DF.12: comp must be covered by Nplus/Pplus -- real tile does this
    # full-tile too (confirmed by direct GDS inspection: layer (31,0), the one full-tile shape besides m1/m2/m3/m4/m5)

    # VSS stepping-stone columns (west, east): Metal3 island (now disjoint from the holed-out main m3=vdd plane)
    # + substrate tap, same box
    for box in we_boxes:
        top.box("m3", *box)
        top.cuts("v1", *box, enc=0.3)  # m1 (main, vss) -> m2 (main, vss) -- real tile does this at the same
        # footprint as v2 (confirmed by direct GDS inspection); without it m1 is a fully isolated net.
        top.cuts("v2", *box, enc=0.3)  # m2 (main, vss) -> island
        top.cuts("v3", *box, enc=0.3)  # island -> m4 (main, vss)
        top.box("comp", *box)
        top.cuts("cont", *box, enc=0.3, sz=lib.CO, sp=lib.CO_SP)  # comp -> m1 (main, vss)

    # VDD stepping-stone columns (north, south): Metal4 island (disjoint from the holed-out main m4=vss plane)
    for box in ns_boxes:
        top.box("m4", *box)
        top.cuts("v3", *box, enc=0.3)  # m3 (main, vdd) -> island
        top.cuts("v4", *box, enc=0.3)  # island -> m5 (main, vdd)

    ly.write(OUT)
    print(f"wrote {os.path.basename(OUT)}: bbox ({-HALF},{-HALF}) .. ({HALF},{HALF})")


main()
