v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 700 -330 720 -330 {
lab=vss}
N 700 -540 700 -460 {
lab=vm2}
N 700 -630 700 -600 {
lab=vdd}
N 440 -280 460 -280 {
lab=s}
N 110 -280 140 -280 {
lab=rf_in_pad}
N 700 -500 740 -500 {
lab=vm2}
N 800 -500 840 -500 {
lab=g_cs}
N 700 -300 700 -290 {
lab=s}
N 700 -290 700 -280 {
lab=s}
N 640 -330 660 -330 {
lab=g_cg}
N 120 -680 120 -660 {
lab=vbias_cg}
N 120 -600 120 -570 {
lab=g_cg}
N 120 -470 120 -430 {
lab=vss}
N 1240 -240 1260 -240 {
lab=vss}
N 1240 -210 1240 -200 {
lab=vss}
N 1180 -240 1200 -240 {
lab=g_cs}
N 960 -240 980 -240 {
lab=vbias_cs}
N 1040 -240 1070 -240 {
lab=g_cs}
N 1240 -200 1240 -140 {
lab=vss}
N 1240 -640 1240 -600 {
lab=vdd}
N 1450 -530 1450 -460 {
lab=vdd}
N 1450 -400 1450 -330 {
lab=vbuf}
N 1450 -270 1450 -240 {
lab=vss}
N 1450 -430 1470 -430 {
lab=vbuf}
N 1700 -370 1740 -370 {
lab=#net1}
N 1800 -370 1850 -370 {
lab=#net2}
N 1910 -370 1950 -370 {
lab=rf_out_pad}
N 1930 -370 1930 -290 {
lab=rf_out_pad}
N 1930 -230 1930 -190 {
lab=vss}
N 120 -280 120 -240 {
lab=rf_in_pad}
N 120 -180 120 -140 {
lab=vss}
N 140 -280 170 -280 {
lab=rf_in_pad}
N 230 -280 280 -280 {
lab=#net3}
N 340 -280 380 -280 {
lab=#net4}
N 1240 -350 1260 -350 {
lab=vss}
N 1240 -320 1240 -310 {
lab=vm1}
N 1180 -350 1200 -350 {
lab=vbias_cas}
N 1240 -540 1240 -460 {
lab=vx}
N 1240 -310 1240 -270 {
lab=vm1}
N 1470 -430 1470 -380 {
lab=vbuf}
N 1450 -380 1470 -380 {
lab=vbuf}
N 700 -230 720 -230 {
lab=vss}
N 700 -200 700 -190 {
lab=vss}
N 640 -230 660 -230 {
lab=vbias_icg}
N 700 -190 700 -170 {
lab=vss}
N 1360 -300 1410 -300 {
lab=vbias_buf}
N 1450 -300 1500 -300 {
lab=vss}
N 1240 -140 1240 -120 {
lab=vss}
N 1370 -430 1410 -430 {
lab=#net5}
N 1240 -430 1310 -430 {
lab=vx}
N 700 -400 700 -390 {
lab=vm2}
N 700 -390 700 -360 {lab=vm2}
N 1160 -620 1160 -600 {lab=vdd}
N 1160 -620 1240 -620 {lab=vdd}
N 1160 -540 1160 -520 {lab=#net6}
N 1320 -540 1320 -530 {lab=vx}
N 1240 -440 1320 -440 {lab=vx}
N 1320 -620 1320 -600 {lab=vdd}
N 1240 -620 1320 -620 {lab=vdd}
N 1320 -530 1320 -520 {lab=vx}
N 700 -460 700 -400 {lab=vm2}
N 1240 -460 1240 -380 {lab=vx}
N 1160 -460 1160 -440 {lab=vx}
N 1160 -440 1240 -440 {lab=vx}
N 1320 -520 1320 -440 {lab=vx}
N 1010 -290 1010 -260 {lab=vss}
N 140 -630 170 -630 {lab=vss}
N 640 -570 680 -570 {lab=vss}
N 1220 -590 1220 -570 {lab=vss}
N 1240 -700 1240 -640 {lab=vdd}
N 1340 -480 1340 -450 {lab=vss}
N 120 -570 120 -530 {lab=g_cg}
N 460 -280 700 -280 {lab=s}
N 650 -540 650 -330 {lab=g_cg}
N 120 -540 450 -540 {lab=g_cg}
N 450 -540 650 -540 {lab=g_cg}
N 1450 -370 1630 -370 {lab=vbuf}
N 1630 -370 1640 -370 {lab=vbuf}
N 1070 -240 1180 -240 {lab=g_cs}
N 840 -500 1070 -500 {lab=g_cs}
N 1070 -500 1070 -240 {lab=g_cs}
C {lab_pin.sym} 700 -630 0 0 {name=p11 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 700 -280 2 0 {name=p1 sig_type=std_logic lab=s}
C {symbols/nfet_06v0.sym} 680 -330 0 0 {name=M2
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
C {lab_pin.sym} 120 -680 1 0 {name=p20 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 110 -280 0 0 {name=p13 sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 640 -330 0 0 {name=p4 sig_type=std_logic lab=g_cg}
C {lab_wire.sym} 1190 -240 0 0 {name=p18 sig_type=std_logic lab=g_cs}
C {lab_pin.sym} 960 -240 0 0 {name=p23 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 1240 -700 0 0 {name=p39 sig_type=std_logic lab=vdd
}
C {symbols/nfet_06v0.sym} 1430 -430 0 0 {name=M3
L=0.6u
W=25u
nf=10
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {lab_pin.sym} 1450 -530 0 0 {name=p40 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 1450 -370 0 0 {name=p43 sig_type=std_logic lab=vbuf}
C {lab_pin.sym} 1950 -370 2 0 {name=p45 sig_type=std_logic lab=rf_out_pad}
C {ind.sym} 1770 -370 1 0 {name=LOUT
m=1
value=2.4n
footprint=1206
device=inductor
}
C {res.sym} 1880 -370 1 0 {name=RLOUT
value=1.0911
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 120 -140 3 0 {name=p46 sig_type=std_logic lab=vss}
C {ind.sym} 200 -280 1 0 {name=LIN
m=1
value=4.2n
footprint=1206
device=inductor
}
C {res.sym} 310 -280 1 0 {name=RLIN
value=1.9095
footprint=1206
device=resistor
m=1}
C {symbols/nfet_06v0.sym} 1220 -350 0 0 {name=M4
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
C {lab_pin.sym} 1180 -350 0 0 {name=p47 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 640 -230 0 0 {name=p50 sig_type=std_logic lab=vbias_icg}
C {lab_pin.sym} 1360 -300 0 0 {name=p51 sig_type=std_logic lab=vbias_buf}
C {symbols/nfet_03v3.sym} 680 -230 0 0 {name=M5
L=0.5u
W=15u
nf=10
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 1430 -300 0 0 {name=M6
L=0.5u
W=25u
nf=10
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
C {symbols/nfet_03v3.sym} 1220 -240 0 0 {name=M1
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
C {lab_pin.sym} 1240 -420 0 0 {name=p36 sig_type=std_logic lab=vx}
C {lab_pin.sym} 700 -388.75 0 0 {name=p71 sig_type=std_logic lab=vm2}
C {lab_pin.sym} 1240 -298.75 0 0 {name=p72 sig_type=std_logic lab=vm1}
C {ind.sym} 1160 -490 0 0 {name=LD2
m=1
value=6.8n
footprint=1206
device=inductor
}
C {res.sym} 1160 -570 0 0 {name=RLD2
value=20.5
footprint=1206
device=resistor
m=1
}
C {symbols/ppolyf_u_1k.sym} 1010 -240 1 0 {name=R2
W=1u
L=48.35u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 120 -630 2 0 {name=R1
W=1u
L=48.35u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u.sym} 700 -570 0 0 {name=R4
W=8u
L=18.96u
model=ppolyf_u
spiceprefix=X
m=1}
C {symbols/ppolyf_u.sym} 1240 -570 0 0 {name=R5
W=8u
L=14.42u
model=ppolyf_u
spiceprefix=X
m=1}
C {symbols/npolyf_s.sym} 1340 -430 1 0 {name=R7
W=10u
L=1.32u
model=npolyf_s
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 770 -500 1 0 {name=C1
W=93.14688u
L=93.14688u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 410 -280 1 0 {name=C2
W=33u
L=33u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 1670 -370 1 0 {name=C3
W=180u
L=180u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 1930 -260 0 0 {name=C4
W=80u
L=80u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 120 -210 0 0 {name=C5
W=72u
L=72u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 1320 -570 0 0 {name=C8
W=40u
L=40u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 120 -500 2 0 {name=C9
W=79.8184u
L=79.8184u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=4}
C {iopin.sym} -340 -860 0 0 {name=p56 lab=rf_in_pad}
C {iopin.sym} -180 -860 0 0 {name=p57 lab=vbias_cg}
C {iopin.sym} -340 -820 0 0 {name=p58 lab=rf_out_pad}
C {iopin.sym} -180 -820 0 0 {name=p59 lab=vbias_cs
}
C {iopin.sym} -340 -780 0 0 {name=p60 lab=vdd}
C {iopin.sym} -180 -780 0 0 {name=p61 lab=vbias_cas}
C {iopin.sym} -340 -740 0 0 {name=p62 lab=vss}
C {iopin.sym} -180 -740 0 0 {name=p63 lab=vbias_casc}
C {iopin.sym} -180 -700 0 0 {name=p64 lab=vbias_buf}
C {iopin.sym} -180 -660 0 0 {name=p65 lab=vbias_icg}
C {iopin.sym} -180 -620 0 0 {name=p79 lab=vbias_csc}
C {lab_pin.sym} 700 -170 3 0 {name=p5 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1240 -120 3 0 {name=p7 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1450 -240 3 0 {name=p8 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1930 -190 3 0 {name=p9 sig_type=std_logic lab=vss}
C {lab_pin.sym} 120 -430 3 0 {name=p10 sig_type=std_logic lab=vss}
C {lab_pin.sym} 720 -230 2 0 {name=p2 sig_type=std_logic lab=vss}
C {lab_pin.sym} 720 -330 2 0 {name=p12 sig_type=std_logic lab=vss}
C {lab_pin.sym} 640 -570 0 0 {name=p16 sig_type=std_logic lab=vss}
C {lab_pin.sym} 170 -630 2 0 {name=p3 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1010 -290 1 0 {name=p31 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1220 -590 1 0 {name=p34 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1340 -480 1 0 {name=p35 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1260 -350 2 0 {name=p41 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1260 -240 2 0 {name=p42 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1500 -300 2 0 {name=p48 sig_type=std_logic lab=vss}
C {lab_pin.sym} 700 -260 0 0 {name=p900 sig_type=std_logic lab=s_tail}
C {ind.sym} 2000 -230 0 0 {name=LCHOKE
m=1
value=12n
footprint=1206
device=inductor
}
C {lab_pin.sym} 2000 -260 0 0 {name=p901 sig_type=std_logic lab=s}
C {lab_pin.sym} 2000 -200 0 0 {name=p902 sig_type=std_logic lab=s_tail}
C {capa.sym} 2000 -130 0 0 {name=CBYPASS
m=1
value=30p
footprint=1206
device="ceramic capacitor"
}
C {lab_pin.sym} 2000 -160 0 0 {name=p903 sig_type=std_logic lab=s_tail}
C {lab_pin.sym} 2000 -100 0 0 {name=p904 sig_type=std_logic lab=vss}
