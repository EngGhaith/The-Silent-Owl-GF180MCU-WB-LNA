"""How much dummy COMP / dummy poly2 sits under the MIM capacitors and the coils?

The fill keepout list (CKO/PKO in make_dummy_fill.py) is driven by the DRC rules: it
avoids comp, poly2, wells, res_mk, ind_mk, ndmy, pmndmy, pad. The MiM stack (M4 bottom
plate, 75/0 top plate) is NOT in that list, because no DRC rule forbids dummy diffusion
underneath it -- so the fill walks straight under the caps unless a keepout marker says
otherwise.

usage: python3 lvs/fill_under_mim.py filled.gds
"""
import sys

import klayout.db as kdb

src = sys.argv[1] if len(sys.argv) > 1 else "klayout/lna_core_parts_filled.gds"
ly = kdb.Layout(); ly.read(src)
dbu = ly.dbu
U = lambda v: int(round(v / dbu))
top = ly.cell("lna_core_parts")


def reg(lay, dt=0):
    i = ly.find_layer(lay, dt)
    r = kdb.Region() if i is None else kdb.Region(top.begin_shapes_rec(i))
    r.merge()
    return r


dcomp, dpoly = reg(22, 4), reg(30, 4)
mim_top = reg(75, 0)                      # MiM top plate
m4 = reg(46, 0)
mim_bot = m4.interacting(mim_top)         # the M4 bottom plates that carry a MiM
indmk = reg(151, 5)

print(f"{src}")
print(f"  dummy COMP  {dcomp.count():5d} islands  {dcomp.area()*dbu*dbu:10.1f} um2")
print(f"  dummy poly2 {dpoly.count():5d} islands  {dpoly.area()*dbu*dbu:10.1f} um2")
print(f"  MiM top plates (75/0) {mim_top.count():3d}, "
      f"{mim_top.area()*dbu*dbu:9.1f} um2; bottom plates {mim_bot.count():3d}, "
      f"{mim_bot.area()*dbu*dbu:9.1f} um2")
print(f"  ind_mk (151/5) {indmk.count():3d}, {indmk.area()*dbu*dbu:9.1f} um2")

for name, foot in (("MiM bottom plate", mim_bot), ("MiM top plate", mim_top),
                   ("ind_mk (coils)", indmk)):
    if foot.is_empty():
        print(f"\n  {name}: none in this layout")
        continue
    a = foot.area() * dbu * dbu
    oc = (dcomp & foot).area() * dbu * dbu
    op = (dpoly & foot).area() * dbu * dbu
    print(f"\n  under {name} ({a:.1f} um2):")
    print(f"      dummy COMP  {oc:9.1f} um2  = {100*oc/a:5.1f} % of its footprint")
    print(f"      dummy poly2 {op:9.1f} um2  = {100*op/a:5.1f} % of its footprint")
    for d in (1.0, 5.0, 10.0):
        g = foot.sized(U(d))
        gc = (dcomp & g).area() * dbu * dbu
        print(f"      within {d:4.1f} um of it: dummy COMP {gc:9.1f} um2")
