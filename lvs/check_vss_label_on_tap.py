"""Does any vss label sit on metal that reaches a p-substrate tap?

Magic merges its substrate node (VSUBS) into a named net only when a substrate tap --
pplus COMP, contacted, with metal on it -- is electrically joined to metal carrying that
label. main_pex_layout_refloor merges VSUBS into vss; main_Chipalooza does not.

usage: python3 lvs/check_vss_label_on_tap.py layout.gds [layout2.gds ...]
"""
import sys

import klayout.db as kdb

M1, M2, M4 = (34, 0), (36, 0), (46, 0)
TEXT = [(34, 10), (36, 10), (46, 10)]

for path in sys.argv[1:]:
    ly = kdb.Layout(); ly.read(path)
    dbu = ly.dbu
    U = lambda v: int(round(v / dbu))
    top = ly.cell("lna_core_parts")

    def reg(num, dt=0):
        i = ly.find_layer(num, dt)
        r = kdb.Region() if i is None else kdb.Region(top.begin_shapes_rec(i))
        r.merge()
        return r

    comp, pplus, cont = reg(22), reg(31), reg(33)
    nwell = reg(21)
    tap = (comp & pplus)
    if not nwell.is_empty():
        tap = tap.outside(nwell)
    tap = tap.interacting(cont)
    m1 = reg(*M1)
    tap_m1 = m1.interacting(tap)          # M1 sitting on a contacted p-tap

    print(f"=== {path.split('/')[-1]}")
    print(f"   p-substrate taps (contacted): {tap.count():6d}  {tap.area()*dbu*dbu:10.1f} um2")
    print(f"   M1 touching a tap          : {tap_m1.count():6d}  {tap_m1.area()*dbu*dbu:10.1f} um2")

    hits = 0
    total = 0
    for num, dt in TEXT:
        li = ly.find_layer(num, dt)
        if li is None:
            continue
        it = top.begin_shapes_rec(li)
        while not it.at_end():
            s = it.shape()
            if s.is_text() and s.text.string == "vss":
                t = s.text.transformed(it.trans())
                total += 1
                pt = kdb.Region(kdb.Box(t.x - U(0.05), t.y - U(0.05),
                                        t.x + U(0.05), t.y + U(0.05)))
                on_tap_metal = not (pt & tap_m1).is_empty()
                if on_tap_metal:
                    hits += 1
                    if hits <= 4:
                        print(f"      vss label at ({t.x*dbu:8.2f},{t.y*dbu:8.2f}) "
                              f"on layer {num}/{dt} IS on tap-connected M1")
            it.next()
    print(f"   vss labels: {total}, of which sitting directly on tap-connected M1: {hits}")
    if hits == 0:
        print("   -> no vss label lands on a substrate tap; Magic keeps the substrate as VSUBS\n")
    else:
        print("   -> substrate should merge into vss\n")
