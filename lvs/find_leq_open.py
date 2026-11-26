"""Where exactly is LEQ's floating terminal, and how far is it from vss?

usage: python3 lvs/find_leq_open.py [layout.gds]
"""
import sys

import klayout.db as kdb

SRC = sys.argv[1] if len(sys.argv) > 1 else "lvs/work/lna_core_parts.gds"
STACK = [("M1", 34), ("V1", 35), ("M2", 36), ("V2", 38), ("M3", 42),
         ("V3", 40), ("M4", 46), ("V4", 41), ("M5", 81)]

ly = kdb.Layout(); ly.read(SRC)
dbu = ly.dbu
U = lambda v: int(round(v / dbu))
top = ly.cell("lna_core_parts")


def abs_trans(name, cell, tr=kdb.Trans()):
    for i in cell.each_inst():
        t2 = tr * i.trans
        if i.cell.name == name:
            return t2
        r = abs_trans(name, i.cell, t2)
        if r:
            return r


tr = abs_trans("lna_core_input_match__LEQ", top)
leq = ly.cell("lna_core_input_match__LEQ")
lb = leq.bbox().transformed(tr)
win = lb.enlarged(U(80), U(80))
print(f"LEQ {tr}  bbox ({lb.left*dbu:.1f},{lb.bottom*dbu:.1f})-({lb.right*dbu:.1f},{lb.top*dbu:.1f})")

leq_metal = kdb.Region()
for _, num in STACK:
    li = ly.find_layer(num, 0)
    if li is not None:
        leq_metal += kdb.Region(leq.begin_shapes_rec(li)).transformed(tr)
leq_metal.merge()

clip = kdb.Layout(); clip.dbu = dbu
cc = clip.create_cell("CLIP")
for n, num in STACK:
    li = ly.find_layer(num, 0)
    r = (kdb.Region(top.begin_shapes_rec(li)) & kdb.Region(win)) if li is not None else kdb.Region()
    r.merge()
    for p in r.each():
        cc.shapes(clip.layer(num, 0)).insert(p)

l2n = kdb.LayoutToNetlist(kdb.RecursiveShapeIterator(clip, cc, []))
lay = {n: l2n.make_polygon_layer(clip.layer(num, 0), n) for n, num in STACK}
for a, v, b in (("M1", "V1", "M2"), ("M2", "V2", "M3"), ("M3", "V3", "M4"), ("M4", "V4", "M5")):
    l2n.connect(lay[a], lay[v]); l2n.connect(lay[v], lay[b])
for n, _ in STACK:
    l2n.connect(lay[n])
l2n.extract_netlist()
circ = next(iter(l2n.netlist().each_circuit()))

nets = []
for net in circ.each_net():
    reg = kdb.Region()
    per = {}
    for n, _ in STACK:
        s = l2n.shapes_of_net(net, lay[n], True)
        per[n] = s.area() * dbu * dbu
        reg += s
    reg.merge()
    if reg.area():
        nets.append((reg.area() * dbu * dbu, reg, per))
nets.sort(key=lambda r: -r[0])
print(f"\n{len(nets)} nets in LEQ's window (+80 um):")
for a, reg, per in nets[:10]:
    b = reg.bbox()
    inside = (reg & leq_metal).area() * dbu * dbu
    lay_s = " ".join(f"{k}={v:.0f}" for k, v in per.items() if v > 1)
    print(f"  {a:10.1f} um2  bbox ({b.left*dbu:7.1f},{b.bottom*dbu:7.1f})-"
          f"({b.right*dbu:7.1f},{b.top*dbu:7.1f})  in-LEQ {inside:8.1f}   {lay_s}")

big = nets[0][1]
for a, reg, per in nets[1:]:
    if (reg & leq_metal).area() == 0:
        continue
    b = reg.bbox()
    print(f"\nisolated LEQ piece: {a:.1f} um2 at ({b.left*dbu:.2f},{b.bottom*dbu:.2f})-"
          f"({b.right*dbu:.2f},{b.top*dbu:.2f})")
    for d in (0.5, 1, 2, 5, 10, 20, 40):
        if not (reg.sized(U(d)) & big).is_empty():
            touch = (reg.sized(U(d)) & big)
            tb = touch.bbox()
            print(f"   reaches the big net when grown {d} um  -> gap ~{d} um, "
                  f"nearest at ({tb.left*dbu:.2f},{tb.bottom*dbu:.2f})-"
                  f"({tb.right*dbu:.2f},{tb.top*dbu:.2f})")
            break
    else:
        print("   stays isolated out to 40 um")
