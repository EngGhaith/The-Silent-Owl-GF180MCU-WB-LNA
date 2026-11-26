#!/usr/bin/env python3
"""Render lna_top.gds with macro/pad/coil annotations: klayout PNG + PIL overlay.

  klayout -zz -rm render_annotated.py   (run via plain python3, not -b -r, since we need PIL)
  python3 render_annotated.py [out.png] ["achievement caption"]

Two-stage by necessity: this stage (pya loaded) only computes geometry and saves the raw
klayout render + a JSON sidecar describing the overlay; _render_overlay.py (invoked below as a
genuinely separate `python3` process, no pya import anywhere in it) does the actual PIL/
ImageDraw/ImageFont work. Discovered empirically: with pya and PIL's font rendering (_imagingft,
backed by FreeType) loaded in the SAME process, draw.text() intermittently crashes with a
DecompressionBombError reporting a garbage/huge pixel count for the glyph mask size -- not a real
oversized image, and not fixed by retrying in-process or by switching between `klayout -b -r` and
`klayout -zz -rm`. Looks like the two libraries' FreeType usage conflicting in one process. Giving
PIL its own process (no pya at all) made it reliable.
"""
import json
import os
import shutil
import subprocess
import sys

import pya

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

# ---- macro placement (from make_lna_top.py's own printed geometry convention) ----
MACRO_ORIGIN = (410.3, 1441.3)  # world (x, y) of block coordinate (0, Y0)
INFO = json.load(open("lna_core_layouts.json"))
_, Y0, MW, MH_Y = map(float, INFO["lna_core_output_match"]["frame"])
MACRO_W, MACRO_H = MW, MH_Y - Y0


def blk2world(bx, by):
    return MACRO_ORIGIN[0] + bx, MACRO_ORIGIN[1] + (by - Y0)


COILS = {
    "LEQ": ("lna_core_input_match", "LEQ_MAIN_RECT2_coil.gds"),
    "L1": ("lna_core_cg", "L1_RECT_coil.gds"),
    "LD4": ("lna_core_cg", "LD4_RECT_coil.gds"),
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

try:
    BRANCH = subprocess.run(["git", "rev-parse", "--abbrev-ref", "HEAD"], cwd=HERE, capture_output=True,
                             text=True, check=True).stdout.strip()
except Exception:
    BRANCH = "?"

sidecar = {
    "w_px": W_PX, "h_px": H_PX, "view_box": [vb_l, vb_b, vb_r, vb_t],
    "macro_world": list(macro_world), "macro_w": MACRO_W, "macro_h": MACRO_H,
    "coil_boxes": coil_boxes, "pads": pads, "branch": BRANCH, "out": OUT, "caption": CAPTION,
}
SIDECAR_PATH = "/tmp/_lna_render_sidecar.json"
json.dump(sidecar, open(SIDECAR_PATH, "w"))

# NOTE: do NOT use sys.executable here -- inside klayout's embedded Python, sys.executable resolves
# to the klayout binary itself (re-running this same conflicted interpreter, which was observed to
# hang rather than crash). Find a real system python3 explicitly instead.
PY3 = shutil.which("python3") or shutil.which("python")
if not PY3:
    raise SystemExit("no system python3 found on PATH -- needed for the overlay subprocess")
r = subprocess.run([PY3, os.path.join(HERE, "_render_overlay.py"), SIDECAR_PATH, RAW],
                    capture_output=True, text=True, timeout=60)
sys.stdout.write(r.stdout)
sys.stderr.write(r.stderr)
if r.returncode != 0:
    raise SystemExit(f"overlay subprocess failed (exit {r.returncode})")
