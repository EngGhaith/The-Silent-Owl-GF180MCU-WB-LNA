"""usage: python3 lvs/make_dummy_fill.py in.gds out.gds

Dummy COMP (22/4) + dummy poly2 (30/4) fill for lna_core_parts. No metal fill.

Main area: conformal fill -- the region where dummy COMP is legal, cut by a grid of
STREET-wide streets at PITCH, so islands follow the available space.

De-embedding structures (Open / Short / Load_R / Load_2R / Load_0p5R) are special:
they only subtract correctly if all five sit in the same environment, so
  * the main fill is kept out of each structure's bbox plus a DEEMB_MARGIN ring, and
  * one single fill pattern is computed in the structures' own (normalised) frame from
    the INTERSECTION of what is legal in all five, then written into each of the five
    cells -- so every structure carries a geometrically identical pattern.
"""
import sys
import klayout.db as kdb

src, dst = sys.argv[1], sys.argv[2]
# Magic codes two poly-fill rules the KLayout deck omits:
#   DPF.1  poly fill width   >= 5.6 um
#   DPF.2a poly fill spacing >= 2.4 um
# poly = COMP grown by GROW per side, so COMP street must be >= 2.4 + 2*GROW,
# and poly-capable COMP islands must be at least 5.6 - 2*GROW wide.
PITCH, STREET, GROW, MINW = 30.0, 2.8, 0.1, 1.2
MINW_POLY = 5.6                          # COMP width; poly = +2*GROW on top
DEEMB = ("Open", "Short", "Load_R", "Load_2R", "Load_0p5R")
DEEMB_MARGIN = 5.0

ly = kdb.Layout(); ly.read(src)
top = ly.cell("lna_core_parts")
dbu = ly.dbu
U = lambda x: int(round(x / dbu))

CKO = [("ndmy", 3.5), ("comp", 3.5), ("poly2", 1.5), ("nwell", 1.3), ("dnwell", 4.0),
       ("lvpwell", 1.3), ("dualgate", 1.3), ("res_mk", 3.5), ("ind_mk", 3.0)]
PKO = [("ndmy", 29.7), ("comp", 3.2), ("poly2", 5.0), ("nwell", 1.0), ("dnwell", 2.0),
       ("lvpwell", 1.0), ("dualgate", 1.0), ("res_mk", 19.7), ("ind_mk", 3.0),
       ("pad", 6.7), ("mtpmark", 3.0), ("pmndmy", 8.0)]
LAY = {"comp": (22, 0), "poly2": (30, 0), "nwell": (21, 0), "dnwell": (12, 0),
       "lvpwell": (204, 0), "dualgate": (55, 0), "res_mk": (110, 5), "ind_mk": (151, 5),
       "ndmy": (111, 5), "pmndmy": (152, 5), "pad": (37, 0), "mtpmark": (122, 5)}


def whole(n):
    i = ly.find_layer(*LAY[n])
    return kdb.Region() if i is None else kdb.Region(top.begin_shapes_rec(i)).merged()


def streets_of(box, pitch, street):
    s = kdb.Region()
    y = (int(box.bottom * dbu / pitch) - 1) * pitch
    while y < box.top * dbu + pitch:
        s.insert(kdb.Box(box.left, U(y), box.right, U(y + street))); y += pitch
    x = (int(box.left * dbu / pitch) - 1) * pitch
    while x < box.right * dbu + pitch:
        s.insert(kdb.Box(U(x), box.bottom, U(x + street), box.top)); x += pitch
    return s.merged()


clean = lambda r: r.sized(U(-MINW / 2)).sized(U(MINW / 2)).merged()
gap = U(STREET / 2)

# ---------------------------------------------------------------- de-embedding structures
insts = [i for i in top.each_inst() if i.cell.name in DEEMB]
print("de-embedding structures found: %d (%s)" % (len(insts), ", ".join(i.cell.name for i in insts)))
guard = kdb.Region()
for i in insts:
    guard.insert(i.bbox().enlarged(U(DEEMB_MARGIN), U(DEEMB_MARGIN)))
guard.merge()

# DCF.1a demands that any >=20um gap between COMP be filled; the deliberate DEEMB
# exclusion is exactly such a gap. NDMY (111/5) is in that rule's own keepout list, so
# marking each structure legitimises its clear ring. Each is well under DE.3's 15000 um2
# and they are >20um apart (DE.4).
ndmy_layer = ly.layer(111, 5)
for p_ in guard.each():
    top.shapes(ndmy_layer).insert(p_)
print("NDMY markers added over DEEMB: %d, largest %.0f um2 (DE.3 limit 15000)"
      % (guard.count(), max((p_.bbox().width() * p_.bbox().height() * dbu * dbu
                             for p_ in guard.each()), default=0.0)))

if not insts:
    # main_Chipalooza has no de-embedding structures, so there is no common
    # pattern to compute and no exclusion ring to honour.
    print('no de-embedding structures: skipping the common-pattern step')
