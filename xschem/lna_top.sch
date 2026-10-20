v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {LNA top cell for layout / LVS: lna_core + bandgap + lna_bias + bias decoupling} -700 -700 0 0 0.4 0.4 {}
T {vbias_casc / vbias_csc are unused inside lna_core -> tied to vss} -560 330 0 0 0.3 0.3 {}
N 250 -80 210 -80 {lab=rf_in_pad}
N 250 -20 210 -20 {lab=vss}
N 250 0 210 0 {lab=vbias_icg}
N 250 20 210 20 {lab=vbias_cg}
N 250 40 210 40 {lab=vbias_cs}
N 250 60 210 60 {lab=vbias_cas}
N 250 80 210 80 {lab=vss}
N 250 100 210 100 {lab=vbias_buf}
N 550 0 590 0 {lab=rf_out_pad}
N 400 -130 400 -160 {lab=vdd}
N 400 130 400 160 {lab=vss}
N -650 -440 -690 -440 {lab=vdd}
N -650 -370 -690 -370 {lab=vss}
N -350 -400 -310 -400 {lab=vref}
N -100 -430 -100 -460 {lab=vdd}
N -100 -130 -100 -100 {lab=vss}
N -250 -340 -290 -340 {lab=vref}
N 50 -360 90 -360 {lab=vbias_cas}
N 50 -320 90 -320 {lab=vbias_cg}
N 50 -280 90 -280 {lab=vbias_cs}
N 50 -240 90 -240 {lab=vbias_icg}
N 50 -200 90 -200 {lab=vbias_buf}
N -500 120 -500 90 {lab=vbias_cas}
N -500 180 -500 210 {lab=vss}
N -410 120 -410 90 {lab=vbias_icg}
N -410 180 -410 210 {lab=vss}
N -320 120 -320 90 {lab=vbias_buf}
N -320 180 -320 210 {lab=vss}
N -230 120 -230 90 {lab=vbias_cg}
N -230 180 -230 210 {lab=vss}
N -140 120 -140 90 {lab=vbias_cs}
N -140 180 -140 210 {lab=vss}
C {lna_core.sym} 400 0 0 0 {name=x1}
C {lab_pin.sym} 210 -80 0 0 {name=l1 sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 210 -20 0 0 {name=l2 sig_type=std_logic lab=vss}
C {lab_pin.sym} 210 0 0 0 {name=l3 sig_type=std_logic lab=vbias_icg}
C {lab_pin.sym} 210 20 0 0 {name=l4 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 210 40 0 0 {name=l5 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 210 60 0 0 {name=l6 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 210 80 0 0 {name=l7 sig_type=std_logic lab=vss}
C {lab_pin.sym} 210 100 0 0 {name=l8 sig_type=std_logic lab=vbias_buf}
C {lab_pin.sym} 590 0 2 0 {name=l9 sig_type=std_logic lab=rf_out_pad}
C {lab_pin.sym} 400 -160 1 0 {name=l10 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 400 160 3 0 {name=l11 sig_type=std_logic lab=vss}
C {bandgap.sym} -500 -300 0 0 {name=XBG}
C {lab_pin.sym} -690 -440 0 0 {name=l12 sig_type=std_logic lab=vdd}
C {lab_pin.sym} -690 -370 0 0 {name=l13 sig_type=std_logic lab=vss}
C {lab_pin.sym} -310 -400 2 0 {name=l14 sig_type=std_logic lab=vref}
C {lna_bias.sym} -100 -280 0 0 {name=XBIAS}
C {lab_pin.sym} -100 -460 1 0 {name=l15 sig_type=std_logic lab=vdd}
C {lab_pin.sym} -100 -100 3 0 {name=l16 sig_type=std_logic lab=vss}
C {lab_pin.sym} -290 -340 0 0 {name=l17 sig_type=std_logic lab=vref}
C {lab_pin.sym} 90 -360 2 0 {name=l18 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 90 -320 2 0 {name=l19 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 90 -280 2 0 {name=l20 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 90 -240 2 0 {name=l21 sig_type=std_logic lab=vbias_icg}
C {lab_pin.sym} 90 -200 2 0 {name=l22 sig_type=std_logic lab=vbias_buf}
C {symbols/cap_mim_2f0fF.sym} -500 150 0 0 {name=CB1
W=150u
L=150u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_pin.sym} -500 90 1 0 {name=l23 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} -500 210 3 0 {name=l24 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} -410 150 0 0 {name=CB3
W=40u
L=40u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_pin.sym} -410 90 1 0 {name=l25 sig_type=std_logic lab=vbias_icg}
C {lab_pin.sym} -410 210 3 0 {name=l26 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} -320 150 0 0 {name=CB4
W=80u
L=80u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_pin.sym} -320 90 1 0 {name=l27 sig_type=std_logic lab=vbias_buf}
C {lab_pin.sym} -320 210 3 0 {name=l28 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} -230 150 0 0 {name=CB5
W=40u
L=40u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_pin.sym} -230 90 1 0 {name=l29 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} -230 210 3 0 {name=l30 sig_type=std_logic lab=vss}
C {symbols/cap_mim_2f0fF.sym} -140 150 0 0 {name=CB6
W=40u
L=40u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_pin.sym} -140 90 1 0 {name=l31 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} -140 210 3 0 {name=l32 sig_type=std_logic lab=vss}
C {iopin.sym} -700 -600 0 0 {name=p1 lab=rf_in_pad}
C {iopin.sym} -700 -570 0 0 {name=p2 lab=rf_out_pad}
C {iopin.sym} -700 -540 0 0 {name=p3 lab=vdd}
C {iopin.sym} -700 -510 0 0 {name=p4 lab=vss}
