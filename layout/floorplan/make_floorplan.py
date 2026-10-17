#!/usr/bin/env python3
"""
Floorplan of the LNA top cell = lna_core (xschem/lna_core.sch), nothing else.

Writes
  lna_top_floorplan.gds   top structure with the lna_core_floorplan cell placed at (0, 0) (pure python)
  lna_top_floorplan.json  same data, machine readable
  lna_top_floorplan.svg   picture for the docs

Needs lna_core_devices.gds/.json (klayout -b -r make_lna_core_devices.py). The core floorplan
(make_lna_core_floorplan.py) is regenerated first, so all sizes - MIM W / L / m included -
come from lna_core.sch (read only). Pins of the top cell = pins of lna_core (rf_in W, rf_out + DC N).

Units: um, origin = lower-left corner of the macro (= lower-left corner of lna_core).
"""
import json, os, struct, time

import make_lna_core_floorplan as core

HERE = os.path.dirname(os.path.abspath(__file__))
W, H = core.W, core.H  # the top cell is exactly the core tile


def write_json(path):
    json.dump({"size_um": [W, H], "schematic": "xschem/lna_core.sch",
               "core_cell": {"name": "lna_core_floorplan", "origin": [0, 0], "size_um": [W, H]},
               "pins": core.PINS,
               "mims": [{"name": m[0], "w_um": m[2], "l_um": m[3], "c_pF": round(core.c_mim(m[2], m[3]), 4)}
                        for m in core.MIMS]},
              open(path, "w"), indent=1)


def write_gds(path, core_gds):
    """all structures of the core GDS (lna_core_floorplan + its PDK device cells) + top structure with an SREF
    to lna_core_floorplan and the PR boundary"""
    rec, real8, gstr = core._rec, core._real8, core._str
    core_str = core.gds_structures(core_gds)
    t = time.localtime()[:6]
    pts = [(0, 0), (W, 0), (W, H), (0, H), (0, 0)]
    out = [rec(0x00, 2, struct.pack(">h", 600)), rec(0x01, 2, struct.pack(">12h", *t, *t)), gstr(0x02, "LNA_TOP_FP"),
           rec(0x03, 5, real8(1e-3) + real8(1e-9))] + core_str
    out += [rec(0x05, 2, struct.pack(">12h", *t, *t)), gstr(0x06, "lna_top_floorplan"),
            rec(0x0A, 0), gstr(0x12, "lna_core_floorplan"), rec(0x10, 3, struct.pack(">ii", 0, 0)), rec(0x11, 0),
            rec(0x08, 0), rec(0x0D, 2, struct.pack(">h", 0)), rec(0x0E, 2, struct.pack(">h", 0)),  # PR_bndry
            rec(0x10, 3, b"".join(struct.pack(">ii", x * 1000, y * 1000) for x, y in pts)), rec(0x11, 0),
            rec(0x07, 0), rec(0x04, 0)]
    open(path, "wb").write(b"".join(out))


if __name__ == "__main__":
    core.check_mims()
    core.check_decap()
    core_gds = os.path.join(HERE, "lna_core_floorplan.gds")
    core.write_json(os.path.join(HERE, "lna_core_floorplan.json"))
    core.write_gds(core_gds)
    core.write_svg(os.path.join(HERE, "lna_core_floorplan.svg"))
    write_json(os.path.join(HERE, "lna_top_floorplan.json"))
    write_gds(os.path.join(HERE, "lna_top_floorplan.gds"), core_gds)
    core.write_svg(os.path.join(HERE, "lna_top_floorplan.svg"))  # top = core -> same picture
    print(f"wrote GDS + JSON + SVG | lna_top = lna_core {W} x {H} um | " +
          ", ".join(f"{m[0]} {core.c_mim(m[2], m[3]):.2f}p" for m in core.MIMS))
