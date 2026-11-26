"""Restore the LEQ via stitching that KLayout dropped.

A KLayout session regenerated the hierarchy and left `via_stitch_7` with zero
sub-instances; those four instances held every via of the LEQ winding:

    chip-wide   V1 765593 -> 560511   V2 692678 -> 489605
                V3 736149 -> 533076   V4 747838 -> 544765
    all lost inside (93.5, 36.4)-(367.1, 663.6), the LEQ winding footprint

All metal is untouched, so the coil looks right on screen but extracts as four floating
per-layer nets and LVS fails on lna_core_input_match.

Restoring by hierarchy does not work: the emptied sub-cells still exist by name, so
Cell#copy_tree reuses them instead of copying the good content. So the missing vias are
recovered geometrically -- (good - damaged) per via layer -- and placed in one dedicated
cell instantiated at the top. Via squares never touch each other (0.26 um on a 0.52 um
pitch), so merging the difference cannot fuse two vias into an oversized one.

usage: python3 lvs/repair_leq_vias.py damaged.gds good.gds out.gds
"""
import sys

import klayout.db as kdb

VIA = ((35, "V1"), (38, "V2"), (40, "V3"), (41, "V4"))
REPAIR_CELL = "LEQ_VIA_RESTORE"
dmg, good, out = sys.argv[1], sys.argv[2], sys.argv[3]

tgt = kdb.Layout(); tgt.read(dmg)
src = kdb.Layout(); src.read(good)
dbu = tgt.dbu
assert abs(src.dbu - dbu) < 1e-12, (src.dbu, dbu)
top, stop = tgt.cell("lna_core_parts"), src.cell("lna_core_parts")

rep = tgt.cell(REPAIR_CELL) or tgt.create_cell(REPAIR_CELL)
rep.clear()

print(f"{'layer':>6}{'damaged':>10}{'good':>10}{'missing':>10}{'max side um':>13}")
total = 0
for num, nm in VIA:
    lid, lis = tgt.find_layer(num, 0), src.find_layer(num, 0)
    rd = kdb.Region(top.begin_shapes_rec(lid)) if lid is not None else kdb.Region()
    rs = kdb.Region(stop.begin_shapes_rec(lis)) if lis is not None else kdb.Region()
    nd, ns = rd.count(), rs.count()
    miss = (rs - rd).merged()
    # sanity: nothing in the difference may be bigger than a legal via
    big = max((max(p.bbox().width(), p.bbox().height()) * dbu for p in miss.each()),
              default=0.0)
    print(f"{nm:>6}{nd:10d}{ns:10d}{miss.count():10d}{big:13.3f}")
    assert big <= 0.40, f"{nm}: a difference piece is {big:.3f} um across -- not a via"
    li = tgt.layer(num, 0)
    for p in miss.each():
        rep.shapes(li).insert(p)
    total += miss.count()

top.insert(kdb.CellInstArray(rep.cell_index(), kdb.Trans()))
print(f"\nrestored {total} via shapes into {REPAIR_CELL}, instantiated once at the top")

print("\nchip-wide via totals after repair (vs the good layout):")
ok = True
for num, nm in VIA:
    a = kdb.Region(top.begin_shapes_rec(tgt.find_layer(num, 0))).count()
    b = kdb.Region(stop.begin_shapes_rec(src.find_layer(num, 0))).count()
    ok &= (a == b)
    print(f"  {nm}: {a:8d} vs {b:8d}" + ("" if a == b else "   <-- still differs"))
print("  all via counts match" if ok else "  MISMATCH REMAINS")

tgt.write(out)
print(f"\nwrote {out}")
