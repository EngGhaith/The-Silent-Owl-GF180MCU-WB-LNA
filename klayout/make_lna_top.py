#!/usr/bin/env python3
"""
klayout/lna_top.gds: lna_core_parts + the I/O pads of its padframe tile (Chipathon 2026 padframe proposal, tile A).

  klayout -b -r make_lna_top.py

Tile A (1110 x 1110 um) in the north-west corner of the padring (confirmed by the organisers 2026-10-22); pin 1
(ground) is taken as the southmost west slot. Coordinates are those of the Chipathon padring
(openfasoc-tapeouts gf180mcu_padframe/RING_PAD.gds: ring 20.3 .. 2955.3 um, project area 370.3 .. 2605.3 um = 2235 um):
11 pads on the west side, 11 on the north side, same pitch / fillers / corner as RING_PAD:
  pads   gf180mcu_fd_io__asig_5p0 (signals), __dvdd (vdd), __dvss (vss); 75 um wide, 100 um pitch, the 25 um gaps
         filled with fill5 + 2 x fill10, unused slots with 7 x fill10 + fill5; corner cell __cor
  macro  lna_core_parts.gds (1104 x 1104), CH um from the west and north tile edge; its edge pins face the
         core-side pad fingers (make_lna_core_layouts.py), so every route is straight
  routes pad core-side pin fingers (Metal2) -> Metal2 bar in the CH channel -> stack to the route layer:
           signal : straight into the macro pin (label of lna_core_parts), layer / width per net
           vss    : Metal2 straight into the macro vss ring band (Metal2), one strap per pad finger
           vdd    : Metal5 straight onto the macro vdd rail (north band, Metal5)
"""
import os
import sys

import pya

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import lna_lib as lib  # noqa: E402
from lna_lib import Cell, g  # noqa: E402

OUT = os.path.join(HERE, "lna_top.gds")
CORE = os.path.join(HERE, "lna_core_parts.gds")
PADLIB = "/foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/gds/gf180mcu_fd_io.gds"
IO = "gf180mcu_fd_io__"

# padring geometry (RING_PAD.gds)
RING_LO, RING_HI = 20.3, 2955.3  # outer edge of the pad cells (south / west, north / east)
INNER = 350.0  # pad depth: core-side edge at RING_LO + 350 (west) / RING_HI - 350 (north)
PITCH, PAD_W = 100.0, 75.0
TILE = (370.3, 1495.3, 1480.3, 2605.3)  # tile A, north-west corner
WEST0, NORTH0 = 1500.3, 400.3  # first pad slot (k = 0): west from the south end, north from the west end
NSLOT = 11
CH = 3.0  # macro inset from the west / north tile edge (pad fingers): Metal2 bars + stacks of the routes

# pad assignment: (side, slot k) -> (pad cell, net); every other slot gets fillers
PADS = {
    ("W", 0): ("dvss", "vss"),  # pin 1 = ground
    ("W", 4): ("dvss", "vss"),
    ("W", 5): ("asig_5p0", "rf_in_pad"),
    ("W", 6): ("asig_5p0", "g_cg"),
    ("W", 7): ("asig_5p0", "vbias_cg"),
    ("W", 8): ("asig_5p0", "vbias_cs"),
    ("W", 9): ("asig_5p0", "vbias_cas"),
    ("N", 3): ("dvdd", "vdd"),
    ("N", 4): ("dvss", "vss"),
    ("N", 5): ("asig_5p0", "rf_out_pad"),
    ("N", 6): ("dvss", "vss"),
}
# route layer and width per signal net (= layer / width of the macro pin stub)
ROUTE = {"rf_in_pad": ("m5", 10.0), "rf_out_pad": ("m5", 10.0), "g_cg": ("m3", 4.0),
         "vbias_cg": ("m3", 2.0), "vbias_cs": ("m3", 2.0), "vbias_cas": ("m3", 2.0)}
# core-side pin fingers (Metal2, pad cell coordinates: x range, the core edge is y = 350)
FINGERS = {"asig_5p0": (15.34, 59.66), "dvdd": (1.36, 73.64), "dvss": (1.36, 73.64)}
# DVSS fingers of the dvss pad: the vss straps follow them one by one (a single 72 um bar breaks MSLOT.1, 30 um)
DVSS_FINGERS = ((1.36, 10.86), (13.76, 24.01), (25.61, 35.86), (39.14, 49.39), (50.99, 61.24), (64.14, 73.64))
LEVEL = {"m2": 2, "m3": 3, "m5": 5}


def pad_trans(side, start, w):
    """placement of a w um wide ring cell occupying start .. start + w along the side"""
    if side == "N":
        return pya.DCplxTrans(1.0, 180, False, start + w, RING_HI)
    return pya.DCplxTrans(1.0, 270, False, RING_LO, start + w)


def edge_box(side, a, b, depth):
    """box on the tile side of the pad core edge: along-side range a .. b, depth um into the tile"""
    if side == "N":
        y = RING_HI - INNER
        return (a, y - depth, b, y)
    x = RING_LO + INNER
    return (x, a, x + depth, b)


