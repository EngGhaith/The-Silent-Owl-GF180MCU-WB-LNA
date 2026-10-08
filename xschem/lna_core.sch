v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 760 -830 780 -830 {
lab=vss}
N 490 -580 510 -580 {
lab=rf_in_pad}
N 760 -1000 800 -1000 {
lab=vm2}
N 860 -1000 900 -1000 {
lab=g_cs}
N 760 -620 760 -610 {
lab=#net1}
N 760 -610 760 -580 {
lab=#net1}
N 700 -830 720 -830 {
lab=g_cg}
N 550 -970 550 -950 {
lab=vbias_cg}
N 550 -730 550 -690 {
lab=vss}
N 1300 -560 1320 -560 {
lab=vss}
N 1300 -530 1300 -520 {
lab=#net2}
N 1240 -560 1260 -560 {
lab=g_cs}
N 950 -1200 950 -1180 {
lab=vbias_cs}
N 950 -1120 950 -1090 {
lab=g_cs}
N 1300 -520 1300 -460 {
lab=#net2}
N 390 -580 430 -580 {
lab=rf_in_pad}
N 1300 -670 1320 -670 {
lab=vss}
N 1300 -640 1300 -630 {
lab=vm1}
N 1240 -670 1260 -670 {
lab=vbias_cas}
N 1300 -630 1300 -590 {
lab=vm1}
N 1300 -460 1300 -450 {
lab=#net2}
N 1300 -390 1300 -380 {
lab=vss}
N 1300 -380 1300 -360 {
lab=vss}
N 1300 -750 1370 -750 {
lab=vx}
N 760 -900 760 -890 {
lab=vm2}
N 760 -890 760 -860 {lab=vm2}
N 1300 -1160 1300 -1140 {lab=vdd}
N 1300 -1080 1300 -1060 {lab=#net3}
N 760 -960 760 -900 {lab=vm2}
N 1300 -1000 1300 -980 {lab=vx}
N 900 -1150 930 -1150 {lab=vss}
N 500 -920 530 -920 {lab=vss}
N 1300 -1240 1300 -1180 {lab=vdd}
N 550 -830 550 -790 {lab=g_cg}
N 760 -800 760 -620 {lab=#net1}
N 340 -830 700 -830 {lab=g_cg}
N 550 -890 550 -830 {lab=g_cg}
N 900 -1000 950 -1000 {lab=g_cs}
N 950 -1090 950 -1000 {lab=g_cs}
N 950 -1000 1010 -1000 {lab=g_cs}
N 1010 -1000 1010 -560 {lab=g_cs}
N 1010 -560 1240 -560 {lab=g_cs}
N 1300 -980 1300 -760 {lab=vx}
N 1300 -760 1300 -700 {lab=vx}
N 1580 -750 1610 -750 {lab=rf_out_pad}
N 1370 -750 1460 -750 {lab=vx}
N 1520 -750 1580 -750 {lab=rf_out_pad}
N 760 -1105 760 -1085 {lab=#net4}
N 760 -1025 760 -1015 {lab=vm2}
N 760 -1215 760 -1165 {lab=vdd}
N 760 -410 760 -370 {lab=vss}
N 760 -580 760 -560 {lab=#net1}
N 760 -500 760 -470 {lab=#net5}
N 650 -580 760 -580 {lab=#net1}
N 510 -580 590 -580 {lab=rf_in_pad}
N 430 -580 490 -580 {lab=rf_in_pad}
N 330 -580 390 -580 {lab=rf_in_pad}
N 510 -580 510 -540 {lab=rf_in_pad}
N 510 -410 510 -380 {lab=vss}
N 220 -580 270 -580 {lab=rf_in_pad}
N 170 -580 220 -580 {lab=rf_in_pad}
N 510 -480 510 -470 {lab=#net6}
N 270 -580 330 -580 {lab=rf_in_pad}
N 1580 -750 1580 -675 {lab=rf_out_pad}
N 1300 -1175 1300 -1160 {lab=vdd}
N 1300 -1180 1300 -1175 {lab=vdd}
N 760 -1000 760 -960 {lab=vm2}
N 760 -1010 760 -1000 {lab=vm2}
N 760 -1015 760 -1010 {lab=vm2}
C {lab_pin.sym} 760 -1215 1 0 {name=p11 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 900 -1000 0 0 {name=p14 sig_type=std_logic lab=g_cs}
C {lab_pin.sym} 760 -600 2 0 {name=p1 sig_type=std_logic lab=s
spice_ignore=true}
C {symbols/nfet_06v0.sym} 740 -830 0 0 {name=M2
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
}
C {lab_pin.sym} 340 -830 0 0 {name=p4 sig_type=std_logic lab=g_cg}
C {lab_pin.sym} 1300 -1240 0 0 {name=p39 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 510 -380 3 0 {name=p46 sig_type=std_logic lab=vss
}
C {ind.sym} 510 -440 0 0 {name=LEQ
m=1
value=1.3333n
footprint=1206
device=inductor
}
C {symbols/nfet_06v0.sym} 1280 -670 0 0 {name=M4
L=0.6u
W=35u
nf=10
m=4
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {res.sym} 1300 -420 0 0 {name=RS_EQ
value=0.05
footprint=1206
device=resistor
m=1
}
C {symbols/nfet_03v3.sym} 1280 -560 0 0 {name=M1
L=0.28u
W=20u
nf=10
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1300 -740 0 0 {name=p36 sig_type=std_logic lab=vx
}
C {lab_pin.sym} 760 -888.75 0 0 {name=p71 sig_type=std_logic lab=vm2}
C {lab_pin.sym} 1300 -618.75 0 0 {name=p72 sig_type=std_logic lab=vm1}
C {ind.sym} 1300 -1030 0 0 {name=LD2
m=1
value=4n
footprint=1206
device=inductor
}
C {res.sym} 1300 -1110 0 0 {name=RLD2
value=50
footprint=1206
device=resistor
m=1
}
C {symbols/ppolyf_u_1k.sym} 950 -1150 2 1 {name=R2
W=1u
L=48.35u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 550 -920 2 1 {name=R1
W=1u
L=48.35u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 830 -1000 1 0 {name=C1
W=58.2168u
L=58.2168u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 550 -760 2 1 {name=C9
W=49.8865u
L=49.8865u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=4}
C {iopin.sym} 170 -580 0 1 {name=p56 lab=rf_in_pad}
C {iopin.sym} 550 -970 3 0 {name=p57 lab=vbias_cg}
C {iopin.sym} 1610 -750 0 0 {name=p58 lab=rf_out_pad}
C {iopin.sym} 950 -1200 3 0 {name=p59 lab=vbias_cs
}
C {iopin.sym} 70 -810 0 1 {name=p60 lab=vdd}
C {iopin.sym} 1240 -670 0 1 {name=p61 lab=vbias_cas}
C {iopin.sym} 70 -770 0 1 {name=p62 lab=vss}
C {iopin.sym} 180 -1230 3 0 {name=p64 lab=vbias_buf
}
C {iopin.sym} 1010 -330 0 1 {name=p65 lab=vbias_icg
spice_ignore=true}
C {lab_pin.sym} 1300 -360 3 0 {name=p7 sig_type=std_logic lab=vss}
C {lab_pin.sym} 550 -690 3 0 {name=p10 sig_type=std_logic lab=vss}
C {lab_pin.sym} 780 -830 2 0 {name=p12 sig_type=std_logic lab=vss}
C {lab_pin.sym} 500 -920 2 1 {name=p3 sig_type=std_logic lab=vss}
C {lab_pin.sym} 900 -1150 2 1 {name=p31 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1320 -670 2 0 {name=p41 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1320 -560 2 0 {name=p42 sig_type=std_logic lab=vss}
C {iopin.sym} 230 -1230 3 0 {name=p6 lab=vbias_csc
}
C {iopin.sym} 280 -1230 3 0 {name=p13 lab=vbias_casc
}
C {capa.sym} 1490 -750 3 0 {name=C11
m=1
value=7p
footprint=1206
device="ceramic capacitor"
}
C {ind.sym} 760 -1055 0 0 {name=LD4
m=1
value=8n
footprint=1206
device=inductor
}
C {res.sym} 760 -1135 0 0 {name=RLD3
value=30
footprint=1206
device=resistor
m=1
}
C {ind.sym} 760 -440 0 0 {name=L1
m=1
value=2.5n
footprint=1206
device=inductor
}
C {lab_pin.sym} 760 -370 3 0 {name=p19 sig_type=std_logic lab=vss}
C {res.sym} 760 -530 0 0 {name=Rs
value=2.5
footprint=1206
device=resistor
m=1
}
C {capa.sym} 620 -580 3 0 {name=C15
m=1
value=1.25p
footprint=1206
device="ceramic capacitor"
}
C {res.sym} 510 -510 0 0 {name=RLEQ
value=1.6755
footprint=1206
device=resistor
m=1
}
C {ind.sym} 1580 -645 0 0 {name=LSHUNT_OUT
m=1
value=2.5n
footprint=1206
device=inductor
}
C {res.sym} 1580 -585 2 0 {name=RLSHOUT
value=3.1416
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 1580 -555 2 0 {name=p915 sig_type=std_logic lab=vss}
