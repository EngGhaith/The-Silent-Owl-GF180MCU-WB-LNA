v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1000 -630 1800 -230 {flags=graph
y1=0
y2=2
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1.0587912e-22
x2=1e-05
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
legendmag=1.0
node=""
color=""
dataset=-1
unitx=1
logx=0
logy=0
}
N 2180 -730 2240 -730 {lab=0
}
N 2240 -730 2240 -680 {lab=0
}
N 2180 -700 2180 -600 {lab=vs
}
N 2180 -600 2180 -560 {lab=vs
}
N 2180 -840 2180 -760 {lab=vdd}
N 1460 -1000 1460 -960 {lab=vdd}
N 1900 -730 1940 -730 {lab=vin
}
N 2250 -600 2270 -600 {lab=#net1}
N 2510 -580 2510 -560 {lab=vout
}
N 2180 -600 2190 -600 {lab=vs}
N 2330 -600 2470 -600 {lab=vout}
N 580 -430 640 -430 {lab=#net6
spice_ignore=true}
N 530 -200 580 -200 {lab=#net6
spice_ignore=true}
N 450 -430 580 -430 {lab=#net6
spice_ignore=true}
N 390 -130 410 -130 {lab=0
spice_ignore=true}
N 390 -130 390 -100 {lab=0
spice_ignore=true}
N 580 -430 580 -200 {lab=#net6
spice_ignore=true}
N 370 -130 390 -130 {lab=0
spice_ignore=true}
N 1770 -730 1870 -730 {lab=vin
}
N 1770 -730 1770 -700 {lab=vin
}
N 2000 -730 2140 -730 {lab=vds}
N 1870 -730 1910 -730 {lab=vin}
N 2510 -600 2510 -580 {lab=vout}
N 2470 -600 2510 -600 {lab=vout}
C {vsource.sym} 1460 -930 0 0 {name=V3 value=3.3 savecurrent=false
}
C {gnd.sym} 1460 -900 0 0 {name=l5 lab=0
}
C {ngspice_get_value.sym} 800 -720 0 0 {name=r2 node=@m.xm1.m0[cdd]
descr="cdd="}
C {devices/code_shown.sym} 130 -740 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"
spice_ignore=true}
C {devices/launcher.sym} 2240 -410 0 0 {name=h3
descr="annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {ngspice_get_value.sym} 800 -680 0 0 {name=r3 node=@m.xm1.m0[cgb]
descr="cgb="}
C {ngspice_get_value.sym} 800 -640 0 0 {name=r4 node=@m.xm1.m0[cgd]
descr="cgd="}
C {ngspice_get_value.sym} 800 -600 0 0 {name=r5 node=@m.xm1.m0[cgg]
descr="cgg="}
C {ngspice_get_value.sym} 800 -560 0 0 {name=r6 node=@m.xm1.m0[css]
descr="css="}
C {ngspice_get_value.sym} 800 -760 0 0 {name=r1 node=@m.xm1.m0[gm]
descr="gm="}
C {ngspice_get_value.sym} 800 -520 0 0 {name=r7 node=@m.xm1.m0[cgs]
descr="cgs="}
C {title-2.sym} 0 0 0 0 {name=l8 author="Ilir Shala" title="The Silent Owl" rev=1.0 lock=true}
C {ngspice_get_value.sym} 800 -480 0 0 {name=r11 node=@m.xm1.m0[vgs]
descr="vgs="}
C {lab_wire.sym} 2070 -730 0 0 {name=p1 sig_type=std_logic lab=vds}
C {lab_wire.sym} 1930 -730 0 0 {name=p2 sig_type=std_logic lab=vin
}
C {gnd.sym} 2510 -505 0 0 {name=l3 lab=0
}
C {vsource.sym} 2510 -535 0 0 {name=V2 value="dc 0 ac 1 portnum 2 z0 50"
}
C {lab_wire.sym} 2380 -600 2 0 {name=p5 sig_type=std_logic lab=vout
spice_ignore=short}
C {symbols/nfet_03v3.sym} 2160 -730 0 0 {name=M2
L=0.28u
W=20u
nf=1
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {gnd.sym} 2240 -680 0 0 {name=l9 lab=0
}
C {isource.sym} 2180 -530 0 0 {name=I2 value=4m
}
C {gnd.sym} 2180 -500 0 0 {name=l17 lab=0
}
C {lab_pin.sym} 1460 -1000 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 2180 -840 0 0 {name=p6 sig_type=std_logic lab=vdd}
C {code_shown.sym} 1290 -1480 0 0 {name=ngspice_s2 only_toplevel=true 
value="

.temp 25

.control

set spnum = 1

sp lin 500 100e6 10e9 1
write LNA_sim.raw

let A_fs = vdb(v(vds)/v(vin))
let A_ss = vdb(v(vout)/v(vds))

let zout = 50*(1+sp1.s_2_2)/(1-sp1.s_2_2)
plot mag(zout)
plot ph(zout)

plot vdb(sp1.s_1_1) vdb(sp1.s_2_2)
plot vdb(sp1.s_2_1)
plot nf NFmin
plot A_fs A_ss


.endc
"
}
C {capa.sym} 1970 -730 3 0 {name=C1
m=1
value=100p
footprint=1206
device="ceramic capacitor"
}
C {capa.sym} 2300 -600 3 0 {name=C3
m=1
value=150p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 1770 -645 0 0 {name=l1 lab=0
}
C {vsource.sym} 1770 -675 0 0 {name=V1 value="dc 0 ac 1 portnum 1 z0 50"
}
C {ind.sym} 2220 -600 3 0 {name=L10
m=1
value=0.3n
footprint=1206
device=inductor}
C {code_shown.sym} 120 -1285 0 0 {name=MODELS1 only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"
}
C {code_shown.sym} 2785 -880 0 0 {name=ngspice_op2 only_toplevel=true 
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

save @m.xm4.m0[id]
save @m.xm4.m0[gm]



op
write LNA_sim.raw
set appendwrite
quit
.endc
"
spice_ignore=true}
C {code_shown.sym} 2320 -1520 0 0 {name=ngspice_op3 only_toplevel=true 
value="

.option klu
.temp 25
.control

ac dec 20 1 20e9
let A_fs = db(v(vds)/v(vin))
let A_ss = db(v(vout)/v(vds))
let A = db(v(vout)/v(vin))
*let vo_phase_margin = phase(v(vo)) *180/pi+180
*meas ac A0 find vo_mag at=1k
*meas ac UGF when vo_mag=1 fall=1
*meas ac PM find vo_phase_margin when vo_mag=1
*echo $&A0 $&UGF $&PM
*echo $&A0
*echo $plots
plot A_fs A_ss A
remzerovec
write LNA_sim.raw

.endc
"
spice_ignore=true}
C {/foss/designs/theSilentOwl/Pads_Simulation/port_diff.sym} 450 -400 0 0 {name=V4 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=
spice_ignore=true
spice_ignore=true}
C {/foss/designs/theSilentOwl/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.sym} 380 -200 0 0 {name=x1 model=gf180mcu_fd_io__asig_5p0
spice_ignore=true}
C {gnd.sym} 390 -100 0 0 {name=l13 lab=0
spice_ignore=true}
C {lab_wire.sym} 2180 -650 0 0 {name=p7 sig_type=std_logic lab=vs}
