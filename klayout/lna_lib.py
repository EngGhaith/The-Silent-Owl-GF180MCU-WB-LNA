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

    def dipped_column(self, x, y0, y1, dip_bands, w=2.0, margin=2.0):
        """vertical Metal5 run from y0 to y1 at (x, x+w) that drops to Metal4 (with real clearance stacks on
        both sides, not just touching at the band edge) across each (lo, hi) in dip_bands -- for threading a
        cross-block lead past a series of known obstructions (e.g. gaps in an inductor's own winding) on a
        fixed grid column, instead of a single bespoke detour per obstruction."""
        y0, y1 = sorted((y0, y1))
        bands = sorted(dip_bands)
        cur = y0
        for lo, hi in bands:
            assert cur <= lo - margin, f"dip band {(lo, hi)} leaves no room after y={cur}"
            if lo - margin > cur:
                self.box("m5", x, cur, x + w, lo - margin)
            self.stack(x, lo - margin, x + w, lo, 4, 5)
            self.box("m4", x, lo, x + w, hi)
            self.stack(x, hi, x + w, hi + margin, 4, 5)
            cur = hi + margin
        assert cur <= y1, f"dip bands extend past y1={y1}"
        if y1 > cur:
            self.box("m5", x, cur, x + w, y1)

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


def _carve(box, avoid, margin=0.5):
    """`box` (x0,y0,x1,y1) minus each (x0,y0,x1,y1) in `avoid`, with real clearance `margin` added around every
    avoid box (never a zero-gap cut -- same lesson as everywhere else in this project: KLayout merges touching
    same-layer shapes regardless of intent). Splits along whichever axis `box` overlaps each avoid box on --
    for a long thin ring-side box, that's normally its own long axis. Returns a list of remaining sub-boxes (0,
    1, or 2 pieces per avoid overlap, applied one avoid box at a time)."""
    pieces = [box]
    for av in avoid:
        ax0, ay0, ax1, ay1 = av
        new_pieces = []
        for px0, py0, px1, py1 in pieces:
            if ax1 <= px0 or ax0 >= px1 or ay1 <= py0 or ay0 >= py1:
                new_pieces.append((px0, py0, px1, py1))  # no overlap with this piece
                continue
            horiz = (px1 - px0) >= (py1 - py0)
            if horiz:
                lo, hi = ax0 - margin, ax1 + margin
                if lo > px0:
                    new_pieces.append((px0, py0, min(lo, px1), py1))
                if hi < px1:
                    new_pieces.append((max(hi, px0), py0, px1, py1))
            else:
                lo, hi = ay0 - margin, ay1 + margin
                if lo > py0:
                    new_pieces.append((px0, py0, px1, min(lo, py1)))
                if hi < py1:
                    new_pieces.append((px0, max(hi, py0), px1, py1))
        pieces = new_pieces
    return pieces


RING_ISL = 1.0  # stepping-stone island half-size (2x2um islands) -- smaller than the real
# vss_m1m2m4_vdd_m3m5_10x10/20x20.gds supply tiles' own COL_HALF=2.0 (4x4um), by request: a 2x2um island at
# enc=0.15 (below) holds a 3x3 via/contact array (Cell.cuts()'s own VIA=0.26/VIA_SP=0.36, CO=0.22/CO_SP=0.28
# defaults), not that tile's own 6x6.
RING_GAP = 2.0  # same-layer isolation: an island vs. the ring's own continuous plane on that layer, AND the
# real clearance between one group's island and the next (alternating type) group's island -- by request, a
# generous real distance, not just the bare M#.2a minimum (0.23-0.28um) the real supply tile's own GAP used.
RING_PITCH = 2 * RING_ISL + RING_GAP  # centre-to-centre spacing between adjacent groups at this GAP -- the
# densest packing the GAP allows, filling the whole perimeter continuously (by request: every group immediately
# followed by the next, not the old sparse ~20um-pitch stitch)
RING_GAP_FIT = 0.3  # same-layer isolation CROSSWISE (island vs. the ring's own plane to either side, across the
# wall's own thickness w) -- unlike RING_GAP, this one is not a requested design distance, just the ordinary
# M#.2a min-space (0.28um) + a hair of margin, since nothing requires extra real room in this direction (the
# island only needs to clear the wall's own inner/outer edge by a DRC-legal amount, not RING_GAP's own 2um)


