#!/usr/bin/env python3
"""Render lna_top.gds with macro/pad/coil annotations: klayout PNG + PIL overlay.

  klayout -zz -rm render_annotated.py   (run via plain python3, not -b -r, since we need PIL)
  python3 render_annotated.py [out.png] ["achievement caption"]
"""
import json
import os
import sys

import pya
from PIL import Image, ImageDraw, ImageFont

HERE = os.path.dirname(os.path.abspath(__file__))
os.chdir(HERE)
sys.path.insert(0, HERE)
import lna_lib as lib  # noqa: E402

OUT = sys.argv[1] if len(sys.argv) > 1 else "/tmp/lna_render.png"
CAPTION = sys.argv[2] if len(sys.argv) > 2 else ""

W_PX, H_PX = 1900, 1500
RAW = "/tmp/_lna_render_raw.png"

lv = pya.LayoutView()
lv.load_layout("lna_top.gds", 0)
lv.max_hier()
lv.zoom_fit()
view_box = lv.box()  # DBox: the world-coordinate box actually shown
lv.save_image(RAW, W_PX, H_PX)

vb_l, vb_b, vb_r, vb_t = view_box.left, view_box.bottom, view_box.right, view_box.top


def to_px(x, y):
    """world (um) -> pixel (klayout image: y flipped, origin top-left)"""
    px = (x - vb_l) / (vb_r - vb_l) * W_PX
    py = H_PX - (y - vb_b) / (vb_t - vb_b) * H_PX
    return px, py


# ---- macro placement (from make_lna_top.py's own printed geometry convention) ----
MACRO_ORIGIN = (410.3, 1461.3)  # world (x, y) of block coordinate (0, Y0)
INFO = json.load(open("lna_core_layouts.json"))
_, Y0, MW, MH_Y = map(float, INFO["lna_core_output_match"]["frame"])
MACRO_W, MACRO_H = MW, MH_Y - Y0


def blk2world(bx, by):
    return MACRO_ORIGIN[0] + bx, MACRO_ORIGIN[1] + (by - Y0)


COILS = {
    "LEQ": ("lna_core_input_match", "LEQ_MAIN_RECT2_coil.gds"),
    "L1": ("lna_core_cg", "L1_RECT_coil.gds"),
    "LD4": ("lna_core_cg", "LD4_coil.gds"),
    "LD2": ("lna_core_cs", "LD2_coil.gds"),
    "LSHUNT_OUT": ("lna_core_output_match", "LSHUNT_OUT_RECT_coil.gds"),
}
coil_boxes = {}
for name, (cell, gds) in COILS.items():
    cx, cy = INFO[cell][name]["centre"]
    geo = lib._coil_read(gds)[1]
    wx, wy = blk2world(cx, cy)
    coil_boxes[name] = (wx - geo["rx"], wy - geo["ry"], wx + geo["rx"], wy + geo["ry"])

# ---- pads: read instance bboxes of the real PDK io cells directly from lna_top.gds ----
ly = pya.Layout()
ly.read("lna_top.gds")
top = ly.top_cell()
dbu = ly.dbu
NET_BY_SLOT = {
    ("N", 0): "vbias_cg", ("N", 1): "vbias_cs", ("N", 2): "vbias_cas", ("N", 3): "vss",
    ("N", 4): "rf_out", ("N", 5): "vss", ("N", 6): "vdd",
    ("W", 4): "vss", ("W", 5): "rf_in", ("W", 6): "vss", ("W", 7): "g_cg",
}
WEST0, NORTH0, PITCH = 1500.3, 400.3, 100.0
pads = []
for inst in top.each_inst():
    cn = inst.cell.name
    if not ("asig" in cn or "dvdd" in cn or "dvss" in cn):
        continue
    bb = inst.bbox()
    l, b, r, t = bb.left * dbu, bb.bottom * dbu, bb.right * dbu, bb.top * dbu
    if t > 2600:  # north side (near the tile's north edge)
        k = round((l - NORTH0) / PITCH)
        net = NET_BY_SLOT.get(("N", k), "?")
    else:
        k = round((b - WEST0) / PITCH)
        net = NET_BY_SLOT.get(("W", k), "?")
    pads.append((net, l, b, r, t))

macro_world = (MACRO_ORIGIN[0], MACRO_ORIGIN[1], MACRO_ORIGIN[0] + MACRO_W, MACRO_ORIGIN[1] + MACRO_H)

# ================================================================ overlay
img = Image.open(RAW).convert("RGB")
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
title = f"The-Silent-Owl GF180MCU LNA -- main_layout -- macro {MACRO_W:.0f} x {MACRO_H:.0f} um (pad-tile budget 1070 x 1070)"
draw.rectangle([0, 0, img.width, 40], fill=(0, 0, 0))
draw.text((10, 6), title, fill=WHITE, font=F_TITLE)
if CAPTION:
    draw.rectangle([0, img.height - 34, img.width, img.height], fill=(0, 0, 0))
    draw.text((10, img.height - 28), CAPTION, fill=(180, 255, 180), font=F_LABEL)

img.save(OUT)
print("wrote", OUT)
