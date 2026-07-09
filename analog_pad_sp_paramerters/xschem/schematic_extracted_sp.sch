v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 55 -880 665 -600 {flags=graph
y1=0.91
y2=0.99
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3.35
x2=10.35
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=1
logy=0
sim_type=sp
autoload=1
color=4
node=s_1_1
rawfile=$netlist_dir/sp_extracted_analog_pad.raw}
B 2 695 -880 1305 -600 {flags=graph
y1=-180
y2=-170
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3.35
x2=10.35
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=1
logy=0
rawfile=$netlist_dir/sp_extracted_analog_pad.raw
sim_type=sp
autoload=1
color=4
node=ph(s_1_1)}
P 4 4 565 -435 575 -440 575 -430 565 -435 {fill=1}
P 4 3 575 -435 600 -435 600 -380 {}
N 660 -460 660 -400 {lab=Vin}
N 660 -340 660 -300 {lab=0}
N 380 -390 380 -340 {lab=0}
N 340 -390 340 -340 {lab=0}
N 60 -380 60 -330 {lab=0}
N 500 -460 660 -460 {lab=Vin}
N 1230 -440 1230 -380 {lab=#net1}
N 1230 -440 1280 -440 {lab=#net1}
N 1350 -440 1350 -420 {lab=#net1}
N 1280 -440 1350 -440 {lab=#net1}
N 1350 -360 1350 -310 {lab=0}
N 340 -340 380 -340 {lab=0}
N 380 -580 380 -530 {lab=#net2}
N 340 -580 380 -580 {lab=#net2}
N 340 -580 340 -530 {lab=#net2}
N 60 -580 340 -580 {lab=#net2}
N 60 -580 60 -440 {lab=#net2}
N 1350 -310 1350 -300 {lab=0}
N 1230 -320 1230 -300 {lab=0}
C {vsource.sym} 660 -370 0 1 {name=V1 value="dc 0 ac 1 portnum 1 z0 50"
}
C {vsource.sym} 60 -410 0 0 {name=V_DVDD value=5 savecurrent=false}
C {code_shown.sym} 710 -540 0 0 {name=NGSPICE
only_toplevel=true
value="
.control
save all
sp lin 100 1e3 10e9 0
write sp_extracted_analog_pad.raw

let s11_db = db(S_1_1)
plot s11_db ylabel 'S11 (dB)' xlabel 'Frequency'
.endc
" 
spice_ignore=0}
C {launcher.sym} 540 -565 0 0 {name=h1
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/sp_extracted_analog_pad.raw sp"}
C {code_shown.sym} 20 -245 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
*.include /foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/unextracted_gf180mcu_fd_io__asig_5p0.spice
*.include /foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/extracted_gf180mcu_fd_io__asig_5p0_manually_scaled.spice
*.include /foss/designs/tempo/gf180mcu_fd_io__asig_5p0.spice
.include /foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/gf180mcu_fd_io__asig_5p0_pex__pdk_gf180mcuD__rcx__flat__cthresh_0__extresist_0mohm.spice
"}
C {lab_wire.sym} 660 -460 0 1 {name=p4 sig_type=std_logic lab=Vin}
C {title.sym} 180 -40 0 0 {name=l4 author="Ahmed Elnaggar/A38- The Silent Owl"}
C {gnd.sym} 660 -300 0 0 {name=l1 lab=0}
C {gnd.sym} 60 -330 0 0 {name=l6 lab=0}
C {vsource.sym} 1230 -350 0 0 {name=V_Dummy value="dc 0 ac 1 portnum 2 z0 50"
}
C {gnd.sym} 1230 -300 0 0 {name=l7 lab=0}
C {res.sym} 1350 -390 0 0 {name=R1
value=50
footprint=1206
device=resistor
m=1}
C {gnd.sym} 1350 -300 0 0 {name=l3 lab=0}
C {gnd.sym} 360 -340 0 0 {name=l2 lab=0}
C {/foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/xschem/gf180mcu_fd_io__asig_5p0.sym} 350 -460 0 0 {name=x2}
C {code_shown.sym} 1400 -560 0 0 {name=NGSPICE2
only_toplevel=true
value="
.control
save all

sp lin 100 1e3 10e9

let s11_re = real(s_1_1)
let s11_im = imag(s_1_1)
let s11_db = db(s_1_1)

set wr_vecnames
set wr_singlescale

wrdata sp_extracted_analog_pad.csv frequency s11_re s11_im s11_db

plot s11_db ylabel 'S11 (dB)' xlabel 'Frequency'

.endc
" 
spice_ignore=1}
