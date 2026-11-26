"""For each coil candidate: which metal layers carry the WINDING (guard ring excluded).

The guard ring is the polygon whose bbox spans (near) the full cell extent; every
other conductor polygon on that layer belongs to the winding / its feed.
"""
import glob, os
import klayout.db as kdb

GT = "/foss/designs/rapidpassives/try4/newflow/good_tries"
METAL = {(34, 0): "M1", (36, 0): "M2", (42, 0): "M3", (46, 0): "M4", (81, 0): "M5/TM", (53, 0): "TM"}
VIA = {(35, 0): "V1", (38, 0): "V2", (40, 0): "V3", (41, 0): "V4", (50, 0): "TV"}

DIRS = [
    ("D418.0 square", "LEQ_MAIN_FINAL_D418.0_N2_W26", "LEQ_MAIN_REAL_5LAYER_D418.0"),
    ("RECT_FINAL X247/Y174", "LEQ_MAIN_RECT_FINAL_X247.0_Y174.0_N2_W26", "LEQ_MAIN_RECT_REAL_5LAYER_X247.0_Y174.0"),
    ("RECT cand1 X244/Y174", "LEQ_MAIN_RECT_cand1_X244.0_Y174.0_N2_W26", None),
    ("RECT4 X130.8/Y314", "LEQ_MAIN_RECT4_X130.8_Y314.0_N2_W26", None),
    ("L1_RECT3 X314/Y118", "L1_RECT3_X314.0_Y118.0_N2_W26", None),
    ("LSHUNT_OUT_RECT_CAND3", "LSHUNT_OUT_RECT_CAND3_X314.0_Y112.5_N2_W26", None),
]


def analyse(gds):
    ly = kdb.Layout(); ly.read(gds)
    top = ly.top_cell()
    full = top.bbox()
    win, ring, vias = [], [], []
    for i in ly.layer_indexes():
        inf = ly.get_info(i)
        key = (inf.layer, inf.datatype)
        reg = kdb.Region(top.begin_shapes_rec(i)).merged()
        if reg.is_empty():
            continue
        if key in VIA:
            vias.append(VIA[key]); continue
        if key not in METAL:
            continue
        has_ring = has_win = False
        for p in reg.each():
            b = p.bbox()
            spans = (b.width() >= full.width() * 0.92 and b.height() >= full.height() * 0.92)
            if spans: has_ring = True
            else:     has_win = True
        if has_win:  win.append(METAL[key])
        if has_ring: ring.append(METAL[key])
    order = ["M1", "M2", "M3", "M4", "M5/TM", "TM"]
    srt = lambda L: sorted(set(L), key=lambda x: order.index(x) if x in order else 99)
    return srt(win), srt(ring), sorted(set(vias), key=lambda v: list(VIA.values()).index(v))


for label, d1, d2 in DIRS:
    print("===", label)
    seen = set()
    for d in [x for x in (d1, d2) if x]:
        for g in sorted(glob.glob(os.path.join(GT, d, "*.gds"))):
            b = os.path.basename(g)
            if "test_" in b or b in seen:
                continue
            seen.add(b)
            try:
                w, r, v = analyse(g)
            except Exception as e:
                print("   %-52s ERR %s" % (b[:52], e)); continue
            print("   %-52s winding=%-22s ring=%-22s vias=%s"
                  % (b[:52], "+".join(w) or "-", "+".join(r) or "-", "+".join(v) or "-"))
