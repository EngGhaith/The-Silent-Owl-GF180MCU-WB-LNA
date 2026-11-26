"""Render one of the two substrate-tie fixes, highlighting what it adds.

  A  lna_core_parts_fixed.gds  -- four tap shapes drawn directly in the top cell.
     The shapes coincide with ones already inside lna_core_supply, so geometrically
     nothing changes; what changes is OWNERSHIP. Highlight = shapes owned by the top
     cell itself (cell.shapes, not recursive).

  B  lna_core_parts_rdum.gds   -- a real ppolyf_u_1k device instantiated in the top
     cell. Highlight = geometry present here and absent from the base layout.

usage: python3 lvs/render_fix.py A|B out.png xlo ylo xhi yhi
"""
import sys

import klayout.db as kdb
from PIL import Image, ImageDraw, ImageFont

MODE, OUT = sys.argv[1], sys.argv[2]
win = [float(v) for v in sys.argv[3:7]]
BASE = "klayout/lna_core_parts_viafix.gds"
SRC = {"A": "klayout/lna_core_parts_fixed.gds",
       "B": "klayout/lna_core_parts_rdum.gds"}[MODE]
if len(sys.argv) > 7:                     # render a different build of the same fix
    SRC = sys.argv[7]
W_PX, PAD, BAR = 1400, 12, 76

# context is drawn bottom-up and kept deliberately dark, so the highlight reads on top
CTX = [((22, 0), (26, 54, 40), "COMP"), ((31, 0), (52, 48, 24), "pplus"),
       ((30, 0), (58, 30, 50), "poly2"), ((110, 5), (44, 44, 72), "RES_MK"),
       ((33, 0), (62, 62, 68), "contact"), ((34, 0), (36, 44, 66), "M1"),
       ((36, 0), (40, 52, 62), "M2"), ((42, 0), (58, 52, 38), "M3"),
       ((46, 0), (56, 44, 38), "M4"), ((81, 0), (64, 38, 44), "M5")]
# (layer, colour, name, outline-only?) -- lower layers filled, M1/markers outlined so the
# stack underneath stays visible
HL = [((22, 0), (90, 255, 160), "COMP", False), ((31, 0), (255, 240, 90), "pplus", True),
      ((30, 0), (255, 110, 220), "poly2", False), ((33, 0), (255, 255, 255), "contact", False),
      ((110, 5), (255, 160, 60), "RES_MK", True), ((34, 0), (120, 190, 255), "M1", True)]

ly = kdb.Layout(); ly.read(SRC)
dbu = ly.dbu
U = lambda v: int(round(v / dbu))
top = ly.cell("lna_core_parts")
box = kdb.Box(U(win[0]), U(win[1]), U(win[2]), U(win[3]))
sx = (W_PX - 2 * PAD) / (win[2] - win[0])
H = int((win[3] - win[1]) * sx) + 2 * PAD + BAR
img = Image.new("RGB", (W_PX, H), (13, 14, 18))
dr = ImageDraw.Draw(img, "RGBA")
xf = lambda x, y: (PAD + (x - win[0]) * sx, BAR + PAD + (win[3] - y) * sx)


def paint(r, col, outline=False):
    n = 0
    for p in (r & kdb.Region(box)).each():
        pts = [xf(v.x * dbu, v.y * dbu) for v in p.to_simple_polygon().each_point()]
        if len(pts) >= 3:
            if outline:
                dr.line(pts + [pts[0]], fill=col, width=3)
            else:
                dr.polygon(pts, fill=col)
            n += 1
    return n


for (num, dt), col, _ in CTX:
    i = ly.find_layer(num, dt)
    if i is None:
        continue
    r = kdb.Region(top.begin_shapes_rec(i)); r.merge()
    paint(r, col + (255,))

base = kdb.Layout(); base.read(BASE)
btop = base.cell("lna_core_parts")
counts = {}
for (num, dt), col, name, outline in HL:
    i = ly.find_layer(num, dt)
    if i is None:
        continue
    if MODE == "A":
        hl = kdb.Region(top.shapes(i))                 # owned by the top cell itself
    else:
        bi = base.find_layer(num, dt)
        bb = kdb.Region(btop.begin_shapes_rec(bi)) if bi is not None else kdb.Region()
        bb.merge()
        cur = kdb.Region(top.begin_shapes_rec(i)); cur.merge()
        hl = (cur - bb)                                # geometry this layout adds
    hl.merge()
    counts[name] = paint(hl, col + (255,), outline)

try:
    f1 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 19)
    f2 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 13)
except Exception:
    f1 = f2 = ImageFont.load_default()
title = ("A -- substrate tap owned by lna_core_parts (duplicate geometry, schematic unchanged)"
         if MODE == "A" else
         "B -- dummy ppolyf_u_1k in lna_core_parts, both terminals on the vss plane")
dr.text((PAD, 5), f"{title}", font=f1, fill=(240, 240, 240))
dr.text((PAD, 28), f"{SRC.split('/')[-1]}   window x {win[0]:.1f}..{win[2]:.1f}  "
                   f"y {win[1]:.1f}..{win[3]:.1f} um   "
                   f"(muted = surrounding context, bright = the fix)",
        font=f2, fill=(170, 170, 170))
x = PAD
for (num, dt), col, name, outline in HL:
    lbl = f"{name} {counts.get(name, 0)}" + (" (outline)" if outline else "")
    dr.rectangle([x, 50, x + 13, 63], fill=col + (255,))
    dr.text((x + 18, 49), lbl, font=f2, fill=(205, 205, 205))
    x += 20 + int(dr.textlength(lbl, font=f2)) + 16
img.save(OUT)
print("wrote", OUT, img.size, counts)
