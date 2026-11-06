#!/usr/bin/env python3
"""
klayout/pex/lna_core_parts_pex.gds: lna_core_parts prepared for parasitic extraction (run by make_lna_core_pex.py).

  klayout -b -r make_lna_core_pex_gds.py

The coils are EM-simulated (xschem/*_model.lib): their own R / L / C is in the models, so the coil cells
(<block>__L*, with their sub cells) are removed here and the models are put back in the PEX wrapper netlist. Coil
terminals on nets without a pin of lna_core_parts get a Metal5 port label at the coil port stub (COIL_PINS), so the
extracted subcircuit has a node exactly where the coil connects. Terminals on vdd / vss / rf_in_pad / rf_out_pad use
those pins.
"""
import json
import os
import sys

import pya

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import lna_lib as lib  # noqa: E402

SRC = os.path.join(HERE, "lna_core_parts.gds")
OUT = os.path.join(HERE, "pex", "lna_core_parts_pex.gds")
PINS = os.path.join(HERE, "pex", "lna_core_parts_pex_pins.json")
COILS = {"LEQ": "LEQ_coil.gds", "L1": "LSHUNT_OUT_coil.gds", "LD4": "LD4_coil.gds", "LD2": "LD2_coil.gds",
         "LSHUNT_OUT": "LSHUNT_OUT_coil.gds"}
# (block, coil, port 1 / 2) -> port label; the other terminals are on pins of lna_core_parts
COIL_PINS = {("lna_core_cg", "LD4", 2): "pex_vm2",  # CG drain
             ("lna_core_cs", "LD2", 2): "pex_vx",  # CS drain (cascode output)
             ("lna_core_cg", "L1", 1): "pex_input_cg"}  # CG source / input match node


def main():
    ly = pya.Layout()
    ly.read(SRC)
    top = ly.top_cell()
    m5 = ly.layer(81, 0)
    lbl = ly.layer(81, 10)
    coils = {c.cell_index(): c.name.split("__") for c in ly.each_cell()
             if c.name.count("__") == 1 and c.name.split("__")[1] in COILS}
    assert len(coils) == len(COILS), f"coil cells: {sorted(c for _, c in coils.values())}"
    placed = {}
    it = top.begin_instances_rec()
    while not it.at_end():
        ci = it.inst_cell().cell_index()
        if ci in coils:
            blk, name = coils[ci]
            t = it.trans().to_itrans(ly.dbu) * it.inst_dtrans()  # coil cell -> top, um
            geo = lib.coil_geom(os.path.join(HERE, COILS[name]))
            placed[(blk, name)] = lib.coil_ports(t, geo)
        it.next()
    assert len(placed) == len(COILS), sorted(placed)
    pins = {}
    for (blk, name, port), net in COIL_PINS.items():
        b = placed[(blk, name)][port - 1]
        x, y = (b[0] + b[2]) / 2, (b[1] + b[3]) / 2
        hit = pya.Region(top.begin_shapes_rec_touching(m5, pya.DBox(x, y, x, y).to_itype(ly.dbu)))
        assert hit.interacting(pya.Region(pya.DBox(x - 0.01, y - 0.01, x + 0.01, y + 0.01).to_itype(ly.dbu))).count(), \
            f"{blk} {name} port {port}: no Metal5 at ({x}, {y})"
        top.shapes(lbl).insert(pya.DText(net, x, y))
        pins[net] = {"coil": name, "block": blk, "port": port, "xy": [round(x, 3), round(y, 3)]}
    for ci in coils:
        ly.prune_cell(ci, -1)  # with the coil sub cells
    os.makedirs(os.path.dirname(OUT), exist_ok=True)
    ly.write(OUT)
    with open(PINS, "w") as f:
        json.dump(pins, f, indent=1)
    print(f"wrote {OUT}: {len(coils)} coils removed, port labels {sorted(pins)}")


try:
    main()
except BaseException as e:  # KLayout -b swallows tracebacks of -r scripts
    import traceback
    traceback.print_exc()
    print("ERROR:", e)
    raise
