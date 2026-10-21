v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {ipin.sym} 0 -100 0 0 {name=p1 lab=rf_in_pad}
C {ipin.sym} 0 100 0 0 {name=p2 lab=vss}
C {symbols/rm1.sym} 100 -200 0 0 {name=RLEQ_P1_RM1
W=26e-6
L=0.5e-6
model=rm1
spiceprefix=X
m=1
}
C {lab_pin.sym} 100 -230 3 0 {name=p_RLEQ_P1_RM1_bot sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 100 -170 1 0 {name=p_RLEQ_P1_RM1_top sig_type=std_logic lab=tip_m14}
C {symbols/rm1.sym} 160 -200 0 0 {name=RLEQ_P1_RM2
W=26e-6
L=0.5e-6
model=rm2
spiceprefix=X
m=1
}
C {lab_pin.sym} 160 -230 3 0 {name=p_RLEQ_P1_RM2_bot sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 160 -170 1 0 {name=p_RLEQ_P1_RM2_top sig_type=std_logic lab=tip_m14}
C {symbols/rm1.sym} 220 -200 0 0 {name=RLEQ_P1_RM3
W=26e-6
L=0.5e-6
model=rm3
spiceprefix=X
m=1
}
C {lab_pin.sym} 220 -230 3 0 {name=p_RLEQ_P1_RM3_bot sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 220 -170 1 0 {name=p_RLEQ_P1_RM3_top sig_type=std_logic lab=tip_m14}
C {symbols/rm1.sym} 280 -200 0 0 {name=RLEQ_P1_RM4
W=26e-6
L=0.5e-6
model=rm4
spiceprefix=X
m=1
}
C {lab_pin.sym} 280 -230 3 0 {name=p_RLEQ_P1_RM4_bot sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 280 -170 1 0 {name=p_RLEQ_P1_RM4_top sig_type=std_logic lab=tip_m14}
C {symbols/rm1.sym} 340 -200 0 0 {name=RLEQ_P1_TM11K
W=26e-6
L=0.5e-6
model=tm11k
spiceprefix=X
m=1
}
C {lab_pin.sym} 340 -230 3 0 {name=p_RLEQ_P1_TM11K_bot sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 340 -170 1 0 {name=p_RLEQ_P1_TM11K_top sig_type=std_logic lab=tip_tm}
C {symbols/rm1.sym} 160 200 0 0 {name=RLEQ_P2_RM2
W=26e-6
L=0.5e-6
model=rm2
spiceprefix=X
m=1
}
C {lab_pin.sym} 160 170 3 0 {name=p_RLEQ_P2_RM2_bot sig_type=std_logic lab=tip_m14}
C {lab_pin.sym} 160 230 1 0 {name=p_RLEQ_P2_RM2_top sig_type=std_logic lab=vss}
C {symbols/rm1.sym} 220 200 0 0 {name=RLEQ_P2_RM3
W=26e-6
L=0.5e-6
model=rm3
spiceprefix=X
m=1
}
C {lab_pin.sym} 220 170 3 0 {name=p_RLEQ_P2_RM3_bot sig_type=std_logic lab=tip_m14}
C {lab_pin.sym} 220 230 1 0 {name=p_RLEQ_P2_RM3_top sig_type=std_logic lab=vss}
C {symbols/rm1.sym} 280 200 0 0 {name=RLEQ_P2_RM4
W=26e-6
L=0.5e-6
model=rm4
spiceprefix=X
m=1
}
C {lab_pin.sym} 280 170 3 0 {name=p_RLEQ_P2_RM4_bot sig_type=std_logic lab=tip_m14}
C {lab_pin.sym} 280 230 1 0 {name=p_RLEQ_P2_RM4_top sig_type=std_logic lab=vss}
C {symbols/rm1.sym} 340 200 0 0 {name=RLEQ_P2_TM11K
W=26e-6
L=0.5e-6
model=tm11k
spiceprefix=X
m=1
}
C {lab_pin.sym} 340 170 3 0 {name=p_RLEQ_P2_TM11K_bot sig_type=std_logic lab=tip_tm}
C {lab_pin.sym} 340 230 1 0 {name=p_RLEQ_P2_TM11K_top sig_type=std_logic lab=vss}
