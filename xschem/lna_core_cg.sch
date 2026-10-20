v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 190 -790 230 -790 {lab=vss}
N 190 -820 230 -820 {lab=vdd}
N 760 -590 780 -590 {
lab=vss}
N 760 -760 800 -760 {
lab=vm2}
N 700 -590 720 -590 {
lab=g_cg}
N 550 -730 550 -710 {
lab=vbias_cg}
N 550 -490 550 -450 {
lab=vss}
N 760 -660 760 -650 {
lab=vm2}
N 760 -650 760 -620 {lab=vm2}
N 760 -720 760 -660 {lab=vm2}
N 500 -680 530 -680 {lab=vss}
N 550 -590 550 -550 {lab=g_cg}
N 340 -590 700 -590 {lab=g_cg}
N 550 -650 550 -590 {lab=g_cg}
N 760 -760 760 -720 {lab=vm2}
N 760 -380 760 -370 {
lab=input_match}
N 760 -370 760 -340 {
lab=input_match}
N 760 -560 760 -380 {lab=input_match}
N 760 -170 760 -130 {lab=vss}
N 760 -340 760 -320 {lab=input_match}
N 760 -260 760 -230 {lab=#net1}
N 650 -340 760 -340 {lab=input_match}
N 760 -340 880 -340 {lab=input_match}
N 880 -400 900 -400 {lab=input_match}
N 900 -400 900 -340 {lab=input_match}
N 880 -340 900 -340 {lab=input_match}
N 820 -370 840 -370 {lab=vss}
N 760 -865 760 -845 {lab=#net2}
N 760 -785 760 -775 {lab=vm2}
N 760 -975 760 -925 {lab=vdd}
N 760 -770 760 -760 {lab=vm2}
N 760 -775 760 -770 {lab=vm2}
N 860 -760 900 -760 {
lab=output_cs}
N 950 -960 950 -940 {
lab=vbias_cs}
N 950 -880 950 -850 {
lab=output_cs}
N 900 -910 930 -910 {lab=vss}
N 900 -760 950 -760 {lab=output_cs}
N 950 -850 950 -760 {lab=output_cs}
N 950 -760 1010 -760 {lab=output_cs}
C {ipin.sym} 650 -340 0 0 {name=p5 lab=input_match}
C {iopin.sym} 190 -820 2 0 {name=p4 lab=vdd}
C {iopin.sym} 190 -790 2 0 {name=p7 lab=vss}
C {lab_pin.sym} 230 -820 2 0 {name=p8 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 230 -790 2 0 {name=p9 sig_type=std_logic lab=vss
}
C {symbols/nfet_05v0.sym} 740 -590 0 0 {name=M1
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
C {lab_pin.sym} 760 -648.75 0 0 {name=p15 sig_type=std_logic lab=vm2}
C {symbols/ppolyf_u_1k.sym} 550 -680 2 1 {name=R3
W=1u
L=48.35u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 830 -760 1 0 {name=C2
W=58.2168u
L=58.2168u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 550 -520 2 1 {name=C3
W=49.8865u
L=49.8865u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=4}
C {iopin.sym} 550 -730 3 0 {name=p16 lab=vbias_cg}
C {lab_pin.sym} 550 -450 3 0 {name=p17 sig_type=std_logic lab=vss}
C {lab_pin.sym} 780 -590 2 0 {name=p18 sig_type=std_logic lab=vss}
C {lab_pin.sym} 500 -680 2 1 {name=p20 sig_type=std_logic lab=vss}
C {ind.sym} 760 -200 0 0 {name=L2
m=1
value=2.5n
footprint=1206
device=inductor
}
C {lab_pin.sym} 760 -130 3 0 {name=p22 sig_type=std_logic lab=vss}
C {res.sym} 760 -290 0 0 {name=Rs1
value=2.5
footprint=1206
device=resistor
m=1
}
C {symbols/nfet_05v0.sym} 860 -370 0 0 {name=M3
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
C {lab_pin.sym} 820 -370 0 0 {name=pM1 sig_type=std_logic lab=vss}
C {lab_pin.sym} 880 -370 2 0 {name=pM2 sig_type=std_logic lab=vss}
C {lab_pin.sym} 760 -975 1 0 {name=p21 sig_type=std_logic lab=vdd
}
C {ind.sym} 760 -815 0 0 {name=LD1
m=1
value=8n
footprint=1206
device=inductor
}
C {res.sym} 760 -895 0 0 {name=RLD1
value=30
footprint=1206
device=resistor
m=1
}
C {symbols/ppolyf_u_1k.sym} 950 -910 2 1 {name=R4
W=1u
L=48.35u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {iopin.sym} 950 -960 3 0 {name=p24 lab=vbias_cs
}
C {lab_pin.sym} 900 -910 2 1 {name=p25 sig_type=std_logic lab=vss}
C {opin.sym} 1010 -760 0 0 {name=p26 lab=output_cs}
C {iopin.sym} 340 -590 2 0 {name=p13 lab=g_cg}
