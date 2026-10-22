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
N 170 -380 210 -380 {lab=vss}
N 440 -120 480 -120 {lab=rf_out_pad}
N 440 -220 440 -120 {lab=rf_out_pad}
N 440 -300 440 -220 {lab=rf_out_pad}
N 680 -120 730 -120 {lab=vss}
C {ipin.sym} 230 -300 0 0 {name=p3 lab=output_cs}
C {capa.sym} 350 -300 3 0 {name=C1
m=1
value=7p
footprint=1206
device="ceramic capacitor"
}
C {iopin.sym} 170 -380 0 1 {name=p1 lab=vss}
C {lab_pin.sym} 210 -380 2 0 {name=p4 sig_type=std_logic lab=vss
}
C {opin.sym} 470 -300 0 0 {name=p5 lab=rf_out_pad}
C {LSHUNT_OUT_model.sym} 580 -120 0 0 {name=XLSHUNT_OUT}
C {lab_pin.sym} 730 -120 2 0 {name=pRLSHUNT_OUT_T2 sig_type=std_logic lab=vss}