else:
    # normalised frame: each structure's own bbox centred on the origin
    norm_box = None
    ko_c = kdb.Region()
    ko_p = kdb.Region()
    for i in insts:
        cb = i.cell.bbox()
        shift = kdb.Trans(kdb.Vector(-cb.center().x, -cb.center().y))
        nb = cb.transformed(shift)
        norm_box = nb if norm_box is None else (norm_box & nb)
        inv = i.cplx_trans.inverted()   # ICplxTrans, DBU units
        for name, dist in CKO:
            li = ly.find_layer(*LAY[name])
            if li is None:
                continue
            r = kdb.Region(top.begin_shapes_rec_touching(li, i.bbox())).transformed_icplx(inv).transformed(shift)
            if not r.is_empty():
                ko_c += r.sized(U(dist))
        for name, dist in PKO:
            li = ly.find_layer(*LAY[name])
            if li is None:
                continue
            r = kdb.Region(top.begin_shapes_rec_touching(li, i.bbox())).transformed_icplx(inv).transformed(shift)
            if not r.is_empty():
                ko_p += r.sized(U(dist))
    ko_c.merge(); ko_p.merge()

    nbr = kdb.Region(norm_box)
    free_c_d = nbr - ko_c
    free_p_d = nbr - ko_p
    st = streets_of(norm_box, PITCH, STREET)
    gap = U(STREET / 2)
    pz = free_p_d.sized(U(-GROW))
    zp = clean((free_c_d & pz.sized(-gap)) - st)
    zc = clean((free_c_d - pz.sized(gap)) - st)
    d_comp = (zp + zc).merged()
    d_poly = zp.sized(U(GROW)).merged()
    print("DEEMB common pattern: %d COMP islands (%.0f um2), %d poly islands (%.0f um2)"
          % (d_comp.count(), d_comp.area() * dbu * dbu, d_poly.count(), d_poly.area() * dbu * dbu))

    placed_c = placed_p = 0
    for i in insts:
        cb = i.cell.bbox()
        back = kdb.Trans(kdb.Vector(cb.center().x, cb.center().y))
        cell = i.cell
        for p in d_comp.transformed(back).each():
            cell.shapes(ly.layer(22, 4)).insert(p); placed_c += 1
        for p in d_poly.transformed(back).each():
            cell.shapes(ly.layer(30, 4)).insert(p); placed_p += 1
    print("written into the 5 cells: %d COMP, %d poly shapes" % (placed_c, placed_p))

# ---------------------------------------------------------------- main area
die = kdb.Region(top.bbox())
free_c = die.sized(U(-10.0)) - guard
for n, d in CKO:
    r = whole(n)
    if not r.is_empty():
        free_c -= r.sized(U(d))
free_p = die.sized(U(-10.0)) - guard
for n, d in PKO:
    r = whole(n)
    if not r.is_empty():
        free_p -= r.sized(U(d))

st = streets_of(top.bbox(), PITCH, STREET)
pz = free_p.sized(U(-GROW))
zp = clean((free_c & pz.sized(-gap)) - st)
zc = clean((free_c - pz.sized(gap)) - st)
comp_fill = (zp + zc).merged()
# Magic DPF.1 wants poly fill >= 5.6 um wide. Keep every COMP island for density and
# put poly only on those wide enough to carry a legal poly shape.
# A shape can be wide somewhere and still have a narrow rim, so test the actual poly
# shape for sub-minimum width ANYWHERE: opening(g) must give back essentially g.
half = U(MINW_POLY / 2)
wide = kdb.Region()
narrow = 0
for q in zp.each():
    g = kdb.Region(q).sized(U(GROW))
    opened = g.sized(-half).sized(half)
    if opened.is_empty() or (g - opened).area() > 0:
        narrow += 1
    else:
        wide.insert(q)
poly_fill = wide.sized(U(GROW)).merged()
print("poly skipped on %d islands too narrow for DPF.1 (<%.1f um)" % (narrow, MINW_POLY))
print("main fill: %d COMP islands (poly-capable %d, comp-only %d)"
      % (comp_fill.count(), zp.count(), zc.count()))

fill = ly.create_cell("FILL_COMP_POLY")
for p in comp_fill.each():
    fill.shapes(ly.layer(22, 4)).insert(p)
for p in poly_fill.each():
    fill.shapes(ly.layer(30, 4)).insert(p)
top.insert(kdb.CellInstArray(fill.cell_index(), kdb.Trans()))

ly.write(dst)
rl = kdb.Layout(); rl.read(dst); rt = rl.cell("lna_core_parts"); rd = rl.dbu
A = kdb.Region(rt.bbox()).area() * rd * rd
cd = kdb.Region(rt.begin_shapes_rec(rl.find_layer(22, 0))).merged().area() + \
     kdb.Region(rt.begin_shapes_rec(rl.find_layer(22, 4))).merged().area()
pd = kdb.Region(rt.begin_shapes_rec(rl.find_layer(30, 0))).merged().area() + \
     kdb.Region(rt.begin_shapes_rec(rl.find_layer(30, 4))).merged().area()
print("\n  COMP  + dummy COMP : %5.2f %%   (DCF.1b >= 25 %%, DCF.1d <= 70 %%)" % (100 * cd * rd * rd / A))
print("  poly2 + dummy poly2: %5.2f %%   (PL.8  >= 14 %%)" % (100 * pd * rd * rd / A))
print("wrote", dst)
