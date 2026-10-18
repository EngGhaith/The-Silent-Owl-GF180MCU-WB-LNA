#!/usr/bin/env python3
"""
Layouts of the four lna_core sub-blocks, drawn after layout/floorplan/lna_core_floorplan.svg:

  lna_core_input_match.gds   xschem/lna_core_input_match.sch   LEQ1 spiral, C1 (series)
  lna_core_cg.gds            xschem/lna_core_cg.sch            M1 (+M3 dummies), R3, C3 (4x), L2 + LD1 spirals, C2, R4
  lna_core_cs.gds            xschem/lna_core_cs.sch            M3 (+M5 dummies), M2 (+M4D dummies), LD1 spiral
  lna_core_output_match.gds  xschem/lna_core_output_match.sch  C1 (series), LSHUNT_OUT1 spiral

Run:  klayout -b -r make_lna_core_layouts.py          (all cells)
      klayout -b -r make_lna_core_layouts.py -rd cells=cg,cs

All four cells use the floorplan coordinate system (origin = lower-left corner of the lna_core macro, 747 x MACRO_H um),
so the final assembly is just the four cells placed at (0, 0) + the vss ring / supply tiles of the floorplan.
Floorplan: layout/floorplan/lna_core_floorplan (747 x 554 um, rf_in west, rf_out north); the macro is extended to the
north by one spiral keep-out box for LSHUNT_OUT1 (output shunt, not in that floorplan), east of the rf_out lead.

Devices are gf180mcu PCells (flattened), spirals are Metal5 (w 10 / s 3 um, size from the modified Wheeler formula
as in the floorplan) with a Metal4 + Metal3 underpass. Ideal res.sym elements (RLEQ1, RLD1, Rs1, RLSHOUT1, RS_EQ1) are
the inductor loss / parasitic models of the simulation -> no layout; RS_EQ1 (0.05 ohm) means M3 source = vss.
Ideal capa.sym capacitors (C1 of the input / output match) are drawn as MIM caps of the same value.

Device type and size come from the schematics (M1, M2 + dummies: nfet_05v0 L=0.6u, 5V device with V5_XTOR marker).
"""
import json
import math
import os
import re
import sys

import pya

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import lna_lib as lib  # noqa: E402
from lna_lib import Cell, g, tbox  # noqa: E402

XSCHEM = os.path.join(HERE, "..", "xschem")

# ---------------------------------------------------------------- schematic values (read only)


def sch_params(sch):
    """{name: (symbol, {param: value})} of every instance of xschem/<sch>.sch"""
    out = {}
    txt = open(os.path.join(XSCHEM, sch + ".sch")).read()
    for sym, body in re.findall(r"^C \{([^}]*)\}[^{]*\{(.*?)\}", txt, re.S | re.M):
        p = dict(re.findall(r"(\w+)=(\S+)", body))
        if "name" in p:
            out[p["name"]] = (os.path.basename(sym)[:-4], p)
    return out


def um(v):
    return float(v[:-1]) if v.endswith("u") else float(v) * 1e6


def um_grid(v):
    """MIM W/L from the schematic rounded to 10 nm: values like 34.7078u are off the 5 nm grid, and the PDK cap_mim
    PCell (gdsfactory) rounds the plate to 10 nm anyway (58.215 -> 58.22); dC < 0.03 %"""
    return round(um(v), 2)


def nh(v):
    return float(v[:-1]) * 1e-9 if v.endswith("n") else float(v)


def wheeler_dout(L, n, w=10.0, s=3.0):
    """outer diameter (um) of a square spiral with inductance L (H), modified Wheeler K1=2.34, K2=2.75"""
    def ind(dout):
        din = dout - 2 * n * w - 2 * (n - 1) * s
        davg, rho = (dout + din) / 2, (dout - din) / (dout + din)
        return 2.34 * 4e-7 * math.pi * n * n * davg * 1e-6 / (1 + 2.75 * rho)
    lo, hi = 2 * n * w + 2 * (n - 1) * s + 1, 2000.0
    for _ in range(100):
        mid = (lo + hi) / 2
        lo, hi = (mid, hi) if ind(mid) < L else (lo, mid)
    return lo


def cap_side(c_pf, w=None):
    """MIM plate (w, l) in um (10 nm grid) for an ideal capacitor value; square unless w is given"""
    if w is None:
        lo, hi = 1.0, 100.0
        for _ in range(60):
            mid = (lo + hi) / 2
            lo, hi = (mid, hi) if lib.c_mim_pf(mid, mid) < c_pf else (lo, mid)
        return round(lo, 2), round(lo, 2)
    l = (c_pf * 1000 - 0.2383 * 2 * w) / (1.99 * w + 0.2383 * 2)
    return w, round(l, 2)


def pf(v):
    return float(v[:-1]) if v.endswith("p") else float(v) * 1e12


