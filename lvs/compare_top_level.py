"""What does main's top cell have that Chipalooza's doesn't, for substrate naming?

Magic exports a cell's substrate node as a port only when the cell contains a DEVICE that
references it. A cell full of substrate taps but no devices (lna_core_supply) ties its own
local substrate to vss invisibly -- nothing propagates to the parent. main's top cell
instantiates the de-embedding Load_* cells, which DO contain devices (ppolyf resistors),
so their substrate port is exported and wired to vss at the top, naming the node.

usage: python3 lvs/compare_top_level.py mainUnfilled.gds chipalooza.gds
"""
import sys

import klayout.db as kdb

DEVICE_MARKERS = [("COMP", 22, 0), ("poly2", 30, 0), ("nplus", 32, 0), ("pplus", 31, 0),
                  ("contact", 33, 0), ("RES_MK", 110, 5), ("MIM", 75, 0)]

for path in sys.argv[1:3]:
    ly = kdb.Layout(); ly.read(path)
    dbu = ly.dbu
    top = ly.cell("lna_core_parts")
    print(f"=== {path.split('/')[-1]}   top-level instances")
    for i in top.each_inst():
        c = i.cell

        def n(num, dt=0):
            li = ly.find_layer(num, dt)
            return 0 if li is None else kdb.Region(c.begin_shapes_rec(li)).count()

        # a transistor needs poly over COMP; a poly resistor needs RES_MK over poly
        comp, poly, res = n(22), n(30), n(110, 5)
        gates = 0
        if comp and poly:
            lc, lp = ly.find_layer(22, 0), ly.find_layer(30, 0)
            gates = (kdb.Region(c.begin_shapes_rec(lc)) & kdb.Region(c.begin_shapes_rec(lp))).count()
        taps = 0
        lc, lpp, lct = ly.find_layer(22, 0), ly.find_layer(31, 0), ly.find_layer(33, 0)
        if None not in (lc, lpp, lct):
            t = kdb.Region(c.begin_shapes_rec(lc)) & kdb.Region(c.begin_shapes_rec(lpp))
            t.merge()
            taps = t.interacting(kdb.Region(c.begin_shapes_rec(lct))).count()
        kind = []
        if gates:
            kind.append(f"gates {gates}")
        if res:
            kind.append(f"RES_MK {res}")
        if taps:
            kind.append(f"taps {taps}")
        print(f"   {c.name:30s} {'DEVICES: ' + ', '.join(kind) if kind else 'no devices'}")
    print()
