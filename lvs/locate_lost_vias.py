"""Where did the vias go? Compare two layouts per via layer and localise the loss.

usage: python3 lvs/locate_lost_vias.py before.gds after.gds
"""
import sys

import klayout.db as kdb

VIA = [("V1", 35), ("V2", 38), ("V3", 40), ("V4", 41)]
COILS = ["lna_core_input_match__LEQ", "lna_core_cg__L1",
         "lna_core_output_match__LSHUNT_OUT", "lna_core_cg__LD4", "lna_core_cs__LD2"]
before, after = sys.argv[1], sys.argv[2]


def load(p):
    ly = kdb.Layout(); ly.read(p)
    return ly, ly.cell("lna_core_parts")


def abs_trans(ly, name, cell, tr=kdb.Trans()):
    for i in cell.each_inst():
        t2 = tr * i.trans
        if i.cell.name == name:
            return t2
        r = abs_trans(ly, name, i.cell, t2)
        if r:
            return r


lb, tb = load(before)
la, ta = load(after)
dbu = lb.dbu

print("vias inside each coil cell (recursive):")
print(f"{'cell':38}{'layer':>6}{'before':>10}{'after':>10}{'delta':>10}")
for cn in COILS:
    cb, ca = lb.cell(cn), la.cell(cn)
    if cb is None or ca is None:
        print(f"  {cn}: present before={cb is not None} after={ca is not None}")
        continue
    for nm, num in VIA:
        lib, lia = lb.find_layer(num, 0), la.find_layer(num, 0)
        nb = kdb.Region(cb.begin_shapes_rec(lib)).count() if lib is not None else 0
        na = kdb.Region(ca.begin_shapes_rec(lia)).count() if lia is not None else 0
        if nb != na:
            print(f"  {cn:36}{nm:>6}{nb:10d}{na:10d}{na-nb:10d}")

print("\nwhere the lost via area sits (top-level geometric difference):")
for nm, num in VIA:
    lib, lia = lb.find_layer(num, 0), la.find_layer(num, 0)
    rb = kdb.Region(tb.begin_shapes_rec(lib)) if lib is not None else kdb.Region()
    ra = kdb.Region(ta.begin_shapes_rec(lia)) if lia is not None else kdb.Region()
    rb.merge(); ra.merge()
    lost = (rb - ra).merged()
    if lost.is_empty():
        print(f"  {nm}: nothing lost")
        continue
    b = lost.bbox()
    print(f"  {nm}: {lost.count():7d} pieces  {lost.area()*dbu*dbu:9.1f} um2  "
          f"bbox ({b.left*dbu:7.1f},{b.bottom*dbu:7.1f})-({b.right*dbu:7.1f},{b.top*dbu:7.1f})")
