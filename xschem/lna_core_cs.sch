v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 290 -330 310 -330 {
lab=vss}
N 290 -300 290 -290 {
lab=#net1}
N 230 -330 250 -330 {
lab=input_cg}
N 290 -290 290 -230 {
lab=#net1}
N 290 -440 310 -440 {
lab=vss}
N 290 -410 290 -400 {
lab=vm1}
N 230 -440 250 -440 {
lab=vbias_cas}
N 290 -400 290 -360 {
lab=vm1}
N 290 -230 290 -220 {
lab=#net1}
N 290 -160 290 -150 {
lab=vss}
N 290 -150 290 -130 {
lab=vss}
N 290 -520 360 -520 {
lab=vx}
N 290 -710 290 -690 {lab=vdd}
N 290 -630 290 -610 {lab=#net2}
N 290 -550 290 -530 {lab=vx}
N 290 -790 290 -730 {lab=vdd}
N 290 -530 290 -470 {lab=vx}
N 290 -725 290 -710 {lab=vdd}
N 290 -730 290 -725 {lab=vdd}
N 150 -330 230 -330 {lab=input_cg}
N 360 -520 410 -520 {lab=vx}
N 290 -240 470 -240 {lab=#net1}
N 470 -300 490 -300 {lab=#net1}
N 490 -300 490 -240 {lab=#net1}
N 470 -240 490 -240 {lab=#net1}
N 410 -270 430 -270 {lab=vss}
N 470 -440 470 -420 {lab=vm1}
N 470 -360 470 -340 {lab=vm1}
N 470 -390 540 -390 {lab=vss}
N 420 -390 430 -390 {lab=vss}
C {symbols/nfet_05v0.sym} 270 -440 0 0 {name=M4
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
C {res.sym} 290 -190 0 0 {name=RS_EQ
value=0.05
footprint=1206
device=resistor
m=1
}
C {symbols/nfet_03v3.sym} 270 -330 0 0 {name=M1
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
C {lab_pin.sym} 290 -510 0 0 {name=p36 sig_type=std_logic lab=output_match
}
C {lab_pin.sym} 290 -388.75 0 0 {name=p72 sig_type=std_logic lab=vm1}
C {ind.sym} 290 -580 0 0 {name=LD2
m=1
value=4n
footprint=1206
device=inductor
}
C {res.sym} 290 -660 0 0 {name=RLD2
value=50
footprint=1206
device=resistor
m=1
}
C {iopin.sym} 230 -440 0 1 {name=p61 lab=vbias_cas}
C {lab_pin.sym} 310 -440 2 0 {name=p41 sig_type=std_logic lab=vss}
C {lab_pin.sym} 310 -330 2 0 {name=p42 sig_type=std_logic lab=vss}
C {ipin.sym} 150 -330 0 0 {name=p1 lab=input_cg}
C {opin.sym} 410 -520 0 0 {name=p2 lab=output_match}
C {iopin.sym} 290 -790 1 1 {name=p3 lab=vdd}
C {iopin.sym} 290 -130 3 1 {name=p4 lab=vss}
C {symbols/nfet_03v3.sym} 450 -270 0 0 {name=M1D
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
C {lab_pin.sym} 410 -270 0 0 {name=pM1D_g sig_type=std_logic lab=vss}
C {lab_pin.sym} 470 -270 2 0 {name=pM1D_b sig_type=std_logic lab=vss}
C {symbols/nfet_05v0.sym} 450 -390 0 0 {name=M4D
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
C {lab_pin.sym} 470 -440 2 0 {name=pM4D_d sig_type=std_logic lab=vm1}
C {lab_pin.sym} 470 -340 2 0 {name=pM4D_s sig_type=std_logic lab=vm1}
C {lab_pin.sym} 420 -390 0 0 {name=pM4D_g sig_type=std_logic lab=vss}
C {lab_pin.sym} 540 -390 2 0 {name=pM4D_b sig_type=std_logic lab=vss}
