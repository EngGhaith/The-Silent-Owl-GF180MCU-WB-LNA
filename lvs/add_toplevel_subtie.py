"""Give lna_core_parts its own substrate tap, so Magic names the substrate node vss.

Magic exports a cell's substrate node as a port only if the cell contains a device that
references it. main_Chipalooza's tap-rich cell, lna_core_supply, has 2620 taps but NO
devices, so its substrate-to-vss tie stays local and never reaches the parent -- the top
level ends up with an unnamed substrate node, VSUBS. main_pex_layout_refloor avoids this
only because its de-embedding Load_* cells (480 RES_MK each) do contain devices, so their
substrate port is exported and wired to vss at the top.

Fix: duplicate one existing tap -- COMP + pplus + contact + M1, verbatim, at the same
absolute coordinates -- into the lna_core_parts cell itself. The shapes coincide exactly
with ones already there, so they merge and no DRC rule can see a difference, but the top
cell now touches the substrate and the vss plane directly.

usage: python3 lvs/add_toplevel_subtie.py in.gds out.gds
"""
import sys

import klayout.db as kdb

LAY = [("COMP", 22, 0), ("pplus", 31, 0), ("contact", 33, 0), ("M1", 34, 0)]
src, dst = sys.argv[1], sys.argv[2]

ly = kdb.Layout(); ly.read(src)
dbu = ly.dbu
U = lambda v: int(round(v / dbu))
top = ly.cell("lna_core_parts")
sup = ly.cell("lna_core_supply")
tr = None
for i in top.each_inst():
    if i.cell.name == "lna_core_supply":
        tr = i.trans
        break
assert tr is not None, "lna_core_supply not instantiated at the top"


def reg(cell, num, dt=0):
    li = ly.find_layer(num, dt)
    r = kdb.Region() if li is None else kdb.Region(cell.begin_shapes_rec(li))
    r.merge()
    return r


comp = reg(sup, 22).transformed(tr)
pplus = reg(sup, 31).transformed(tr)
cont = reg(sup, 33).transformed(tr)
m1 = reg(sup, 34).transformed(tr)
tap = (comp & pplus).interacting(cont)
assert tap.count(), "no contacted p-tap in lna_core_supply"

# pick the largest tap that is covered by M1, and take a small window around it
best = max(tap.each(), key=lambda p: p.area())
b = best.bbox()
win = kdb.Region(b.enlarged(U(0.5), U(0.5)))
print(f"tap chosen: {best.area()*dbu*dbu:.2f} um2 at "
      f"({b.left*dbu:.3f},{b.bottom*dbu:.3f})-({b.right*dbu:.3f},{b.top*dbu:.3f})")

added = {}
for name, num, dt in LAY:
    piece = reg(sup, num, dt).transformed(tr) & win
    piece.merge()
    li = ly.layer(num, dt)
    n = 0
    for p in piece.each():
        top.shapes(li).insert(p)
        n += 1
    added[name] = (n, piece.area() * dbu * dbu)
    print(f"   {name:8s}: {n} shape(s), {piece.area()*dbu*dbu:8.3f} um2 copied into lna_core_parts")

assert added["COMP"][0] and added["pplus"][0] and added["contact"][0] and added["M1"][0], \
    "the window did not capture a full tap stack"
ly.write(dst)
print(f"\nwrote {dst}")
