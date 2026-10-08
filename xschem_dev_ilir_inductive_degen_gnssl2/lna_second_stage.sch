v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 890 -250 910 -250 {lab=vin_cs}
N 950 -220 950 -190 {lab=0}
N 950 -250 980 -250 {lab=0}
N 980 -250 980 -200 {lab=0}
N 950 -740 950 -700 {lab=vdd}
N 950 -190 950 -170 {lab=0}
N 950 -520 950 -490 {lab=vout_cs}
N 950 -490 950 -420 {lab=vout_cs}
N 950 -420 950 -400 {lab=vout_cs}
N 950 -200 980 -200 {lab=0}
N 950 -440 1100 -440 {lab=vout_cs}
N 840 -250 890 -250 {lab=vin_cs}
N 950 -310 950 -280 {lab=vout_cs}
N 580 -250 580 -210 {lab=vdd}
N 800 -250 800 -200 {lab=vin_cs}
N 950 -400 950 -310 {lab=vout_cs}
N 950 -640 950 -580 {lab=#net1}
N 810 -250 840 -250 {lab=vin_cs}
N 800 -250 810 -250 {lab=vin_cs}
C {symbols/nfet_03v3.sym} 930 -250 0 0 {name=M9
L=0.28u
W=20u
nf=1
m=5
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {res.sym} 950 -670 0 0 {name=R7
value=400
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 950 -740 0 0 {name=p35 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1080 -440 2 0 {name=p36 sig_type=std_logic lab=vout_cs
}
C {gnd.sym} 950 -170 0 0 {name=l36 lab=0
}
C {lab_wire.sym} 860 -250 0 0 {name=p1 sig_type=std_logic lab=vin_cs
}
C {code_shown.sym} 15 -1050 0 0 {name=ngspice_op2 only_toplevel=true 
value="

.temp 27
.control

save all
save @m.xm9.m0[id]
save @m.xm9.m0[gm]

save @m.xm10.m0[id]
save @m.xm10.m0[gm]

op
write lna_second_stage.raw
set appendwrite
quit
.endc
"
spice_ignore=true}
C {devices/launcher.sym} 110 -290 0 0 {name=h3
descr="annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
spice_ignore=true}
C {vsource.sym} 580 -180 0 0 {name=V3 value=3.3 savecurrent=false
}
C {gnd.sym} 580 -150 0 0 {name=l5 lab=0
}
C {lab_pin.sym} 580 -250 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {vsource.sym} 800 -170 0 0 {name=V1 value="dc 1.02 ac 1" savecurrent=false
}
C {gnd.sym} 800 -140 0 0 {name=l1 lab=0
}
C {code_shown.sym} 30 -155 0 0 {name=MODELS1 only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"
}
C {code_shown.sym} 290 -1040 0 0 {name=ngspice_op3 only_toplevel=true 
value="

.option klu
.temp 25
.control

ac dec 20 1 20e9
let A = db(v(vout_cs)/v(vin_cs))

plot A
remzerovec
write lna_second_stage.raw

.endc
"
spice_ignore=true}
C {ind.sym} 950 -550 0 0 {name=L2
m=1
value=2n
footprint=1206
device=inductor
}
C {code_shown.sym} 660 -1140 0 0 {name=ac simulation only_toplevel=true 
value="

.option klu
.temp 25
.control

ac dec 20 1 20e9
let A = db(v(vout_cs)/v(vin_cs))
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
