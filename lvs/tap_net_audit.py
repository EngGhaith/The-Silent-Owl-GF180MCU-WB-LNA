"""Which net does each substrate-tap-bearing piece of M1 belong to?

extra_be_checks README: "Any discrepancies should be the result of well/substrate taps
not connected to the correct power net." So: take every M1 polygon that sits on a
contacted p-substrate tap, and report which net labels land on it.

usage: python3 lvs/tap_net_audit.py layout.gds [layout2.gds ...]
"""
import collections
import sys

import klayout.db as kdb

TEXT_LAYERS = [(34, 10), (36, 10), (46, 10), (42, 10), (81, 10)]

for path in sys.argv[1:]:
    ly = kdb.Layout(); ly.read(path)
    dbu = ly.dbu
    U = lambda v: int(round(v / dbu))
    top = ly.cell("lna_core_parts")

    def reg(num, dt=0):
        i = ly.find_layer(num, dt)
        r = kdb.Region() if i is None else kdb.Region(top.begin_shapes_rec(i))
        r.merge()
        return r

    comp, pplus, cont, nwell = reg(22), reg(31), reg(33), reg(21)
    tap = comp & pplus
    if not nwell.is_empty():
        tap = tap.outside(nwell)
    tap = tap.interacting(cont)
    tap_m1 = reg(34).interacting(tap)

    labels = []
    for num, dt in TEXT_LAYERS:
        li = ly.find_layer(num, dt)
        if li is None:
            continue
        it = top.begin_shapes_rec(li)
        while not it.at_end():
            s = it.shape()
            if s.is_text():
                t = s.text.transformed(it.trans())
                labels.append((s.text.string, t.x, t.y, num))
            it.next()

    print(f"=== {path.split('/')[-1]}")
    print(f"   {tap.count()} contacted p-taps; {tap_m1.count()} M1 polygons sit on them\n")
    for p in sorted(tap_m1.each(), key=lambda q: -q.area()):
        pr = kdb.Region(p)
        b = p.bbox()
        names = collections.Counter()
        for s, x, y, lay in labels:
            if lay != 34:
                continue
            if not (pr & kdb.Region(kdb.Box(x - U(0.05), y - U(0.05),
                                            x + U(0.05), y + U(0.05)))).is_empty():
                names[s] += 1
        ntaps = tap.interacting(pr).count()
        lab = ", ".join(f"{k} x{v}" for k, v in names.most_common()) or "NO LABEL"
        print(f"   M1 {p.area()*dbu*dbu:10.1f} um2  ({b.left*dbu:7.1f},{b.bottom*dbu:7.1f})-"
              f"({b.right*dbu:7.1f},{b.top*dbu:7.1f})  taps on it: {ntaps:5d}   labels: {lab}")
    print()
