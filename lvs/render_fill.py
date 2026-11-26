"""Render the dummy COMP / dummy poly2 fill against the circuit it avoids.

usage: python3 lvs/render_fill.py in.gds out.png [xlo ylo xhi yhi]
"""
import sys

import klayout.db as kdb
from PIL import Image, ImageDraw, ImageFont

src, out = sys.argv[1], sys.argv[2]
win = [float(v) for v in sys.argv[3:7]] if len(sys.argv) > 6 else None
W_PX, PAD, BAR = 1400, 12, 62

ly = kdb.Layout(); ly.read(src)
top = ly.cell("lna_core_parts")
dbu = ly.dbu
bb = kdb.Box(*[int(round(v / dbu)) for v in win]) if win else top.bbox()
sx = (W_PX - 2 * PAD) / bb.width()
H = int(bb.height() * sx) + 2 * PAD + BAR
img = Image.new("RGB", (W_PX, H), (14, 15, 19))
dr = ImageDraw.Draw(img, "RGBA")
xf = lambda p: (PAD + (p.x - bb.left) * sx, BAR + PAD + (bb.top - p.y) * sx)

# context first, fill on top
PLAN = [
    ((81, 0), (70, 74, 96, 255), "metal5 (context)"),
    ((34, 0), (58, 70, 110, 255), "metal1 (context)"),
    ((22, 0), (40, 170, 110, 255), "COMP (circuit)"),
    ((30, 0), (200, 60, 150, 255), "poly2 (circuit)"),
    ((22, 4), (120, 255, 170, 255), "dummy COMP 22/4"),
    ((30, 4), (255, 200, 60, 255), "dummy poly2 30/4"),
    ((111, 5), (255, 90, 90, 160), "NDMY 111/5"),
]
counts = {}
for (lay, dt), col, _ in PLAN:
    i = ly.find_layer(lay, dt)
    if i is None:
        counts[(lay, dt)] = 0
        continue
    r = kdb.Region(top.begin_shapes_rec(i))
    counts[(lay, dt)] = r.count()
    r = (r & kdb.Region(bb))
    r.merge()
    for poly in r.each():
        pts = [xf(p) for p in poly.to_simple_polygon().each_point()]
        if len(pts) >= 3:
            dr.polygon(pts, fill=col)

try:
    f1 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 19)
    f2 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 13)
except Exception:
    f1 = f2 = ImageFont.load_default()
title = f"{src.split('/')[-1]} -- dummy COMP + dummy poly2 fill, no metal fill"
if win:
    title += f"   detail x {win[0]:.0f}..{win[2]:.0f}  y {win[1]:.0f}..{win[3]:.0f} um"
dr.text((PAD, 7), title, font=f1, fill=(240, 240, 240))
x = PAD
for (lay, dt), col, name in PLAN:
    dr.rectangle([x, 36, x + 13, 49], fill=col[:3] + (255,))
    label = f"{name} ({counts[(lay, dt)]})"
    dr.text((x + 18, 36), label, font=f2, fill=(205, 205, 205))
    x += 20 + int(dr.textlength(label, font=f2)) + 14
img.save(out)
print("wrote", out, img.size, {f"{k[0]}/{k[1]}": v for k, v in counts.items()})
