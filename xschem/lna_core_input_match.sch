v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 270 -340 310 -340 {lab=vss}
N 730 -260 750 -260 {
lab=rf_in_pad}
N 630 -260 670 -260 {
lab=rf_in_pad}
N 890 -260 1000 -260 {lab=input_cg}
N 750 -260 830 -260 {lab=rf_in_pad}
N 670 -260 730 -260 {lab=rf_in_pad}
N 570 -260 630 -260 {lab=rf_in_pad}
N 460 -260 510 -260 {lab=rf_in_pad}
N 410 -260 460 -260 {lab=rf_in_pad}
N 510 -260 570 -260 {lab=rf_in_pad}
N 1000 -260 1130 -260 {lab=input_cg}
N 570 -120 610 -120 {lab=rf_in_pad}
N 810 -120 850 -120 {lab=vss}
N 570 -260 570 -120 {lab=rf_in_pad}
C {iopin.sym} 270 -340 0 1 {name=p1 lab=vss}
C {lab_pin.sym} 310 -340 2 0 {name=p2 sig_type=std_logic lab=vss
}
C {opin.sym} 1130 -260 0 0 {name=p3 lab=input_cg}
C {LEQ_model.sym} 710 -120 0 0 {name=XLEQ}
C {lab_pin.sym} 850 -120 1 0 {name=pRLEQ_T2 sig_type=std_logic lab=vss}
C {iopin.sym} 410 -260 0 1 {name=p6 lab=rf_in_pad}
C {capa.sym} 860 -260 3 0 {name=C15
m=1
value=1.25p
footprint=1206
device="ceramic capacitor"
}