def _dreg(ly, b):
    """pya.Region of exactly box b=(x0,y0,x1,y1) [um], DBU-exact"""
    return pya.Region(pya.DBox(*b).to_itype(ly.dbu))


def coil_guard_ring(cell, cx, cy, geo, rot=0, w=6.0, sp=1.0, avoid=(), outer_half=None):
    """grid-compliant vss+vdd ring directly around a coil, mimicking the real, DRC-clean
    vss_m1m2m4_vdd_m3m5_10x10/20x20.gds supply tiles' own stepping-stone recipe (layout/floorplan/cells/
    make_pg_plain_10x10.py) rather than instantiating them: M1, M2 and M5 are solid continuous planes around the
    full ring (M1/M2 = vss, M5 = vdd); M3 (main plane = vdd) and M4 (main plane = vss) are each the same solid
    ring with small holes punched wherever the OTHER polarity needs a stepping-stone island through them -- a
    hole drawn ON TOP of a solid plane on the SAME layer just re-merges into it (no separate net), so the hole
    must be a real Region subtraction, sized up by RING_GAP past the island on every side, exactly like the
    real tile.

    Every RING_PITCH um around the full perimeter (continuing across every side and every avoid-carved piece,
    so the whole ring is one continuous OOO-XXX-OOO-XXX... sequence, never per-side independent, and never a
    sparse stitch -- groups pack back to back at the tightest spacing RING_GAP allows), one alternating group:
      - vss group ("O"): a 2x2um Metal3 island (disjoint from the main Metal3=vdd plane) with Via1 (M1<->M2),
        Via2 (M2<->island) and Via3 (island<->M4 main), each a 3x3 array -- stitches M1-M2-M4 (vss) straight
        through the vdd plane without ever touching it -- plus a COMP+PPLUS substrate tap (3x3 contact array
        -> M1) at the same 2x2um footprint, same layer convention as the supply tiles' own west/east columns.
      - vdd group ("X"): a 2x2um Metal4 island (disjoint from the main Metal4=vss plane) with Via3 (M3 main
        <->island) and Via4 (island<->M5 main), each a 3x3 array -- stitches M3-M5 (vdd) through the vss plane.
    A piece too short for even one group (less than one island's own footprint + clearance on both ends) is
    left as plain unbroken metal on every layer -- no DRC rule requires stitching density beyond each cut's
    own minimum, this only skips the *extra* redundancy, never the ring's own base conductivity (every layer
    is still a continuous plane end to end regardless of how many groups land on it).

    `w` is the ring's own wall thickness -- must be wide enough for a centred 2x2um island with real clearance
    to the ring's own inner/outer edge (checked below); 6.0 is this project's own wall thickness for this ring.
    `sp` is a small REAL clearance (GF180 M#.2a min-space is 0.23-0.28um; this project's old SP_KO/SPIRAL_KO=10
    was a self-imposed empirical margin against generic-tile proximity, not a PDK floor -- see make_lna_core_
    layouts.py's own SPIRAL_KO bisection comment) from the coil's own true extent (geo["rx"]/["ry"], which
    already accounts for its winding + inner-port M3/M4 underpass + port pads, per coil_geom()'s docstring) to
    the ring's own inner edge.

    rot must match the coil's own place_coil() rotation (mirror doesn't affect axis mapping, only a +-90
    rotation swaps which of rx/ry is the world-X vs world-Y half-extent -- same convention as every fit-assert
    in make_lna_core_layouts.py).

    `avoid`: (x0,y0,x1,y1) world-coordinate boxes (with real margin added automatically, see _carve()) where the
    ring must leave NO metal on any layer -- for a pre-existing crossing that tunnels through M1..M4 at this
    exact (x,y) (e.g. another block's own dipped_column() dip-band), which blocks every layer the ring would
    otherwise occupy there. Confirmed necessary, not hypothetical: output_match's own rf_out_pad crossing at
    L1's site did exactly this and produced a real LVS short (rf_out_pad merging into vss) before this param
    existed.

    Returns (clear, outer): each (x0, y0, x1, y1) in world coords. `clear` is the coil's own real keep-out
    boundary (nothing but this ring's own metal may enter clear..outer); `outer` is the ring's own outer edge --
    what make_lna_core_parts.py should let tile sites touch directly (not stay SPIRAL_KO away from)."""
    assert w >= 2 * RING_ISL + 2 * RING_GAP_FIT, f"ring wall w={w} too thin for a {2 * RING_ISL}um island + clearance"
    rx, ry = geo["rx"], geo["ry"]
    wx, wy = (ry, rx) if round(rot / 90) % 2 == 1 else (rx, ry)
    # `clear`: boundary between the coil's own true extent (+ small real gap `sp`) and the ring's own metal --
    # nothing may occupy clear..outer except this ring.
    clear = (cx - wx - sp, cy - wy - sp, cx + wx + sp, cy + wy + sp)
    if outer_half is not None:
        # pin the ring's own OUTER edge directly to the real, EM-simulated outer dimension (local half-extents,
        # same rot-swap convention as geo["rx"]/["ry"]) instead of deriving it from sp -- the coil's own small
        # via-landing pads (inter-layer stitches inside the winding) can poke slightly past the generic sp
        # clearance in a few spots without changing the ring's own real outer footprint; those spots need an
        # `avoid` notch (see module doc), not a bigger sp pushing the whole ring further out.
        ox, oy = outer_half
        owx, owy = (oy, ox) if round(rot / 90) % 2 == 1 else (ox, oy)
        outer = (cx - owx, cy - owy, cx + owx, cy + owy)
        # `clear` must track the PINNED outer (inset by the real wall thickness w), not the old rx+sp formula --
        # otherwise it can numerically coincide with `outer` itself (confirmed: geo["rx"]+sp landed exactly on
        # outer_half for 3 of 4 coils here), collapsing the reported ring_inner/ring_outer to the same box and
        # silently zeroing out any ring-band-region computation downstream (e.g. the lna_top2.gds surgical
        # replacement script, which lost its whole insert region for exactly this reason).
        clear = (outer[0] + w, outer[1] + w, outer[2] - w, outer[3] - w)
    else:
        outer = (clear[0] - w, clear[1] - w, clear[2] + w, clear[3] + w)
    x0, y0, x1, y1 = outer
    sides = [(x0, y0, x1, y0 + w), (x0, y1 - w, x1, y1), (x0, y0 + w, x0 + w, y1 - w), (x1 - w, y0 + w, x1, y1 - w)]
    min_piece = 0.3  # drop a carved sliver this thin or thinner -- not wide enough for a real group anyway
    min_fit = 2 * RING_ISL + 2 * RING_GAP  # shortest piece that can hold even one centred group
    min_sep = 2 * RING_ISL + RING_GAP  # shortest safe centre-to-centre spacing between adjacent groups
    ly = cell.ly
    gap_dbu = int(round(RING_GAP / ly.dbu))  # along-ring: the requested 2um inter-group distance
    fit_dbu = int(round(RING_GAP_FIT / ly.dbu))  # crosswise: plain DRC-legal clearance, not a design distance
    pe = 0.2  # PPLUS enclosure of COMP, same as guard_ring()'s own pe
    grp_idx = 0  # global alternation counter -- continues across every side/piece so the whole perimeter is
    # one single OOO-XXX-OOO-XXX... sequence, never reset per side
    for i, b in enumerate(sides):
        for p in (_carve(b, avoid) if avoid else [b]):
            if p[2] - p[0] <= min_piece or p[3] - p[1] <= min_piece:
                continue  # carved down to nothing (or a sliver) by an `avoid` box -- leave the gap bare
            cell.box("m1", *p)
            cell.box("m2", *p)
            cell.box("m5", *p)
            horiz = (p[2] - p[0]) >= (p[3] - p[1])
            cross_mid = (p[1] + p[3]) / 2 if horiz else (p[0] + p[2]) / 2
            # Group PLACEMENT range: only a horizontal (bottom/top) side owns the ring's 4 true outer corners
            # (its own box spans the full outer width, corners included -- a vertical side's box already starts
            # /ends short of them, see `sides` above), so only a horizontal side's own TRUE ends (not an
            # avoid-carved piece's inner cut edge) get trimmed back by one full wall thickness `w`: that leaves
            # every w x w corner square solid/unholed on every layer, on both sides of the corner, so whatever
            # pattern the adjoining vertical side draws right next to it always meets a plain straight edge
            # there instead of a jagged, DRC-illegal notch (confirmed real, not hypothetical: an earlier version
            # without this trim produced real M3.1/M3.2a/M4.1/M4.2a violations at all 4 corners of every ring).
            if horiz:
                lo = p[0] + w if abs(p[0] - b[0]) < 1e-6 else p[0]
                hi = p[2] - w if abs(p[2] - b[2]) < 1e-6 else p[2]
            else:
                lo, hi = p[1], p[3]
            length = hi - lo
            a_boxes, b_boxes = [], []
            if length >= min_fit:
                avail = length - 2 * RING_ISL  # room for a group centre to range over
                # floor, not round: guarantees the n+1 evenly-spread centres below are >= min_sep apart by
                # construction (avail/n >= min_sep whenever n <= avail/min_sep) -- RING_PITCH itself sits
                # exactly AT min_sep (densest packing), so round()-ing length/RING_PITCH was landing on the
                # wrong side of that threshold from floating-point noise alone, collapsing every long piece to
                # a single centred group instead of packing it densely.
                n = max(1, int(avail / min_sep + 1e-9))
                ts = [0.5] if n == 1 else [k / n for k in range(n + 1)]
                for t in ts:
                    ctr = lo + RING_ISL + t * avail
                    if horiz:
                        gbox = (ctr - RING_ISL, cross_mid - RING_ISL, ctr + RING_ISL, cross_mid + RING_ISL)
                    else:
                        gbox = (cross_mid - RING_ISL, ctr - RING_ISL, cross_mid + RING_ISL, ctr + RING_ISL)
                    (a_boxes if grp_idx % 2 == 0 else b_boxes).append(gbox)
                    grp_idx += 1
            else:
                grp_idx += 1  # keep the OOO-XXX phase consistent even where no group fits this piece
            # hole oversize is axis-aware: RING_GAP (the requested 2um) along the ring's own long axis, where a
            # hole's enlargement eats into the SAME continuous plane the next group's hole also eats into --
            # RING_GAP_FIT (plain DRC clearance) crosswise, where it only has to clear the wall's own edge.
            ax, ay = (gap_dbu, fit_dbu) if horiz else (fit_dbu, gap_dbu)
            base = _dreg(ly, p)
            holes_a, holes_b = pya.Region(), pya.Region()
            for gb in a_boxes:
                holes_a += _dreg(ly, gb).sized(ax, ay)
            for gb in b_boxes:
                holes_b += _dreg(ly, gb).sized(ax, ay)
            cell.c.shapes(cell.li("m3")).insert(base - holes_a)
            cell.c.shapes(cell.li("m4")).insert(base - holes_b)
            for gb in a_boxes:  # vss stepping stone: M2 <-> M4 through an isolated M3 island, + substrate tap
                cell.box("m3", *gb)
                cell.cuts("v1", *gb, enc=0.15)
                cell.cuts("v2", *gb, enc=0.15)
                cell.cuts("v3", *gb, enc=0.15)
                cell.box("comp", *gb)
                cell.cuts("cont", *gb, enc=0.15, sz=CO, sp=CO_SP)
                cell.box("pplus", gb[0] - pe, gb[1] - pe, gb[2] + pe, gb[3] + pe)
            for gb in b_boxes:  # vdd stepping stone: M3 <-> M5 through an isolated M4 island
                cell.box("m4", *gb)
                cell.cuts("v3", *gb, enc=0.15)
                cell.cuts("v4", *gb, enc=0.15)
    cell.label(1, "vss", (x0 + x1) / 2, y0 + w / 2)
    cell.label(3, "vdd", (x0 + x1) / 2, y1 - w / 2)
    return clear, outer


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


