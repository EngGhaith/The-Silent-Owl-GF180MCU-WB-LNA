"""Find a clear place to drop a dummy poly resistor in the top cell.

Wanted: a window fully covered by the vss M1 plane (so the resistor's own terminal M1
merges with vss) but empty of poly2, COMP, contact and the device marker layers, so
nothing can clash.

usage: python3 lvs/find_free_spot.py layout.gds W H
"""
import sys

import klayout.db as kdb

SRC = sys.argv[1]
W = float(sys.argv[2]) if len(sys.argv) > 2 else 56.0
H = float(sys.argv[3]) if len(sys.argv) > 3 else 6.0
CLEAR = [(30, 0), (22, 0), (33, 0), (49, 0), (62, 0), (31, 0), (110, 5)]

ly = kdb.Layout(); ly.read(SRC)
dbu = ly.dbu
U = lambda v: int(round(v / dbu))
top = ly.cell("lna_core_parts")


def reg(num, dt=0):
    i = ly.find_layer(num, dt)
    r = kdb.Region() if i is None else kdb.Region(top.begin_shapes_rec(i))
    r.merge()
    return r


m1 = reg(34)
busy = kdb.Region()
for num, dt in CLEAR:
    busy += reg(num, dt)
busy.merge()
# keep a margin away from anything busy
busy = busy.sized(U(1.0))

# candidate: inside M1, outside busy
cand = m1 - busy
cand.merge()
print(f"candidate area (inside vss M1, 1 um clear of poly/COMP/contact/markers): "
      f"{cand.area()*dbu*dbu:.0f} um2 in {cand.count()} pieces")

best = None
for p in cand.each():
    b = p.bbox()
    if b.width() < U(W) or b.height() < U(H):
        continue
    # require the whole W x H box to be inside this polygon
    for dy in (0,):
        box = kdb.Box(b.left, b.bottom, b.left + U(W), b.bottom + U(H))
        if (kdb.Region(box) - kdb.Region(p)).is_empty():
            a = p.area()
            if best is None or a > best[0]:
                best = (a, box)
if best is None:
    print("no clear window of that size found")
else:
    b = best[1]
    print(f"placement window {W} x {H} um at "
          f"({b.left*dbu:.2f},{b.bottom*dbu:.2f})-({b.right*dbu:.2f},{b.top*dbu:.2f})")
    # confirm it really is covered by M1 and clear of everything else
    r = kdb.Region(b)
    print(f"   covered by M1 : {(r - m1).is_empty()}")
    for num, dt in CLEAR:
        print(f"   {num}/{dt} inside: {(r & reg(num, dt)).area()*dbu*dbu:.3f} um2")
