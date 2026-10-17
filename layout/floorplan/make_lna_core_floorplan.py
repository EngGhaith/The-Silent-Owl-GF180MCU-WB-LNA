#!/usr/bin/env python3
"""
Floorplan of the LNA core cell (xschem/lna_core.sch) with realistic sizes, a tile at the edge of the shared
Chipathon / Chipalooza chip.

Writes
  lna_core_floorplan.gds   real PDK devices (from lna_core_devices.gds) placed as cells, spirals drawn as real
                           Metal5 windings, plus floorplan boxes / guard rings / pins / labels (pure python)
  lna_core_floorplan.json  same data, machine readable
  lna_core_floorplan.svg   picture for the docs

Sizes
  FETs, poly resistors, MIMs: real PCell geometry. Run `klayout -b -r make_lna_core_devices.py` first - it reads
  W / L / nf / m from lna_core.sch (read only) and writes lna_core_devices.gds/.json. FET arrays are rows of
  nf=10 unit cells with shared diffusion + the dummy fingers of M2D / M4D / M1D at both row ends.
  Spirals: square, Metal5 (top metal), w = 10 um, s = 3 um, turns n as before; the outer diameter is solved from
  the inductance in lna_core.sch with the modified Wheeler formula, plus a 25 um keep-out per side.
  Ideal res.sym elements (RLEQ, RLD2, RLD3, Rs, RS_EQ) are the inductor loss / parasitic models -> no layout.
  spice_ignore'd elements (LSHUNT_OUT, RLSHOUT) are not placed.
  C values: PDK model of cap_mim_2f0_m4m5_noshield (1.99 fF/um^2 area + 0.2383 fF/um sidewall).

Pin plan: pins on two sides only - rf_in_pad on the west edge, rf_out_pad and all DC (vdd, vss, vbias_cg /
vbias_cs / vbias_cas) on the north edge, a vss pin next to each RF pin. Each gain stage (CG, CS, cascode) sits
in its own P+ guard ring. Supply: free area tiled with the team's 20 x 20 um supply cells (cells/*.gds):
M5 = VDD (also routing), M4 = VSS, M3 = VDD, M2 = VSS, M1 = VSS + device contacts, SUB = VSS; the MIM version adds
decap MIMs between M5 (VDD) and M4 (VSS). Not under spirals, device blocks, routing channels and route corridors.

Units: um, origin = lower-left corner of the macro.
"""
import json, math, os, re, struct, time

HERE = os.path.dirname(os.path.abspath(__file__))
SCH = os.path.join(HERE, "..", "..", "xschem", "lna_core.sch")
DEV_GDS, DEV_JSON = os.path.join(HERE, "lna_core_devices.gds"), os.path.join(HERE, "lna_core_devices.json")


# ---------- schematic (read only) ----------
def _um(v):
    return float(v[:-1]) if v.endswith("u") else float(v) * 1e6


def sch_instances(path=SCH):
    """{name: (symbol, {param: value})} of every instance"""
    out = {}
    for sym, body in re.findall(r"^C \{([^}]*)\}[^{]*\{(.*?)\}", open(path).read(), re.S | re.M):
        p = dict(re.findall(r"(\w+)=(\S+)", body))
        if "name" in p:
            out[p["name"]] = (os.path.basename(sym)[:-4], p)
    return out


SUPPLY_DECAP = "CDCPL"  # vdd-vss decap of the PG_MIM supply tiles: in the schematic for LVS, not placed as a device


def sch_mims(path=SCH):
    """{name: (W, L, m)} of every signal cap_mim instance (without SUPPLY_DECAP), W/L in um"""
    return {n: (_um(p["W"]), _um(p["L"]), int(p.get("m", 1)))
            for n, (s, p) in sch_instances(path).items() if s.startswith("cap_mim") and n != SUPPLY_DECAP}


INST = sch_instances()
DEV = json.load(open(DEV_JSON))

# ---------- MIM ----------
MIM_ENC = 0.6  # um, bottom plate (Metal4) enclosure of the top plate
MIM_SP = 1.2  # um, min bottom-plate spacing (MIMTM.1)
# each MIM is placed as a tile (make_lna_core_devices.py): PCell + Metal4 tab with Via4 for the bottom plate +
# Metal5 leads (bottom plate west, top plate east) + 1.2 um halo around the bottom plate
C_AREA, C_PERI = 1.99, 0.2383  # fF/um^2, fF/um - cap_mim_2f0_m4m5_noshield (sm141064_mim.ngspice, typ)


def c_mim(w, l):
    """capacitance of one MIM top plate in pF (area + sidewall term of the PDK model)"""
    return (C_AREA * w * l + C_PERI * 2 * (w + l)) / 1000


def mim_cell(name):
    w, l, _ = sch_mims()[name]
    return f"MIMC_{w:.4f}x{l:.4f}"


# ---------- spirals ----------
SP_W, SP_S, SP_KO = 10.0, 3.0, 25.0  # um: trace width, spacing (Metal5), keep-out per side
SP_TURNS = {"LEQ": 4.25, "L1": 4.25, "LD4": 6.25, "LD2": 5}  # turns (quarter-turn steps)
SP_INFO = {"LEQ": "shunt rf_in_pad -> vss (+RLEQ)", "L1": "CG source choke net1 -> Rs -> vss",
           "LD4": "CG load vdd -> vm2 (+RLD3)", "LD2": "CS load vdd -> vx (+RLD2)"}