# ---------------------------------------------------------------- EM-characterised coils (klayout/*_coil.gds)
COIL_MARK = {"ind": (151, 5), "p1": (201, 0), "p2": (202, 0)}  # IND_MK, port 1 / port 2 markers of the EM setup
COIL_KEEP = (151, 201, 202, 110)  # marker layers (IND_MK, ports, metal resistor markers) are never trimmed


def _coil_read(path):
    """coil layout with the EM-only parts removed, + geometry (um, coil coordinates): the coils come with a Metal4 +
    Metal5 bracket east of the ports (EM port return) that shorts port 1 and port 2 -> every shape of the top cell
    at or beyond the port edge pe is dropped, and the text labels too (the block draws its own)"""
    src = pya.Layout()
    src.read(path)
    t = src.top_cell()
    mk = {k: pya.Region(t.begin_shapes_rec(src.layer(*v))).bbox().to_dtype(src.dbu) for k, v in COIL_MARK.items()}
    pe = mk["p1"].right
    assert abs(mk["p2"].right - pe) < 1e-6, f"{path}: ports not on one edge"
    for li in src.layer_indexes():
        keep = src.get_info(li).layer in COIL_KEEP
        for c in src.each_cell():
            for s in list(c.shapes(li).each()):
                if s.is_text() or (c.cell_index() == t.cell_index() and not keep and s.dbbox().left >= pe - 1e-6):
                    s.delete()
    b = t.dbbox()
    rx, ry = max(abs(b.left), b.right), max(abs(b.bottom), b.top)
    geo = {"pe": pe, "p1": (mk["p1"].bottom, mk["p1"].top), "p2": (mk["p2"].bottom, mk["p2"].top),
           "r": max(rx, ry), "rx": rx, "ry": ry}
    return src, geo


