"""
Shared layout helpers for the lna_core sub-cell layouts (run inside KLayout python, see make_lna_core_layouts.py).

Units: um, dbu = 1 nm, everything snapped to the 5 nm manufacturing grid.
Metal levels 1..5 = Metal1..Metal5 (Metal5 = top metal of the 5LM / MIM-B stack of gf180mcuD).
"""
import math
import os
import sys

import pya

sys.path.insert(0, "/foss/pdks/gf180mcuD/libs.tech/klayout/tech/pymacros")
import cells as pdk_cells  # noqa: E402  (gf180mcu PCell library)

LAYERS = {
    "comp": (22, 0), "poly": (30, 0), "pplus": (31, 0), "nplus": (32, 0), "cont": (33, 0), "dualgate": (55, 0),
    "m1": (34, 0), "v1": (35, 0), "m2": (36, 0), "v2": (38, 0), "m3": (42, 0), "v3": (40, 0), "m4": (46, 0),
    "v4": (41, 0), "m5": (81, 0), "fusetop": (75, 0), "prb": (0, 0), "ind_mk": (151, 5),
    "m1_lbl": (34, 10), "m2_lbl": (36, 10), "m3_lbl": (42, 10), "m4_lbl": (46, 10), "m5_lbl": (81, 10),
}
GRID = 0.005
VIA, VIA_SP = 0.26, 0.36  # Via1..Via4 size, spacing (array rule V*.2b)
CO, CO_SP = 0.22, 0.28  # contact size, spacing (array rule CO.2b)


def g(v):
    """snap to the 5 nm grid"""
    return round(round(v / GRID) * GRID, 4)


def m(k):
    return f"m{k}"


class Cell:
    """thin wrapper around a pya.Cell with um-based drawing helpers"""

    def __init__(self, ly, name):
        self.ly = ly
        self.c = ly.create_cell(name)

    def li(self, lay):
        return self.ly.layer(*LAYERS[lay])

    def box(self, lay, x0, y0, x1, y1):
        x0, x1 = sorted((x0, x1))
        y0, y1 = sorted((y0, y1))
        self.c.shapes(self.li(lay)).insert(pya.DBox(g(x0), g(y0), g(x1), g(y1)))
        return (g(x0), g(y0), g(x1), g(y1))

    def poly(self, lay, dpoly):
        self.c.shapes(self.li(lay)).insert(dpoly)

    def cuts(self, lay, x0, y0, x1, y1, enc=0.1, sz=VIA, sp=VIA_SP):
        """centred array of square cuts (vias / contacts) inside the box minus enclosure"""
        x0, x1 = sorted((x0, x1))
        y0, y1 = sorted((y0, y1))
        w, h = x1 - x0 - 2 * enc, y1 - y0 - 2 * enc
        assert w >= sz - 1e-6 and h >= sz - 1e-6, f"{lay}: box {x0, y0, x1, y1} too small for a cut"
        nx, ny = int((w + sp) / (sz + sp) + 1e-6), int((h + sp) / (sz + sp) + 1e-6)
        sx = g(x0 + (x1 - x0 - (nx * sz + (nx - 1) * sp)) / 2)
        sy = g(y0 + (y1 - y0 - (ny * sz + (ny - 1) * sp)) / 2)
        shp = self.c.shapes(self.li(lay))
        for i in range(nx):
            for j in range(ny):
                x, y = g(sx + i * (sz + sp)), g(sy + j * (sz + sp))
                shp.insert(pya.DBox(x, y, g(x + sz), g(y + sz)))
        return nx * ny

    def stack(self, x0, y0, x1, y1, lo, hi, enc=0.1):
        """metal lo..hi on the box + via arrays between each pair of neighbouring levels"""
        for k in range(lo, hi + 1):
            self.box(m(k), x0, y0, x1, y1)
        for k in range(lo, hi):
            self.cuts(f"v{k}", x0, y0, x1, y1, enc)

    def wire(self, lay, pts, w):
        """manhattan wire of width w through pts (each segment as a box, ends extended by w/2)"""
        for (xa, ya), (xb, yb) in zip(pts, pts[1:]):
            assert xa == xb or ya == yb, f"non-manhattan segment {(xa, ya)} -> {(xb, yb)}"
            self.box(lay, min(xa, xb) - w / 2, min(ya, yb) - w / 2, max(xa, xb) + w / 2, max(ya, yb) + w / 2)

    def label(self, lvl, text, x, y):
        self.c.shapes(self.li(f"m{lvl}_lbl")).insert(pya.DText(text, g(x), g(y)))

    def place(self, child, x=0.0, y=0.0, rot=0, mirror=False):
        """instance of child (pya.Cell or Cell), rot in degrees (multiple of 90), mirror = about the x axis first"""
        cc = child.c if isinstance(child, Cell) else child
        t = pya.DCplxTrans(1.0, rot, mirror, g(x), g(y))
        self.c.insert(pya.DCellInstArray(cc.cell_index(), t))
        return t


