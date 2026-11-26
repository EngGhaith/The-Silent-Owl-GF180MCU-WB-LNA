"""Per-layer shape count and area, for two layouts side by side.

usage: python3 lvs/layer_census.py before.gds after.gds
"""
import sys

import klayout.db as kdb

LAY = [("M1", 34), ("V1", 35), ("M2", 36), ("V2", 38), ("M3", 42),
       ("V3", 40), ("M4", 46), ("V4", 41), ("M5", 81),
       ("COMP", 22), ("cont", 33), ("poly2", 30), ("pplus", 31)]
paths = sys.argv[1:3]

res = []
for p in paths:
    ly = kdb.Layout(); ly.read(p)
    dbu = ly.dbu
    top = ly.cell("lna_core_parts")
    d = {}
    for nm, num in LAY:
        li = ly.find_layer(num, 0)
        r = kdb.Region() if li is None else kdb.Region(top.begin_shapes_rec(li))
        r.merge()
        d[nm] = (r.count(), r.area() * dbu * dbu)
    res.append(d)

print(f"{'layer':6}{'before n':>10}{'before um2':>13}{'after n':>10}"
      f"{'after um2':>13}{'delta um2':>13}{'':>9}")
for nm, _ in LAY:
    c0, a0 = res[0][nm]
    c1, a1 = res[1][nm]
    pct = 100.0 * (a1 - a0) / a0 if a0 else 0.0
    flag = "  <-- lost" if pct < -5 else ""
    print(f"{nm:6}{c0:10d}{a0:13.0f}{c1:10d}{a1:13.0f}{a1-a0:13.0f}{pct:8.1f} %{flag}")
