v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 550 -410 580 -410 {lab=v_dd}
N 480 -410 550 -410 {lab=v_dd}
N 480 -410 480 -390 {lab=v_dd}
N 580 -340 580 -320 {lab=GND}
N 480 -320 580 -320 {lab=GND}
N 480 -330 480 -320 {lab=GND}
N 480 -320 480 -300 {lab=GND}
N 880 -370 910 -370 {lab=vref}
C {devices/code_shown.sym} 70 -570 0 0 {name=NGSPICE only_toplevel=true 
value="
*.option klu
.option method=gear
.option warn=0
.temp 27

.control
save all
set filetype=ascii

op
write bandgap_tb.raw

dc temp -30 125 1
set appendwrite
write bandgap_tb.raw
plot vref

*wrdata bandgap_tb.txt vref
.endc
"}
C {devices/code_shown.sym} 620 -60 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

"}
C {devices/code_shown.sym} 1150 -60 0 0 {name=MODELS2 only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/launcher.sym} 340 -40 0 0 {name=h3
descr="annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
spice_ignore=true}
C {devices/gnd.sym} 480 -300 0 0 {name=l3 lab=GND}
C {devices/vsource.sym} 480 -360 0 0 {name=Vdd value=5}
C {devices/lab_pin.sym} 520 -410 1 0 {name=p2 sig_type=std_logic lab=v_dd}
C {devices/lab_wire.sym} 910 -370 2 0 {name=p1 sig_type=std_logic lab=vref}
C {bandgap.sym} 730 -270 0 0 {name=x1}