def tbox(t, b):
    """transform an (x0, y0, x1, y1) box with a DCplxTrans"""
    r = t * pya.DBox(*b)
    return (g(r.left), g(r.bottom), g(r.right), g(r.top))


# ---------------------------------------------------------------- PCells
_registered = False


def pcell(ly, name, pc, params):
    """flat copy of a gf180mcu PCell as static cell `name`"""
    global _registered
    if not _registered:
        pdk_cells.gf180mcu()
        _registered = True
    v = ly.create_cell(pc, "gf180mcu", params)
    assert v is not None and not v.dbbox().empty(), f"PCell {pc} {params} failed"
    c = ly.create_cell(name)
    c.insert(pya.CellInstArray(v.cell_index(), pya.Trans()))
    c.flatten(True)
    snap_cell(c)
    return c


def snap_cell(c, grid=5):
    """put off-grid PCell shapes on the 5 nm grid (gf180mcu nfet gate pads sit at x.289 / x.671 um, MIM via arrays
    of odd plate sizes are off grid): boxes with an on-grid size are shifted down-left, other boxes grow outwards
    to the grid, other polygons are rounded point by point"""
    up = lambda v: -((-v) // grid) * grid
    dn = lambda v: (v // grid) * grid
    for li in c.layout().layer_indexes():
        for s in list(c.shapes(li).each()):
            if s.is_box():
                b = s.box
                if b.left % grid or b.right % grid or b.bottom % grid or b.top % grid:
                    # on-grid size (e.g. 0.26 um vias of an off-grid array): shift down-left, keeps size and pitch
                    x0, y0 = dn(b.left), dn(b.bottom)
                    x1 = x0 + b.width() if b.width() % grid == 0 else up(b.right)
                    y1 = y0 + b.height() if b.height() % grid == 0 else up(b.top)
                    s.box = pya.Box(x0, y0, x1, y1)
            elif s.is_polygon() or s.is_path():
                p = s.polygon
                if any(pt.x % grid or pt.y % grid for pt in p.each_point_hull()):
                    s.polygon = pya.Polygon(
                        [pya.Point(round(pt.x / grid) * grid, round(pt.y / grid) * grid) for pt in p.each_point_hull()])


def merged_boxes(cell, lay, ly):
    r = pya.Region(cell.begin_shapes_rec(ly.layer(*LAYERS[lay]))).merged()
    return [p.bbox().to_dtype(ly.dbu) for p in r.each()]


# ---------------------------------------------------------------- FET tile
def fet_tile(ly, name, volt, wf, l, n_act, n_dum, ws, wd, ext=3.0, gb=1.0, gap_s=1.0, gap_d=0.8, draw_s=True):
    """
    One nfet row (PCell, shared diffusion, gate contacts on top) wired as a tile:
      fingers   n_dum dummies | n_act active | n_dum dummies; all diffusions of the dummies = source net
      gate      Metal1 bar (gb high) over the active gate contacts, strapped to a Metal3 gate strap via Via1/Via2
                landings above the inner source diffusions; dummy gates: separate Metal1 bars, run out to the tile ends
      source    Via1 + Metal2 drop from every source diffusion to the source bus below the row
      drain     Via1 + Metal2 riser from every drain diffusion (crossing the gate bar) to the drain bus above
      buses     Metal2 + Metal3 (Via2 array), source ws / drain wd high, from x0 to x1 (row +- ext);
                draw_s=False leaves the source bus out (it is the drain bus of the row below, cascode stack)
    Returns (cell, terminals) with terminal boxes in tile coordinates:
      S, D (Metal2+3 buses), G (Metal3 strap), DGL / DGR (Metal1 dummy-gate bar ends), row (PCell bbox)
    """
    nf = n_act + 2 * n_dum
    params = {"volt": volt, "w_gate": wf, "l_gate": l, "nf": nf, "bulk": "None", "gate_con_pos": "top"}
    row = pcell(ly, f"{name}_pcell", "nfet", params)
    t = Cell(ly, name)
    t.c.insert(pya.CellInstArray(row.cell_index(), pya.Trans()))
    m1 = merged_boxes(row, "m1", ly)
    strips = sorted([b for b in m1 if b.top < wf], key=lambda b: b.left)
    pads = sorted([b for b in m1 if b.bottom > wf], key=lambda b: b.left)
    assert len(strips) == nf + 1 and len(pads) == nf, (len(strips), len(pads), nf)

    def role(i):
        if i <= n_dum or i >= nf - n_dum:
            return "S"
        return "S" if (i - n_dum) % 2 == 0 else "D"

    rb = row.dbbox()
    x0, x1 = g(rb.left - ext), g(rb.right + ext)
    pb0 = pads[0].bottom
    gtop = g(pb0 + gb)
    ys0, ys1 = g(-gap_s - ws), -gap_s
    yd0 = g(gtop + gap_d)
    yd1 = g(yd0 + wd)
    act = pads[n_dum:nf - n_dum]
    t.box("m1", act[0].left, pb0, act[-1].right, gtop)
    t.box("m1", x0, pb0, pads[n_dum - 1].right, gtop)
    t.box("m1", pads[nf - n_dum].left, pb0, x1, gtop)
    for i, s in enumerate(strips):
        t.cuts("v1", s.left, s.bottom, s.right, s.top, enc=0.06)
        if role(i) == "S":
            t.box("m2", s.left, ys1 - 0.5, s.right, s.top)
        else:
            t.box("m2", s.left, s.bottom, s.right, yd0 + 0.5)
        if role(i) == "S" and n_dum < i < nf - n_dum:  # gate landing above an inner source diffusion
            t.box("m2", s.left, pb0, s.right, gtop)
            t.cuts("v1", s.left, pb0, s.right, gtop, enc=0.06)
            t.cuts("v2", s.left, pb0, s.right, gtop, enc=0.06)
    t.box("m3", x0, pb0, x1, gtop)
    if draw_s:
        t.stack(x0, ys0, x1, ys1, 2, 3)
    t.stack(x0, yd0, x1, yd1, 2, 3)
    term = {"S": (x0, ys0, x1, ys1), "D": (x0, yd0, x1, yd1), "G": (x0, g(pb0), x1, gtop),
            "DGL": (x0, g(pb0), g(x0 + 1), gtop), "DGR": (g(x1 - 1), g(pb0), x1, gtop),
            "row": (g(rb.left), g(rb.bottom), g(rb.right), g(rb.top)), "nf": nf}
    return t, term


# ---------------------------------------------------------------- guard ring
def guard_ring(cell, x0, y0, x1, y1, w=0.8, m2=True):
    """P+ substrate tap ring (COMP + PPLUS + contacts + Metal1 [+ Metal2 with Via1]) with outer box x0..y1"""
    pe = 0.2  # PPLUS enclosure of COMP
    sides = [(x0, y0, x1, y0 + w), (x0, y1 - w, x1, y1), (x0, y0 + w, x0 + w, y1 - w), (x1 - w, y0 + w, x1, y1 - w)]
    for b in sides:
        cell.box("comp", *b)
        cell.box("m1", *b)
        if m2:
            cell.box("m2", *b)
    cell.box("pplus", x0 - pe, y0 - pe, x1 + pe, y0 + w + pe)
    cell.box("pplus", x0 - pe, y1 - w - pe, x1 + pe, y1 + pe)
    cell.box("pplus", x0 - pe, y0 + w, x0 + w + pe, y1 - w)
    cell.box("pplus", x1 - w - pe, y0 + w, x1 + pe, y1 - w)
    for i, b in enumerate(sides):  # contacts / vias, vertical sides without the corners
        bx = b if i < 2 else (b[0], b[1] + 0.3, b[2], b[3] - 0.3)
        cell.cuts("cont", *bx, enc=0.15, sz=CO, sp=CO_SP)
        if m2:
            cell.cuts("v1", *bx, enc=0.15)


# ---------------------------------------------------------------- MIM tile
MIM_ENC, MIM_HALO = 0.6, 1.2
TAB_M4, TAB_STRAP, TAB_VIA_X = -3.4, (-3.0, -1.0), (-2.53, -1.73)


def mim_tile(ly, name, w, l):
    """
    cap_mim (MIM-B, Metal4 bottom plate / FuseTop top plate, Metal5 on top) + bottom-plate contact tab on the west
    (Metal4 tab, 2 Via4 columns, Metal5 strap). Local origin = lower-left of the top plate.
    terminals: top = Metal5 over the top plate, bot = Metal5 strap of the bottom plate,
               bp = bottom plate incl. tab (Metal4), halo = bp + 1.2 um (no other Metal4 inside, MIMTM.1)
    """
    pc = pcell(ly, f"{name}_pcell", "cap_mim", {"mim_option": "MIM-B", "metal_level": "M5", "wc": w, "lc": l})
    t = Cell(ly, name)
    t.c.insert(pya.CellInstArray(pc.cell_index(), pya.Trans()))
    t.box("m4", TAB_M4, -MIM_ENC, 0, l + MIM_ENC)
    n = int((l - 2 * 0.4 - VIA) / (VIA + VIA_SP)) + 1
    vy0 = (l - (n - 1) * (VIA + VIA_SP) - VIA) / 2
    for vx in TAB_VIA_X:
        for i in range(n):
            y = g(vy0 + i * (VIA + VIA_SP))
            t.box("v4", vx, y, vx + VIA, y + VIA)
    t.box("m5", TAB_STRAP[0], 0, TAB_STRAP[1], l)
    bp = (TAB_M4, -MIM_ENC, g(w + MIM_ENC), g(l + MIM_ENC))
    term = {"top": (0, 0, g(w), g(l)), "bot": (TAB_STRAP[0], 0, TAB_STRAP[1], g(l)), "bp": bp,
            "halo": (bp[0] - MIM_HALO, bp[1] - MIM_HALO, bp[2] + MIM_HALO, bp[3] + MIM_HALO)}
    return t, term


def c_mim_pf(w, l):
    """cap_mim_2f0_m4m5_noshield, typ: 1.99 fF/um^2 + 0.2383 fF/um perimeter"""
    return (1.99 * w * l + 0.2383 * 2 * (w + l)) / 1000


# ---------------------------------------------------------------- spiral inductor
def spiral_points(dout, n, w, s):
    """centre line of a square spiral around (0, 0): start at the outer top-left corner, clockwise inwards"""
    a, p = dout / 2 - w / 2, w + s
    pts, (x, y) = [(-a, a)], (-a, a)
    for k in range(round(4 * n)):
        ln = 2 * a - (max(k - 1, 0) // 2) * p
        assert ln > w, "spiral does not fit"
        dx, dy = [(1, 0), (0, -1), (-1, 0), (0, 1)][k % 4]
        x, y = x + dx * ln, y + dy * ln
        pts.append((x, y))
    return [(g(x), g(y)) for x, y in pts]


def spiral(ly, name, dout, n, w=10.0, s=3.0, under="S", lead=0.0, exit_gap=3.0):
    """
    square Metal5 spiral (centre at the local origin), outer terminal at the top-left corner (winding starts there
    heading east; `lead` extends it west), inner terminal brought out on a Metal4 + Metal3 underpass in direction
    `under` (N/S/E/W) to a w x w Metal5 pad exit_gap outside the outer winding.
    terminals: outer / inner = w x w Metal5 pads, centre line points in `pts`
    """
    t = Cell(ly, name)
    pts = spiral_points(dout, n, w, s)
    if lead:
        pts = [(g(pts[0][0] - lead), pts[0][1])] + pts
    path = pya.DPath([pya.DPoint(*p) for p in pts], w, w / 2, w / 2)
    t.poly("m5", path.polygon())
    xi, yi = pts[-1]
    h = w / 2
    r = g(dout / 2 + exit_gap + h)  # centre of the exit pad, measured from the spiral centre
    ex, ey = {"N": (xi, r), "S": (xi, -r), "E": (r, yi), "W": (-r, yi)}[under]
    ub = (min(xi, ex) - h, min(yi, ey) - h, max(xi, ex) + h, max(yi, ey) + h)
    t.box("m4", *ub)
    t.box("m3", *ub)
    for (cx, cy) in ((xi, yi), (ex, ey)):
        t.stack(cx - h, cy - h, cx + h, cy + h, 3, 5)
    xo, yo = pts[0]
    term = {"outer": (g(xo - h), g(yo - h), g(xo + h), g(yo + h)), "inner": (g(ex - h), g(ey - h), g(ex + h), g(ey + h)),
            "pts": pts, "underpass": ub}
    return t, term


# ---------------------------------------------------------------- reports
def write_png(gds, png, w=1600, h=1200, box=None):
    """render a GDS with the PDK layer properties (needs a KLayout with Qt / LayoutView)"""
    lv = pya.LayoutView()
    lv.load_layout(gds, True)
    lyp = "/foss/pdks/gf180mcuD/libs.tech/klayout/tech/gf180mcu.lyp"
    if os.path.exists(lyp):
        lv.load_layer_props(lyp)
    lv.max_hier()
    if box:
        lv.zoom_box(pya.DBox(*box))
    else:
        lv.zoom_fit()
    lv.save_image(png, w, h)
