v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 460 -430 460 -410 {lab=#net6}
N 460 -350 460 -330 {lab=#net6}
N 410 -380 420 -380 {lab=vss}
N 210 -290 230 -290 {
lab=vss}
N 210 -260 210 -250 {
lab=#net7}
N 150 -290 170 -290 {
lab=input_cg}
N 210 -250 210 -190 {
lab=#net7}
N 210 -400 230 -400 {
lab=vss}
N 210 -370 210 -360 {
lab=vm1}
N 150 -400 170 -400 {
lab=vbias_cas}
N 210 -360 210 -320 {
lab=vm1}
N 210 -190 210 -180 {
lab=#net7}
N 210 -120 210 -110 {
lab=vss}
N 210 -110 210 -90 {
lab=vss}
N 210 -480 280 -480 {
lab=output_match}
N 210 -670 210 -650 {lab=vdd}
N 210 -590 210 -570 {lab=#net8}
N 210 -510 210 -490 {lab=output_match}
N 210 -750 210 -690 {lab=vdd}
N 210 -490 210 -430 {lab=output_match}
N 210 -685 210 -670 {lab=vdd}
N 210 -690 210 -685 {lab=vdd}
N 210 -200 390 -200 {lab=#net7}
N 390 -260 410 -260 {lab=#net7}
N 410 -260 410 -200 {lab=#net7}
N 390 -200 410 -200 {lab=#net7}
N 330 -230 350 -230 {lab=vss}
N 460 -330 530 -330 {lab=#net6}
N 530 -430 530 -330 {lab=#net6}
N 460 -430 530 -430 {lab=#net6}
N 60 -560 100 -560 {lab=vss}
C {ipin.sym} 150 -290 0 0 {name=p1 lab=input_cg}
C {opin.sym} 280 -480 0 0 {name=p2 lab=output_match}
C {iopin.sym} 210 -750 1 1 {name=p3 lab=vdd}
C {symbols/nfet_05v0.sym} 440 -380 0 0 {name=M4D
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
C {lab_pin.sym} 410 -380 0 0 {name=pM4D_g sig_type=std_logic lab=vss}
C {lab_pin.sym} 460 -380 2 0 {name=pM4D_b sig_type=std_logic lab=vss}
C {symbols/nfet_05v0.sym} 190 -400 0 0 {name=M2
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
C {res.sym} 210 -150 0 0 {name=RS_EQ1
value=0.05
footprint=1206
device=resistor
m=1
}
C {symbols/nfet_03v3.sym} 190 -290 0 0 {name=M3
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
C {lab_pin.sym} 210 -348.75 0 0 {name=p6 sig_type=std_logic lab=vm1}
C {ind.sym} 210 -540 0 0 {name=LD1
m=1
value=4n
footprint=1206
device=inductor
}
C {res.sym} 210 -620 0 0 {name=RLD1
value=50
footprint=1206
device=resistor
m=1
}
C {iopin.sym} 150 -400 0 1 {name=p7 lab=vbias_cas}
C {lab_pin.sym} 210 -90 3 0 {name=p8 sig_type=std_logic lab=vss}
C {lab_pin.sym} 230 -400 2 0 {name=p9 sig_type=std_logic lab=vss}
C {lab_pin.sym} 230 -290 2 0 {name=p10 sig_type=std_logic lab=vss}
C {symbols/nfet_03v3.sym} 370 -230 0 0 {name=M5
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
C {lab_pin.sym} 330 -230 0 0 {name=pM1 sig_type=std_logic lab=vss}
C {lab_pin.sym} 390 -230 2 0 {name=pM2 sig_type=std_logic lab=vss}
C {lab_pin.sym} 460 -330 0 0 {name=p5 sig_type=std_logic lab=vm1}
C {iopin.sym} 60 -560 2 0 {name=p11 lab=vss}
C {lab_pin.sym} 100 -560 2 0 {name=p13 sig_type=std_logic lab=vss
}