# floorplan (layout/floorplan/make_lna_core_floorplan.py): spiral turns + keep-out boxes, macro size
SP_W, SP_S, SP_KO = 10.0, 3.0, 25.0
SP_TURNS = {("lna_core_input_match", "LEQ1"): 3.25, ("lna_core_cg", "L2"): 4.25, ("lna_core_cg", "LD1"): 6.25,
            ("lna_core_cs", "LD1"): 5, ("lna_core_output_match", "LSHUNT_OUT1"): 4.25}
KO_LEQ = 170.87 + 2 * SP_KO  # floorplan LEQ box (2.85 nH spiral); LEQ1 (1.33 nH) is centred in it
H_FP = 554  # floorplan height; the macro grows north by the LSHUNT_OUT1 box
MACRO_W, RING = 747, 12


def spiral_dout(sch, name):
    return wheeler_dout(nh(sch_params(sch)[name][1]["value"]), SP_TURNS[(sch, name)])


# LSHUNT_OUT1: box on top of the floorplan (lower edge = top of the LD2 box), east of the rf_out lead
D_LSH = wheeler_dout(2.5e-9, 4.25)
LSH_Y0 = 541.65  # top of the LD2 keep-out box
LSH_C = (640.0, g(LSH_Y0 + SP_KO + D_LSH / 2))
MACRO_H = int(math.ceil(LSH_C[1] + D_LSH / 2 + SP_KO + RING))
RFO_X = 415.0  # rf_out_pad lead column (centre)
RFO_Y = (g(LSH_C[1] - D_LSH / 2), g(LSH_C[1] - D_LSH / 2 + SP_W))  # LSHUNT_OUT1 lead (Metal5) to the rf_out column


def vdd_column(top, x0, x1, y0, y1):
    """Metal5 vdd lead x0..x1 from y0 to y1, crossing under the rf_out lead (RFO_Y) on a Metal3 + Metal4 bridge"""
    b0, b1 = g(RFO_Y[0] - 10), g(RFO_Y[1] + 10)
    if not (y0 < b0 and y1 > b1):
        top.box("m5", x0, y0, x1, y1)
        return
    top.box("m5", x0, y0, x1, b0 + 6)
    top.stack(x0, b0, x1, b0 + 6, 3, 5)
    top.box("m3", x0, b0, x1, b1)
    top.box("m4", x0, b0, x1, b1)
    top.stack(x0, b1 - 6, x1, b1, 3, 5)
    top.box("m5", x0, b1 - 6, x1, y1)


INFO = {}  # per cell: notes for the json report


# ================================================================ lna_core_input_match
def build_input_match(ly):
    """
    rf_in_pad (Metal5, west edge, y = 295) -> C1 bottom plate; C1 top plate -> input_cg (east edge, x = 82)
    LEQ1 outer end -> rf_in_pad, inner end (underpass) -> vss (Metal5 + Metal3 into the south ring band)
    """
    P = "lna_core_input_match"
    sch = sch_params(P)
    top = Cell(ly, P)
    # --- LEQ1: centred in the floorplan LEQ keep-out box, lower-left (12, 12)
    d = spiral_dout(P, "LEQ1")
    cx = cy = g(RING + KO_LEQ / 2)
    a = d / 2 - SP_W / 2
    lead_x = 20.0  # rf_in lead column (centre)
    sp, st = lib.spiral(ly, f"{P}__LEQ1", d, SP_TURNS[(P, "LEQ1")], under="S", lead=g(cx - a - lead_x))
    tr = top.place(sp, cx, cy)
    t_out, t_in = tbox(tr, st["outer"]), tbox(tr, st["inner"])
    # --- C1 (ideal 1.25 pF -> square MIM)
    c_pf = pf(sch["C1"][1]["value"])
    w1, l1 = cap_side(c_pf)
    rf_y = 295.0
    px = 36.4
    c1, t1 = lib.mim_tile(ly, f"{P}__C1", w1, l1)
    tr1 = top.place(c1, px, g(rf_y - l1 / 2))
    b1, p1 = tbox(tr1, t1["bot"]), tbox(tr1, t1["top"])
    # --- rf_in_pad: west edge -> C1 bottom-plate strap; LEQ1 lead column joins it
    top.box("m5", 0, rf_y - 5, b1[2], rf_y + 5)
    top.box("m5", lead_x - 5, t_out[1], lead_x + 5, rf_y + 5)
    top.label(5, "rf_in_pad", 1, rf_y)
    # --- input_cg: C1 top plate -> east edge
    x_e = 82.0
    top.box("m5", p1[2] - 1, rf_y - 5, x_e, rf_y + 5)
    top.label(5, "input_cg", x_e - 1, rf_y)
    # --- vss: LEQ1 inner pad -> south ring band
    top.box("m5", t_in[0], 2, t_in[2], t_in[3])
    top.stack(t_in[0], 2, t_in[2], 10, 3, 5)
    top.label(5, "vss", (t_in[0] + t_in[2]) / 2, 3)
    INFO[P] = {"LEQ1": {"dout_um": round(d, 2), "turns": SP_TURNS[(P, "LEQ1")], "centre": [cx, cy]},
               "C1": {"W": w1, "L": l1, "pF": round(lib.c_mim_pf(w1, l1), 3), "schematic_pF": c_pf},
               "pins": {"rf_in_pad": "Metal5 west edge y=295", "input_cg": f"Metal5 east edge x={x_e} y=295",
                        "vss": "Metal5 south edge"}}
    return top


