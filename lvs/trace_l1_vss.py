"""Trace L1's vss-side terminal to the vss grid in both layouts, and show where the two
differ along that path.

usage: python3 lvs/trace_l1_vss.py
"""
import klayout.db as kdb

MAIN = "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/klayout/lna_core_parts.gds"
CHIP = "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/chipalooza_sim/klayout/lna_core_parts.gds"
STACK = [("M1", 34), ("V1", 35), ("M2", 36), ("V2", 38), ("M3", 42),
         ("V3", 40), ("M4", 46), ("V4", 41), ("M5", 81)]
# L1's two terminals, absolute (same transform in both layouts)
TERM = {201: kdb.DBox(589.2, 489.0, 615.2, 677.0),      # input_match side
        202: kdb.DBox(617.2, 489.0, 643.2, 677.0)}      # vss side per XXL1 ... vss
WIN = kdb.DBox(430.0, 0.0, 820.0, 760.0)


def nets_in(path, tag):
    ly = kdb.Layout(); ly.read(path)
    dbu = ly.dbu
    U = lambda v: int(round(v / dbu))
    top = ly.cell("lna_core_parts")
    win = kdb.Box(U(WIN.left), U(WIN.bottom), U(WIN.right), U(WIN.top))
    clip = kdb.Layout(); clip.dbu = dbu
    cc = clip.create_cell("CLIP")
    for n, num in STACK:
        li = ly.find_layer(num, 0)
        r = (kdb.Region(top.begin_shapes_rec(li)) & kdb.Region(win)) if li is not None \
            else kdb.Region()
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
    out = []
    for net in circ.each_net():
        reg = kdb.Region()
        for n, _ in STACK:
            reg += l2n.shapes_of_net(net, lay[n], True)
        reg.merge()
        if reg.area():
            out.append((reg.area() * dbu * dbu, reg))
    out.sort(key=lambda r: -r[0])
    print(f"\n{tag}: {len(out)} nets in the window, largest {out[0][0]:.0f} um2")
    for pl, box in TERM.items():
        probe = kdb.Region(kdb.Box(U(box.left), U(box.bottom), U(box.right), U(box.top)))
        hit = [(a, i) for i, (a, r) in enumerate(out) if not (r & probe).is_empty()]
        if not hit:
            print(f"   terminal {pl}: no net found")
            continue
        a, i = max(hit)
        print(f"   terminal {pl} ({box.left:.1f},{box.bottom:.1f})-({box.right:.1f},{box.top:.1f})"
              f" -> net #{i}, {a:10.1f} um2"
              + ("   <-- the big grid net" if i == 0 else "   <-- ISOLATED from the grid"))
    return out, dbu


nm, _ = nets_in(MAIN, "main_pex_layout_refloor")
nc, dbu = nets_in(CHIP, "main_Chipalooza")

print("\nwhat is in main's biggest net but not in chipalooza's, inside the window:")
diff = (nm[0][1] - nc[0][1]).merged()
rows = sorted(((p.area() * dbu * dbu, p.bbox()) for p in diff.each()), key=lambda r: -r[0])
print(f"  {len(rows)} pieces, {sum(r[0] for r in rows):.1f} um2 total")
for a, b in rows[:12]:
    print(f"    {a:9.1f} um2  ({b.left*dbu:8.2f},{b.bottom*dbu:8.2f})-"
          f"({b.right*dbu:8.2f},{b.top*dbu:8.2f})")
