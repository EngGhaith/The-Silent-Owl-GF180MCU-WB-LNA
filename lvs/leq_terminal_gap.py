"""Where does LEQ's second terminal stop, and how far is it from vss?

Magic cuts the coil at its RES_MK / metal5_res marker into a tm11k device with two
terminal nets. Plain metal connectivity does not do that, which is why a geometric
extraction shows the winding as one net while LVS sees a floating terminal. So: cut the
metal at the resistor marker, re-extract, and report which side fails to reach the grid.

usage: python3 lvs/leq_terminal_gap.py [layout.gds]
"""
import sys

import klayout.db as kdb

SRC = sys.argv[1] if len(sys.argv) > 1 else "lvs/work/lna_core_parts.gds"
STACK = [("M1", 34), ("V1", 35), ("M2", 36), ("V2", 38), ("M3", 42),
         ("V3", 40), ("M4", 46), ("V4", 41), ("M5", 81)]
RESMK = [(110, 5), (110, 11), (110, 12), (110, 13), (110, 14), (110, 15)]

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


leq = ly.cell("lna_core_input_match__LEQ")
tr = abs_trans("lna_core_input_match__LEQ", top)
lb = leq.bbox().transformed(tr)
win = lb.enlarged(U(120), U(120))
print(f"LEQ {tr}  bbox ({lb.left*dbu:.1f},{lb.bottom*dbu:.1f})-({lb.right*dbu:.1f},{lb.top*dbu:.1f})")

marks = kdb.Region()
for num, dt in RESMK:
    li = ly.find_layer(num, dt)
    if li is None:
        continue
    # the marker sits on the route OUTSIDE the coil cell, so search the whole top cell
    # inside the window rather than the LEQ cell
    r = kdb.Region(top.begin_shapes_rec(li)) & kdb.Region(win)
    if not r.is_empty():
        b = r.bbox()
        print(f"  marker {num}/{dt}: {r.count()} shapes  "
              f"({b.left*dbu:.2f},{b.bottom*dbu:.2f})-({b.right*dbu:.2f},{b.top*dbu:.2f})")
        marks += r
marks.merge()
if marks.is_empty():
    print("  no resistor marker inside LEQ -- nothing to cut")
    raise SystemExit

clip = kdb.Layout(); clip.dbu = dbu
cc = clip.create_cell("CLIP")
for n, num in STACK:
    li = ly.find_layer(num, 0)
    r = (kdb.Region(top.begin_shapes_rec(li)) & kdb.Region(win)) if li is not None else kdb.Region()
    r.merge()
    if n == "M5":
        r = r - marks           # Magic's resistor: the marked span is the device, not a wire
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
    for n, _ in STACK:
        reg += l2n.shapes_of_net(net, lay[n], True)
    reg.merge()
    if reg.area():
        nets.append((reg.area() * dbu * dbu, reg))
nets.sort(key=lambda r: -r[0])
big = nets[0][1]
print(f"\nwith the coil cut at its resistor marker: {len(nets)} nets, "
      f"largest {nets[0][0]:.0f} um2")

# the terminal stubs: small nets that touch the marker
for a, reg in nets[1:]:
    if (reg.sized(U(0.3)) & marks).is_empty():
        continue
    b = reg.bbox()
    print(f"\n  terminal stub {a:9.1f} um2  ({b.left*dbu:8.2f},{b.bottom*dbu:8.2f})-"
          f"({b.right*dbu:8.2f},{b.top*dbu:8.2f})")
    for d in (0.5, 1, 2, 3, 5, 8, 12, 20, 30, 50):
        if not (reg.sized(U(d)) & big).is_empty():
            near = (reg.sized(U(d)) & big)
            nb = near.bbox()
            print(f"      reaches the grid when grown {d} um -> gap about {d} um, "
                  f"nearest grid metal at ({nb.left*dbu:.2f},{nb.bottom*dbu:.2f})-"
                  f"({nb.right*dbu:.2f},{nb.top*dbu:.2f})")
            break
    else:
        print("      stays isolated out to 50 um -- no nearby grid metal at all")
