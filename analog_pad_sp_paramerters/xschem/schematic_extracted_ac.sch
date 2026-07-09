v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 645 -630 1255 -350 {flags=graph
y1=0.99
y2=1
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=4
x2=9.30103
divx=5
subdivx=8
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=1
logy=0
rawfile=$netlist_dir/ac_extracted_analog_pad.raw
sim_type=ac
autoload=1
color=4
node=vin}
P 4 4 465 -505 475 -510 475 -500 465 -505 {fill=1}
P 4 3 475 -505 500 -505 500 -450 {}
N 530 -540 530 -480 {lab=#net1}
N 530 -420 530 -380 {lab=0}
N 400 -540 450 -540 {lab=Vin}
N 390 -540 400 -540 {lab=Vin}
N 510 -540 530 -540 {lab=#net1}
N 80 -540 80 -480 {lab=#net2}
N 80 -420 80 -380 {lab=0}
N 270 -640 270 -610 {lab=#net2}
N 230 -640 270 -640 {lab=#net2}
N 230 -640 230 -610 {lab=#net2}
N 230 -640 230 -610 {lab=#net2}
N 80 -640 230 -640 {lab=#net2}
N 80 -640 80 -540 {lab=#net2}
N 270 -470 270 -410 {lab=0}
N 80 -400 270 -400 {lab=0}
N 230 -470 230 -410 {lab=0}
N 230 -410 230 -400 {lab=0}
N 270 -410 270 -400 {lab=0}
C {vsource.sym} 530 -450 0 0 {name=V1 value="dc 0 ac 1"

*name=V1 value="dc 0 ac 1 portnum 1 z0 50"
}
C {code_shown.sym} 580 -280 0 0 {name=NGSPICE
only_toplevel=true
value="
.control
save all
ac dec 1000 10e3 10e9 
*sp lin 100 1e3 2e9 0
write ac_extracted_analog_pad.raw
.endc
" }
C {launcher.sym} 990 -305 0 0 {name=h1
descr="load waves" 
tclcommand="xschem raw_read $netlist_dir/ac_extracted_analog_pad.raw ac"}
C {code_shown.sym} 20 -235 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
*.include /foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/unextracted_gf180mcu_fd_io__asig_5p0.spice
.include /foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/extracted_gf180mcu_fd_io__asig_5p0_manually_scaled.spice
"}
C {lab_wire.sym} 410 -540 0 1 {name=p4 sig_type=std_logic lab=Vin}
C {title.sym} 180 -40 0 0 {name=l4 author="Ahmed Elnaggar/A38-SilentOwl"}
C {gnd.sym} 530 -380 0 0 {name=l1 lab=0}
C {res.sym} 480 -540 3 0 {name=R1
value=50
footprint=1206
device=resistor
m=1}
C {/foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/xschem/gf180mcu_fd_io__asig_5p0.sym} 240 -540 0 0 {name=x1}
C {vsource.sym} 80 -450 0 1 {name=V2 value="dc 0 ac 1"

*name=V1 value="dc 0 ac 1 portnum 1 z0 50"
}
C {gnd.sym} 80 -380 0 1 {name=l2 lab=0}
