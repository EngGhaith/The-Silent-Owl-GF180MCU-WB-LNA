v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 610 -630 630 -630 {
lab=g_cg}
N 460 -770 460 -750 {
lab=vbias_cg}
N 460 -530 460 -490 {
lab=vss}
N 410 -720 440 -720 {lab=vss}
N 460 -630 460 -590 {lab=g_cg}
N 250 -630 610 -630 {lab=g_cg}
N 460 -690 460 -630 {lab=g_cg}
N 670 -630 690 -630 {
lab=vss}
N 670 -420 670 -410 {
lab=input_match}
N 670 -410 670 -380 {
lab=input_match}
N 670 -600 670 -420 {lab=input_match}
N 670 -210 670 -170 {lab=vss}
N 670 -380 670 -360 {lab=input_match}
N 670 -300 670 -270 {lab=#net1}
N 560 -380 670 -380 {lab=input_match}
N 670 -410 790 -410 {lab=input_match}
N 790 -470 810 -470 {lab=input_match}
N 810 -470 810 -410 {lab=input_match}
N 790 -410 810 -410 {lab=input_match}
N 730 -440 750 -440 {lab=vss}
N 670 -700 670 -690 {
lab=vm2}
N 670 -690 670 -660 {lab=vm2}
N 670 -760 670 -700 {lab=vm2}
N 670 -905 670 -885 {lab=#net2}
N 670 -825 670 -815 {lab=vm2}
N 670 -1015 670 -965 {lab=vdd}
N 670 -800 670 -760 {lab=vm2}
N 670 -810 670 -800 {lab=vm2}
N 670 -815 670 -810 {lab=vm2}
N 750 -740 790 -740 {
lab=vm2}
N 850 -740 890 -740 {
lab=g_cs}
N 940 -940 940 -920 {
lab=vbias_cs}
N 940 -860 940 -830 {
lab=g_cs}
N 890 -890 920 -890 {lab=vss}
N 890 -740 940 -740 {lab=g_cs}
N 940 -830 940 -740 {lab=g_cs}
N 940 -740 1000 -740 {lab=g_cs}
N 670 -740 750 -740 {lab=vm2}
N 190 -790 230 -790 {lab=vss}
N 190 -820 230 -820 {lab=vdd}
C {symbols/nfet_05v0.sym} 650 -630 0 0 {name=M2
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
C {symbols/ppolyf_u_1k.sym} 460 -720 2 1 {name=R1
W=1u
L=48.35u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 460 -560 2 1 {name=C9
W=49.8865u
L=49.8865u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=4}
C {iopin.sym} 460 -770 3 0 {name=p57 lab=vbias_cg}
C {lab_pin.sym} 460 -490 3 0 {name=p10 sig_type=std_logic lab=vss}
C {lab_pin.sym} 410 -720 2 1 {name=p3 sig_type=std_logic lab=vss}
C {lab_pin.sym} 690 -630 2 0 {name=p12 sig_type=std_logic lab=vss}
C {lab_pin.sym} 670 -400 2 0 {name=p1 sig_type=std_logic lab=s
spice_ignore=true}
C {ind.sym} 670 -240 0 0 {name=L1
m=1
value=2.5n
footprint=1206
device=inductor
}
C {lab_pin.sym} 670 -170 3 0 {name=p19 sig_type=std_logic lab=vss}
C {res.sym} 670 -330 0 0 {name=Rs
value=2.5
footprint=1206
device=resistor
m=1
}
C {symbols/nfet_05v0.sym} 770 -440 0 0 {name=M2D
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
C {lab_pin.sym} 730 -440 0 0 {name=pM2D_g sig_type=std_logic lab=vss}
C {lab_pin.sym} 790 -440 2 0 {name=pM2D_b sig_type=std_logic lab=vss}
C {lab_pin.sym} 670 -1015 1 0 {name=p11 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 670 -688.75 0 0 {name=p71 sig_type=std_logic lab=vm2}
C {ind.sym} 670 -855 0 0 {name=LD4
m=1
value=8n
footprint=1206
device=inductor
}
C {res.sym} 670 -935 0 0 {name=RLD3
value=30
footprint=1206
device=resistor
m=1
}
C {lab_wire.sym} 890 -740 0 0 {name=p14 sig_type=std_logic lab=output_cs}
C {symbols/ppolyf_u_1k.sym} 940 -890 2 1 {name=R2
W=1u
L=48.35u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 820 -740 1 0 {name=C1
W=58.2168u
L=58.2168u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {iopin.sym} 940 -940 3 0 {name=p59 lab=vbias_cs
}
C {lab_pin.sym} 890 -890 2 1 {name=p31 sig_type=std_logic lab=vss}
C {ipin.sym} 560 -380 0 0 {name=p5 lab=input_match}
C {opin.sym} 1000 -740 0 0 {name=p2 lab=output_cs}
C {iopin.sym} 250 -630 2 0 {name=p6 lab=g_cg}
C {iopin.sym} 190 -820 2 0 {name=p4 lab=vdd}
C {iopin.sym} 190 -790 2 0 {name=p7 lab=vss}
C {lab_pin.sym} 230 -820 2 0 {name=p8 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 230 -790 2 0 {name=p9 sig_type=std_logic lab=vss
}
