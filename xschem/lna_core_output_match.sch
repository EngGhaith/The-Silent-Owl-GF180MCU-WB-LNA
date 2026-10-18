v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 440 -300 470 -300 {lab=rf_out_pad}
N 230 -300 320 -300 {lab=output_cs}
N 380 -300 440 -300 {lab=rf_out_pad}
N 440 -300 440 -225 {lab=rf_out_pad}
N 170 -380 210 -380 {lab=vss}
C {ipin.sym} 230 -300 0 0 {name=p3 lab=output_cs}
C {capa.sym} 350 -300 3 0 {name=C1
m=1
value=7p
footprint=1206
device="ceramic capacitor"
}
C {ind.sym} 440 -195 0 0 {name=LSHUNT_OUT1
m=1
value=2.5n
footprint=1206
device=inductor
}
C {res.sym} 440 -135 2 0 {name=RLSHOUT1
value=3.1416
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 440 -105 2 0 {name=p2 sig_type=std_logic lab=vss}
C {iopin.sym} 170 -380 0 1 {name=p1 lab=vss}
C {lab_pin.sym} 210 -380 2 0 {name=p4 sig_type=std_logic lab=vss
}
C {opin.sym} 470 -300 0 0 {name=p5 lab=rf_out_pad}
