"""Side-by-side render of the broken layout and the repaired one.

Left panel  = what KLayout left behind (via_stitch_7 emptied)
Right panel = after lvs/repair_leq_vias.py restored the via stitching
Vias are drawn bright over muted metal, so the missing stitching is obvious.

usage: python3 lvs/render_via_repair.py out.png xlo ylo xhi yhi [title]
"""
import sys

import klayout.db as kdb
from PIL import Image, ImageDraw, ImageFont

BROKEN = "lvs/work/pre_via_repair.gds"
FIXED = "klayout/lna_core_parts_viafix.gds"
out = sys.argv[1]
win_um = [float(v) for v in sys.argv[2:6]]
subtitle = sys.argv[6] if len(sys.argv) > 6 else ""

PANEL, PAD, BAR, GAP = 720, 10, 74, 16
METAL = [((34, 0), (58, 64, 92)), ((36, 0), (64, 78, 92)), ((42, 0), (92, 80, 58)),
         ((46, 0), (88, 66, 58)), ((81, 0), (96, 58, 64))]
VIAS = [((35, 0), (90, 240, 255), "V1"), ((38, 0), (120, 255, 160), "V2"),
        ((40, 0), (255, 230, 90), "V3"), ((41, 0), (255, 140, 220), "V4")]

W = 2 * PANEL + 2 * PAD + GAP
sx = PANEL / (win_um[2] - win_um[0])
H = int((win_um[3] - win_um[1]) * sx) + 2 * PAD + BAR
img = Image.new("RGB", (W, H), (12, 13, 17))
dr = ImageDraw.Draw(img, "RGBA")

counts = {}
for idx, (tag, path) in enumerate((("BROKEN  (as KLayout left it)", BROKEN),
                                   ("REPAIRED  (via stitching restored)", FIXED))):
    ox = PAD + idx * (PANEL + GAP)
    ly = kdb.Layout(); ly.read(path)
    dbu = ly.dbu
    top = ly.cell("lna_core_parts")
    U = lambda v: int(round(v / dbu))
    box = kdb.Box(U(win_um[0]), U(win_um[1]), U(win_um[2]), U(win_um[3]))
    xf = lambda x, y: (ox + (x - win_um[0]) * sx, BAR + PAD + (win_um[3] - y) * sx)

    def draw(lay, col, alpha=255):
        i = ly.find_layer(*lay)
        if i is None:
            return 0
        r = (kdb.Region(top.begin_shapes_rec(i)) & kdb.Region(box))
        r.merge()
        for p in r.each():
            pts = [xf(v.x * dbu, v.y * dbu) for v in p.to_simple_polygon().each_point()]
            if len(pts) >= 3:
                dr.polygon(pts, fill=col + (alpha,))
        return r.count()

    for lay, col in METAL:
        draw(lay, col)
    n = {}
    for lay, col, nm in VIAS:
        n[nm] = draw(lay, col)
    counts[idx] = n
    dr.rectangle([ox - 2, BAR + PAD - 2, ox + PANEL + 2, H - PAD + 2],
                 outline=(200, 60, 60) if idx == 0 else (60, 200, 120), width=3)

try:
    f1 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 19)
    f2 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 15)
    f3 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 13)
except Exception:
    f1 = f2 = f3 = ImageFont.load_default()
dr.text((PAD, 5), f"via_stitch_7 lost all 4 sub-instances -- LEQ via stitching  "
                  f"[x {win_um[0]:.1f}..{win_um[2]:.1f}  y {win_um[1]:.1f}..{win_um[3]:.1f} um]"
                  f"{'   ' + subtitle if subtitle else ''}", font=f1, fill=(240, 240, 240))
for idx, lbl, col in ((0, "BROKEN  (as KLayout left it)", (235, 110, 110)),
                      (1, "REPAIRED  (vias restored)", (110, 225, 160))):
    ox = PAD + idx * (PANEL + GAP)
    dr.text((ox, 30), lbl, font=f2, fill=col)
    dr.text((ox, 50), "   ".join(f"{nm} {counts[idx][nm]}" for _, _, nm in VIAS),
            font=f3, fill=(190, 190, 190))
x = PAD + PANEL + GAP + 300
for _, col, nm in VIAS:
    dr.rectangle([x, 50, x + 12, 62], fill=col + (255,))
    dr.text((x + 16, 49), nm, font=f3, fill=(200, 200, 200))
    x += 48
img.save(out)
print("wrote", out, img.size, "broken:", counts[0], "repaired:", counts[1])
