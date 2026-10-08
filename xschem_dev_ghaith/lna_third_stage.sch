v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 610 -180 610 -140 {lab=vdd}
N 970 -470 1030 -470 {lab=vin_sf}
N 880 -470 970 -470 {lab=vin_sf}
N 880 -470 880 -440 {lab=vin_sf}
N 1070 -440 1070 -310 {lab=#net1}
N 1070 -470 1100 -470 {lab=0}
N 1100 -470 1100 -410 {lab=0}
N 1070 -580 1070 -500 {lab=vdd}
N 1360 -350 1360 -310 {lab=vout_sf}
N 1290 -350 1360 -350 {lab=vout_sf}
N 1360 -350 1450 -350 {lab=vout_sf}
N 1070 -350 1120 -350 {lab=#net1}
N 1200 -350 1230 -350 {lab=#net2}
N 1120 -350 1140 -350 {lab=#net1}
C {symbols/nfet_03v3.sym} 1050 -470 0 0 {name=M9
L=0.28u
W=20u
nf=1
m=30
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {res.sym} 1360 -280 0 0 {name=R7
value=50
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 1070 -580 0 0 {name=p35 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1440 -350 2 0 {name=p36 sig_type=std_logic lab=vout_sf
}
C {gnd.sym} 1100 -410 0 0 {name=l36 lab=0
}
C {lab_wire.sym} 960 -470 0 0 {name=p1 sig_type=std_logic lab=vin_sf
}
C {code_shown.sym} 85 -970 0 0 {name=ngspice_op2 only_toplevel=true 
value="

.temp 27
.control

save all
save @m.xm9.m0[id]
save @m.xm9.m0[gm]

op
write lna_third_stage.raw
set appendwrite
quit
.endc
"
spice_ignore=true}
C {devices/launcher.sym} 140 -230 0 0 {name=h3
descr="annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
spice_ignore=true}
C {vsource.sym} 610 -110 0 0 {name=V3 value=3.3 savecurrent=false
}
C {gnd.sym} 610 -80 0 0 {name=l5 lab=0
}
C {lab_pin.sym} 610 -180 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {vsource.sym} 880 -410 0 0 {name=V1 value="dc 1.7 ac 1" savecurrent=false
}
C {gnd.sym} 880 -380 0 0 {name=l1 lab=0
}
C {code_shown.sym} 70 -125 0 0 {name=MODELS1 only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"
}
C {code_shown.sym} 410 -990 0 0 {name=ngspice_op3 only_toplevel=true 
value="

.option klu
.temp 25
.control

ac dec 20 1 10e9
let A = db(v(vout_sf)/v(vin_sf))

plot A
remzerovec
write lna_third_stage.raw

.endc
"
spice_ignore=true}
C {isource.sym} 1070 -280 0 0 {name=I1 value=8m pwl(0 0 10u 0 }
C {gnd.sym} 1070 -250 0 0 {name=l3 lab=0
}
C {gnd.sym} 1360 -250 0 0 {name=l4 lab=0
}
C {capa.sym} 1260 -350 3 0 {name=C8
m=1
value=10p
footprint=1206
device="ceramic capacitor"
}
C {ind.sym} 1170 -350 1 0 {name=L6
m=1
value=0.1n
footprint=1206
device=inductor
}
C {code_shown.sym} 860 -1030 0 0 {name=ac simulation only_toplevel=true 
value="

.option klu
.temp 25
.control

ac dec 20 1 20e9
let A = db(v(vout_sf)/v(vin_sf))
*let vo_phase_margin = phase(v(vo)) *180/pi+180
*meas ac A0 find vo_mag at=1k
*meas ac UGF when vo_mag=1 fall=1
*meas ac PM find vo_phase_margin when vo_mag=1
*echo $&A0 $&UGF $&PM
*echo $&A0
*echo $plots
plot A
remzerovec
write LNA_sim.raw

.endc
"
}
