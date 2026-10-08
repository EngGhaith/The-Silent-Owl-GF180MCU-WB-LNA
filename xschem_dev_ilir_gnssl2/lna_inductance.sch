v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 730 -430 730 -410 {lab=cg_vin}
N 730 -520 730 -490 {lab=vd}
N 690 -460 730 -460 {lab=cg_vin}
N 690 -460 690 -410 {lab=cg_vin}
N 690 -410 730 -410 {lab=cg_vin}
N 730 -410 730 -350 {lab=cg_vin}
N 770 -460 820 -460 {lab=#net1}
N 730 -660 730 -600 {lab=vdd}
N 730 -600 730 -590 {lab=vdd}
N 730 -530 730 -520 {lab=vd}
N 420 -350 420 -320 {lab=#net2
}
N 500 -350 590 -350 {lab=#net2
}
N 420 -260 420 -250 {lab=0
}
N 420 -270 420 -260 {lab=0
}
N 710 -350 730 -350 {lab=cg_vin}
N 650 -350 710 -350 {lab=cg_vin}
N 420 -350 500 -350 {lab=#net2}
N 730 -350 730 -300 {lab=cg_vin}
N 730 -300 730 -270 {lab=cg_vin}
N 880 -460 880 -430 {lab=#net1}
N 820 -460 880 -460 {lab=#net1}
N 730 -510 830 -510 {lab=vd}
N 880 -510 890 -510 {lab=#net3
}
N 980 -410 980 -400 {lab=0
}
N 980 -420 980 -410 {lab=0
}
N 890 -510 980 -510 {lab=#net3
}
N 980 -510 980 -470 {lab=#net3
}
N 110 -490 110 -450 {lab=vdd}
C {symbols/nfet_06v0.sym} 750 -460 0 1 {name=M1
L=0.70u
W=20u
nf=1
m=13
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {res.sym} 730 -560 0 0 {name=R8
value=400
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 730 -660 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {vsource.sym} 420 -295 0 0 {name=V1 value="dc 0 ac 1 portnum 1 z0 50"
}
C {lab_wire.sym} 730 -350 2 1 {name=p9 sig_type=std_logic lab=cg_vin
}
C {gnd.sym} 420 -250 0 0 {name=l15 lab=0
}
C {capa.sym} 620 -350 3 0 {name=C3
m=1
value=10p
footprint=1206
device="ceramic capacitor"
}
C {gnd.sym} 730 -210 0 0 {name=l1 lab=0
}
C {ind.sym} 730 -240 0 0 {name=L6
m=1
value=1n
footprint=1206
device=inductor}
C {vsource.sym} 880 -400 0 0 {name=vgs value=1.4 savecurrent=false
}
C {gnd.sym} 880 -370 0 0 {name=l4 lab=0
}
C {capa.sym} 860 -510 3 0 {name=C9
m=1
value=10p
footprint=1206
device="ceramic capacitor"
}
C {vsource.sym} 980 -445 0 0 {name=V2 value="dc 0 ac 1 portnum 2 z0 1M"
}
C {gnd.sym} 980 -400 0 0 {name=l2 lab=0
}
C {code_shown.sym} 10 -135 0 0 {name=MODELS2 only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical

.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"
spice_ignore=true}
C {code_shown.sym} 70 -1080 0 0 {name=ngspice_s2 only_toplevel=true 
value="

.temp 25

.control

set spnum = 1

foreach Lval 0.5n 0.75n 1n 1.25n 1.5n 2n
	alter L6 $Lval

	sp lin 500 100e6 10e9 1

end

plot vdb(sp1.s_2_1) vdb(sp2.s_2_1)

*let zin = 50*(1+s_1_1)/(1-s_1_1)
*plot mag(zin)
*plot ph(zin)

*plot vdb(s_1_1) vdb(s_2_2)

*plot nf NFmin
*plot Im(zin) Re(zin)
write lna_inductance.raw


.endc
"
spice_ignore=true}
C {vsource.sym} 110 -420 0 0 {name=V10 value=5 savecurrent=false
}
C {gnd.sym} 110 -390 0 0 {name=l29 lab=0
value=5}
C {lab_pin.sym} 110 -490 0 0 {name=p33 sig_type=std_logic lab=vdd
value=5}
C {devices/code_shown.sym} 950 -60 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {code_shown.sym} 515 -1000 0 0 {name=ngspice_op2 only_toplevel=true 
value="

.temp 27
.control

save all
save @m.xm1.m0[id]
save @m.xm1.m0[gm]

op
write lna_inductance.raw

set appendwrite
quit
.endc
"
}
C {devices/launcher.sym} 1030 -190 0 0 {name=h2
descr="simulate" 
tclcommand="xschem save; xschem netlist; xschem simulate"
}
C {devices/launcher.sym} 1220 -190 0 0 {name=h1
descr="annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {lab_pin.sym} 730 -510 0 0 {name=p1 sig_type=std_logic lab=vd}
