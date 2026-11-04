v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 430 -270 450 -270 {
lab=rf_in_pad}
N 590 -270 700 -270 {lab=#net1}
N 450 -270 530 -270 {lab=rf_in_pad}
N 370 -270 430 -270 {lab=rf_in_pad}
N 450 -270 450 -230 {lab=rf_in_pad}
N 450 -100 450 -70 {lab=vss}
N 320 -270 370 -270 {lab=rf_in_pad}
N 450 -170 450 -160 {lab=#net2}
N 700 -270 820 -270 {lab=#net1}
N 270 -340 310 -340 {lab=vss}
C {lab_pin.sym} 450 -70 3 0 {name=p46 sig_type=std_logic lab=vss
}
C {ind.sym} 450 -130 0 0 {name=LEQ
m=1
value=2.8491n
footprint=1206
device=inductor
}
C {iopin.sym} 320 -270 0 1 {name=p56 lab=rf_in_pad}
C {symbols/cap_mim_2f0fF.sym} 560 -270 3 0 {name=C15
W=34.7078u
L=34.7078u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 640 -240 0 0 {name=CPI
W=26.7084u
L=26.7084u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_pin.sym} 640 -210 3 0 {name=pCPI_vss sig_type=std_logic lab=vss}
C {res.sym} 450 -200 0 0 {name=RLEQ
value=3.5803
footprint=1206
device=resistor
m=1
}
C {iopin.sym} 270 -340 0 1 {name=p1 lab=vss}
C {lab_pin.sym} 310 -340 2 0 {name=p2 sig_type=std_logic lab=vss
}
C {opin.sym} 820 -270 0 0 {name=p3 lab=input_cg}