# ---------------------------------------------------------------- interfaces between the cells (floorplan coords)
CS_GATE_PAD = (268.0, 399.5, 274.0, 405.5)  # input_cg of lna_core_cs = output_cs of lna_core_cg (Metal3..5 stack)
VX_X = (377.0, 387.0)  # output_match (vx) Metal5 column of lna_core_cs, east of the cascode
C_OUT_PLATE = (391.0, 466.0)  # lower-left of the output C1 top plate (rotated: x extent = L, y extent = W)
C_OUT_L = 54.0  # x extent of the output C1 plate (fits between the vx column and the LD1 vdd lead of lna_core_cg)
OM_IN_X = 380.0  # west end of the output_cs lead of lna_core_output_match


def c_out_wl():
    """(W, L) of the output C1 (ideal capa) as a MIM with fixed L"""
    l_, w_ = cap_side(pf(sch_params("lna_core_output_match")["C1"][1]["value"]), C_OUT_L)
    return w_, l_


def om_lead_y():
    """centre of the output_cs lead (= vx column top of lna_core_cs)"""
    w_, _ = c_out_wl()
    return g(C_OUT_PLATE[1] + w_ / 2)


# ================================================================ lna_core_output_match
def build_output_match(ly):
    """
    C1 (series, ideal 7 pF -> MIM): top plate = output_cs (lead to the west, x = 380), bottom plate (tab rotated
    to the north) = rf_out_pad (Metal5 lead to the north edge, x = 415)
    LSHUNT_OUT1: spiral in the north extension, outer end (lead west at RFO_Y) -> rf_out lead, inner end
    (underpass east) -> vss (east ring band)
    """
    P = "lna_core_output_match"
    sch = sch_params(P)
    top = Cell(ly, P)
    w, l = c_out_wl()
    c, t = lib.mim_tile(ly, f"{P}__C1", w, l)
    x0, y0 = C_OUT_PLATE
    tr = top.place(c, x0, y0 + w, rot=270)  # tab (bottom plate) west -> north
    pt, bt = tbox(tr, t["top"]), tbox(tr, t["bot"])
    yc = g((pt[1] + pt[3]) / 2)
    assert abs(yc - om_lead_y()) < 1e-6
    top.box("m5", OM_IN_X, yc - 5, pt[0] + 1, yc + 5)
    top.label(5, "output_cs", OM_IN_X + 1, yc)
    xr = RFO_X
    top.box("m5", bt[0], bt[1], bt[2], bt[3])
    top.box("m5", xr - 5, bt[1], xr + 5, MACRO_H)
    top.label(5, "rf_out_pad", xr, MACRO_H - 1)
    # --- LSHUNT_OUT1 (mirrored: winding starts at the lower-left corner, lead west to the rf_out column)
    d = spiral_dout(P, "LSHUNT_OUT1")
    assert abs(d - D_LSH) < 1e-6
    cx, cy = LSH_C
    a = d / 2 - SP_W / 2
    sp, st = lib.spiral(ly, f"{P}__LSHUNT_OUT1", d, SP_TURNS[(P, "LSHUNT_OUT1")], under="E", lead=g(cx - a - xr))
    trs = top.place(sp, cx, cy, mirror=True)
    t_out, t_in = tbox(trs, st["outer"]), tbox(trs, st["inner"])
    assert abs(t_out[1] - RFO_Y[0]) < 1e-6 and abs(t_out[3] - RFO_Y[1]) < 1e-6, (t_out, RFO_Y)
    top.box("m5", t_in[0], t_in[1], MACRO_W - 2, t_in[3])
    top.label(5, "vss", MACRO_W - 3, (t_in[1] + t_in[3]) / 2)
    INFO[P] = {"C1": {"W": w, "L": l, "pF": round(lib.c_mim_pf(w, l), 3),
                      "schematic_pF": pf(sch["C1"][1]["value"])}, "top_plate": list(pt), "output_cs_lead_y": yc,
               "rf_out_x": [xr - 5, xr + 5], "LSHUNT_OUT1": {"dout_um": round(d, 2), "centre": [cx, cy]},
               "lsh_vss_lead_y": [t_in[1], t_in[3]], "macro": [MACRO_W, MACRO_H],
               "pins": {"output_cs": f"Metal5 x={OM_IN_X} y={yc}", "rf_out_pad": f"Metal5 north edge x={xr}",
                        "vss": "Metal5 east edge"}}
    return top


# ================================================================ lna_core_cs
def fet_params(sch, name, dummy):
    """(wf, L, active fingers) of a FET instance + dummy fingers per row end of its dummy instance"""
    s, p = sch[name]
    nf, mm = int(p["nf"]), int(p["m"])
    sd, pd = sch[dummy]
    return um(p["W"]) / nf, um(p["L"]), nf * mm, int(pd["nf"]) * int(pd["m"]) // 2, s


