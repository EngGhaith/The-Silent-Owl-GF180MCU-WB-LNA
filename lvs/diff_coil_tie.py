"""Why are LEQ's and L1's ground terminals floating in main_Chipalooza?

main_pex_layout_refloor passes LVS, so its coils ARE tied to vss. Compare the metal
around each coil's terminals in the two layouts, per layer, inside the coil cell and in
the parent that routes to it. Whatever is present in main and missing here is what was
lost.

usage: python3 lvs/diff_coil_tie.py
"""
import klayout.db as kdb

MAIN = "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/klayout/lna_core_parts.gds"
CHIP = "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/chipalooza_sim/klayout/lna_core_parts.gds"
LAYERS = [("M1", 34), ("V1", 35), ("M2", 36), ("V2", 38), ("M3", 42),
          ("V3", 40), ("M4", 46), ("V4", 41), ("M5", 81)]
COILS = ["lna_core_cg__L1", "lna_core_input_match__LEQ",
         "lna_core_output_match__LSHUNT_OUT"]
HALO = 25.0


def load(path):
    ly = kdb.Layout(); ly.read(path)
    return ly, ly.cell("lna_core_parts")


def abs_trans(ly, name, cell, tr=kdb.Trans()):
    for i in cell.each_inst():
        t2 = tr * i.trans
        if i.cell.name == name:
            return t2
        r = abs_trans(ly, name, i.cell, t2)
        if r:
            return r


def terminals(ly, name, tr):
    """the two 201/202 marker boxes of a coil, in absolute coordinates"""
    c = ly.cell(name)
    out = {}
    for pl in (201, 202):
        li = ly.find_layer(pl, 0)
        if li is None:
            continue
        for s in c.shapes(li).each():
            out[pl] = s.polygon.bbox().transformed(tr)
    return out


lym, topm = load(MAIN)
lyc, topc = load(CHIP)
dbu = lym.dbu
U = lambda v: int(round(v / dbu))

for coil in COILS:
    trm = abs_trans(lym, coil, topm)
    trc = abs_trans(lyc, coil, topc)
    print(f"\n================ {coil}")
    if trm is None or trc is None:
        print(f"   main: {trm}   chipalooza: {trc}   (missing in one of them)")
        continue
    print(f"   main {trm}      chipalooza {trc}")
    tm_, tc_ = terminals(lym, coil, trm), terminals(lyc, coil, trc)
    for pl in sorted(set(tm_) | set(tc_)):
        bm = tm_.get(pl)
        if bm is None:
            print(f"   marker {pl}: absent in main")
            continue
        # look at a halo around the terminal TIP (the far end of the leg)
        win_m = bm.enlarged(U(HALO), U(HALO))
        bc = tc_.get(pl)
        win_c = bc.enlarged(U(HALO), U(HALO)) if bc else None
        print(f"   --- terminal {pl}  main ({bm.left*dbu:.1f},{bm.bottom*dbu:.1f})-"
              f"({bm.right*dbu:.1f},{bm.top*dbu:.1f})"
              + (f"   chip ({bc.left*dbu:.1f},{bc.bottom*dbu:.1f})-"
                 f"({bc.right*dbu:.1f},{bc.top*dbu:.1f})" if bc else "   chip: MARKER ABSENT"))
        if win_c is None:
            continue
        for nm, num in LAYERS:
            li_m, li_c = lym.find_layer(num, 0), lyc.find_layer(num, 0)
            rm_ = (kdb.Region(topm.begin_shapes_rec(li_m)) & kdb.Region(win_m)) \
                if li_m is not None else kdb.Region()
            rc_ = (kdb.Region(topc.begin_shapes_rec(li_c)) & kdb.Region(win_c)) \
                if li_c is not None else kdb.Region()
            rm_.merge(); rc_.merge()
            am, ac = rm_.area() * dbu * dbu, rc_.area() * dbu * dbu
            if abs(am - ac) < 1.0:
                continue
            print(f"        {nm:3s}: main {am:9.1f} um2 ({rm_.count():4d})   "
                  f"chip {ac:9.1f} um2 ({rc_.count():4d})   diff {ac-am:+9.1f}")
