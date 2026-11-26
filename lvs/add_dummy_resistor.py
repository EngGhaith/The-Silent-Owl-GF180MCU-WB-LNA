"""Place a dummy poly resistor in the top cell with both terminals on vss.

Counterpart of XRDUM_SUBTIE in lna_core_parts.sch:
    XRDUM_SUBTIE vss vss vss ppolyf_u_1k r_width=1u r_length=48.35u

The existing lna_core_cg__R3 cell is exactly that device (RES_MK 48.35 um2, W=1u), so it
is instantiated rather than drawn from scratch. It goes under the vss M1 plane in a window
that carries no poly2, COMP, contact, pplus or marker geometry, so its own terminal M1
merges with the vss plane and both ends are on vss, while its bulk is the substrate --
which is the point: a top-level device referencing the substrate makes Magic export and
name that node.

usage: python3 lvs/add_dummy_resistor.py in.gds out.gds X Y
"""
import sys

import klayout.db as kdb

RCELL = "lna_core_cg__R3"
src, dst = sys.argv[1], sys.argv[2]
cx = float(sys.argv[3]) if len(sys.argv) > 3 else 536.4
cy = float(sys.argv[4]) if len(sys.argv) > 4 else 39.0

ly = kdb.Layout(); ly.read(src)
dbu = ly.dbu
U = lambda v: int(round(v / dbu))
top = ly.cell("lna_core_parts")
rc = ly.cell(RCELL)
assert rc is not None, RCELL

b = rc.bbox()
dx = U(cx) - (b.left + b.right) // 2
dy = U(cy) - (b.bottom + b.top) // 2
tr = kdb.Trans(kdb.Vector(dx, dy))
placed = b.transformed(tr)
print(f"{RCELL} {b.width()*dbu:.2f} x {b.height()*dbu:.2f} um placed at "
      f"({placed.left*dbu:.2f},{placed.bottom*dbu:.2f})-({placed.right*dbu:.2f},{placed.top*dbu:.2f})")


def reg(num, dt=0):
    i = ly.find_layer(num, dt)
    r = kdb.Region() if i is None else kdb.Region(top.begin_shapes_rec(i))
    r.merge()
    return r


# the window must be clear, and the terminals must land on the vss M1 plane
win = kdb.Region(placed.enlarged(U(1.0), U(1.0)))
for num, dt, name in ((30, 0, "poly2"), (22, 0, "COMP"), (33, 0, "contact"),
                      (31, 0, "pplus"), (110, 5, "RES_MK"), (49, 0, "49/0"), (62, 0, "62/0")):
    a = (win & reg(num, dt)).area() * dbu * dbu
    print(f"   existing {name:8s} within 1 um of the site: {a:8.3f} um2")
    assert a == 0, f"{name} present at the site"

m1_before = reg(34)
rm1 = kdb.Region(rc.begin_shapes_rec(ly.find_layer(34, 0))).transformed(tr)
rm1.merge()
ov = (rm1 & m1_before).area() * dbu * dbu
print(f"   resistor terminal M1 {rm1.area()*dbu*dbu:.3f} um2, "
      f"overlapping the vss plane: {ov:.3f} um2")
assert ov > 0, "terminals do not touch the vss plane"

top.insert(kdb.CellInstArray(rc.cell_index(), tr))
ly.write(dst)
print(f"\nwrote {dst}")