def volt_of(sym):
    return {"nfet_03v3": "3.3V", "nfet_05v0": "5V", "nfet_06v0": "6V"}[sym]


def build_cs(ly):
    """
    cascode stack in one P+ guard ring: M3 row (nfet_03v3, bottom, M5 dummies) and M2 row (nfet_05v0, on top,
    M4D dummies) share the vm1 bus (M3 drain = M2 source). M3 source bus -> guard ring (vss, RS_EQ1 = 0).
      input_cg  : M3 gate strap (Metal3) -> west to CS_GATE_PAD (Metal3..5 stack, met by C2 / R4 of lna_core_cg)
      vbias_cas : M2 gate strap (Metal3) -> west, Metal3 column to the north edge
      output_match (vx): M2 drain bus -> east, Metal5 column VX_X -> C1 lead (lna_core_output_match) and on a
                  Metal5 trace to the LD1 underpass pad
      LD1       : spiral, floorplan LD2 keep-out box; outer end (top-left) -> vdd (north edge, under the rf_out
                  lead on a Metal3/4 bridge), inner end -> vx
    """
    P = "lna_core_cs"
    sch = sch_params(P)
    top = Cell(ly, P)
    wf1, l1, na1, nd1, s1 = fet_params(sch, "M3", "M5")
    wf4, l4, na4, nd4, s4 = fet_params(sch, "M2", "M4D")
    i_ma = 13.2  # drain current (ngspice OP, typ) -> bus width at 1 mA/um on Metal2 + Metal3
    wb = math.ceil(i_ma / 2 * 2) / 2
    m1t, m1 = lib.fet_tile(ly, f"{P}__M1", volt_of(s1), wf1, l1, na1, nd1, ws=wb, wd=wb)
    m4t, m4 = lib.fet_tile(ly, f"{P}__M4", volt_of(s4), wf4, l4, na4, nd4, ws=wb, wd=wb, draw_s=False)
    x_m1, y_m1 = 285.0, 400.0
    tr1 = top.place(m1t, x_m1 - m1["row"][0], y_m1)
    T1 = {k: tbox(tr1, v) for k, v in m1.items() if k != "nf"}
    xc = (T1["row"][0] + T1["row"][2]) / 2
    tr4 = top.place(m4t, xc - (m4["row"][0] + m4["row"][2]) / 2, T1["D"][1] - m4["S"][1])
    T4 = {k: tbox(tr4, v) for k, v in m4.items() if k != "nf"}
    assert abs(T4["S"][1] - T1["D"][1]) < 1e-6 and abs(T4["S"][3] - T1["D"][3]) < 1e-6
    # guard ring
    gw, gm = 0.8, 1.5
    R = (g(T1["S"][0] - gm - gw), g(T1["S"][1] - gm - gw), g(T1["S"][2] + gm + gw), g(T4["D"][3] + gm + gw))
    lib.guard_ring(top, *R, w=gw)
    ri = (R[0] + gw, R[1] + gw, R[2] - gw, R[3] - gw)  # inner edge
    top.box("m2", T1["S"][0], R[1], T1["S"][2], T1["S"][1])  # M1 source bus -> ring (vss)
    for T in (T1, T4):  # dummy gates -> ring (Metal1)
        top.box("m1", ri[0] - 0.1, T["DGL"][1], T["DGL"][2], T["DGL"][3])
        top.box("m1", T["DGR"][0], T["DGR"][1], ri[2] + 0.1, T["DGR"][3])
    top.label(1, "vss", R[0] + gw / 2, (R[1] + R[3]) / 2)
    # input_cg: M1 gate strap -> CS_GATE_PAD
    gp = CS_GATE_PAD
    top.box("m3", gp[0], T1["G"][1], T1["G"][0], T1["G"][3])
    top.stack(*gp, 3, 5)
    top.label(5, "input_cg", (gp[0] + gp[2]) / 2, (gp[1] + gp[3]) / 2)
    # vbias_cas: M4 gate strap -> west, Metal3 column north
    xv = g(R[0] - 3.0)
    top.box("m3", xv - 1, T4["G"][1], T4["G"][0], T4["G"][3])
    top.box("m3", xv - 1, T4["G"][1], xv + 1, MACRO_H)
    top.label(3, "vbias_cas", xv, MACRO_H - 1)
    # vx: M4 drain bus -> east, Metal5 column
    yd0, yd1 = T4["D"][1], T4["D"][3]
    top.box("m3", T4["D"][2], yd0, VX_X[1], yd1)
    top.box("m2", T4["D"][2], yd0, ri[2] - 0.6, yd1)
    top.stack(VX_X[0], yd0, VX_X[1], yd1, 3, 5)
    # LD1: floorplan LD2 box lower-left = (LD4 box right - KO(LD2), top of LD4 box)
    d2 = spiral_dout(P, "LD1")
    d4 = spiral_dout("lna_core_cg", "LD1")  # LD1 of lna_core_cg (floorplan stacking only)
    x_ld4 = RING + KO_LEQ + (spiral_dout("lna_core_cg", "L2") + 2 * SP_KO)
    ko4, ko2 = d4 + 2 * SP_KO, d2 + 2 * SP_KO
    cx, cy = g(x_ld4 + ko4 - ko2 / 2), g(RING + ko4 + ko2 / 2)
    sp, st = lib.spiral(ly, f"{P}__LD1", d2, SP_TURNS[(P, "LD1")], under="W")
    trs = top.place(sp, cx, cy)
    t_out, t_in = tbox(trs, st["outer"]), tbox(trs, st["inner"])
    assert t_out[2] + SP_KO <= LSH_C[0] - D_LSH / 2, "LD1 vdd lead too close to LSHUNT_OUT1"
    vdd_column(top, t_out[0], t_out[2], t_out[1], MACRO_H)
    top.label(5, "vdd", (t_out[0] + t_out[2]) / 2, MACRO_H - 1)
    yx = (t_in[1] + t_in[3]) / 2
    top.box("m5", VX_X[0], yd0, VX_X[1], om_lead_y() + 5)  # up to the C1 lead of lna_core_output_match
    top.box("m5", VX_X[0], t_in[1], t_in[2], t_in[3])  # to the LD2 inner terminal
    top.label(5, "output_match", (VX_X[0] + VX_X[1]) / 2, yx)
    INFO[P] = {"M3": {"rows": 1, "fingers": m1["nf"], "wf": wf1, "L": l1, "sym": s1},
               "M2": {"rows": 1, "fingers": m4["nf"], "wf": wf4, "L": l4, "sym": s4},
               "bus_w_um": wb, "guard_ring": R, "LD1": {"dout_um": round(d2, 2), "centre": [cx, cy]},
               "ld2_vdd_lead": [t_out[0], t_out[1], t_out[2], MACRO_H], "vx_column_x": list(VX_X),
               "pins": {"input_cg": list(gp), "vbias_cas": f"Metal3 north edge x={xv}", "vdd": "Metal5 north edge",
                        "output_match": f"Metal5 column x={VX_X}", "vss": "guard ring"}}
    return top


