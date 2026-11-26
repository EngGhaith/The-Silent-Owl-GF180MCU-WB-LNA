#!/usr/bin/env python3
"""PIL overlay stage for render_annotated.py, run as a genuinely separate process (no pya import
anywhere in this file) -- see render_annotated.py's own docstring for why.

  python3 _render_overlay.py <sidecar.json> <raw.png>
"""
import json
import os
import sys

from PIL import Image, ImageDraw, ImageFont

sidecar_path, raw_path = sys.argv[1], sys.argv[2]
d = json.load(open(sidecar_path))
W_PX, H_PX = d["w_px"], d["h_px"]
vb_l, vb_b, vb_r, vb_t = d["view_box"]
macro_world = d["macro_world"]
MACRO_W, MACRO_H = d["macro_w"], d["macro_h"]
coil_boxes = d["coil_boxes"]
pads = d["pads"]
BRANCH = d["branch"]
OUT = d["out"]
CAPTION = d["caption"]


def to_px(x, y):
    """world (um) -> pixel (klayout image: y flipped, origin top-left)"""
    px = (x - vb_l) / (vb_r - vb_l) * W_PX
    py = H_PX - (y - vb_b) / (vb_t - vb_b) * H_PX
    return px, py


img = Image.open(raw_path).convert("RGB")
draw = ImageDraw.Draw(img)


def font(sz):
    for path in ("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf",
                 "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"):
        if os.path.exists(path):
            return ImageFont.truetype(path, sz)
    return ImageFont.load_default()


F_TITLE, F_LABEL, F_SMALL = font(26), font(18), font(14)
YELLOW, CYAN, WHITE, RED = (255, 220, 0), (0, 230, 230), (255, 255, 255), (255, 70, 70)

# macro outline + dimensions
mx0, my0 = to_px(macro_world[0], macro_world[1])
mx1, my1 = to_px(macro_world[2], macro_world[3])
draw.rectangle([mx0, my1, mx1, my0], outline=YELLOW, width=3)
dim_y = min(my0 + 28, H_PX - 50)
draw.line([(mx0, dim_y), (mx1, dim_y)], fill=YELLOW, width=2)
draw.line([(mx0, dim_y - 6), (mx0, dim_y + 6)], fill=YELLOW, width=2)
draw.line([(mx1, dim_y - 6), (mx1, dim_y + 6)], fill=YELLOW, width=2)
draw.text(((mx0 + mx1) / 2, dim_y + 10), f"{MACRO_W:.0f} um (budget 1070)", fill=YELLOW, font=F_LABEL, anchor="mt")
dim_x = mx1 + 28
draw.line([(dim_x, my1), (dim_x, my0)], fill=YELLOW, width=2)
draw.line([(dim_x - 6, my1), (dim_x + 6, my1)], fill=YELLOW, width=2)
draw.line([(dim_x - 6, my0), (dim_x + 6, my0)], fill=YELLOW, width=2)
txt = f"{MACRO_H:.0f} um (budget 1070)"
tw = draw.textlength(txt, font=F_LABEL)
img2 = Image.new("RGBA", (int(tw) + 10, 30), (0, 0, 0, 0))
d2 = ImageDraw.Draw(img2)
d2.text((5, 0), txt, fill=YELLOW, font=F_LABEL)
img2 = img2.rotate(90, expand=True)
img.paste(img2, (int(dim_x + 10), int((my0 + my1) / 2 - img2.height / 2)), img2)

# coil annotations
for name, (x0, y0, x1, y1) in coil_boxes.items():
    px0, py0 = to_px(x0, y0)
    px1, py1 = to_px(x1, y1)
    draw.rectangle([px0, py1, px1, py0], outline=CYAN, width=2)
    cxp, cyp = (px0 + px1) / 2, (py0 + py1) / 2
    tw = draw.textlength(name, font=F_LABEL)
    draw.rectangle([cxp - tw / 2 - 4, py1 - 24, cxp + tw / 2 + 4, py1 - 2], fill=(0, 0, 0))
    draw.text((cxp, py1 - 6), name, fill=CYAN, font=F_LABEL, anchor="mb")

# pad annotations
for net, l, b, r, t in pads:
    p0 = to_px(l, b)
    p1 = to_px(r, t)
    cx, cy = (p0[0] + p1[0]) / 2, (p0[1] + p1[1]) / 2
    color = RED if net in ("rf_in", "rf_out") else WHITE
    draw.rectangle([p0[0], p1[1], p1[0], p0[1]], outline=color, width=2)
    label_y = p0[1] + 14 if t > 2600 else cy
    anchor = "mt" if t > 2600 else "rm"
    lx = cx if t > 2600 else p0[0] - 6
    draw.text((lx, label_y), net, fill=color, font=F_SMALL, anchor=anchor)

# title / caption
title = f"The-Silent-Owl GF180MCU LNA -- {BRANCH} -- macro {MACRO_W:.0f} x {MACRO_H:.0f} um (pad-tile budget 1070 x 1070)"
draw.rectangle([0, 0, img.width, 40], fill=(0, 0, 0))
draw.text((10, 6), title, fill=WHITE, font=F_TITLE)
if CAPTION:
    draw.rectangle([0, img.height - 34, img.width, img.height], fill=(0, 0, 0))
    draw.text((10, img.height - 28), CAPTION, fill=(180, 255, 180), font=F_LABEL)

img.save(OUT)
print("wrote", OUT)
