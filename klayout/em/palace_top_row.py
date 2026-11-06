# Palace model of the top coil row (top_row_em.gds, make_top_row_em_gds.py): LD4, LD2, LSHUNT_OUT + leads, 5 via ports
# (gds2palace flow of the IHP PDK, GF180 stackup of the team EM-Flow/ + SUBGND port ground). Run, then ./run_sim in
# palace_model/palace_top_row_data (palace -np 4 config.json), then evaluate_top_row.py.
import os
import sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), 'gds2palace')))
from gds2palace import *

gds_filename = "top_row_em.gds"
XML_filename = "PALACE-GF180-SUBGND.xml"
preprocess_gds = True
merge_polygon_size = 2  # via arrays of the coils -> blocks

script_path = utilities.get_script_path(__file__)
model_basename = utilities.get_basename(__file__)
sim_path = utilities.create_sim_path(script_path, model_basename)
os.chdir(os.path.dirname(os.path.abspath(__file__)))

settings = {}
settings['unit'] = 1e-6
settings['margin'] = 150
settings['air_around'] = 50
settings['fpoint'] = [1e9, 2e9, 2.4e9, 3e9]  # discrete points only (a 0.25 .. 5 GHz adaptive sweep takes hours here)
settings['adaptive_sweep'] = False
settings['refined_cellsize'] = 5
settings['cells_per_wavelength'] = 10
settings['meshsize_max'] = 70
settings['adaptive_mesh_iterations'] = 0
settings['no_gui'] = True

ports = simulation_setup.all_simulation_ports()
for n in range(1, 6):  # 1 vm2, 2 vx, 3 vdd, 4 rf_out, 5 LSHUNT vss
    ports.add_port(simulation_setup.simulation_port(portnumber=n, voltage=1, port_Z0=50, source_layernum=200 + n,
                                                    from_layername='SUBGND', to_layername='TM', direction='z'))

materials_list, dielectrics_list, metals_list = stackup_reader.read_substrate(XML_filename)
layernumbers = metals_list.getlayernumbers()
layernumbers.extend(ports.portlayers)
allpolygons = gds_reader.read_gds(gds_filename, layernumbers, purposelist=[0], metals_list=metals_list,
                                  preprocess=preprocess_gds, merge_polygon_size=merge_polygon_size)
settings.update({'simulation_ports': ports, 'materials_list': materials_list, 'dielectrics_list': dielectrics_list,
                 'metals_list': metals_list, 'layernumbers': layernumbers, 'allpolygons': allpolygons,
                 'sim_path': sim_path, 'model_basename': model_basename})
config_name, data_dir = simulation_setup.create_palace(ports.all_active_excitations(), settings)
# gds2palace (PDK copy) leaves the oxide / nitride without material -> Palace drops those volumes and with them the
# ports inside: add every dielectric of the stackup that is missing (attribute = physical group of its name)
import json
import re
msh = open(os.path.join(sim_path, model_basename + ".msh")).read(200000)
groups = {n: int(a) for a, n in re.findall(r'^3 (\d+) "([^"]+)"', msh, re.M)}
cfg = json.load(open(config_name))
have = {a for m in cfg["Domains"]["Materials"] for a in m["Attributes"]}
for name, eps in (("NITR", 7.0), ("SIO2", 4.0)):
    if groups.get(name) and groups[name] not in have:
        cfg["Domains"]["Materials"].append({"Attributes": [groups[name]], "Permittivity": eps, "LossTan": 0.0})
# 4 points, order-1 elements (order 2: ~12 min per solve, order 1: ~4 min)
cfg["Solver"]["Order"] = 1
cfg["Solver"]["Driven"] = {"Samples": [{"Type": "Point", "Freq": [f / 1e9 for f in settings['fpoint']], "SaveStep": 0}],
                           "AdaptiveTol": 0.0}
json.dump(cfg, open(config_name, "w"), indent=1)
utilities.create_run_script(sim_path)
print("model:", sim_path, config_name)
