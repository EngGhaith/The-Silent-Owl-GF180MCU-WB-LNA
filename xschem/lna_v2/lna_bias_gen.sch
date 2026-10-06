v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 200 -1130 200 -1090 {lab=vdd}
N 200 -1030 200 -990 {lab=vbias_cg}
N 140 -1060 180 -1060 {lab=vss}
N 200 -990 200 -950 {lab=vbias_cg}
N 120 -920 160 -920 {lab=vbias_cg}
N 200 -890 200 -850 {lab=vss}
N 200 -920 240 -920 {lab=vss}
N 340 -970 340 -930 {lab=vbias_cg}
N 340 -870 340 -830 {lab=vss}
N 660 -1140 660 -1100 {lab=vdd}
N 660 -1040 660 -1000 {lab=vbias_cs}
N 600 -1070 640 -1070 {lab=vss}
N 660 -1000 660 -960 {lab=vbias_cs}
N 580 -930 620 -930 {lab=vbias_cs}
N 660 -900 660 -860 {lab=vss}
N 660 -930 700 -930 {lab=vss}
N 790 -1000 790 -960 {lab=vbias_cs}
N 790 -900 790 -860 {lab=vss}
N 1200 -1140 1200 -1100 {lab=vdd}
N 1200 -1040 1200 -1000 {lab=vbias_csc}
N 1140 -1070 1180 -1070 {lab=vss}
N 1200 -1000 1200 -960 {lab=vbias_csc}
N 1120 -930 1160 -930 {lab=vbias_csc}
N 1200 -900 1200 -860 {lab=vss}
N 1200 -930 1240 -930 {lab=vss}
N 1340 -1000 1340 -960 {lab=vbias_csc}
N 1340 -900 1340 -860 {lab=vss}
N 210 -690 210 -650 {lab=vdd}
N 210 -590 210 -550 {lab=vbias_cas}
N 150 -620 190 -620 {lab=vss}
N 210 -550 210 -510 {lab=vbias_cas}
N 210 -450 210 -410 {lab=vss}
N 150 -480 190 -480 {lab=vss}
N 330 -550 330 -510 {lab=vbias_cas}
N 330 -450 330 -410 {lab=vss}
N 720 -700 720 -660 {lab=vdd}
N 720 -600 720 -560 {lab=vbias_casc}
N 660 -630 700 -630 {lab=vss}
N 720 -560 720 -520 {lab=vbias_casc}
N 720 -460 720 -420 {lab=vss}
N 660 -490 700 -490 {lab=vss}
N 840 -560 840 -520 {lab=vbias_casc}
N 840 -460 840 -420 {lab=vss}
N 200 -970 340 -970 {lab=vbias_cg}
N 340 -970 390 -970 {lab=vbias_cg}
N 660 -1000 790 -1000 {lab=vbias_cs}
N 790 -1000 840 -1000 {lab=vbias_cs}
N 1200 -1000 1320 -1000 {lab=vbias_csc}
N 1320 -1000 1340 -1000 {lab=vbias_csc}
N 1340 -1000 1420 -1000 {lab=vbias_csc}
N 210 -550 330 -550 {lab=vbias_cas}
N 330 -550 390 -550 {lab=vbias_cas}
N 720 -560 840 -560 {lab=vbias_casc}
N 840 -560 920 -560 {lab=vbias_casc}
C {iopin.sym} 1250 -700 0 0 {name=p1 lab=vdd}
C {iopin.sym} 1250 -660 0 0 {name=p2 lab=vss}
C {iopin.sym} 1250 -620 0 0 {name=p3 lab=vbias_cg}
C {iopin.sym} 1250 -580 0 0 {name=p4 lab=vbias_cs}
C {iopin.sym} 1250 -540 0 0 {name=p5 lab=vbias_csc}
C {iopin.sym} 1250 -500 0 0 {name=p6 lab=vbias_cas}
C {iopin.sym} 1250 -460 0 0 {name=p7 lab=vbias_casc}
C {symbols/ppolyf_u_1k.sym} 200 -1060 0 0 {name=RBG2
W=1u
L=128.2762u
model=ppolyf_u_1k
spiceprefix=X
m=1
}
C {lab_pin.sym} 200 -1130 1 0 {name=l8 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 140 -1060 0 0 {name=l10 sig_type=std_logic lab=vss}
C {symbols/nfet_05v0.sym} 180 -920 0 0 {name=BG2
L=0.6u
W=20.000u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'"
nrs="'0.18u / W'"
sa=0
sb=0
sd=0
model=nfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 390 -970 2 0 {name=l11 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 120 -920 0 0 {name=l12 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 200 -850 3 0 {name=l13 sig_type=std_logic lab=vss}
C {lab_pin.sym} 240 -920 2 0 {name=l14 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} 340 -900 0 0 {name=CBG2
W=20u
L=20u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1
}
C {lab_pin.sym} 340 -830 3 0 {name=l16 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 660 -1070 0 0 {name=RBG1
W=1u
L=43.1180u
model=ppolyf_u_1k
spiceprefix=X
m=1
}
C {lab_pin.sym} 660 -1140 1 0 {name=l17 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 600 -1070 0 0 {name=l19 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 640 -930 0 0 {name=BG1
L=0.28u
W=2.000u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'"
nrs="'0.18u / W'"
sa=0
sb=0
sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 840 -1000 2 0 {name=l20 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 580 -930 0 0 {name=l21 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 660 -860 3 0 {name=l22 sig_type=std_logic lab=vss}
C {lab_pin.sym} 700 -930 2 0 {name=l23 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} 790 -930 0 0 {name=CBG1
W=20u
L=20u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1
}
C {lab_pin.sym} 790 -860 3 0 {name=l25 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 1200 -1070 0 0 {name=RBG9
W=1u
L=25.1301u
model=ppolyf_u_1k
spiceprefix=X
m=1
}
C {lab_pin.sym} 1200 -1140 1 0 {name=l26 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 1420 -1000 2 0 {name=l27 sig_type=std_logic lab=vbias_csc}
C {lab_pin.sym} 1140 -1070 0 0 {name=l28 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 1180 -930 0 0 {name=BG9
L=0.28u
W=7.500u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'"
nrs="'0.18u / W'"
sa=0
sb=0
sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1120 -930 0 0 {name=l30 sig_type=std_logic lab=vbias_csc}
C {lab_pin.sym} 1200 -860 3 0 {name=l31 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1240 -930 2 0 {name=l32 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} 1340 -930 0 0 {name=CBG9
W=20u
L=20u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1
}
C {lab_pin.sym} 1340 -860 3 0 {name=l34 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 210 -620 0 0 {name=RBGA
W=1u
L=12.4703u
model=ppolyf_u_1k
spiceprefix=X
m=1
}
C {lab_pin.sym} 210 -690 1 0 {name=l35 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 150 -620 0 0 {name=l37 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 210 -480 0 0 {name=RBGB
W=1u
L=35.8035u
model=ppolyf_u_1k
spiceprefix=X
m=1
}
C {lab_pin.sym} 210 -410 3 0 {name=l39 sig_type=std_logic lab=vss}
C {lab_pin.sym} 150 -480 0 0 {name=l40 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} 330 -480 0 0 {name=CBGA
W=20u
L=20u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1
}
C {lab_pin.sym} 390 -550 2 0 {name=l41 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 330 -410 3 0 {name=l42 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 720 -630 0 0 {name=RBGC
W=1u
L=17.3314u
model=ppolyf_u_1k
spiceprefix=X
m=1
}
C {lab_pin.sym} 720 -700 1 0 {name=l43 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 660 -630 0 0 {name=l45 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 720 -490 0 0 {name=RBGD
W=1u
L=30.9425u
model=ppolyf_u_1k
spiceprefix=X
m=1
}
C {lab_pin.sym} 720 -420 3 0 {name=l47 sig_type=std_logic lab=vss}
C {lab_pin.sym} 660 -490 0 0 {name=l48 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} 840 -490 0 0 {name=CBGC
W=80u
L=80u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1
}
C {lab_pin.sym} 920 -560 2 0 {name=l49 sig_type=std_logic lab=vbias_casc}
C {lab_pin.sym} 840 -420 3 0 {name=l50 sig_type=std_logic lab=vss}
