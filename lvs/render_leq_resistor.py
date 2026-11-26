"""Show where LEQ's tm11k device sits and which half of it is floating.

Magic cuts the M5 at the tm11k marker into the coil side (reaches rf_in_pad) and the
vss side (reaches nothing). Both halves are drawn in contrasting colours over the metal
context, with the marker itself picked out.

usage: python3 lvs/render_leq_resistor.py out.png xlo ylo xhi yhi
"""
import sys

import klayout.db as kdb
from PIL import Image, ImageDraw, ImageFont

SRC = "lvs/work/lna_core_parts.gds"
out = sys.argv[1]
win_um = [float(v) for v in sys.argv[2:6]]
W_PX, PAD, BAR = 1400, 12, 86

ly = kdb.Layout(); ly.read(SRC)
dbu = ly.dbu
U = lambda v: int(round(v / dbu))
top = ly.cell("lna_core_parts")
box = kdb.Box(U(win_um[0]), U(win_um[1]), U(win_um[2]), U(win_um[3]))
sx = (W_PX - 2 * PAD) / (win_um[2] - win_um[0])
H = int((win_um[3] - win_um[1]) * sx) + 2 * PAD + BAR
img = Image.new("RGB", (W_PX, H), (16, 17, 21))
dr = ImageDraw.Draw(img, "RGBA")
xf = lambda x, y: (PAD + (x - win_um[0]) * sx, BAR + PAD + (win_um[3] - y) * sx)


def reg(num, dt=0):
    i = ly.find_layer(num, dt)
    r = kdb.Region() if i is None else kdb.Region(top.begin_shapes_rec(i))
    r.merge()
    return r


def paint(r, col):
    for p in (r & kdb.Region(box)).each():
        pts = [xf(v.x * dbu, v.y * dbu) for v in p.to_simple_polygon().each_point()]
        if len(pts) >= 3:
            dr.polygon(pts, fill=col)


# context
for num, col in ((34, (48, 56, 80)), (36, (54, 66, 80)), (42, (76, 68, 50)),
                 (46, (74, 56, 50)), (81, (84, 52, 58))):
    paint(reg(num), col + (255,))

# the tm11k device and the two halves of the strip it cuts
mk = reg(110, 15) & kdb.Region(kdb.Box(U(60), U(500), U(90), U(600)))
m5 = reg(81)
strip = m5.interacting(kdb.Region(kdb.Box(U(72), U(520), U(78), U(526))))
halves = sorted((strip - mk).merged().each(), key=lambda p: -p.area())
paint(kdb.Region(halves[0]), (70, 200, 255, 255))      # coil side, reaches rf_in_pad
paint(kdb.Region(halves[1]), (255, 70, 70, 255))       # vss side, floating
paint(mk, (255, 240, 60, 255))

mb = mk.bbox()
mx, my = xf(mb.left * dbu, mb.top * dbu)
dr.ellipse([mx - 26, my - 26, mx + 26, my + 26], outline=(255, 240, 60), width=4)

try:
    f1 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 19)
    f2 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 14)
except Exception:
    f1 = f2 = ImageFont.load_default()
dr.text((PAD, 6), "LEQ's tm11k device: the marker Magic turns into R1 p1 p2 tm11k "
                  "W=10u L=1u", font=f1, fill=(240, 240, 240))
rows = [((255, 240, 60), f"tm11k marker 110/15  ({mb.left*dbu:.2f},{mb.bottom*dbu:.2f})-"
                         f"({mb.right*dbu:.2f},{mb.top*dbu:.2f})  10.0 x 1.0 um"),
        ((70, 200, 255), f"p1  coil side   {halves[0].area()*dbu*dbu:9.1f} um2  "
                         f"-> reaches rf_in_pad through C15   MATCHES"),
        ((255, 70, 70), f"p2  vss side    {halves[1].area()*dbu*dbu:9.1f} um2  "
                        f"-> reaches nothing   THIS IS THE OPEN")]
y = 30
for col, txt in rows:
    dr.rectangle([PAD, y + 2, PAD + 13, y + 15], fill=col + (255,))
    dr.text((PAD + 20, y), txt, font=f2, fill=(205, 205, 205))
    y += 18
img.save(out)
print("wrote", out, img.size)
for h in halves:
    b = h.bbox()
    print(f"   half {h.area()*dbu*dbu:10.1f} um2  ({b.left*dbu:7.2f},{b.bottom*dbu:7.2f})-"
          f"({b.right*dbu:7.2f},{b.top*dbu:7.2f})")
