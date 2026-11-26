"""Render the L_SHUNT_OUT footprint before and after deleting the coil instance.

The point of the AFTER panel is to show what survives the deletion: geometry that belongs
to lna_core_output_match itself rather than to the coil cell, which is what has to be
decided about before the area can be tiled with PG cells.

usage: python3 lvs/render_lshunt.py <gds> out_before.png out_after.png
"""
import sys

import klayout.db as kdb
from PIL import Image, ImageDraw, ImageFont

SRC, OUT_B, OUT_A = sys.argv[1], sys.argv[2], sys.argv[3]
WIN = (820.0, 0.0, 1110.0, 700.0)          # footprint plus a margin of context
W_PX, BAR = 900, 92

LAYERS = [((22, 0), (40, 120, 80), "COMP"), ((34, 0), (60, 80, 130), "M1"),
          ((36, 0), (55, 95, 115), "M2"), ((42, 0), (120, 100, 60), "M3"),
          ((46, 0), (115, 80, 65), "M4"), ((81, 0), (140, 70, 85), "M5"),
          ((75, 0), (170, 150, 70), "MIM"), ((151, 5), (70, 70, 120), "ind_mk")]
HOT = [((34, 0), (120, 190, 255), "M1"), ((36, 0), (120, 230, 230), "M2"),
       ((42, 0), (255, 200, 90), "M3"), ((46, 0), (255, 150, 90), "M4"),
       ((81, 0), (255, 110, 150), "M5")]


def load(drop_coil):
    ly = kdb.Layout(); ly.read(SRC)
    if drop_coil:
        om = ly.cell("lna_core_output_match")
        for i in [x for x in om.each_inst() if "LSHUNT_OUT" in x.cell.name]:
            om.erase(i)
    return ly


def render(ly, out, title, highlight):
    dbu = ly.dbu
    U = lambda v: int(round(v / dbu))
    top = ly.cell("lna_core_parts")
    box = kdb.Box(U(WIN[0]), U(WIN[1]), U(WIN[2]), U(WIN[3]))
    clip = kdb.Region(box)
    sx = W_PX / (WIN[2] - WIN[0])
    H = int((WIN[3] - WIN[1]) * sx) + BAR
    img = Image.new("RGB", (W_PX, H), (13, 14, 18))
    dr = ImageDraw.Draw(img, "RGBA")
    xf = lambda x, y: ((x - WIN[0]) * sx, BAR + (WIN[3] - y) * sx)

    def paint(r, col, outline=False):
        n = 0
        for p in r.each():
            pts = [xf(v.x * dbu, v.y * dbu) for v in p.to_simple_polygon().each_point()]
            if len(pts) >= 3:
                dr.line(pts + [pts[0]], fill=col, width=2) if outline else dr.polygon(pts, fill=col)
                n += 1
        return n

    for (num, dt), col, _ in LAYERS:
        i = ly.find_layer(num, dt)
        if i is None:
            continue
        r = kdb.Region(top.begin_shapes_rec(i)); r.merge()
        paint(r & clip, col + (255,))

    counts = {}
    if highlight:
        foot = kdb.Region(kdb.Box(U(839.98), U(19.98), U(1087.62), U(680.02)))
        for (num, dt), col, name in HOT:
            i = ly.find_layer(num, dt)
            if i is None:
                continue
            r = kdb.Region(top.begin_shapes_rec(i)); r.merge()
            r = r & foot
            counts[name] = (r.count(), r.area() * dbu * dbu)
            paint(r, col + (255,))

    # the footprint boundary
    f = [xf(839.98, 19.98), xf(1087.62, 19.98), xf(1087.62, 680.02), xf(839.98, 680.02)]
    dr.line(f + [f[0]], fill=(255, 255, 255, 170), width=2)

    try:
        f1 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 17)
        f2 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 12)
    except Exception:
        f1 = f2 = ImageFont.load_default()
    dr.text((10, 6), title, font=f1, fill=(240, 240, 240))
    dr.text((10, 28), f"window x {WIN[0]:.0f}..{WIN[2]:.0f}  y {WIN[1]:.0f}..{WIN[3]:.0f} um   "
                      f"white box = the L_SHUNT_OUT footprint 247.64 x 660.02 um",
            font=f2, fill=(170, 170, 170))
    x = 10
    legend = ([(c, f"{n} {counts[n][0]}x {counts[n][1]:.1f}um2") for _, c, n in HOT if n in counts]
              if highlight else [(c, n) for _, c, n in LAYERS])
    for col, lbl in legend:
        dr.rectangle([x, 50, x + 12, 62], fill=col + (255,))
        dr.text((x + 17, 49), lbl, font=f2, fill=(205, 205, 205))
        x += 17 + int(dr.textlength(lbl, font=f2)) + 14
        if x > W_PX - 120:
            x = 10
            break
    img.save(out)
    print("wrote", out, img.size, counts if highlight else "")


render(load(False), OUT_B, "BEFORE -- L_SHUNT_OUT in place", False)
render(load(True), OUT_A, "AFTER -- coil instance deleted; bright = what SURVIVES inside the footprint", True)
