"""Re-apply the three fixes that KLayout's PCell regeneration keeps wiping.

usage: python3 lvs/repair_pcell_regression.py in.gds [out.gds]

Every time the layout is saved from a KLayout session holding stale PCell content, these
come back (observed four times now, in c729ca4, 136fd24, the lna_top2 working copy and the
Chipalooza layout):

  a) RES_MK (110/5) is dropped from the metal_resistor* cells, so Magic no longer extracts
     the coils as tm11k/rm4/rm3/rm2 and LVS fails;
  b) a stray rm1 marker (110/11) reappears -- Magic maps 110/11 to MET2RES, so it extracts
     nothing and only confuses the netlist;
  c) the MIMTM.2 via4 trim is undone, so via4 sit closer than 0.4 um to the MiM bottom
     plate edge (Magic DRC: "MiM bottom plate surrounds contact < 0.4um").

(a) and (c) are taken from lvs/apply_lvs_layout_fixes.py steps 2 and 6. (c) is recomputed
geometrically rather than copied, because later edits may legitimately add vias.
"""
import sys
import klayout.db as db

src = sys.argv[1]
dst = sys.argv[2] if len(sys.argv) > 2 else src
ly = db.Layout()
ly.read(src)
top = ly.cell("lna_core_parts")
dbu = ly.dbu
L = lambda a, d=0: ly.layer(a, d)

# ---- a) RES_MK on every metal-resistor marker, in the marker's own cell -------------------
k = 0
for c in ly.each_cell():
    for d in (11, 12, 13, 14, 15):
        li = ly.find_layer(110, d)
        if li is None:
            continue
        have = db.Region(c.shapes(L(110, 5)))
        for s in c.shapes(li).each():
            if not (db.Region(s.polygon) - have).is_empty():
                c.shapes(L(110, 5)).insert(s.polygon)
                k += 1
print(f"a) RES_MK (110/5) inserted on {k} metal-resistor markers")

# ---- b) stray rm1 marker (110/11) --------------------------------------------------------
n11 = 0
li = ly.find_layer(110, 11)
if li is not None:
    for c in ly.each_cell():
        for s in list(c.shapes(li).each()):
            s.delete(); n11 += 1
print(f"b) rm1 markers (110/11) removed: {n11}")

# ---- c) MIMTM.2: via4 closer than 0.42 um to the MiM bottom-plate edge --------------------
dbu_i = lambda v: int(round(v / dbu))
M4 = db.Region(top.begin_shapes_rec(L(46))).merged()
bot = M4.interacting(db.Region(top.begin_shapes_rec(L(75))))       # M4 plates touching the MiM top plate
inner = bot.sized(-dbu_i(0.42))
bad, ok = {}, {}
it = top.begin_shapes_rec(L(41))
while not it.at_end():
    b = it.shape().bbox()
    rb = db.Region(b.transformed(it.trans()))
    is_bad = not (rb & bot).is_empty() and not (rb - inner).is_empty()
    (bad if is_bad else ok).setdefault(it.cell_index(), set()).add((b.left, b.bottom, b.right, b.top))
    it.next()
nvia = 0
for ci, boxes in bad.items():
    assert not (boxes & ok.get(ci, set())), f"{ly.cell(ci).name}: via4 bad in one instance, ok in another"
    assert len(ok.get(ci, set())) >= 4, f"{ly.cell(ci).name}: fewer than 4 via4 would remain"
    sh = ly.cell(ci).shapes(L(41))
    for s in list(sh.each()):
        bb = s.bbox()
        if (bb.left, bb.bottom, bb.right, bb.top) in boxes:
            s.delete(); nvia += 1
print(f"c) via4 removed for MIMTM.2: {nvia} shapes in {len(bad)} cells")

ly.write(dst)
print("wrote", dst)
