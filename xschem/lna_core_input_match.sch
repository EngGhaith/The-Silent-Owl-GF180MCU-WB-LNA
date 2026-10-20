v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 270 -340 310 -340 {lab=vss}
N 640 -270 660 -270 {
lab=rf_in_pad}
N 540 -270 580 -270 {
lab=rf_in_pad}
N 660 -270 740 -270 {lab=rf_in_pad}
N 580 -270 640 -270 {lab=rf_in_pad}
N 480 -270 540 -270 {lab=rf_in_pad}
N 660 -270 660 -230 {lab=rf_in_pad}
N 660 -100 660 -70 {lab=vss}
N 370 -270 420 -270 {lab=rf_in_pad}
N 320 -270 370 -270 {lab=rf_in_pad}
N 660 -170 660 -160 {lab=#net1}
N 420 -270 480 -270 {lab=rf_in_pad}
N 800 -270 820 -270 {lab=input_cg}
C {iopin.sym} 320 -270 0 1 {name=p56 lab=rf_in_pad}
C {iopin.sym} 270 -340 0 1 {name=p1 lab=vss}
C {lab_pin.sym} 310 -340 2 0 {name=p2 sig_type=std_logic lab=vss
}
C {opin.sym} 820 -270 0 0 {name=p3 lab=input_cg}
C {lab_pin.sym} 660 -70 3 0 {name=p4 sig_type=std_logic lab=vss
}
C {ind.sym} 660 -130 0 0 {name=LEQ1
m=1
value=1.3333n
footprint=1206
device=inductor
}
C {capa.sym} 770 -270 3 0 {name=C1
m=1
value=1.25p
footprint=1206
device="ceramic capacitor"
}
C {res.sym} 660 -200 0 0 {name=RLEQ1
value=1.6755
footprint=1206
device=resistor
m=1
}
