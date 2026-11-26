"""Which cells lost shapes between two layouts? Compare per-cell, per-layer shape counts.

usage: python3 lvs/find_emptied_cells.py before.gds after.gds
"""
import sys

import klayout.db as kdb

LAY = [("M1", 34), ("V1", 35), ("M2", 36), ("V2", 38), ("M3", 42),
       ("V3", 40), ("M4", 46), ("V4", 41), ("M5", 81)]


def census(path):
    ly = kdb.Layout(); ly.read(path)
    out = {}
    for c in ly.each_cell():
        d = {}
        for nm, num in LAY:
            li = ly.find_layer(num, 0)
            n = 0 if li is None else c.shapes(li).size()      # own shapes only
            if n:
                d[nm] = n
        if d:
            out[c.name] = d
    return out


a = census(sys.argv[1])
b = census(sys.argv[2])
names = sorted(set(a) | set(b))
rows = []
for n in names:
    da, db = a.get(n, {}), b.get(n, {})
    for nm, _ in LAY:
        x, y = da.get(nm, 0), db.get(nm, 0)
        if x != y:
            rows.append((y - x, n, nm, x, y))
rows.sort()
print(f"{'cell':34}{'layer':>6}{'before':>10}{'after':>10}{'delta':>10}")
for d, n, nm, x, y in rows[:25]:
    print(f"{n:34}{nm:>6}{x:10d}{y:10d}{d:10d}")
print(f"\n{len(rows)} cell/layer pairs changed; "
      f"cells only in before: {sorted(set(a)-set(b))[:5]}; "
      f"only in after: {sorted(set(b)-set(a))[:5]}")
