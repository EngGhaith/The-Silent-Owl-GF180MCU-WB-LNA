#!/usr/bin/env python3
"""
klayout/em/top_row_em.gds: EM model of the top coil row of lna_core_parts (LD4, LD2, LSHUNT_OUT + their leads)
for the Palace flow (palace_top_row.py).

  klayout -b -r make_top_row_em_gds.py

Geometry (block coordinates of make_lna_core_layouts.py, written flat):
  coils  LD4 (lna_core_cg), LD2 (lna_core_cs), LSHUNT_OUT (lna_core_output_match), Metal1 .. Metal5, via arrays as solid blocks
  leads  top-level Metal5 of the blocks inside WIN (vm2 jog + column end, LD4 / LD2 vdd leads + vdd column,
         vx column end, rf_out tab segment / lane / jog / pin, LSHUNT_OUT vss lane); C1 / CS / CG are left out
  ports  via ports (zero-height lines, layers 201..205) at the cut lead ends, SUBGND (210) to Metal5:
           1 vm2 (y = 455)  2 vx (y = 430)  3 vdd column (north)  4 rf_out pin (north)  5 LSHUNT_OUT vss lane end
  ground SUBGND frame (210) along the macro edges where the vss ring is + straps to ports 1 / 2 / patch at 5
Not modelled: supply tiles, vss / vdd ring metal, CG / CS devices, C1.
"""
import os
import pya

HERE = os.path.dirname(os.path.abspath(__file__))
KL = os.path.dirname(HERE)
OUT = os.path.join(HERE, "top_row_em.gds")
# coils: stacked spirals on Metal1 .. Metal5 (the crossings change layers, so every metal layer is needed); the via
# arrays are written as solid blocks (merged array & both metals) to keep gmsh able to mesh them
METALS = [(34, 0), (36, 0), (42, 0), (46, 0), (81, 0)]  # M1 .. M5
VIAS = [(35, 0), (38, 0), (40, 0), (41, 0)]  # V1 .. V4 (between METALS[i] and METALS[i + 1])
# block -> (window of its top-level Metal5 leads, coil cell)
BLOCKS = {"lna_core_cg": ((0, 455, 400, 839), "lna_core_cg__LD4"),
          "lna_core_cs": ((360, 430, 395, 839), "lna_core_cs__LD2"),
          "lna_core_output_match": ((450, 430, 1104, 839), "lna_core_output_match__LSHUNT_OUT")}
PORTS = {201: (202, 455, 206), 202: (380, 430, 384), 203: (362, 839, 370), 204: (559.5, 839, 569.5),
         205: (635, 831, 645)}  # layer: (x0, y, x1) zero-height line at the lead end
SUBGND = [(0, 380, 1104, 392), (0, 380, 12, 851), (0, 836, 1104, 851), (1092, 380, 1104, 851),
          (198, 392, 210, 458), (376, 392, 388, 433), (630, 826, 650, 836)]

ly = pya.Layout()
ly.dbu = 0.001
top = ly.create_cell("top_row_em")
d = lambda b: pya.DBox(*b)
for blk, (win, coil) in BLOCKS.items():
    src = pya.Layout()
    src.read(os.path.join(KL, blk + ".gds"))
    t = src.top_cell()
    m5 = pya.Region(t.shapes(src.layer(81, 0))) & pya.Region(d(win).to_itype(src.dbu))
    top.shapes(ly.layer(81, 0)).insert(m5)
    inst = [i for i in t.each_inst() if i.cell.name == coil][0]
    coil_r = lambda l: pya.Region(inst.cell.begin_shapes_rec(src.layer(*l))).transformed(inst.cplx_trans).merged()
    met = [coil_r(l) for l in METALS]
    for l, r in zip(METALS, met):
        top.shapes(ly.layer(*l)).insert(r)
    grow = int(1.0 / src.dbu)
    for i, l in enumerate(VIAS):
        blk = coil_r(l).sized(grow).merged().sized(-grow) & met[i] & met[i + 1]
        top.shapes(ly.layer(*l)).insert(blk)
for ln, (x0, y, x1) in PORTS.items():
    top.shapes(ly.layer(ln, 0)).insert(pya.DBox(x0, y, x1, y))
for b in SUBGND:
    top.shapes(ly.layer(210, 0)).insert(d(b))
ly.write(OUT)
print("wrote", OUT, top.dbbox())
