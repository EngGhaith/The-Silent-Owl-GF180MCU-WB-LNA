v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Layout fingers (unit cell nf=10, shared diffusion, row edges = source):
M2: 2 rows x 7 units = 140 fingers + 2 dummy fingers per row end -> M2D (nf=2, m=4)
M4: 1 row x 4 units = 40 fingers + 2 dummy fingers per row end -> M4D (nf=2, m=2)
M1: 1 row x 10 units = 100 fingers + 2 dummy fingers per row end -> M1D (nf=2, m=2)
Dummies: gate + bulk -> vss, S/D -> row edge net (net1 / vm1 / net2)} 1060 -320 0 0 0.25 0.25 {}
T {CDCPL: supply decap of the 20x20 supply tiles in the layout
(cells/vss_m1m2m4_vdd_m3m5_dcpl_mim_20x20_fix.gds, 4 MIM 5.1x6.3 per tile,
top plate M5 = vdd, bottom plate M4 = vss). m = 4 x number of PG_MIM tiles
in klayout/lna_core_parts.gds (70 -> 280). Needed for LVS; no effect on the
simulation with the ideal VDD source of the testbench.} 1800 -1260 0 0 0.3 0.3 {}
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
N 760 -960 760 -900 {lab=vm2}
N 900 -1150 930 -1150 {lab=vss}
N 500 -920 530 -920 {lab=vss}
N 1300 -1240 1300 -1180 {lab=vdd}
N 550 -830 550 -790 {lab=g_cg}
N 760 -800 760 -620 {lab=#net1}
N 340 -830 700 -830 {lab=g_cg
spice_ignore=short}
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
N 760 -610 880 -610 {lab=#net1}
N 880 -670 900 -670 {lab=#net1}
N 900 -670 900 -610 {lab=#net1}
N 880 -610 900 -610 {lab=#net1}
N 820 -640 840 -640 {lab=vss}
N 1300 -460 1480 -460 {lab=#net2}
N 1480 -520 1500 -520 {lab=#net2}
N 1500 -520 1500 -460 {lab=#net2}
N 1480 -460 1500 -460 {lab=#net2}
N 1420 -490 1440 -490 {lab=vss}
N 190 -790 190 -770 {lab=#net8
spice_ignore=true}
C {lab_pin.sym} 760 -1215 1 0 {name=p11 sig_type=std_logic lab=vdd
}
C {lab_wire.sym} 900 -1000 0 0 {name=p14 sig_type=std_logic lab=g_cs}
C {lab_pin.sym} 760 -600 2 0 {name=p1 sig_type=std_logic lab=s
spice_ignore=true}
C {symbols/nfet_05v0.sym} 740 -830 0 0 {name=M2
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
model=nfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 340 -830 0 0 {name=p4 sig_type=std_logic lab=g_cg
spice_ignore=short}
C {lab_pin.sym} 1300 -1240 0 0 {name=p39 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 510 -380 3 0 {name=p46 sig_type=std_logic lab=vss
}
C {ind.sym} 510 -440 0 0 {name=LEQ
m=1
value=2.8491n
footprint=1206
device=inductor
}
C {symbols/nfet_05v0.sym} 1280 -670 0 0 {name=M4
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
model=nfet_05v0
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
C {LD2_model.sym} 1300 -1030 0 0 {name=XLD2}
C {symbols/rm1.sym} 1200 -1060 0 0 {name=RLD2_T1
W=1.75e-6
L=2.5e-6
model=tm11k
spiceprefix=X
m=1
}
C {lab_pin.sym} 1200 -1090 3 0 {name=pRLD2_T1 sig_type=std_logic lab=vdd}
C {symbols/rm1.sym} 1240 -1060 0 0 {name=RLD2_T1_M
W=1.75e-6
L=2.5e-6
model=rm1
spiceprefix=X
m=4
}
N 1200 -1030 1240 -1030 {lab=net_rld2_t1}
C {lab_pin.sym} 1240 -1090 3 0 {name=pRLD2_T1_M sig_type=std_logic lab=vdd}
C {symbols/rm1.sym} 1400 -1060 0 0 {name=RLD2_T2
W=1.75e-6
L=2.5e-6
model=tm11k
spiceprefix=X
m=1
}
C {lab_pin.sym} 1400 -1090 3 0 {name=pRLD2_T2 sig_type=std_logic lab=vx}
C {symbols/rm1.sym} 1440 -1060 0 0 {name=RLD2_T2_M
W=1.75e-6
L=2.5e-6
model=rm1
spiceprefix=X
m=4
}
N 1400 -1030 1440 -1030 {lab=net_rld2_t2}
C {lab_pin.sym} 1440 -1090 3 0 {name=pRLD2_T2_M sig_type=std_logic lab=vx}
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
C {symbols/cap_mim_2f0fF.sym} 1490 -750 3 0 {name=C11
W=33.118u
L=33.118u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {LD4_model.sym} 760 -1055 0 0 {name=XLD4}
C {symbols/rm1.sym} 660 -1085 0 0 {name=RLD4_T1
W=2.0e-6
L=2.5e-6
model=tm11k
spiceprefix=X
m=1
}
C {lab_pin.sym} 660 -1115 3 0 {name=pRLD4_T1 sig_type=std_logic lab=vdd}
C {symbols/rm1.sym} 700 -1085 0 0 {name=RLD4_T1_M
W=2.0e-6
L=2.5e-6
model=rm1
spiceprefix=X
m=4
}
N 660 -1055 700 -1055 {lab=net_rld4_t1}
C {lab_pin.sym} 700 -1115 3 0 {name=pRLD4_T1_M sig_type=std_logic lab=vdd}
C {symbols/rm1.sym} 860 -1085 0 0 {name=RLD4_T2
W=2.0e-6
L=2.5e-6
model=tm11k
spiceprefix=X
m=1
}
C {lab_pin.sym} 860 -1115 3 0 {name=pRLD4_T2 sig_type=std_logic lab=vm2}
C {symbols/rm1.sym} 900 -1085 0 0 {name=RLD4_T2_M
W=2.0e-6
L=2.5e-6
model=rm1
spiceprefix=X
m=4
}
N 860 -1055 900 -1055 {lab=net_rld4_t2}
C {lab_pin.sym} 900 -1115 3 0 {name=pRLD4_T2_M sig_type=std_logic lab=vm2}
C {LSHUNT_OUT_model.sym} 800 -440 0 0 {name=XL1}
C {symbols/rm1.sym} 700 -470 0 0 {name=RL1_T1
W=26e-6
L=2.5e-6
model=tm11k
spiceprefix=X
m=1
}
N 700 -500 680 -500 {lab=#net1}
N 680 -500 680 -580 {lab=#net1}
C {symbols/rm1.sym} 740 -470 0 0 {name=RL1_T1_M
W=26e-6
L=2.5e-6
model=rm1
spiceprefix=X
m=4
}
N 700 -440 740 -440 {lab=net_rl1_t1}
N 700 -500 740 -500 {lab=net_rl1_t1_top}
C {symbols/rm1.sym} 900 -470 0 0 {name=RL1_T2
W=26e-6
L=2.5e-6
model=tm11k
spiceprefix=X
m=1
}
C {lab_pin.sym} 900 -500 3 0 {name=pRL1_T2 sig_type=std_logic lab=vss}
C {symbols/rm1.sym} 940 -470 0 0 {name=RL1_T2_M
W=26e-6
L=2.5e-6
model=rm1
spiceprefix=X
m=3
}
N 900 -440 940 -440 {lab=net_rl1_t2}
C {lab_pin.sym} 940 -500 3 0 {name=pRL1_T2_M sig_type=std_logic lab=vss}
C {lab_pin.sym} 760 -370 3 0 {name=p19 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} 620 -580 3 0 {name=C15
W=34.7078u
L=34.7078u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 700 -550 0 0 {name=CPI
W=26.7084u
L=26.7084u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_pin.sym} 700 -520 3 0 {name=pCPI_vss sig_type=std_logic lab=vss}
C {res.sym} 510 -510 0 0 {name=RLEQ
value=3.5803
footprint=1206
device=resistor
m=1
}
C {ind.sym} 1580 -645 0 0 {name=LSHUNT_OUT
spice_ignore=true
m=1
value=4.0607n
footprint=1206
device=inductor
}
C {res.sym} 1580 -585 2 0 {name=RLSHOUT
spice_ignore=true
value=5.1028
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 1580 -555 2 0 {name=p915 sig_type=std_logic lab=vss}
C {symbols/nfet_05v0.sym} 860 -640 0 0 {name=M2D
L=0.6u
W=8u
nf=2
m=4
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 820 -640 0 0 {name=pM2D_g sig_type=std_logic lab=vss}
C {lab_pin.sym} 880 -640 2 0 {name=pM2D_b sig_type=std_logic lab=vss}
C {symbols/nfet_05v0.sym} 1460 -650 0 0 {name=M4D
L=0.6u
W=7u
nf=2
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 1480 -680 2 0 {name=pM4D_d sig_type=std_logic lab=vm1}
C {lab_pin.sym} 1480 -620 2 0 {name=pM4D_s sig_type=std_logic lab=vm1}
C {lab_pin.sym} 1440 -650 0 0 {name=pM4D_g sig_type=std_logic lab=vss}
C {lab_pin.sym} 1480 -650 2 0 {name=pM4D_b sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 1460 -490 0 0 {name=M1D
L=0.28u
W=4u
nf=2
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1420 -490 0 0 {name=pM1D_g sig_type=std_logic lab=vss}
C {lab_pin.sym} 1480 -490 2 0 {name=pM1D_b sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} 1880 -1040 0 0 {name=CDCPL
W=5.1u
L=6.3u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=280}
C {lab_pin.sym} 1880 -1070 1 0 {name=pCDCPL_vdd sig_type=std_logic lab=vdd}
C {lab_pin.sym} 1880 -1010 3 0 {name=pCDCPL_vss sig_type=std_logic lab=vss}
C {vsource.sym} 190 -740 0 0 {name=V1 value=1 savecurrent=false
spice_ignore=true}
C {lab_pin.sym} 190 -710 1 1 {name=p2 sig_type=std_logic lab=vss
spice_ignore=true}