def coil_geom(path):
    """geometry of a coil (see _coil_read): pe = port edge x, p1 / p2 = (y0, y1) of the ports, r = half size (max
    of rx/ry, kept for square coils / generic keep-out checks), rx / ry = half-extent along x / y separately (a
    square coil has rx == ry == r; a rectangular one -- e.g. LEQ_MAIN_RECT -- does not, callers that check a
    placement fit against a specific axis must use rx or ry, not r)"""
    return _coil_read(path)[1]


def coil(ly, name, path):
    """coil as static cell `name` (sub cells renamed <name>__*), origin = coil centre, ports on the east edge"""
    src, geo = _coil_read(path)
    t = src.top_cell()
    for c in src.each_cell():
        if c.cell_index() != t.cell_index():
            c.name = f"{name}__{c.name}"
    dst = ly.create_cell(name)
    dst.copy_tree(t)
    return dst, geo


def coil_ports(t, geo, stub=3.5):
    """(port 1, port 2) Metal5 stubs at port width from the port edge `stub` outwards, through the placement t.
    The outer winding reaches 0.5 um past the port edge: wide leads may start 3 um past it (the last 0.5 um of the
    stub), 2.5 um clear of the winding"""
    pe = geo["pe"]
    return tuple(tbox(t, (pe, y0, pe + stub, y1)) for y0, y1 in (geo["p1"], geo["p2"]))


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
