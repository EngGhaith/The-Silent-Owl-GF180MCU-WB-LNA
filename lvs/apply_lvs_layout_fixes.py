#!/usr/bin/env python3
"""Layout changes on klayout/lna_top2.gds (top cell lna_core_parts) for a clean Magic/Netgen LVS
(extra_be_checks run_full_lvs, the flow used by the Chipathon integration). See lvs/README.md.

usage: python3 lvs/apply_lvs_layout_fixes.py [in.gds [out.gds]]      (default: in place on klayout/lna_top2.gds)

1. remove the two M4 "vss" labels on VDD strap metal at (778.107 / 978.107, 1096.027) -> vdd/vss merge
2. RES_MK (110/5) on every metal-resistor marker (110/11..15), inside the same cell as the marker:
   Magic only extracts rm1..rm4 / tm11k where RESDEF (110/5) AND the metal marker overlap
3. DEEMB_O / DEEMB_S / DEEMB_R / DEEMB_2R / DEEMB_0P5R: identical feed in all five (cell DEEMB_feed_rm3):
   M1 feed line -> via tower M1-V1-M2-V2-M3 (1.62 x 1.62 um) -> M3 -> rm3 (W=1.62 L=1, 110/13 + 110/5) -> M3 pin
   - rm1 markers (110/11) of DEEMB_O / DEEMB_S removed (Magic maps 110/11 to MET2RES, so rm1 is never extracted)
   - pin labels deemb_* moved from M1 (34/10) to the M3 end of the feed (42/10); the M1-side labels are removed
"""
import os, sys
import klayout.db as db

HERE = os.path.dirname(os.path.abspath(__file__))
src = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "..", "klayout", "lna_top2.gds")
dst = sys.argv[2] if len(sys.argv) > 2 else src

ly = db.Layout()
ly.read(src)
top = ly.cell("lna_core_parts")
dbu = ly.dbu
L = lambda a, d=0: ly.layer(a, d)


def find_texts(cell, layer, name):
    return [s for s in cell.shapes(L(layer, 10)).each() if s.is_text() and s.text_string == name]


# ---- 1. vss labels on VDD metal --------------------------------------------------------------------------------
n = 0
for s in find_texts(top, 46, "vss") + find_texts(top, 46, "VSS"):
    p = s.text_dpos
    if abs(p.y - 1096.027) < 0.002 and min(abs(p.x - 778.107), abs(p.x - 978.107)) < 0.002:
        s.delete()
        n += 1
assert n == 2, f"expected 2 vss labels on VDD metal, found {n}"

# ---- 3a. DEEMB feed cell (local frame: M1 feed line ends at the origin, structure towards +x) ------------------
W, H = 1.62, 0.81                      # line width / half width
TOWER = (-2.12, -0.50)                 # via tower x range (1.62 um)
M3_END = -7.12                         # far end of the M3 feed (pin side)
RM3 = (-4.50, -3.50)                   # rm3 marker, L = 1 um
feed = ly.create_cell("DEEMB_feed_rm3")
box = lambda x1, y1, x2, y2: db.DBox(x1, y1, x2, y2)
feed.shapes(L(34)).insert(box(TOWER[0], -H, 0.30, H))            # M1 (0.3 um overlap into the existing line)
feed.shapes(L(36)).insert(box(TOWER[0], -H, TOWER[1], H))        # M2 landing
feed.shapes(L(42)).insert(box(M3_END, -H, TOWER[1], H))          # M3 feed
for lay in (35, 38):                                             # via1 / via2: 3 x 3, 0.26 um, pitch 0.52 um
    for cx in (-1.83, -1.31, -0.79):
        for cy in (-0.52, 0.0, 0.52):
            feed.shapes(L(lay)).insert(box(cx - 0.13, cy - 0.13, cx + 0.13, cy + 0.13))
feed.shapes(L(110, 13)).insert(box(RM3[0], -H, RM3[1], H))       # rm3 marker
feed.shapes(L(110, 5)).insert(box(RM3[0], -H, RM3[1], H))        # RES_MK

DEEMB = {  # instance cell -> pin name
    "Open": "deemb_o", "Short": "deemb_s", "Load_R": "deemb_r", "Load_2R": "deemb_2r", "Load_0p5R": "deemb_0p5r"}
