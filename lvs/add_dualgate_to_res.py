"""Mark the two poly bias resistors as 6 V devices by drawing DUALGATE over them.

Magic separates the two poly-resistor flavours purely by DUALGATE (gf180mcuD.tech):

    layer hires    POLY and SBLK and HRES and RESDEF and-not DUALGATE  -> ppolyf_u_1k
    layer mvhires  POLY and SBLK and HRES and RESDEF and     DUALGATE  -> ppolyf_u_1k_6p0

The models are otherwise identical (rsh 1000 ohm/sq, same TC, same corners), so this is a
voltage-domain marker, not an electrical change. The schematic now calls R1/R2
ppolyf_u_1k_6p0, so the layout has to carry the marker or LVS sees two different devices.

The rectangle is poly2 grown by 0.4 um (DV.8) unioned with COMP grown by 0.24 um (DV.6/DV.7),
taken as a bbox so DV.5 (min width 0.7 um) is satisfied by construction. The script refuses to
run if anything unrelated is close enough to trip DV.2/DV.3.

The marker goes INSIDE the resistor cell, not into lna_core_parts: Magic extracts
lna_core_cg__R3/R4 as cells of their own, and a shape drawn in the parent is not visible to
the device recognition that runs inside the child -- a top-level marker leaves the device
extracted as plain ppolyf_u_1k. Clearances are still checked in top-level coordinates, once
per instance.

usage: python3 lvs/add_dualgate_to_res.py in.gds out.gds
"""
import sys

import klayout.db as kdb

CELLS = ("lna_core_cg__R3", "lna_core_cg__R4")
DUALGATE = (55, 0)
src, dst = sys.argv[1], sys.argv[2]

ly = kdb.Layout(); ly.read(src)
dbu = ly.dbu
U = lambda v: int(round(v / dbu))
top = ly.cell("lna_core_parts")


def reg(cell, num, dt=0):
    i = ly.find_layer(num, dt)
    r = kdb.Region() if i is None else kdb.Region(cell.begin_shapes_rec(i))
    r.merge()
    return r


def find(cell, tr, out, depth=0):
    for inst in cell.each_inst():
        t = tr * inst.trans
        if inst.cell.name in CELLS:
            out.append((inst.cell.name, t, inst.cell))
        elif depth < 4:
            find(inst.cell, t, out, depth + 1)


placed = []
find(top, kdb.Trans(), placed)
assert placed, "no resistor instances found"

ALL_COMP, ALL_POLY = reg(top, 22), reg(top, 30)
ALL_DG = reg(top, *DUALGATE)
li = ly.layer(*DUALGATE)

done = set()
for name, tr, cell in placed:
    # the marker, in the cell's own coordinates
    local = reg(cell, 30).sized(U(0.4)) + reg(cell, 22).sized(U(0.24))
    local.merge()
    assert not local.is_empty(), f"{name} has no poly2/COMP"
    box = local.bbox()
    assert box.width() >= U(0.7) and box.height() >= U(0.7), "DV.5 min width 0.7 um"

    # clearances, checked where the instance actually sits
    poly, comp = reg(cell, 30).transformed(tr), reg(cell, 22).transformed(tr)
    probe = kdb.Region(box.transformed(tr).enlarged(U(0.44), U(0.44)))
    for other, label, rule in (((ALL_COMP - comp), "COMP", "DV.3 0.24um"),
                               ((ALL_POLY - poly), "poly2", "DV.8 0.4um"),
                               (ALL_DG, "DUALGATE", "DV.2 0.44um")):
        n = other.interacting(probe).count()
        assert n == 0, f"{name}: {n} unrelated {label} shape(s) inside the 0.44 um probe ({rule})"

    at = box.transformed(tr)
    print(f"{name}: DUALGATE {box.width()*dbu:.2f} x {box.height()*dbu:.2f} um inside the cell, "
          f"landing at ({at.left*dbu:.3f},{at.bottom*dbu:.3f})-({at.right*dbu:.3f},{at.top*dbu:.3f})")
    if name not in done:
        cell.shapes(li).insert(box)
        done.add(name)

ly.write(dst)
print(f"\nwrote {dst}")
