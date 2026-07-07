v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 200 -460 270 -460 {lab=vdd}
N 140 -460 140 -420 {lab=vdd}
N 140 -460 200 -460 {lab=vdd}
N 250 -390 270 -390 {lab=0}
N 250 -390 250 -370 {lab=0}
N 250 -370 250 -360 {lab=0}
N 140 -360 250 -360 {lab=0}
N 570 -420 720 -420 {lab=vp}
N 800 -310 800 -290 {lab=0}
N 840 -310 840 -240 {lab=#net1}
N 800 -510 800 -470 {lab=vdd}
N 840 -510 840 -470 {lab=#net2}
N 840 -590 840 -570 {
lab=vdd}
N 840 -600 840 -590 {lab=vdd}
N 680 -360 720 -360 {lab=vn}
N 680 -360 680 -130 {lab=vn}
N 900 -390 990 -390 {lab=vref}
N 680 -130 1030 -130 {lab=vn}
N 1030 -490 1030 -420 {lab=vdd}
N 1030 -360 1030 -300 {lab=#net3}
N 1030 -240 1030 -130 {lab=vn}
N 1030 -130 1030 -100 {lab=vn}
N 1030 -320 1280 -320 {lab=#net3}
N 1180 -320 1180 -270 {lab=#net3}
N 1280 -320 1280 -280 {lab=#net3}
N 1280 -220 1280 -180 {lab=#net4}
N 1030 -390 1050 -390 {lab=vdd}
N 1050 -440 1050 -390 {lab=vdd}
N 1030 -440 1050 -440 {lab=vdd}
C {bandgap.sym} 420 -320 0 0 {name=x1}
C {ota-5t.sym} 710 -310 0 0 {name=x2}
C {vsource.sym} 140 -390 0 0 {name=V3 value=5 savecurrent=false
}
C {gnd.sym} 140 -360 0 0 {name=l5 lab=0
}
C {lab_pin.sym} 140 -460 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {gnd.sym} 800 -290 0 0 {name=l1 lab=0
}
C {vsource.sym} 840 -210 0 0 {name=V1 value=0 savecurrent=false
}
C {gnd.sym} 840 -180 0 0 {name=l2 lab=0
}
C {lab_pin.sym} 800 -510 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {isource.sym} 840 -540 0 0 {name=I0 value=20u pwl(0 0 10u 0 11u 20u)"}
C {lab_pin.sym} 840 -600 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {symbols/pfet_03v3.sym} 1010 -390 0 0 {name=M1
L=2u
W=20u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1030 -490 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {res.sym} 1030 -270 0 0 {name=R1
value=18k
footprint=1206
device=resistor
m=1}
C {res.sym} 1030 -70 0 0 {name=R2
value=1k
footprint=1206
device=resistor
m=1}
C {gnd.sym} 1030 -40 0 0 {name=l3 lab=0
}
C {capa.sym} 1180 -240 0 0 {name=C1
m=1
value=10f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 1180 -210 0 0 {name=l4 lab=0
}
C {ammeter.sym} 1280 -250 0 0 {name=Vmeas savecurrent=true spice_ignore=0}
C {vsource.sym} 1280 -150 0 0 {name=V2 value=0.89 savecurrent=false
}
C {gnd.sym} 1280 -120 0 0 {name=l6 lab=0
}
C {code_shown.sym} 20 45 0 0 {name=MODELS1 only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"
spice_ignore=true}
C {devices/code_shown.sym} 960 50 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

"}
C {devices/code_shown.sym} 1500 90 0 0 {name=MODELS2 only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 1390 -430 0 0 {name=NGSPICE only_toplevel=true 
value="
*.option klu
.option method=gear
.option warn=0
.temp 27

.control
save all
set filetype=ascii

op
write bias_current.raw

quit
*wrdata bandgap_tb.txt vref
.endc
"}
C {devices/launcher.sym} 210 -60 0 0 {name=h2
descr="simulate" 
tclcommand="xschem save; xschem netlist; xschem simulate"
}
C {devices/launcher.sym} 450 -60 0 0 {name=h3
descr="annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {lab_pin.sym} 640 -420 0 0 {name=p5 sig_type=std_logic lab=vp}
C {lab_pin.sym} 960 -390 0 0 {name=p6 sig_type=std_logic lab=vref}
C {lab_pin.sym} 930 -130 0 0 {name=p7 sig_type=std_logic lab=vn}