FEED_END_LOCAL = db.DPoint(-17.825, 0.0)  # left end of the M1 feed line in every DEEMB cell (all drawn alike)
done = {}
for inst in list(top.each_inst()):
    name = inst.cell.name
    if name not in DEEMB:
        continue
    tr = inst.dcplx_trans
    origin = tr * FEED_END_LOCAL
    # rotation of the instance carries over: local +x of the feed = local +x of the DEEMB cell
    ftr = db.DCplxTrans(1.0, tr.angle, tr.is_mirror(), origin.x, origin.y)
    # keep-out check: nothing on M1/M2/M3 (other than this structure's own M1 line) where the feed goes
    for lay, x1, x2 in ((34, TOWER[0], -0.05), (36, TOWER[0], TOWER[1]), (42, M3_END, TOWER[1])):
        fp = db.Region((ftr * box(x1, -H, x2, H)).enlarged(0.6, 0.6).to_itype(dbu))
        other = db.Region(top.begin_shapes_rec_overlapping(L(lay), fp.bbox())) & fp
        if lay == 34:
            own = db.Region(inst.cell.begin_shapes_rec(L(34))).transformed(
                db.CplxTrans(dbu).inverted() * tr * db.CplxTrans(dbu))
            other -= own
        assert other.is_empty(), f"{name}: layer {lay} not free where the feed goes: {other.bbox().to_dtype(dbu)}"
    top.insert(db.DCellInstArray(feed.cell_index(), ftr))
    # pin label on the M3 end
    pin = DEEMB[name]
    pp = ftr * db.DPoint(M3_END + 0.6, 0.0)
    top.shapes(L(42, 10)).insert(db.DText(pin, db.DTrans(pp.x, pp.y)))
    # old M1 pin labels: top level (near the feed end) and inside the DEEMB cell
    for s in find_texts(top, 34, pin):
        if (db.DPoint(s.text_dpos.x, s.text_dpos.y) - origin).length() < 8.0:
            s.delete()
    for s in find_texts(inst.cell, 34, pin):
        s.delete()
    done[name] = (round(origin.x, 3), round(origin.y, 3))
assert len(done) == 5, done

# ---- 3b. rm1 markers of DEEMB_O / DEEMB_S gone (M1 under them stays) --------------------------------------------
n = 0
for c in ly.each_cell():
    if c.name.startswith("metal_resistor"):
        n += c.shapes(L(110, 11)).size()
        c.shapes(L(110, 11)).clear()
assert n >= 1, "no rm1 marker found"

# ---- 2. RES_MK on every metal-resistor marker, in the marker's own cell ----------------------------------------
k = 0
for c in ly.each_cell():
    for d in (11, 12, 13, 14, 15):
        li = ly.find_layer(110, d)
        if li is None:
            continue
        have = db.Region(c.shapes(L(110, 5)))
        for s in c.shapes(li).each():
            r = db.Region(s.polygon)
            if not (r - have).is_empty():
                c.shapes(L(110, 5)).insert(s.polygon)
                k += 1

# ---- 4. DRC MT.2b (space to wide metaltop 0.6 um): the 2 x 2 um M5 holes of the two PG tiles that merge with the
#         wide M5 of the L1 / LSHUNT_OUT coils are filled (holes are empty on M3..M5 and all vias -> same M5 net)
for x, y in ((734.0, 14.0), (844.0, 14.0)):
    hole = db.DBox(x, y, x + 2.0, y + 2.0)
    for lay in (81, 41):
        assert (db.Region(top.begin_shapes_rec_touching(L(lay), hole.to_itype(dbu))) & db.Region(hole.to_itype(dbu))
                ).is_empty(), f"M5 hole at {x},{y} not empty on {lay}"
    top.shapes(L(81)).insert(hole)

# ---- 5. two "vss" labels on unconnected metal (Magic: disconnected nodes vss_uq19 / vss_uq31 -> extra pins
#         in netgen, "port errors"): M4 label at (578.107, 1096.027), M1 label at (55, 535). Text only, no geometry.
m = 0
for layer, x, y in ((46, 578.107, 1096.027), (34, 55.0, 535.0)):
    for s in find_texts(top, layer, "vss"):
        p = s.text_dpos
        if abs(p.x - x) < 0.002 and abs(p.y - y) < 0.002:
            s.delete()
            m += 1
assert m == 2, f"expected 2 dangling vss labels, found {m}"

ly.write(dst)
print(f"vss labels removed: 2 + {m} dangling, DEEMB feeds: {done}, rm1 markers removed: {n}, RES_MK added: {k}, "
      f"M5 holes filled: 2 -> {dst}")
