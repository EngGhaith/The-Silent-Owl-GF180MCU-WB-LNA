"""Localise the two opens LVS reports in the Chipalooza layout.

  1. lna_core_output_match: the LSHUNT_OUT terminal and the MIM cap sit on different
     nets where the schematic has both on rf_out_pad.
  2. top level: vss extracts as ~19 disconnected islands.

usage: python3 lvs/locate_opens.py [layout.gds]
"""
import sys

import klayout.db as kdb

SRC = sys.argv[1] if len(sys.argv) > 1 else "klayout/lna_core_parts.gds"
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


tr = abs_trans("lna_core_output_match__LSHUNT_OUT", top)
coil = ly.cell("lna_core_output_match__LSHUNT_OUT")
cb = coil.bbox().transformed(tr)
win = cb.enlarged(U(60), U(60))
print(f"LSHUNT_OUT at {tr}, bbox ({cb.left*dbu:.1f},{cb.bottom*dbu:.1f})-"
      f"({cb.right*dbu:.1f},{cb.top*dbu:.1f}); window +60 um")

clip = kdb.Layout(); clip.dbu = dbu
cc = clip.create_cell("CLIP")
for name, num in STACK:
    li = ly.find_layer(num, 0)
    r = (kdb.Region(top.begin_shapes_rec(li)) & kdb.Region(win)) if li is not None else kdb.Region()
    r.merge()
    for p in r.each():
        cc.shapes(clip.layer(num, 0)).insert(p)

l2n = kdb.LayoutToNetlist(kdb.RecursiveShapeIterator(clip, cc, []))
lay = {n: l2n.make_polygon_layer(clip.layer(num, 0), n) for n, num in STACK}
for a, v, b in (("M1", "V1", "M2"), ("M2", "V2", "M3"), ("M3", "V3", "M4"),
                ("M4", "V4", "M5")):
    l2n.connect(lay[a], lay[v]); l2n.connect(lay[v], lay[b])
for n, _ in STACK:
    l2n.connect(lay[n])
l2n.extract_netlist()
circ = next(iter(l2n.netlist().each_circuit()))

# the coil's own top-metal terminal: its 201/0 marker, transformed
li201 = ly.find_layer(201, 0)
term = None
if li201 is not None:
    for s in coil.shapes(li201).each():
        term = s.polygon.bbox().transformed(tr)
        break
print(f"coil terminal marker: ({term.left*dbu:.2f},{term.bottom*dbu:.2f})-"
      f"({term.right*dbu:.2f},{term.top*dbu:.2f})" if term else "no 201/0 marker")

nets = []
for net in circ.each_net():
    reg = kdb.Region()
    for n, _ in STACK:
        reg += l2n.shapes_of_net(net, lay[n], True)
    reg.merge()
    if reg.area() > 0:
        nets.append((reg.area() * dbu * dbu, reg, net))
nets.sort(key=lambda r: -r[0])
print(f"\n{len(nets)} nets in the window, largest first:")
for a, reg, net in nets[:8]:
    b = reg.bbox()
    hit = ""
    if term is not None and not (reg & kdb.Region(term.enlarged(U(0.5), U(0.5)))).is_empty():
        hit = "  <-- contains the LSHUNT_OUT terminal"
    print(f"  {a:10.1f} um2  bbox ({b.left*dbu:8.1f},{b.bottom*dbu:8.1f})-"
          f"({b.right*dbu:8.1f},{b.top*dbu:8.1f}){hit}")

# how far apart are the coil's net and the nearest other net?
if term is not None:
    own = next((r for _, r, _ in nets
                if not (r & kdb.Region(term.enlarged(U(0.5), U(0.5)))).is_empty()), None)
    if own is not None:
        for d in (0.1, 0.5, 1.0, 2.0, 5.0, 10.0, 20.0):
            grown = own.sized(U(d))
            touch = [a for a, r, _ in nets if r is not own and not (grown & r).is_empty()]
            if touch:
                print(f"\n  the coil's net reaches another net only when grown by {d} um "
                      f"-> the open is about {d} um wide (nearest net {max(touch):.0f} um2)")
                break
        else:
            print("\n  the coil's net stays isolated out to 20 um")
