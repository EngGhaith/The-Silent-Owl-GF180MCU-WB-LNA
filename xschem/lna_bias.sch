v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {V->I:  Iref = vref / RREF  (~10 uA)} -305 -895 0 0 0.4 0.4 {}
T {PMOS mirror, unit current = Iref} 0 -445 0 0 0.4 0.4 {}
T {Replica devices (1/100 of XM1, 1/50 of XM6, 1/10 of XM2+XM5)} 0 -140 0 0 0.4 0.4 {}
T {vbias_icg = vref * RICG/RREF (bandgap-referenced, ~2.8 V)} 210 230 0 0 0.3 0.3 {}
T {vbias_cg/cs/buf: replica diodes -> LNA branch currents follow Iref, not Vth/VDD} 130 260 0 0 0.3 0.3 {}
N -205 -810 -205 -780 {lab=vdd}
N -205 -720 -205 -690 {lab=ib}
N -255 -750 -225 -750 {lab=vss}
N 230 -750 230 -720 {lab=vdd}
N 270 -750 270 -720 {lab=ib}
N 120 -670 150 -670 {lab=vref}
N 120 -610 150 -610 {lab=vr}
N 330 -640 360 -640 {lab=vg}
N 270 -560 270 -530 {lab=vdd}
N 230 -560 230 -530 {lab=vss}
N 440 -660 440 -630 {lab=vg}
N 440 -570 440 -540 {lab=vss}
N 725 -675 725 -645 {lab=pd}
N 725 -585 725 -555 {lab=vr}
N 655 -615 685 -615 {lab=vg}
N 725 -615 755 -615 {lab=vss}
N 905 -680 905 -650 {lab=vr}
N 905 -590 905 -560 {lab=vss}
N 855 -620 885 -620 {lab=vss}
N -10 -360 -10 -330 {lab=vdd}
N -10 -270 -10 -240 {lab=pd}
N -80 -300 -50 -300 {lab=pd}
N -10 -300 20 -300 {lab=vdd}
N 200 -370 200 -340 {lab=vdd}
N 200 -280 200 -250 {lab=vbias_cs}
N 130 -310 160 -310 {lab=pd}
N 200 -310 230 -310 {lab=vdd}
N 420 -360 420 -330 {lab=vdd}
N 420 -270 420 -240 {lab=vbias_buf}
N 350 -300 380 -300 {lab=pd}
N 420 -300 450 -300 {lab=vdd}
N 600 -360 600 -330 {lab=vdd}
N 600 -270 600 -240 {lab=vbias_cg}
N 530 -300 560 -300 {lab=pd}
N 600 -300 630 -300 {lab=vdd}
N 780 -360 780 -330 {lab=vdd}
N 780 -270 780 -240 {lab=vbias_icg}
N 710 -300 740 -300 {lab=pd}
N 780 -300 810 -300 {lab=vdd}
N -100 20 -100 50 {lab=vbias_cs}
N -100 110 -100 140 {lab=vss}
N -170 80 -140 80 {lab=vbias_cs}
N -100 80 -70 80 {lab=vss}
N 160 30 160 60 {lab=vbias_buf}
N 160 120 160 150 {lab=vss}
N 90 90 120 90 {lab=vbias_buf}
N 160 90 190 90 {lab=vss}
N 410 30 410 60 {lab=vbias_cg}
N 410 120 410 150 {lab=srep}
N 340 90 370 90 {lab=vbias_cg}
N 410 90 440 90 {lab=vss}
N 1120 20 1120 50 {lab=srep}
N 1120 110 1120 140 {lab=vss}
N 1050 80 1080 80 {lab=vbias_icg}
N 1120 80 1150 80 {lab=vss}
N 590 30 590 60 {lab=vbias_icg}
N 590 120 590 150 {lab=vss}
N 540 90 570 90 {lab=vss}
N 820 20 820 50 {lab=vdd}
N 820 110 820 140 {lab=vbias_cas}
N 770 80 800 80 {lab=vss}
C {ipin.sym} -400 -600 0 0 {name=p1 lab=vdd}
C {ipin.sym} -400 -560 0 0 {name=p2 lab=vref}
C {iopin.sym} -400 -520 0 0 {name=p3 lab=vss}
C {opin.sym} -400 -480 0 0 {name=p4 lab=vbias_cas}
C {opin.sym} -400 -440 0 0 {name=p5 lab=vbias_cg}
C {opin.sym} -400 -400 0 0 {name=p6 lab=vbias_cs}
C {opin.sym} -400 -360 0 0 {name=p7 lab=vbias_icg}
C {opin.sym} -400 -320 0 0 {name=p8 lab=vbias_buf}
C {symbols/ppolyf_u_2k_6p0.sym} -205 -750 0 0 {name=ROB
W=1e-6
L=190e-6
model=ppolyf_u_2k_6p0
spiceprefix=X
m=1}
C {lab_pin.sym} -205 -810 1 0 {name=l1 sig_type=std_logic lab=vdd}
C {lab_pin.sym} -205 -690 3 0 {name=l2 sig_type=std_logic lab=ib}
C {lab_pin.sym} -255 -750 0 0 {name=l3 sig_type=std_logic lab=vss}
C {ota-5t.sym} 140 -560 0 0 {name=XOTA}
C {lab_pin.sym} 230 -750 1 0 {name=l4 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 270 -750 1 0 {name=l5 sig_type=std_logic lab=ib}
C {lab_pin.sym} 120 -670 0 0 {name=l6 sig_type=std_logic lab=vref}
C {lab_pin.sym} 120 -610 0 0 {name=l7 sig_type=std_logic lab=vr}
C {lab_pin.sym} 360 -640 2 0 {name=l8 sig_type=std_logic lab=vg}
C {lab_pin.sym} 270 -530 3 0 {name=l9 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 230 -530 3 0 {name=l10 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} 440 -600 0 0 {name=CC
W=20e-6
L=20e-6
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_pin.sym} 440 -660 1 0 {name=l11 sig_type=std_logic lab=vg}
C {lab_pin.sym} 440 -540 3 0 {name=l12 sig_type=std_logic lab=vss}
C {symbols/nfet_05v0.sym} 705 -615 0 0 {name=MVI
L=1u
W=10u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 725 -675 1 0 {name=l13 sig_type=std_logic lab=pd}
C {lab_pin.sym} 725 -555 3 0 {name=l14 sig_type=std_logic lab=vr}
C {lab_pin.sym} 655 -615 0 0 {name=l15 sig_type=std_logic lab=vg}
C {lab_pin.sym} 755 -615 2 0 {name=l16 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_2k_6p0.sym} 905 -620 0 0 {name=RREF
W=1e-6
L=58e-6
model=ppolyf_u_2k_6p0
spiceprefix=X
m=1}
C {lab_pin.sym} 905 -680 1 0 {name=l17 sig_type=std_logic lab=vr}
C {lab_pin.sym} 905 -560 3 0 {name=l18 sig_type=std_logic lab=vss}
C {lab_pin.sym} 855 -620 0 0 {name=l19 sig_type=std_logic lab=vss}
C {symbols/pfet_05v0.sym} -30 -300 0 0 {name=MP0
L=2u
W=5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {lab_pin.sym} -10 -360 1 0 {name=l20 sig_type=std_logic lab=vdd}
C {lab_pin.sym} -10 -240 3 0 {name=l21 sig_type=std_logic lab=pd}
C {lab_pin.sym} -80 -300 0 0 {name=l22 sig_type=std_logic lab=pd}
C {lab_pin.sym} 20 -300 2 0 {name=l23 sig_type=std_logic lab=vdd}
C {symbols/pfet_05v0.sym} 180 -310 0 0 {name=MPCS
L=2u
W=5u
nf=1
m=17
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 200 -370 1 0 {name=l24 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 200 -250 3 0 {name=l25 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 130 -310 0 0 {name=l26 sig_type=std_logic lab=pd}
C {lab_pin.sym} 230 -310 2 0 {name=l27 sig_type=std_logic lab=vdd}
C {symbols/pfet_05v0.sym} 400 -300 0 0 {name=MPBUF
L=2u
W=5u
nf=1
m=18
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 420 -360 1 0 {name=l28 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 420 -240 3 0 {name=l29 sig_type=std_logic lab=vbias_buf}
C {lab_pin.sym} 350 -300 0 0 {name=l30 sig_type=std_logic lab=pd}
C {lab_pin.sym} 450 -300 2 0 {name=l31 sig_type=std_logic lab=vdd}
C {symbols/pfet_05v0.sym} 580 -300 0 0 {name=MPCG
L=2u
W=5u
nf=1
m=20
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 600 -360 1 0 {name=l32 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 600 -240 3 0 {name=l33 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 530 -300 0 0 {name=l34 sig_type=std_logic lab=pd}
C {lab_pin.sym} 630 -300 2 0 {name=l35 sig_type=std_logic lab=vdd}
C {symbols/pfet_05v0.sym} 760 -300 0 0 {name=MPICG
L=2u
W=5u
nf=1
m=4
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 780 -360 1 0 {name=l36 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 780 -240 3 0 {name=l37 sig_type=std_logic lab=vbias_icg}
C {lab_pin.sym} 710 -300 0 0 {name=l38 sig_type=std_logic lab=pd}
C {lab_pin.sym} 810 -300 2 0 {name=l39 sig_type=std_logic lab=vdd}
C {symbols/nfet_03v3.sym} -120 80 0 0 {name=MRCS
L=0.28u
W=2u
nf=1
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
C {lab_pin.sym} -100 20 1 0 {name=l40 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} -100 140 3 0 {name=l41 sig_type=std_logic lab=vss}
C {lab_pin.sym} -170 80 0 0 {name=l42 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} -70 80 2 0 {name=l43 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 140 90 0 0 {name=MRBUF
L=0.5u
W=2.5u
nf=1
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
C {lab_pin.sym} 160 30 1 0 {name=l44 sig_type=std_logic lab=vbias_buf}
C {lab_pin.sym} 160 150 3 0 {name=l45 sig_type=std_logic lab=vss}
C {lab_pin.sym} 90 90 0 0 {name=l46 sig_type=std_logic lab=vbias_buf}
C {lab_pin.sym} 190 90 2 0 {name=l47 sig_type=std_logic lab=vss}
C {symbols/nfet_05v0.sym} 390 90 0 0 {name=MRCG
L=0.6u
W=56u
nf=14
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_05v0
spiceprefix=X
}
C {lab_pin.sym} 410 30 1 0 {name=l48 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 410 150 3 0 {name=l49 sig_type=std_logic lab=srep}
C {lab_pin.sym} 340 90 0 0 {name=l50 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 440 90 2 0 {name=l51 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 1100 80 0 0 {name=MRICG
L=0.5u
W=1.5u
nf=1
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
C {lab_pin.sym} 1120 20 1 0 {name=l52 sig_type=std_logic lab=srep}
C {lab_pin.sym} 1120 140 3 0 {name=l53 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1050 80 0 0 {name=l54 sig_type=std_logic lab=vbias_icg}
C {lab_pin.sym} 1150 80 2 0 {name=l55 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_2k_6p0.sym} 590 90 0 0 {name=RICG
W=1e-6
L=35.1e-6
model=ppolyf_u_2k_6p0
spiceprefix=X
m=1}
C {lab_pin.sym} 590 30 1 0 {name=l56 sig_type=std_logic lab=vbias_icg}
C {lab_pin.sym} 590 150 3 0 {name=l57 sig_type=std_logic lab=vss}
C {lab_pin.sym} 540 90 0 0 {name=l58 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k_6p0.sym} 820 80 0 0 {name=RCAS
W=1e-6
L=10e-6
model=ppolyf_u_1k_6p0
spiceprefix=X
m=1}
C {lab_pin.sym} 820 20 1 0 {name=l59 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 820 140 3 0 {name=l60 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 770 80 0 0 {name=l61 sig_type=std_logic lab=vss}