def ind_value(name):
    s, p = INST[name]
    v = p["value"]
    return float(v[:-1]) * 1e-9 if v.endswith("n") else float(v)


def wheeler_dout(L, n, w=SP_W, s=SP_S):
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


SPIRALS = {}  # name -> (L, n, dout, din)
for _n, _t in SP_TURNS.items():
    _L = ind_value(_n)
    _d = wheeler_dout(_L, _t)
    SPIRALS[_n] = (_L, _t, _d, _d - 2 * _t * SP_W - 2 * (_t - 1) * SP_S)
KO = {n: SPIRALS[n][2] + 2 * SP_KO for n in SPIRALS}  # keep-out box side


def spiral_path(cx, cy, dout, n, w=SP_W, s=SP_S):
    """centre line of a square spiral, starting at the outer top-left corner, clockwise inwards"""
    a, p = dout / 2 - w / 2, w + s
    pts, (x, y) = [(cx - a, cy + a)], (cx - a, cy + a)
    for k in range(round(4 * n)):
        ln = 2 * a - (max(k - 1, 0) // 2) * p
        assert ln > w, "spiral does not fit"
        dx, dy = [(1, 0), (0, -1), (-1, 0), (0, 1)][k % 4]
        x, y = x + dx * ln, y + dy * ln
        pts.append((x, y))
    return pts


# ---------- placement ----------
VSS_RING = 12  # um, vss ring along the boundary
# spiral keep-out boxes, lower-left corners: bottom row LEQ | L1 | LD4, LD2 on top of LD4 at the east edge
_x = VSS_RING
SP_POS = {"LEQ": (_x, VSS_RING)}
SP_POS["L1"] = (_x + KO["LEQ"], VSS_RING)
SP_POS["LD4"] = (SP_POS["L1"][0] + KO["L1"], VSS_RING)
SP_POS["LD2"] = (SP_POS["LD4"][0] + KO["LD4"] - KO["LD2"], VSS_RING + KO["LD4"])
W = math.ceil(SP_POS["LD4"][0] + KO["LD4"] + VSS_RING)
H = math.ceil(SP_POS["LD2"][1] + KO["LD2"] + VSS_RING)


def dev_size(cell):
    b = DEV[cell]["bbox"]
    return b[2] - b[0], b[3] - b[1]


GAP = 3.0  # um, device-to-device inside a group
STAGE_M = 8.0  # um, guard ring (GR_W) + 3 um clearance around the stage content
GR_W = 5.0  # um, P+ guard ring width
MATCH_M, MATCH_LABEL = 10.0, 14.0  # um, margin around pure-MIM blocks + room for the block name


def _stage_content():
    """per block: inner origin (abs) and [(instance, cell, (dx, dy) of the cell bbox lower-left)]"""
    m2w, m2h = dev_size("M2_row")
    m1w, m1h = dev_size("M1_row")
    c9 = mim_cell("C9")
    c9w, c9h = dev_size(c9)
    c1w, _ = dev_size(mim_cell("C1"))
    _, c15h = dev_size(mim_cell("C15"))
    c9x = m2w + STAGE_M
    return {
        "IN_MATCH": ((22, 243), [("C15", mim_cell("C15"), (0, 0)), ("CPI", mim_cell("CPI"), (0, c15h + GAP))]),
        "CG_STAGE": ((95, 243), [("M2.r1", "M2_row", (0, 0)), ("M2.r2", "M2_row", (0, m2h + GAP)),
                                  ("R1", "R1", (0, 2 * m2h + GAP + 8)),
                                  ("C9a", c9, (c9x, 0)), ("C9b", c9, (c9x + c9w + GAP, 0)),
                                  ("C9c", c9, (c9x, c9h + GAP)), ("C9d", c9, (c9x + c9w + GAP, c9h + GAP))]),
        "CS_STAGE": ((200, 377), [("C1", mim_cell("C1"), (0, 0)), ("M1", "M1_row", (c1w + STAGE_M, 0)),
                                  ("R2", "R2", (c1w + STAGE_M, m1h + 8))]),
        "CAS_STAGE": ((304, 457), [("M4", "M4_row", (0, 0))]),
        "OUT_MATCH": ((392, 468), [("C11", mim_cell("C11"), (0, 0))]),
    }


STAGE_CONTENT = _stage_content()
GUARD_RINGS = ["CG_STAGE", "CS_STAGE", "CAS_STAGE"]

# placed device instances: (instance, cell, (x0, y0, x1, y1) abs bbox)
PLACED = []
BLOCK_BOX = {}
for _blk, ((_ox, _oy), _items) in STAGE_CONTENT.items():
    for _i, _c, (_dx, _dy) in _items:
        _w, _h = dev_size(_c)
        PLACED.append((_i, _c, (_ox + _dx, _oy + _dy, _ox + _dx + _w, _oy + _dy + _h)))
    _bx = [b for i, c, b in PLACED[-len(_items):]]
    _m = STAGE_M if _blk in GUARD_RINGS else MATCH_M
    _top = 0 if _blk in GUARD_RINGS else MATCH_LABEL
    BLOCK_BOX[_blk] = (round(min(b[0] for b in _bx) - _m, 2), round(min(b[1] for b in _bx) - _m, 2),
                       round(max(b[2] for b in _bx) + _m, 2), round(max(b[3] for b in _bx) + _m + _top, 2))

# MIMs as (name, (x0, y0) of the top plate, w, h); MIM_GEOM: absolute bottom plate (incl. tab), leads, tile
MIMS, MIM_GEOM = [], {}  # top plate W x L exactly as in the schematic
_caps = sch_mims()
for _i, _c, _b in PLACED:
    if _c.startswith("MIMC_"):
        _w, _l, _ = _caps[_i if _i in _caps else _i[:-1]]
        _d = DEV[_c]
        _ox, _oy = _b[0] - _d["bbox"][0], _b[1] - _d["bbox"][1]
        _abs = lambda r: (r[0] + _ox, r[1] + _oy, r[2] + _ox, r[3] + _oy)
        MIMS.append((_i, (_d["top_plate"][0] + _ox, _d["top_plate"][1] + _oy), _w, _l))
        MIM_GEOM[_i] = {"tile": _b, "bottom_plate": _abs(_d["bottom_plate"]),
                        "leads": {k: _abs(v) for k, v in _d["leads"].items()}}


def mim_footprint(m):
    """bottom plate (Metal4) incl. the contact tab"""
    return MIM_GEOM[m[0]]["bottom_plate"]


def _sp_txt(n):
    L, t, d, din = SPIRALS[n]
    return f"{L * 1e9:.3g} nH {SP_INFO[n]}, n={t:g}, dout={d:.0f}, din={din:.0f}"


def _cap_txt(n):
    w, l, m = sch_mims()[n]
    return f"{n} {m * c_mim(w, l):.2f} pF MIM {f'{m}x ' if m > 1 else ''}{w:.1f}x{l:.1f}"


DC_Y = max(BLOCK_BOX["CAS_STAGE"][3], BLOCK_BOX["CS_STAGE"][3]) + 5  # bottom of the DC channel
# name, kind, (x0, y0, x1, y1), contents
BLOCKS = [(n, "spiral", (x, y, x + KO[n], y + KO[n]), _sp_txt(n)) for n, (x, y) in SP_POS.items()] + [
    ("IN_MATCH",  "block", BLOCK_BOX["IN_MATCH"],  f"{_cap_txt('C15')} series | {_cap_txt('CPI')} shunt"),
    ("CG_STAGE",  "block", BLOCK_BOX["CG_STAGE"],  f"M2 nfet_06v0 40/0.6 nf10 m14, 2 rows | {_cap_txt('C9')} g_cg decap | R1"),
    ("CS_STAGE",  "block", BLOCK_BOX["CS_STAGE"],  f"{_cap_txt('C1')} | M1 nfet_03v3 20/0.28 nf10 m10 | R2"),
    ("CAS_STAGE", "block", BLOCK_BOX["CAS_STAGE"], "M4 cascode nfet_06v0 35/0.6 nf10 m4, drain = vx"),
    ("OUT_MATCH", "block", BLOCK_BOX["OUT_MATCH"], f"{_cap_txt('C11')} series, vx -> rf_out_pad"),
    ("BIAS_CH",   "route", (VSS_RING, DC_Y, BLOCK_BOX["OUT_MATCH"][0] - 5, H - VSS_RING),
     "DC channel: vbias_cg / vbias_cs / vbias_cas from the north edge"),
    ("VDD_TRUNK", "route", (SP_POS["LD4"][0] + 5, SP_POS["LD2"][1], SP_POS["LD2"][0] - 5, H - VSS_RING),
     "vdd from the north edge to LD4 / LD2"),
]
BB = {n: b for n, _, b, _ in BLOCKS}

RF_IN_Y = 295
X_CG, X_CS, X_CAS = 140, 285, 330  # vbias pin x (cs -> R2, cas -> M4 gate)
X_RFOUT = round((BB["OUT_MATCH"][0] + BB["OUT_MATCH"][2]) / 2)
X_VDD = round((BB["VDD_TRUNK"][0] + BB["VDD_TRUNK"][2]) / 2)
PINS = [  # name, x, y, side - west + north only
    ("vss", 0, RF_IN_Y - 45, "W"),
    ("rf_in_pad", 0, RF_IN_Y, "W"),
    ("vss", 0, RF_IN_Y + 45, "W"),
    ("vss", 60, H, "N"),
    ("vbias_cg", X_CG, H, "N"),
    ("vbias_cs", X_CS, H, "N"),
    ("vbias_cas", X_CAS, H, "N"),
    ("vss", X_RFOUT - 32, H, "N"),
    ("rf_out_pad", X_RFOUT, H, "N"),
    ("vss", X_RFOUT + 32, H, "N"),
    ("vdd", X_VDD, H, "N"),
]
# vbias_buf, vbias_csc, vbias_casc, vbias_icg: symbol pins without a net in lna_core.sch -> not placed

_cg, _cs, _cas, _om, _im = BB["CG_STAGE"], BB["CS_STAGE"], BB["CAS_STAGE"], BB["OUT_MATCH"], BB["IN_MATCH"]
_ld4, _ld2, _leq, _l1 = BB["LD4"], BB["LD2"], BB["LEQ"], BB["L1"]
ROUTES = [  # suggested critical nets (polyline), for the drawing only
    ("rf_in", [(0, RF_IN_Y), (_im[0], RF_IN_Y)]),
    ("rf_in -> LEQ", [(_im[0] + 6, RF_IN_Y), (_im[0] + 6, _leq[3] - 20)]),
    ("rf_in' -> CG", [(_im[2], RF_IN_Y), (_cg[0], RF_IN_Y)]),
    ("net1 -> L1", [(280, _cg[1]), (280, _l1[3])]),
    ("vm2 -> LD4", [(_cg[2], 330), (_ld4[0] + 40, 330), (_ld4[0] + 40, _ld4[3])]),
    ("vm2 -> C1", [(230, _cg[3]), (230, _cs[1])]),
    ("vx -> LD2", [(_cas[2], 452), (_ld2[0], 452)]),
    ("vx -> C11", [(_cas[2], 465), (_om[0] - 5, 465), (_om[0] - 5, 495), (_om[0], 495)]),
    ("rf_out", [(X_RFOUT, _om[3]), (X_RFOUT, H)]),
    ("vbias_cg", [(X_CG, H), (X_CG, _cg[3])]),
    ("vbias_cs", [(X_CS, H), (X_CS, _cs[3])]),
    ("vbias_cas", [(X_CAS, H), (X_CAS, _cas[3])]),
    ("vdd", [(X_VDD, H), (X_VDD, _ld4[3])]),
]

# Supply grid (layer plan from the team, 2026-10-15): every free 20 x 20 um grid site carries a supply tile
#   M5 = VDD (thick top metal, also routing), M4 = VSS, M3 = VDD, M2 = VSS (shields the devices), M1 = VSS + device
#   contacts / local routing, SUB tap = VSS.  PG_MIM adds 4 MIM decaps (top plate M5 = VDD, bottom plate M4 = VSS),
#   PG_PLAIN is the same stack without MIM. The tiles are slotted / density-aware (375 of 400 um^2 per metal).
# Free = inside the edge ring and >= PG_KEEP from spiral keep-outs, device blocks and the routing channels, and
# >= ROUTE_KEEP from the centre line of every suggested route.
PG = 20.0  # um, tile pitch
PG_KEEP, ROUTE_KEEP = 2.0, 6.0  # um
PG_DEFAULT = "PG_MIM"  # tile used on free sites
PG_CUT_KINDS = ("spiral", "block", "route")
PG_SUPPLY = ("VDD_TRUNK",)  # channels that are supply themselves (M5 = VDD) -> tiled, not cut out
PG_SUPPLY_ROUTES = ("vdd",)  # routes carried by the tiles themselves -> no corridor
# PG_PLAIN on the vdd trunk: it carries the whole supply current on M5 / M3


def pg_cutouts():
    cut = [(b[0] - PG_KEEP, b[1] - PG_KEEP, b[2] + PG_KEEP, b[3] + PG_KEEP) for n, k, b, _ in BLOCKS
           if k in PG_CUT_KINDS and n not in PG_SUPPLY]
    for name, pts in ROUTES:
        if name in PG_SUPPLY_ROUTES:
            continue
        for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
            cut.append((min(x0, x1) - ROUTE_KEEP, min(y0, y1) - ROUTE_KEEP, max(x0, x1) + ROUTE_KEEP, max(y0, y1) + ROUTE_KEEP))
    return cut


def pg_sites():
    """[(cell, (x0, y0, x1, y1))] of the supply tiles on the 20 um grid"""
    cut = pg_cutouts()
    out = []
    nx, ny = int((W - 2 * VSS_RING) // PG), int((H - 2 * VSS_RING) // PG)
    for i in range(nx):
        for j in range(ny):
            t = (VSS_RING + i * PG, VSS_RING + j * PG, VSS_RING + (i + 1) * PG, VSS_RING + (j + 1) * PG)
            if any(_overlap(t, c) for c in cut):
                continue
            plain = any(_overlap(t, BB[z]) for z in PG_SUPPLY)
            out.append(("PG_PLAIN" if plain else PG_DEFAULT, t))
    return out


def pg_summary():
    sites = pg_sites()
    n = {k: sum(1 for c, _ in sites if c == k) for k in ("PG_MIM", "PG_PLAIN")}
    return {"tiles": n, "area_um2": len(sites) * PG * PG,
            "mim_decap_pF": round(sum(DEV[c]["mim_decap_pF"] for c, _ in sites), 2)}


# ---------- checks ----------
def _overlap(a, b, gap=0.0):
    return a[0] < b[2] + gap and b[0] < a[2] + gap and a[1] < b[3] + gap and b[1] < a[3] + gap


def check_decap():
    """SUPPLY_DECAP in the schematic must match the MIMs of the PG_MIM tiles (C within 1 %); warns, does not stop"""
    s_, p = INST.get(SUPPLY_DECAP, (None, None))
    n = pg_summary()["tiles"]["PG_MIM"]
    c_lay = pg_summary()["mim_decap_pF"]
    if p is None:
        print(f"WARNING: no {SUPPLY_DECAP} in lna_core.sch, the layout has {n} PG_MIM tiles = {c_lay} pF vdd-vss decap")
        return
    w, l, m = _um(p["W"]), _um(p["L"]), int(p.get("m", 1))
    c_sch = m * c_mim(w, l)
    if abs(c_sch - c_lay) > 0.01 * c_lay:
        print(f"WARNING: {SUPPLY_DECAP} in lna_core.sch = {m} x {w:g}x{l:g} = {c_sch:.2f} pF, layout: {n} PG_MIM tiles "
              f"= {c_lay} pF -> set m = {4 * n} (4 MIMs per tile) for LVS")


def check_mims():
    """schematic <-> placement consistency, MIM spacing, devices inside their (guard-ringed) block,
    no overlap between blocks / spiral keep-outs / macro edge ring"""
    caps = sch_mims()
    placed = {}
    for m in MIMS:
        base = m[0] if m[0] in caps else m[0][:-1]
        placed[base] = placed.get(base, 0) + 1
    assert {n: c[2] for n, c in caps.items()} == placed, f"MIMs schematic {caps} vs placed {placed}"
    fps = [(m[0], mim_footprint(m)) for m in MIMS]
    for i, (na, a) in enumerate(fps):
        for nb, b in fps[i + 1:]:
            gap = max(b[0] - a[2], a[0] - b[2], b[1] - a[3], a[1] - b[3])
            assert gap >= MIM_SP, f"{na}/{nb}: bottom plates {gap:.2f} um apart"
    for blk, (_, items) in STAGE_CONTENT.items():
        bb, g = BB[blk], (GR_W if blk in GUARD_RINGS else 0)
        for i, c, b in PLACED:
            if i in [it[0] for it in items]:
                assert b[0] >= bb[0] + g and b[2] <= bb[2] - g and b[1] >= bb[1] + g and b[3] <= bb[3] - g, \
                    f"{i} overlaps the edge / guard ring of {blk}"
    hard = [(n, b) for n, k, b, _ in BLOCKS if k in ("spiral", "block")]
    for i, (na, a) in enumerate(hard):
        assert a[0] >= VSS_RING and a[1] >= VSS_RING and a[2] <= W - VSS_RING and a[3] <= H - VSS_RING, f"{na} in the ring"
        for nb, b in hard[i + 1:]:
            assert not _overlap(a, b), f"{na} overlaps {nb}"


COLORS = {"pad": "#c9a227", "spiral": "#d9822b", "block": "#2b7bd9", "route": "#9aa5b1"}


def write_json(path):
    json.dump({"size_um": [W, H], "schematic": "xschem/lna_core.sch", "vss_ring_um": VSS_RING,
               "blocks": BLOCKS, "pins": PINS, "routes": ROUTES,
               "spirals": {n: {"L_nH": round(v[0] * 1e9, 4), "turns": v[1], "dout_um": round(v[2], 1),
                               "din_um": round(v[3], 1), "w_um": SP_W, "s_um": SP_S, "keepout_um": SP_KO}
                           for n, v in SPIRALS.items()},
               "devices": [{"name": i, "cell": c, "bbox": [round(v, 3) for v in b], "info": DEV[c]["info"]}
                           for i, c, b in PLACED],
               "mims": [{"name": m[0], "top_plate": [m[1][0], m[1][1], m[1][0] + m[2], m[1][1] + m[3]],
                         "bottom_plate": list(mim_footprint(m)), "tile": list(MIM_GEOM[m[0]]["tile"]), "leads": MIM_GEOM[m[0]]["leads"], "c_pF": round(c_mim(m[2], m[3]), 4)}
                        for m in MIMS],
               "guard_rings": {"stages": GUARD_RINGS, "width_um": GR_W},
               "supply_grid": {"layers": {"M5": "vdd", "M4": "vss", "M3": "vdd", "M2": "vss", "M1": "vss", "SUB": "vss"},
                               "pitch_um": PG, **pg_summary(),
                               "sites": [{"cell": c, "box": list(t)} for c, t in pg_sites()]}},
              open(path, "w"), indent=1)


# ---------- minimal GDSII writer ----------
def _rec(rtype, dtype, data=b""):
    return struct.pack(">HBB", 4 + len(data), rtype, dtype) + data


def _real8(v):
    if v == 0:
        return b"\0" * 8
    sign = 0x80 if v < 0 else 0
    v = abs(v); e = 64
    while v >= 1:
        v /= 16; e += 1
    while v < 1 / 16:
        v *= 16; e -= 1
    return bytes([sign | e]) + int(v * (1 << 56)).to_bytes(7, "big")


def _str(rtype, s):
    b = s.encode()
    return _rec(rtype, 6, b + (b"\0" if len(b) % 2 else b""))


def gds_records(data):
    i = 0
    while i < len(data):
        n = struct.unpack(">H", data[i:i + 2])[0]
        yield data[i:i + n]
        i += n


def gds_structures(path):
    """all BGNSTR ... ENDSTR records of a GDS file (bytes), to copy cells into another library"""
    out, keep = [], False
    for r in gds_records(open(path, "rb").read()):
        keep = keep or r[2] == 0x05
        if keep:
            out.append(r)
        if r[2] == 0x07:
            keep = False
    return out


def write_gds(path):
    um = lambda v: int(round(v * 1000))  # dbu = 1 nm
    L = {"prb": (0, 0), "metal5": (81, 0),
         # floorplan only (not PDK layers) - delete before tape-out
         "spiral": (255, 1), "block": (255, 2), "route": (255, 3), "ring": (255, 5), "guard": (255, 6),
         "text": (255, 10), "pin": (255, 20)}
    t = time.localtime()[:6]
    out = [_rec(0x00, 2, struct.pack(">h", 600)), _rec(0x01, 2, struct.pack(">12h", *t, *t)), _str(0x02, "LNA_CORE_FP"),
           _rec(0x03, 5, _real8(1e-3) + _real8(1e-9))]
    out += gds_structures(DEV_GDS)  # real PDK device cells
    out += [_rec(0x05, 2, struct.pack(">12h", *t, *t)), _str(0x06, "lna_core_floorplan")]

    def box(layer, x0, y0, x1, y1):
        pts = [(x0, y0), (x1, y0), (x1, y1), (x0, y1), (x0, y0)]
        out.extend([_rec(0x08, 0), _rec(0x0D, 2, struct.pack(">h", layer[0])),
                    _rec(0x0E, 2, struct.pack(">h", layer[1])),
                    _rec(0x10, 3, b"".join(struct.pack(">ii", um(x), um(y)) for x, y in pts)), _rec(0x11, 0)])

    def wire(layer, pts, width):
        out.extend([_rec(0x09, 0), _rec(0x0D, 2, struct.pack(">h", layer[0])),
                    _rec(0x0E, 2, struct.pack(">h", layer[1])), _rec(0x21, 2, struct.pack(">h", 2)),
                    _rec(0x0F, 3, struct.pack(">i", um(width))),
                    _rec(0x10, 3, b"".join(struct.pack(">ii", um(x), um(y)) for x, y in pts)), _rec(0x11, 0)])

    def text(s, x, y, size, layer=L["text"]):
        out.extend([_rec(0x0C, 0), _rec(0x0D, 2, struct.pack(">h", layer[0])),
                    _rec(0x16, 2, struct.pack(">h", layer[1])),
                    _rec(0x1A, 1, struct.pack(">H", 0)), _rec(0x1B, 5, _real8(size)),
                    _rec(0x10, 3, struct.pack(">ii", um(x), um(y))), _str(0x19, s), _rec(0x11, 0)])

    def sref(cell, x, y):
        out.extend([_rec(0x0A, 0), _str(0x12, cell), _rec(0x10, 3, struct.pack(">ii", um(x), um(y))), _rec(0x11, 0)])

    box(L["prb"], 0, 0, W, H)
    r = VSS_RING
    for b in [(0, 0, W, r), (0, H - r, W, H), (0, r, r, H - r), (W - r, r, W, H - r)]:
        box(L["ring"], *b)
    for c, t in pg_sites():  # supply tiles (cell origin = tile centre)
        ob = DEV[c]["bbox"]
        sref(c, t[0] - ob[0], t[1] - ob[1])
    for name, kind, (x0, y0, x1, y1), _ in BLOCKS:
        box(L[kind], x0, y0, x1, y1)
        text(name, x0 + 4, y1 - 12, 8)
        if name in GUARD_RINGS:
            g = GR_W
            for b in [(x0, y0, x1, y0 + g), (x0, y1 - g, x1, y1), (x0, y0 + g, x0 + g, y1 - g), (x1 - g, y0 + g, x1, y1 - g)]:
                box(L["guard"], *b)
    for n, (L_, t_, d, _) in SPIRALS.items():
        x, y = SP_POS[n]
        wire(L["metal5"], spiral_path(x + KO[n] / 2, y + KO[n] / 2, d, t_), SP_W)
    for i, c, b in PLACED:  # place so that the cell bbox lands on b
        ob = DEV[c]["bbox"]
        sref(c, b[0] - ob[0], b[1] - ob[1])
        text(i, b[0], b[1] - 2.5, 2)
    for name, x, y, _ in PINS:
        box(L["pin"], x - 5, y - 5, x + 5, y + 5)
        text(name, x, y, 10)
    out.extend([_rec(0x07, 0), _rec(0x04, 0)])
    open(path, "wb").write(b"".join(out))


def write_svg(path):
    s = 1.3  # px per um
    pad = 60
    pad_n = pad + 50
    fy = lambda y: pad_n + (H - y) * s
    fx = lambda x: pad + x * s
    PW = 520
    rect = lambda b, st: (f'<rect x="{fx(b[0]):.2f}" y="{fy(b[3]):.2f}" width="{(b[2] - b[0]) * s:.2f}" '
                          f'height="{(b[3] - b[1]) * s:.2f}" {st}/>')
    e = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{W * s + 2 * pad + PW:.0f}" height="{H * s + pad_n + pad + 100:.0f}" '
         f'font-family="sans-serif">',
         '<rect width="100%" height="100%" fill="white"/>',
         rect((0, 0, W, H), 'fill="#f4f6f8" stroke="#333" stroke-width="2"'),
         rect((VSS_RING / 2, VSS_RING / 2, W - VSS_RING / 2, H - VSS_RING / 2),
              f'fill="none" stroke="#6b7785" stroke-width="{VSS_RING * s}" opacity="0.35"'),
         '<defs><pattern id="m1" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(45)">'
         '<line x1="0" y1="0" x2="0" y2="8" stroke="#2e9e5b" stroke-width="2"/></pattern>'
         '<pattern id="m2" width="8" height="8" patternUnits="userSpaceOnUse" patternTransform="rotate(-45)">'
         '<line x1="0" y1="0" x2="0" y2="8" stroke="#8e44ad" stroke-width="1.2"/></pattern></defs>']
    for c, t in pg_sites():  # supply tiles: M5/M3 vdd over M4/M2/M1 vss, PG_MIM with its 4 decap MIMs
        e.append(rect(t, 'fill="#fdebd0" stroke="#d4ac0d" stroke-width="0.5"'))
        if c == "PG_MIM":
            cx, cy = (t[0] + t[2]) / 2, (t[1] + t[3]) / 2
            for dx, dy in ((-1, -1), (1, -1), (-1, 1), (1, 1)):
                x0, y0 = cx + (3.1 if dx > 0 else -9.4), cy + (3.1 if dy > 0 else -9.4)
                e.append(rect((x0, y0, x0 + 6.3, y0 + 6.3), 'fill="#af7ac5" fill-opacity="0.7"'))
    for name, kind, b, info in BLOCKS:
        c = COLORS[kind]
        e.append(rect(b, f'fill="{c}" fill-opacity="{0.10 if kind == "spiral" else 0.18}" stroke="{c}" stroke-width="1.5"'
                         + (' stroke-dasharray="6 3"' if kind == "spiral" else "")))
        if name in GUARD_RINGS:
            e.append(f'<rect x="{fx(b[0]) + GR_W * s / 2:.2f}" y="{fy(b[3]) + GR_W * s / 2:.2f}" '
                     f'width="{(b[2] - b[0] - GR_W) * s:.2f}" height="{(b[3] - b[1] - GR_W) * s:.2f}" '
                     f'fill="none" stroke="#1f5fa8" stroke-width="{GR_W * s}"/>')
        if name in GUARD_RINGS:  # stage name above the guard ring, the stage is packed full
            e.append(f'<text x="{fx(b[0])}" y="{fy(b[3]) - 3}" font-size="11" font-weight="bold" fill="#1f5fa8">{name}</text>')
        elif kind == "route" and b[3] - b[1] > 3 * (b[2] - b[0]):  # narrow vertical channel -> vertical label
            e.append(f'<text x="{fx(b[0]) + 13}" y="{fy(b[1]) - 6}" font-size="11" font-weight="bold" fill="#222" '
                     f'transform="rotate(-90 {fx(b[0]) + 13} {fy(b[1]) - 6})">{name}</text>')
        else:
            e.append(f'<text x="{fx(b[0]) + 4}" y="{fy(b[3]) + 14}" font-size="12" font-weight="bold" fill="#222">{name}</text>')
    for n, (L_, t_, d, din) in SPIRALS.items():
        x, y = SP_POS[n]
        pts = spiral_path(x + KO[n] / 2, y + KO[n] / 2, d, t_)
        e.append(f'<polyline points="{" ".join(f"{fx(px):.1f},{fy(py):.1f}" for px, py in pts)}" fill="none" '
                 f'stroke="#d9822b" stroke-opacity="0.75" stroke-width="{SP_W * s}" stroke-linejoin="miter"/>')
        e.append(f'<text x="{fx(x + KO[n] / 2)}" y="{fy(y + KO[n] / 2) + 4}" font-size="12" font-weight="bold" '
                 f'text-anchor="middle" fill="#7a3e0c">{L_ * 1e9:.3g} nH</text>')
    for i, c, b in PLACED:
        if c.startswith("MIMC_"):
            m = next(m for m in MIMS if m[0] == i)
            g = MIM_GEOM[i]
            (x0, y0), w, h = m[1], m[2], m[3]
            e.append(rect(b, 'fill="#f5eef8" stroke="#5b2c6f" stroke-width="0.6" stroke-dasharray="3 2"'))  # tile + halo
            e.append(rect(g["bottom_plate"], 'fill="#d2b4de" stroke="#5b2c6f" stroke-width="0.6"'))  # Metal4 incl. tab
            for ld in g["leads"].values():
                e.append(rect(ld, 'fill="#6c3483"'))  # Metal5 leads
            e.append(rect((x0, y0, x0 + w, y0 + h), 'fill="#8e44ad" fill-opacity="0.6"'))  # top plate
            e.append(f'<text x="{fx(x0) + 3}" y="{fy(y0 + h) + 11}" font-size="10" font-weight="bold" fill="white">{i}</text>'
                     f'<text x="{fx(x0) + 3}" y="{fy(y0 + h) + 22}" font-size="9" fill="white">{c_mim(w, h):.2f}p</text>')
        elif c.endswith("_row"):  # FET tile: halo, source / drain bus (Metal2), gate bus (Metal1), PCell row
            d = DEV[c]
            ox, oy = b[0] - d["bbox"][0], b[1] - d["bbox"][1]
            ab = lambda r: (r[0] + ox, r[1] + oy, r[2] + ox, r[3] + oy)
            e.append(rect(b, 'fill="#eafaf1" stroke="#1e8449" stroke-width="0.6" stroke-dasharray="3 2"'))
            e.append(rect(ab(d["row"]), 'fill="#27ae60" fill-opacity="0.8"'))
            e.append(rect(ab(d["buses"]["source"]), 'fill="#8e44ad" fill-opacity="0.35"'))
            e.append(rect(ab(d["buses"]["drain"]), 'fill="#8e44ad" fill-opacity="0.35"'))
            e.append(rect(ab(d["buses"]["gate"]), 'fill="#2e86c1"'))
            e.append(f'<text x="{fx(b[0]) + 2}" y="{fy(b[3]) + 8}" font-size="8" font-weight="bold" '
                     f'fill="#145a32">{i}</text>')
        else:
            e.append(rect(b, 'fill="#7f8c8d"'))
            e.append(f'<text x="{fx(b[2]) + 3}" y="{fy(b[1])}" font-size="9" fill="#444">{i}</text>')
    for name, pts in ROUTES:
        d = " ".join(f"{fx(x):.1f},{fy(y):.1f}" for x, y in pts)
        e.append(f'<polyline points="{d}" fill="none" stroke="#c0392b" stroke-width="2"/>')
    for name, x, y, side in PINS:
        e.append(f'<rect x="{fx(x) - 5}" y="{fy(y) - 5}" width="10" height="10" fill="#c0392b"/>')
        if side == "N":
            e.append(f'<text x="{fx(x) + 4}" y="{fy(y) - 9}" font-size="11" fill="#c0392b" '
                     f'transform="rotate(-90 {fx(x) + 4} {fy(y) - 9})">{name}</text>')
        else:
            e.append(f'<text x="{fx(x) - 8}" y="{fy(y) + 4}" font-size="11" text-anchor="end" fill="#c0392b">{name}</text>')
    e.append(f'<text x="{pad}" y="{pad - 30}" font-size="14" font-weight="bold">lna_core floorplan  {W} x {H} um '
             f'({W * H / 1e6:.3f} mm²) - real PDK device sizes, pins W + N</text>')
    ly = pad_n + H * s + 30
    e.append(f'<rect x="{pad}" y="{ly - 10}" width="14" height="12" fill="none" stroke="#1f5fa8" stroke-width="4"/>'
             f'<text x="{pad + 18}" y="{ly}" font-size="11">P+ guard ring (vss), {GR_W:g} um</text>'

             f'<rect x="{pad + 400}" y="{ly - 10}" width="24" height="12" fill="none" stroke="#d9822b" stroke-dasharray="6 3"/>'
             f'<text x="{pad + 428}" y="{ly}" font-size="11">spiral Metal5 w={SP_W:g} s={SP_S:g} + {SP_KO:g} um keep-out</text>'
             f'<rect x="{pad}" y="{ly + 8}" width="24" height="12" fill="#f5eef8" stroke="#5b2c6f" stroke-dasharray="3 2"/>'
             f'<rect x="{pad + 4}" y="{ly + 10}" width="16" height="8" fill="#d2b4de"/>'
             f'<text x="{pad + 28}" y="{ly + 18}" font-size="11">MIM tile: Metal4 bottom plate + Via4 tab (west), '
             f'Metal5 leads (dark), 1.2 um halo (MIMTM.1, dashed)</text>'
             f'<rect x="{pad}" y="{ly + 26}" width="24" height="12" fill="#eafaf1" stroke="#1e8449" stroke-dasharray="3 2"/>'
             f'<rect x="{pad + 3}" y="{ly + 30}" width="18" height="4" fill="#27ae60"/>'
             f'<text x="{pad + 28}" y="{ly + 36}" font-size="11">FET tile: row (green), gate bus Metal1 (blue), drain bus '
             f'over the row + source bus below in Metal2 (violet, width = Id / 1 mA/um), 2 um bus taps, 1 um halo</text>'
             f'<rect x="{pad}" y="{ly + 44}" width="24" height="12" fill="#fdebd0" stroke="#d4ac0d"/>'
             f'<rect x="{pad + 15}" y="{ly + 45}" width="5" height="5" fill="#af7ac5"/>'
             f'<text x="{pad + 28}" y="{ly + 54}" font-size="11">supply tile 20 x 20 um: M5 + M3 = VDD, M4 + M2 + M1 + SUB = VSS; '
             f'with 4 MIM decaps (M5 VDD / M4 VSS) or plain (vdd trunk)</text>')
    # --- side panel: device list with real sizes ---
    px, py = 2 * pad + W * s, pad
    e.append(f'<text x="{px}" y="{py}" font-size="14" font-weight="bold">Devices (PDK PCells, lna_core.sch)</text>')
    seen = set()
    for i, c, b in PLACED:
        if c in seen:
            continue
        seen.add(c)
        cnt = sum(1 for _, cc, _ in PLACED if cc == c)
        py += 30
        e.append(f'<text x="{px}" y="{py}" font-size="11" font-weight="bold">{c}  {b[2] - b[0]:.1f} x {b[3] - b[1]:.1f} um'
                 f'{f"  x{cnt}" if cnt > 1 else ""}</text>'
                 f'<text x="{px}" y="{py + 14}" font-size="10" fill="#444">{DEV[c]["info"][:80]}</text>')
    py += 40
    e.append(f'<text x="{px}" y="{py}" font-size="14" font-weight="bold">Spirals (modified Wheeler)</text>')
    for n, (L_, t_, d, din) in SPIRALS.items():
        py += 18
        e.append(f'<text x="{px}" y="{py}" font-size="11">{n}: {L_ * 1e9:.3g} nH, n={t_:g}, dout {d:.0f} um, '
                 f'din {din:.0f} um, keep-out box {KO[n]:.0f} um</text>')
    py += 30
    for line in ("not drawn: RLEQ, RLD2, RLD3, Rs, RS_EQ (ideal res.sym = inductor loss models),",
                 "LSHUNT_OUT / RLSHOUT (spice_ignore)"):
        e.append(f'<text x="{px}" y="{py}" font-size="10" fill="#444">{line}</text>')
        py += 14
    e.append("</svg>")
    open(path, "w").write("\n".join(e))


if __name__ == "__main__":
    check_mims()
    check_decap()
    write_json(os.path.join(HERE, "lna_core_floorplan.json"))
    write_gds(os.path.join(HERE, "lna_core_floorplan.gds"))
    write_svg(os.path.join(HERE, "lna_core_floorplan.svg"))
    pg = pg_summary()
    print(f"wrote GDS + JSON + SVG | {W} x {H} um = {W * H / 1e6:.3f} mm^2 | supply tiles {pg['tiles']} "
          f"({pg['area_um2'] / 1e6:.3f} mm^2) -> MIM decap {pg['mim_decap_pF']} pF")
    for n, (L_, t_, d, din) in SPIRALS.items():
        print(f"  {n:4s} {L_ * 1e9:6.3f} nH n={t_:<5g} dout={d:6.1f} din={din:5.1f}")
