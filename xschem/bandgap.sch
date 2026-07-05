v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 680 -630 830 -630 {lab=vdd}
N 330 -630 390 -630 {lab=vdd}
N 210 -630 330 -630 {lab=vdd}
N 830 -630 890 -630 {lab=vdd}
N 890 -630 1030 -630 {lab=vdd}
N 1030 -630 1090 -630 {lab=vdd}
N 390 -630 680 -630 {lab=vdd}
N 390 -630 390 -590 {lab=vdd}
N 330 -560 390 -560 {lab=vdd}
N 330 -630 330 -560 {lab=vdd}
N 330 -480 390 -480 {lab=vdd}
N 330 -560 330 -480 {lab=vdd}
N 390 -530 390 -510 {lab=#net1}
N 430 -560 770 -560 {lab=vg4}
N 430 -480 590 -480 {lab=vg3}
N 770 -560 790 -560 {lab=vg4}
N 770 -560 770 -430 {lab=vg4}
N 830 -630 830 -590 {lab=vdd}
N 830 -560 890 -560 {lab=vdd}
N 890 -630 890 -560 {lab=vdd}
N 830 -480 890 -480 {lab=vdd}
N 890 -560 890 -480 {lab=vdd}
N 830 -530 830 -510 {lab=#net2}
N 750 -480 790 -480 {lab=vg3}
N 750 -480 750 -330 {lab=vg3}
N 750 -330 830 -330 {lab=vg3}
N 590 -480 750 -480 {lab=vg3}
N 770 -430 830 -430 {lab=vg4}
N 830 -350 830 -330 {lab=vg3}
N 830 -330 990 -330 {lab=vg3}
N 830 -330 830 -270 {lab=vg3}
N 830 -450 830 -430 {lab=vg4}
N 830 -430 990 -430 {lab=vg4}
N 830 -430 830 -410 {lab=vg4}
N 1030 -400 1030 -360 {lab=#net3}
N 1030 -630 1030 -460 {lab=vdd}
N 1090 -430 1090 -330 {lab=vdd}
N 1030 -330 1090 -330 {lab=vdd}
N 1030 -430 1090 -430 {lab=vdd}
N 1090 -630 1090 -430 {lab=vdd}
N 1030 -150 1210 -150 {lab=vref}
N 1030 -300 1030 -150 {lab=vref}
N 1030 -150 1030 -90 {lab=vref}
N 1030 -30 1030 10 {lab=#net4}
N 890 110 970 110 {lab=vss}
N 970 110 1030 110 {
lab=vss}
N 1030 70 1030 110 {lab=vss}
N 970 40 990 40 {lab=vss}
N 970 40 970 110 {lab=vss}
N 830 -160 890 -160 {lab=vss}
N 830 -240 890 -240 {lab=vss}
N 890 -240 890 -160 {lab=vss}
N 890 -160 890 110 {lab=vss}
N 830 -210 830 -190 {lab=#net5}
N 830 -30 830 10 {lab=#net6}
N 830 -130 830 -90 {lab=#net7}
N 830 70 830 110 {lab=vss}
N 770 40 790 40 {lab=vss}
N 770 40 770 110 {lab=vss}
N 830 110 890 110 {lab=vss}
N 770 110 830 110 {lab=vss}
N 450 110 770 110 {
lab=vss}
N 390 -390 390 -370 {lab=vg2}
N 390 -310 390 -290 {lab=vg1}
N 390 -210 390 -190 {lab=#net8}
N 470 -390 470 -240 {lab=vg2}
N 430 -240 470 -240 {lab=vg2}
N 390 -390 470 -390 {lab=vg2}
N 390 -290 390 -270 {lab=vg1}
N 430 -160 450 -160 {lab=vg1}
N 390 -290 450 -290 {lab=vg1}
N 450 -290 450 -160 {lab=vg1}
N 450 -160 790 -160 {lab=vg1}
N 390 -450 390 -390 {lab=vg2}
N 530 -400 550 -400 {lab=vg2}
N 590 -370 590 -350 {lab=vg2}
N 530 -350 590 -350 {lab=vg2}
N 530 -400 530 -350 {lab=vg2}
N 590 -240 790 -240 {lab=vg2}
N 470 -240 590 -240 {lab=vg2}
N 590 -350 590 -240 {lab=vg2}
N 590 -480 590 -430 {lab=vg3}
N 590 -400 680 -400 {lab=vdd}
N 680 -630 680 -400 {lab=vdd}
N 390 70 390 110 {lab=vss}
N 430 40 450 40 {lab=vss}
N 450 40 450 110 {lab=vss}
N 390 -130 390 10 {lab=#net9}
N 390 110 450 110 {
lab=vss}
N 330 110 390 110 {
lab=vss}
N 330 -160 390 -160 {lab=vss}
N 330 -240 390 -240 {lab=vss}
N 330 -240 330 -160 {lab=vss}
N 330 -160 330 110 {lab=vss}
N 230 110 330 110 {lab=vss}
C {symbols/pfet_03v3.sym} 410 -560 0 1 {name=M1
L=1u
W=50u
nf=10
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 410 -480 0 1 {name=M2
L=1u
W=50u
nf=10
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 810 -560 0 0 {name=M3
L=1u
W=50u
nf=10
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 810 -480 0 0 {name=M4
L=1u
W=50u
nf=10
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {res.sym} 830 -380 0 0 {name=R1
value=10.16k
footprint=1206
device=resistor
m=1}
C {symbols/pfet_03v3.sym} 1010 -430 0 0 {name=M5
L=1u
W=50u
nf=10
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 1010 -330 0 0 {name=M6
L=1u
W=50u
nf=10
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {res.sym} 1030 -60 0 0 {name=R2
value=37.5k
footprint=1206
device=resistor
m=1}
C {symbols/pnp_05p00x05p00.sym} 1010 40 0 0 {name=Q1
model=pnp_05p00x05p00
spiceprefix=X
m=40}
C {symbols/nfet_03v3.sym} 810 -240 0 0 {name=M7
L=1u
W=15u
nf=3
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
C {symbols/nfet_03v3.sym} 810 -160 0 0 {name=M8
L=1u
W=15u
nf=3
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
C {res.sym} 830 -60 0 0 {name=R3
value=6.306k
footprint=1206
device=resistor
m=1}
C {symbols/pnp_05p00x05p00.sym} 810 40 0 0 {name=Q2
model=pnp_05p00x05p00
spiceprefix=X
m=40}
C {symbols/nfet_03v3.sym} 410 -240 0 1 {name=M9
L=1u
W=15u
nf=3
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
C {res.sym} 390 -340 0 0 {name=R4
value=10.16k
footprint=1206
device=resistor
m=1}
C {symbols/nfet_03v3.sym} 410 -160 0 1 {name=M10
L=1u
W=15u
nf=3
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
C {symbols/pfet_03v3.sym} 570 -400 0 0 {name=M11
L=10u
W=0.5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pnp_05p00x05p00.sym} 410 40 0 1 {name=Q3
model=pnp_05p00x05p00
spiceprefix=X
m=2}
C {devices/lab_wire.sym} 560 -560 0 0 {name=p6 sig_type=std_logic lab=vg4}
C {devices/lab_wire.sym} 540 -480 0 0 {name=p9 sig_type=std_logic lab=vg3}
C {devices/lab_wire.sym} 530 -240 0 0 {name=p8 sig_type=std_logic lab=vg2}
C {devices/lab_wire.sym} 520 -160 0 0 {name=p7 sig_type=std_logic lab=vg1}
C {ipin.sym} 210 -630 0 0 {name=p1 lab=vdd}
C {iopin.sym} 230 110 2 0 {name=p2 lab=vss}
C {opin.sym} 1210 -150 0 0 {name=p3 lab=vref}