# ================================================================ lna_core_cg
def resistor(ly, name, sch, inst):
    s, p = sch[inst]
    return lib.pcell(ly, name, "ppolyf_u_high_Rs_resistor",
                     {"volt": "5/6V" if "6p0" in s else "3.3V", "w_res": um(p["W"]), "l_res": um(p["L"])})


def res_terms(c, ly):
    """(west terminal, east terminal, tap) Metal1 boxes of a ppolyf resistor PCell, sorted west -> east"""
    m1 = sorted(lib.merged_boxes(c, "m1", ly), key=lambda b: b.left)
    assert len(m1) == 3, m1
    f = lambda b: (g(b.left), g(b.bottom), g(b.right), g(b.top))
    return f(m1[1]), f(m1[2]), f(m1[0])


C3_VSS_BAR = (236.0, 240.0)  # y of the Metal5 bar joining the C3 bottom plates (vss)


def build_cg(ly):
    """
    M1 (CG, 2 rows of 70 + 2x2 M3 dummy fingers) in a P+ guard ring: row A (mirrored, bottom) and row B share the
    source bus in the middle (y = 295, straight to input_cg of lna_core_input_match);
      drains   : outer buses, joined east on a Metal5 column = vm2 -> C2 (bottom plate) and LD1 (inner end)
      gates    : inner straps (Metal3), joined east on Metal4 = g_cg -> C3 (4 MIM, 2x2, top plates) and R3
      source s : Metal5 west -> x = 82 (input_cg of the input match) and on south to L2 (outer end); L2 inner
                 end -> vss (south edge)
    LD1: outer end (top-left) -> vdd (Metal5 to the north edge, Metal3/4 bridges under the vx trace of lna_core_cs
         and under the rf_out lead), inner end (underpass west) -> vm2.
    C2 top plate = output_cs -> CS_GATE_PAD; R4: vbias_cs -> output_cs.
    """
    P = "lna_core_cg"
    sch = sch_params(P)
    top = Cell(ly, P)
    wf, l2, na, nd, s2 = fet_params(sch, "M1", "M3")
    rows = 2
    ws, wd = 2.5, 4.5  # um, Metal2+3 buses at 1 mA/um per layer: 4.4 mA per row (source bus shared by both rows)
    ta, ma = lib.fet_tile(ly, f"{P}__M2A", volt_of(s2), wf, l2, na // rows, nd // rows, ws=ws, wd=wd)
    tb, mb = lib.fet_tile(ly, f"{P}__M2B", volt_of(s2), wf, l2, na // rows, nd // rows, ws=ws, wd=wd, draw_s=False)
    x1_target = 196.0  # east end of the row buses
    y_s = 295.0  # centre of the shared source bus
    ox = x1_target - ma["S"][2]
    oya = g(y_s - (-(ma["S"][1] + ma["S"][3]) / 2))  # row A mirrored: local y -> -y
    tra = top.place(ta, ox, oya, mirror=True)
    A = {k: tbox(tra, v) for k, v in ma.items() if k != "nf"}
    trb = top.place(tb, ox, A["S"][1] - mb["S"][1])
    B = {k: tbox(trb, v) for k, v in mb.items() if k != "nf"}
    assert abs(B["S"][1] - A["S"][1]) < 1e-6 and abs(B["S"][3] - A["S"][3]) < 1e-6, (A["S"], B["S"])
    x0, x1 = A["S"][0], A["S"][2]
    # guard ring: room for the gate / drain joins on the east side
    gw = 0.8
    R = (g(x0 - 1.5 - gw), g(A["D"][1] - 1.5 - gw), g(x1 + 11.5 + gw), g(B["D"][3] + 1.5 + gw))
    lib.guard_ring(top, *R, w=gw)
    ri = (R[0] + gw, R[1] + gw, R[2] - gw, R[3] - gw)
    for T in (A, B):
        top.box("m1", ri[0] - 0.1, T["DGL"][1], T["DGL"][2], T["DGL"][3])
        top.box("m1", T["DGR"][0], T["DGR"][1], ri[2] + 0.1, T["DGR"][3])
    top.label(1, "vss", R[0] + gw / 2, R[1] + 5)
    # --- gates: straps east -> Metal4 join, g_cg Metal4 east (C3 channel), Metal4 up to R3
    gj = (x1 + 1, x1 + 4)
    for T in (A, B):
        top.box("m3", x1, T["G"][1], gj[1], T["G"][3])
        top.cuts("v3", gj[0], T["G"][1], gj[1], T["G"][3])
    yg = (296.5, 300.5)  # g_cg Metal4 strip (C3 channel)
    # --- drains: buses east -> Metal5 column (vm2)
    dc = (g(x1 + 6), g(x1 + 10))
    for T in (A, B):
        top.box("m2", x1, T["D"][1], dc[1], T["D"][3])
        top.box("m3", x1, T["D"][1], dc[1], T["D"][3])
        top.stack(dc[0], T["D"][1], dc[1], T["D"][3], 3, 5)
    # --- C3: 2 x 2, left column tab west, right column rotated 180 (tab east), top plates joined in the middle
    w9, l9 = um_grid(sch["C3"][1]["W"]), um_grid(sch["C3"][1]["L"])
    n9 = int(sch["C3"][1].get("m", 1))
    assert n9 == 4
    gap9 = 8.0  # bottom plate to bottom plate (Metal4 g_cg strip in the gaps, >= 1.2 um from the plates)
    xl = g(x1 + 14)
    xr = g(xl + w9 + 2 * lib.MIM_ENC + gap9)
    yl = 244.0
    yu = g(yl + l9 + 2 * lib.MIM_ENC + gap9)
    assert yl + l9 + lib.MIM_ENC + 1.2 <= yg[0] and yu - lib.MIM_ENC - 1.2 >= yg[1]
    c9, t9 = lib.mim_tile(ly, f"{P}__C3", w9, l9)
    plates, straps = [], []
    for (px, py, rot) in ((xl, yl, 0), (xl, yu, 0), (xr, yl, 180), (xr, yu, 180)):
        tr = top.place(c9, px + (w9 if rot else 0), py + (l9 if rot else 0), rot=rot)
        plates.append(tbox(tr, t9["top"]))
        straps.append(tbox(tr, t9["bot"]))
    top.box("m5", plates[0][2] - 1, plates[0][1], plates[2][0] + 1, plates[1][3])  # top plates (g_cg)
    xm = (xl + w9 + lib.MIM_ENC + 1.2, xr - lib.MIM_ENC - 1.2)  # Metal4-free zone limits in the middle gap
    top.box("m4", gj[0], yg[0], xm[1], yg[1])
    top.stack(xm[0], yg[0], xm[1], yg[1], 4, 5)
    top.label(4, "g_cg", gj[1] + 3, (yg[0] + yg[1]) / 2)
    for sb in straps:
        top.label(5, "vss", (sb[0] + sb[2]) / 2, (sb[1] + sb[3]) / 2)
    # C3 bottom plates (vss) joined inside the block: Metal5 bar below C3 (y = C3_VSS_BAR), lower straps down to it,
    # across the C3 channel to the upper straps, bar -> guard ring (Metal2); lna_core_parts extends the bar to the tiles
    yb0, yb1 = C3_VSS_BAR
    assert yb1 + lib.MIM_HALO <= yl - lib.MIM_ENC
    top.box("m5", straps[0][0], yb0, straps[2][2], yb1)
    for lo, up in ((straps[0], straps[1]), (straps[2], straps[3])):
        top.box("m5", lo[0], yb0, lo[2], lo[1] + 1)  # lower strap down to the bar
        top.box("m5", lo[0], lo[3] - 1, lo[2], up[1] + 1)  # across the C3 channel to the upper strap
    top.stack(straps[0][0], yb0, straps[0][2], yb1, 2, 5)
    top.box("m2", R[2] - 0.8, yb0, straps[0][2], R[1] + 0.8)
    # --- R3 above the ring: west = vbias_cg (Metal3 north), east = g_cg (Metal4 -> gate join)
    r1 = resistor(ly, f"{P}__R3", sch, "R3")
    rw, re_, rt = res_terms(r1, ly)
    r1x, r1y = g(x0 + 6 - rt[0]), g(R[3] + 4)
    trr = top.place(r1, r1x, r1y)
    rw, re_ = tbox(trr, rw), tbox(trr, re_)
    yr = (re_[1] + re_[3]) / 2
    top.box("m1", re_[0], yr - 0.9, re_[2] + 2.0, yr + 0.9)
    top.stack(re_[2] + 0.2, yr - 0.9, re_[2] + 2.0, yr + 0.9, 1, 4)
    top.box("m4", re_[2] + 0.2, yr - 0.9, gj[1], yr + 0.9)
    top.box("m4", gj[0], A["G"][1], gj[1], yr + 0.9)
    top.box("m1", rw[0], rw[1], rw[2], rw[3] + 2.5)
    top.stack(rw[0] - 0.4, rw[3] + 1.0, rw[2] + 0.4, rw[3] + 2.5, 1, 3)
    xvb = (rw[0] + rw[2]) / 2
    top.box("m3", xvb - 1, rw[3] + 1.0, xvb + 1, MACRO_H)
    top.label(3, "vbias_cg", xvb, MACRO_H - 1)
    # --- source s: middle bus west -> Metal5 -> x = 82 (input match) and south to L2
    ys0, ys1 = A["S"][1], A["S"][3]
    top.stack(x0, ys0, x0 + 6, ys1, 3, 5)
    top.box("m5", R[0] - 1.0, ys0, x0 + 6, ys1)
    xs = (84.0, 92.0)
    top.box("m5", 82.0, y_s - 5, R[0] - 1.0, y_s + 5)
    top.label(5, "input_match", 83.0, y_s)
    d1 = spiral_dout(P, "L2")
    ko_leq = KO_LEQ
    cx1, cy1 = g(RING + ko_leq + (d1 + 2 * SP_KO) / 2), g(RING + (d1 + 2 * SP_KO) / 2)
    sp1, st1 = lib.spiral(ly, f"{P}__L2", d1, SP_TURNS[(P, "L2")], under="S")
    tr1 = top.place(sp1, cx1, cy1)
    o1, i1 = tbox(tr1, st1["outer"]), tbox(tr1, st1["inner"])
    ysl = (222.0, 232.0)
    top.box("m5", xs[0], ysl[0], xs[1], y_s + 5)
    top.box("m5", xs[0], ysl[0], o1[2], ysl[1])
    top.box("m5", o1[0], o1[1], o1[2], ysl[1])
    top.box("m5", i1[0], 2.0, i1[2], i1[3])
    top.label(5, "vss", (i1[0] + i1[2]) / 2, 3.0)
    # --- C2: plate east of the vm2 column; bottom plate (tab west, on the column) = vm2, top plate = output_cs
    w1, l1c = um_grid(sch["C2"][1]["W"]), um_grid(sch["C2"][1]["L"])
    c1, t1 = lib.mim_tile(ly, f"{P}__C2", w1, l1c)
    c1x, c1y = g(dc[1] + 0.9), 372.0
    assert c1x + w1 + lib.MIM_ENC + 1.2 <= CS_GATE_PAD[0], "C2 bottom plate too close to the CS gate pad (MIMTM.1)"
    trc = top.place(c1, c1x, c1y)
    p1, b1 = tbox(trc, t1["top"]), tbox(trc, t1["bot"])
    assert dc[0] <= b1[0] and b1[2] <= dc[1]
    top.box("m5", dc[0], A["D"][1], dc[1], p1[3])  # vm2 column (drains -> C2 strap)
    gp = CS_GATE_PAD
    top.box("m5", p1[2] - 1, gp[1], gp[2], gp[3])  # output_cs -> lna_core_cs input_cg pad
    top.label(5, "output_cs", (gp[0] + gp[2]) / 2, (gp[1] + gp[3]) / 2)
    # --- R4 above C2: west = vbias_cs (Metal3 north), east = output_cs (Metal5 down to the C2 top plate)
    r2 = resistor(ly, f"{P}__R4", sch, "R4")
    rw2, re2, rt2 = res_terms(r2, ly)
    trr2 = top.place(r2, g(c1x - rt2[0] + 1.0), g(p1[3] + lib.MIM_ENC + 6.0))
    rw2, re2 = tbox(trr2, rw2), tbox(trr2, re2)
    yr2 = (re2[1] + re2[3]) / 2
    top.box("m1", re2[0], yr2 - 0.9, re2[2] + 2.0, yr2 + 0.9)
    top.stack(re2[2] + 0.2, yr2 - 0.9, re2[2] + 2.0, yr2 + 0.9, 1, 5)
    top.box("m5", re2[2] + 0.2, p1[3] - 1.0, re2[2] + 2.0, yr2 + 0.9)
    top.box("m1", rw2[0], rw2[1], rw2[2], rw2[3] + 2.5)
    top.stack(rw2[0] - 0.4, rw2[3] + 1.0, rw2[2] + 0.4, rw2[3] + 2.5, 1, 3)
    xvc = (rw2[0] + rw2[2]) / 2
    top.box("m3", xvc - 1, rw2[3] + 1.0, xvc + 1, MACRO_H)
    top.label(3, "vbias_cs", xvc, MACRO_H - 1)
    # --- LD1 (floorplan LD4 box right of L2): outer end -> vdd, inner end (underpass west) -> vm2
    d4 = spiral_dout(P, "LD1")
    cx4, cy4 = g(RING + ko_leq + d1 + 2 * SP_KO + (d4 + 2 * SP_KO) / 2), g(RING + (d4 + 2 * SP_KO) / 2)
    sp4, st4 = lib.spiral(ly, f"{P}__LD1", d4, SP_TURNS[(P, "LD1")], under="W")
    tr4 = top.place(sp4, cx4, cy4)
    o4, i4 = tbox(tr4, st4["outer"]), tbox(tr4, st4["inner"])
    yv = (357.0, 365.0)  # vm2 trace north of C3
    assert yv[0] - 4 >= plates[1][3]
    top.box("m5", dc[0], yv[0], i4[2], yv[1])
    top.box("m5", i4[0], i4[1], i4[2], yv[1])
    # vdd: Metal5 up, Metal3/4 bridge under the vx trace of lna_core_cs (y ~ 441.6 .. 451.6), Metal5 to the edge
    br = (428.0, 465.0)
    top.box("m5", o4[0], o4[1], o4[2], br[0] + 6)
    top.stack(o4[0], br[0], o4[2], br[0] + 6, 3, 5)
    top.box("m3", o4[0], br[0], o4[2], br[1])
    top.box("m4", o4[0], br[0], o4[2], br[1])
    top.stack(o4[0], br[1] - 6, o4[2], br[1], 3, 5)
    assert o4[0] - 1.2 - lib.MIM_ENC >= C_OUT_PLATE[0] + C_OUT_L, "output C1 too close to the LD1 vdd lead"
    vdd_column(top, o4[0], o4[2], br[1] - 6, MACRO_H)
    top.label(5, "vdd", (o4[0] + o4[2]) / 2, MACRO_H - 1)
    INFO[P] = {"M1": {"rows": rows, "fingers_per_row": ma["nf"], "wf": wf, "L": l2,
                      "sym": s2},
               "bus_w_um": {"source": ws, "drain": wd}, "guard_ring": R,
               "C3_pF": round(4 * lib.c_mim_pf(w9, l9), 3), "C2_pF": round(lib.c_mim_pf(w1, l1c), 3),
               "L2": {"dout_um": round(d1, 2), "centre": [cx1, cy1]}, "LD1": {"dout_um": round(d4, 2), "centre": [cx4, cy4]},
               "c9_vss_straps": straps, "c9_plates": plates, "l1_vss_lead_x": [i1[0], i1[2]], "ld4_vdd_lead": list(o4[:3]) + [MACRO_H],
               "vm2_column_x": list(dc),
               "pins": {"input_match": "Metal5 x=82 y=290..300", "output_cs": list(gp), "g_cg": "Metal4 strip",
                        "vbias_cg": f"Metal3 north edge x={xvb:.2f}", "vbias_cs": f"Metal3 north edge x={xvc:.2f}",
                        "vdd": "Metal5 north edge", "vss": "guard ring, C3 straps, L2 inner (south edge)"}}
    return top


BUILDERS = {"input_match": build_input_match, "cg": build_cg, "cs": build_cs, "output_match": build_output_match}


def main():
    want = [c for c in (globals().get("cells") or ",".join(BUILDERS)).split(",") if c]
    for key in want:
        ly = pya.Layout()
        ly.dbu = 0.001
        top = BUILDERS[key](ly)
        for c in list(ly.each_cell()):  # drop the PCell variant cells
            if c.parent_cells() == 0 and c.cell_index() != top.c.cell_index():
                ly.delete_cell(c.cell_index())
        name = top.c.name
        path = os.path.join(HERE, name + ".gds")
        ly.write(path)
        b = top.c.dbbox()
        print(f"wrote {path}  bbox {b.left:.1f},{b.bottom:.1f} .. {b.right:.1f},{b.top:.1f}")
    rep = os.path.join(HERE, "lna_core_layouts.json")
    old = json.load(open(rep)) if os.path.exists(rep) else {}
    old.update(INFO)
    json.dump(old, open(rep, "w"), indent=1)


main()
