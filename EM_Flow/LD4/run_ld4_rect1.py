import os
import numpy as np
from openEMS import openEMS
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

from gds2openEMS import *

gds_filename = "Ind_LD4_RECT_X216.0_Y93.0_SE.gds"
XML_filename = "/foss/designs/rapidpassives/try4/newflow/drains/OPENEMS-GF180MCUD-1P5M-TM11KA-MIMB-STACKED2.xml"

settings = {}
settings['preview_only'] = False
settings['no_gui'] = True
settings['merge_polygon_size'] = 2
settings['resonance_estimation'] = True

script_path = utilities.get_script_path(__file__)
model_basename = utilities.get_basename(__file__)
sim_path = utilities.create_sim_path(script_path, model_basename)
print('Simulation data directory: ', sim_path)
os.chdir(os.path.dirname(os.path.abspath(__file__)))

settings['unit'] = 1e-6
settings['margin'] = 350
settings['fstart'] = 0
settings['fstop'] = 10e9
targetfreq = 2.4e9
settings['numfreq'] = 1001
settings['refined_cellsize'] = 0.5
settings['Boundaries'] = ['PEC', 'PEC', 'PEC', 'PEC', 'PEC', 'PEC']
settings['cells_per_wavelength'] = 10
settings['energy_limit'] = -60

simulation_ports = simulation_setup.all_simulation_ports()
simulation_ports.add_port(simulation_setup.simulation_port(portnumber=1, voltage=1, port_Z0=50, source_layernum=201, from_layername='M1', to_layername='TM', direction='z'))

materials_list, dielectrics_list, metals_list = stackup_reader.read_substrate(XML_filename)
layernumbers = metals_list.getlayernumbers()
layernumbers.extend(simulation_ports.portlayers)
allpolygons = gds_reader.read_gds(gds_filename, layernumbers, purposelist=[0], metals_list=metals_list, merge_polygon_size=settings['merge_polygon_size'])

FDTD = openEMS(EndCriteria=np.exp(settings['energy_limit']/10 * np.log(10)))
FDTD.SetGaussExcite((settings['fstart']+settings['fstop'])/2, (settings['fstop']-settings['fstart'])/2)
FDTD.SetBoundaryCond(settings['Boundaries'])

settings['simulation_ports'] = simulation_ports
settings['materials_list'] = materials_list
settings['dielectrics_list'] = dielectrics_list
settings['metals_list'] = metals_list
settings['layernumbers'] = layernumbers
settings['allpolygons'] = allpolygons
settings['sim_path'] = sim_path
settings['model_basename'] = model_basename

settings['excite_portnumbers'] = [1]
simulation_setup.setupSimulation(FDTD=FDTD, settings=settings)
simulation_setup.runSimulation(FDTD=FDTD, settings=settings)

if not settings['preview_only']:
    f = np.linspace(settings['fstart'], settings['fstop'], settings['numfreq'])
    s11 = utilities.calculate_Sij(1, 1, f, sim_path, simulation_ports)
    utilities.write_snp(np.array([s11]), f, os.path.join(sim_path, model_basename + '.s1p'), z0=simulation_ports.get_reference_impedance())

    z11 = utilities.calculate_Zij(1, 1, f, sim_path, simulation_ports)
    np.seterr(divide='ignore', invalid='ignore')
    omega = 2*np.pi*f
    Qse = z11.imag/z11.real
    Lse = z11.imag/omega
    Rse = z11.real

    findex = np.where(f >= targetfreq)[0].item(0)
    print('\nSingle-ended inductor parameters (LD4_RECT_CAND1_X216.0_Y93.0)')
    print(f"Frequency [GHz]: {f[findex]/1e9:.3f}")
    print(f"Series L  [nH] : {Lse[findex]*1e9:.4f}")
    print(f"Series R  [Ohm]: {Rse[findex]:.4f}")
    print(f"Q factor       : {Qse[findex]:.3f}")
    print(f"Peak Q         : {max(Qse):.3f}")
