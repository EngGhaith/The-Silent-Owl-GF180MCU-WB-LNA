v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1620 -1720 2420 -1320 {flags=graph
y1=0.17
y2=1
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1e+08
x2=1e+10
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
node="s_1_1
s_2_2"
color="4 12"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 1620 -1300 2420 -900 {flags=graph
y1=2.4
y2=5.2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1e+08
x2=1e+10
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
node="nf
NFmin"
color="4 12"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 1620 -880 2420 -480 {flags=graph
y1=-170
y2=56
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1e+08
x2=1e+10
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
color="11 12"
node="Re(z_1_1)
Im(z_1_1)"}
B 2 1620 -460 2420 -60 {flags=graph
y1=0.0021
y2=0.0048
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1e+08
x2=1e+10
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
color=11
node=S_2_1}
N 1030 -650 1030 -630 {lab=cg_vin
}
N 1030 -630 1030 -600 {lab=cg_vin
}
N 1130 -680 1130 -650 {lab=#net1}
N 1070 -680 1130 -680 {lab=#net1}
N 1030 -990 1030 -930 {lab=vdd}
N 520 -630 520 -600 {lab=#net2
}
N 1030 -770 1080 -770 {lab=cg_vout}
N 1030 -850 1030 -710 {lab=cg_vout}
N 1030 -930 1030 -920 {lab=vdd}
N 1030 -860 1030 -850 {lab=cg_vout}
N 1030 -600 1030 -570 {lab=cg_vin}
N 910 -630 950 -630 {lab=cg_vin
spice_ignore=short}
N 1020 -680 1030 -680 {lab=0}
N 1020 -680 1020 -650 {lab=0}
N 930 -680 930 -650 {lab=0}
N 940 -650 1020 -650 {lab=0}
N 930 -650 940 -650 {lab=0}
N 600 -630 690 -630 {lab=#net2
}
N 830 -630 910 -630 {lab=cg_vin}
N 520 -540 520 -530 {lab=0
}
N 520 -550 520 -540 {lab=0
}
N 1080 -770 1170 -770 {lab=cg_vout}
N 810 -630 830 -630 {lab=cg_vin}
N 750 -630 810 -630 {lab=cg_vin}
N 1010 -630 1030 -630 {lab=cg_vin}
N 950 -630 1000 -630 {lab=cg_vin}
N 1000 -630 1010 -630 {lab=cg_vin}
N 150 -770 150 -730 {lab=vdd}
N 1220 -770 1230 -770 {lab=#net3
}
N 1320 -670 1320 -660 {lab=0
}
N 1320 -680 1320 -670 {lab=0
}
N 1230 -770 1320 -770 {lab=#net3
}
N 1320 -770 1320 -730 {lab=#net3
}
N 140 -580 140 -560 {lab=#net2
spice_ignore=true}
N 520 -630 600 -630 {lab=#net2}
C {code_shown.sym} 100 -365 0 0 {name=MODELS1 only_toplevel=true
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
C {code_shown.sym} 85 -1550 0 0 {name=ngspice_op2 only_toplevel=true 
value="

.temp 27
.control

save all
save @m.xm1.m0[gm]
save @m.xm1.m0[cdd]
save @m.xm1.m0[cgb]
save @m.xm1.m0[cgd]
save @m.xm1.m0[cgg]
save @m.xm1.m0[css]
save @m.xm1.m0[cgs]
save @m.xm1.m0[id]
save @m.xm1.m0[vgs]

save @m.xm2.m0[id]
save @m.xm2.m0[gm]

save @m.xm3.m0[id]
save @m.xm3.m0[gm]
save @m.xm3.m0[gds]

save @m.xm4.m0[id]
save @m.xm4.m0[gm]

save @m.xm9.m0[id]
save @m.xm9.m0[gm]

save @m.xm10.m0[id]
save @m.xm10.m0[gm]

op
write lna_first_stage.raw
set appendwrite
quit
.endc
"
spice_ignore=true}
C {vsource.sym} 1130 -620 0 0 {name=vgs value=1.6 savecurrent=false
}
C {gnd.sym} 1130 -590 0 0 {name=l4 lab=0
}
C {gnd.sym} 930 -680 2 0 {name=l7 lab=0
}
C {res.sym} 1030 -890 0 0 {name=R8
value=380
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 1030 -990 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {vsource.sym} 520 -575 0 0 {name=V1 value="dc 0 ac 1 portnum 1 z0 50"
}
C {lab_wire.sym} 830 -630 2 1 {name=p9 sig_type=std_logic lab=cg_vin
}
C {code_shown.sym} 370 -1530 0 0 {name=ngspice_s2 only_toplevel=true 
value="

.temp 25

.control

set spnum = 1

sp lin 500 100e6 10e9 1
write lna_first_stage.raw


let zin = 50*(1+s_1_1)/(1-s_1_1)
plot mag(zin)
plot ph(zin)

plot vdb(s_1_1) vdb(s_2_2)
plot vdb(s_2_1)
plot nf NFmin
plot Im(zin) Re(zin)



.endc
"
}
C {gnd.sym} 520 -530 0 0 {name=l15 lab=0
}
C {capa.sym} 720 -630 3 0 {name=C3
m=1
value=10p
footprint=1206
device="ceramic capacitor"
}
C {devices/launcher.sym} 1000 -250 0 0 {name=h2
descr="simulate" 
tclcommand="xschem save; xschem netlist; xschem simulate"
}
C {devices/launcher.sym} 1190 -250 0 0 {name=h1
descr="annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {devices/code_shown.sym} 100 -180 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

"
spice_ignore=true}
C {vsource.sym} 150 -700 0 0 {name=V10 value=5 savecurrent=false
}
C {gnd.sym} 150 -670 0 0 {name=l29 lab=0
value=5}
C {lab_pin.sym} 150 -770 0 0 {name=p33 sig_type=std_logic lab=vdd
value=5}
C {lab_wire.sym} 1090 -770 2 0 {name=p38 sig_type=std_logic lab=cg_vout
}
C {capa.sym} 1200 -770 3 0 {name=C9
m=1
value=10p
footprint=1206
device="ceramic capacitor"
}
C {devices/launcher.sym} 1420 -250 0 0 {name=h5
descr="waveform" 
tclcommand="xschem raw_read $netlist_dir/lna_first_stage.raw sp"
}
C {gnd.sym} 1030 -510 0 0 {name=l1 lab=0
}
C {vsource.sym} 1320 -705 0 0 {name=V2 value="dc 0 ac 1 portnum 2 z0 1M"
}
C {gnd.sym} 1320 -660 0 0 {name=l2 lab=0
}
C {code_shown.sym} 790 -1540 0 0 {name=ac simulation only_toplevel=true 
value="

.option klu
.temp 25
.control

ac dec 20 1 20e9
let A = db(v(cg_vout)/v(cg_vin))
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
spice_ignore=true}
C {vsource.sym} 140 -530 0 0 {name=vgs1 value="dc 0 ac 1" savecurrent=false
spice_ignore=true}
C {gnd.sym} 140 -500 0 0 {name=l3 lab=0
spice_ignore=true}
C {ind.sym} 1030 -540 0 0 {name=L6
m=1
value=1n
footprint=1206
device=inductor}
C {symbols/nfet_06v0.sym} 760 -820 0 1 {name=M2
L=0.6u
W=40u
nf=10
m=14
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
spice_ignore=true}
C {code_shown.sym} -710 -775 0 0 {name=MODELS2 only_toplevel=true
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
"}
C {symbols/nfet_06v0.sym} 1050 -680 0 1 {name=M1
L=0.70u
W=0.30u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
