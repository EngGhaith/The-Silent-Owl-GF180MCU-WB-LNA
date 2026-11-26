"""What does the LEQ cell contain, before vs after the via loss?

usage: python3 lvs/leq_inst_census.py before.gds after.gds
"""
import collections
import sys

import klayout.db as kdb

CELL = "LEQ_MAIN_RECT4"
VIA = ((35, "V1"), (38, "V2"), (40, "V3"), (41, "V4"))

for tag, path in zip(("before", "after "), sys.argv[1:3]):
    ly = kdb.Layout(); ly.read(path)
    c = ly.cell(CELL)
    kids = collections.Counter()
    placements = 0
    for i in c.each_inst():
        n = i.cell.name
        k = i.cell_inst.size()          # array instances count as many
        kids[n] += k
        placements += k
    own = {}
    for num, nm in VIA:
        li = ly.find_layer(num, 0)
        own[nm] = 0 if li is None else c.shapes(li).size()
    print(f"{tag}: {len(list(c.each_inst())):5d} instance records, {placements:7d} placements, "
          f"{len(kids):4d} distinct children")
    print(f"         via shapes drawn directly in the LEQ cell: {own}")
    for n, k in kids.most_common(5):
        print(f"           {n}  x{k}")