def place_side(top, cells, side, first):
    """fillers + pads of one tile side: 25 um fill before slot 0, then slot k (pad or filler) + 25 um fill"""
    def fill(start, widths):
        for w in widths:
            top.c.insert(pya.DCellInstArray(cells[f"fill{w}"].cell_index(), pad_trans(side, start, w)))
            start += w
    fill(first - 25, (5, 10, 10))
    pins = {}
    for k in range(NSLOT):
        s = first + PITCH * k
        if (side, k) in PADS:
            cell, net = PADS[(side, k)]
            t = pad_trans(side, s, PAD_W)
            top.c.insert(pya.DCellInstArray(cells[cell].cell_index(), t))
            along = (lambda f: (t * pya.DPoint(f, 350)).x) if side == "N" else (lambda f: (t * pya.DPoint(f, 350)).y)
            p = sorted(map(along, FINGERS[cell]))
            fingers = [tuple(sorted(map(along, f))) for f in DVSS_FINGERS] if cell == "dvss" else []
            pins[(side, k)] = (cell, net, g(p[0]), g(p[1]), [(g(a), g(b)) for a, b in fingers])
        else:
            fill(s, (10,) * 7 + (5,))
        fill(s + PAD_W, (5, 10, 10))
    return pins


def macro_pins(core):
    """{net: [(layer level, x, y)]} of the pin labels of lna_core_parts (top cell)"""
    pins = {}
    for li in core.layout().layer_indexes():
        info = core.layout().get_info(li)
        if info.datatype != 10:
            continue
        for s in core.shapes(li).each():
            if s.is_text():
                lvl = {34: 1, 36: 2, 42: 3, 46: 4, 81: 5}[info.layer]
                pins.setdefault(s.text.string, []).append((lvl, s.text.x * core.layout().dbu, s.text.y * core.layout().dbu))
    return pins


def main():
    ly = pya.Layout()
    ly.dbu = 0.001
    src = pya.Layout()
    src.read(CORE)
    core = ly.create_cell("lna_core_parts")
    core.copy_tree(src.top_cell())
    pads = pya.Layout()
    pads.read(PADLIB)
    cells = {}
    for n in ("asig_5p0", "dvdd", "dvss", "cor", "fill5", "fill10"):
        c = ly.create_cell(IO + n)
        c.copy_tree(pads.cell(IO + n))
        cells[n] = c
    top = Cell(ly, "lna_top")
    # corner (north-west)
    top.c.insert(pya.DCellInstArray(cells["cor"].cell_index(), pya.DCplxTrans(1.0, 270, False, RING_LO, RING_HI)))
    pins = place_side(top, cells, "W", WEST0)
    pins.update(place_side(top, cells, "N", NORTH0))
    # macro: CH from the west and north tile edge
    b = core.dbbox()
    mx, my = g(TILE[0] + CH), g(TILE[3] - CH - b.height())
    top.c.insert(pya.DCellInstArray(core.cell_index(), pya.DTrans(mx, my)))
    over = (max(0.0, mx + b.width() - TILE[2]), max(0.0, TILE[1] - my))
    mp = {n: [(l, g(mx + x), g(my + y)) for l, x, y in v] for n, v in macro_pins(core).items()}
    top_n, west_x = g(my + b.height()), mx  # macro north / west edge
    bar = CH - 0.5  # Metal2 bar / stack depth: 0.5 um clear of the macro ring band (Metal2 = vss)
    for (side, k), (cell, net, a0, a1, fingers) in sorted(pins.items()):
        fc = g((a0 + a1) / 2)
        if net == "vss":  # Metal2 straps (one per pad finger) straight into the vss ring band of the macro
            for f0, f1 in fingers:
                top.box("m2", *(edge_box(side, f0, f1, CH + 6)))
        elif net == "vdd":  # Metal5 onto the north vdd rail, Metal2 bar + stack at the pad
            assert side == "N"
            top.box("m2", *edge_box(side, a0, a1, bar))
            top.stack(*edge_box(side, fc - 10, fc + 10, bar), 2, 5)
            top.box("m5", fc - 10, top_n - 8, fc + 10, TILE[3])
        else:  # straight: the macro pin faces the pad finger
            lay, w = ROUTE[net]
            lvl = LEVEL[lay]
            (pl, px, py), = [p for p in mp[net] if p[0] == lvl and (abs(p[2] - top_n) < 2 if side == "N" else abs(p[1] - west_x) < 2)]
            assert abs((px if side == "N" else py) - fc) < 0.01, f"{net}: macro pin {px, py} not facing the pad finger {fc}"
            top.box("m2", *edge_box(side, a0, a1, bar))
            top.stack(*edge_box(side, fc - w / 2, fc + w / 2, bar), 2, lvl)
            top.box(lay, *edge_box(side, fc - w / 2, fc + w / 2, CH + 1))
        # pin label at the pad (top level), on metal: centre of the first strap for vss
        lc = g((fingers[0][0] + fingers[0][1]) / 2) if fingers else fc
        lx, lyy = ((lc, TILE[3] - 1) if side == "N" else (TILE[0] + 1, lc))
        top.label(2, net, lx, lyy)
    ly.write(OUT)
    print(f"wrote {OUT}: macro at ({mx}, {my}) size {b.width():.0f} x {b.height():.0f}, tile A {TILE}")
    print(f"pads: {len(pins)}, macro outside tile A: east {over[0]:.1f} um, south {over[1]:.1f} um")


try:
    main()
except BaseException as e:  # KLayout -b swallows tracebacks of -r scripts
    import traceback
    traceback.print_exc()
    print("ERROR:", e)
    raise
