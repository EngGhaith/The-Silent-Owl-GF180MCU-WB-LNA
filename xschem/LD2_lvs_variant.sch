v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
C {ipin.sym} 0 -100 0 0 {name=p1 lab=vdd}
C {ipin.sym} 0 100 0 0 {name=p2 lab=vx}
C {symbols/rm1.sym} 160 -200 0 0 {name=RLD2_P1_RM2
W=1.75e-6
L=0.5e-6
model=rm2
spiceprefix=X
m=1
}
C {lab_pin.sym} 160 -230 3 0 {name=p_RLD2_P1_RM2_bot sig_type=std_logic lab=vdd}
C {lab_pin.sym} 160 -170 1 0 {name=p_RLD2_P1_RM2_top sig_type=std_logic lab=tip_m24}
C {symbols/rm1.sym} 220 -200 0 0 {name=RLD2_P1_RM3
W=1.75e-6
L=0.5e-6
model=rm3
spiceprefix=X
m=1
}
C {lab_pin.sym} 220 -230 3 0 {name=p_RLD2_P1_RM3_bot sig_type=std_logic lab=vdd}
C {lab_pin.sym} 220 -170 1 0 {name=p_RLD2_P1_RM3_top sig_type=std_logic lab=tip_m24}
C {symbols/rm1.sym} 280 -200 0 0 {name=RLD2_P1_RM4
W=1.75e-6
L=0.5e-6
model=rm4
spiceprefix=X
m=1
}
C {lab_pin.sym} 280 -230 3 0 {name=p_RLD2_P1_RM4_bot sig_type=std_logic lab=vdd}
C {lab_pin.sym} 280 -170 1 0 {name=p_RLD2_P1_RM4_top sig_type=std_logic lab=tip_m24}
C {symbols/rm1.sym} 340 -200 0 0 {name=RLD2_P1_TM11K
W=1.75e-6
L=0.5e-6
model=tm11k
spiceprefix=X
m=1
}
C {lab_pin.sym} 340 -230 3 0 {name=p_RLD2_P1_TM11K_bot sig_type=std_logic lab=vdd}
C {lab_pin.sym} 340 -170 1 0 {name=p_RLD2_P1_TM11K_top sig_type=std_logic lab=tip_tm}
C {symbols/rm1.sym} 160 200 0 0 {name=RLD2_P2_RM2
W=1.75e-6
L=0.5e-6
model=rm2
spiceprefix=X
m=1
}
C {lab_pin.sym} 160 170 3 0 {name=p_RLD2_P2_RM2_bot sig_type=std_logic lab=tip_m24}
C {lab_pin.sym} 160 230 1 0 {name=p_RLD2_P2_RM2_top sig_type=std_logic lab=vx}
C {symbols/rm1.sym} 220 200 0 0 {name=RLD2_P2_RM3
W=1.75e-6
L=0.5e-6
model=rm3
spiceprefix=X
m=1
}
C {lab_pin.sym} 220 170 3 0 {name=p_RLD2_P2_RM3_bot sig_type=std_logic lab=tip_m24}
C {lab_pin.sym} 220 230 1 0 {name=p_RLD2_P2_RM3_top sig_type=std_logic lab=vx}
C {symbols/rm1.sym} 280 200 0 0 {name=RLD2_P2_RM4
W=1.75e-6
L=0.5e-6
model=rm4
spiceprefix=X
m=1
}
C {lab_pin.sym} 280 170 3 0 {name=p_RLD2_P2_RM4_bot sig_type=std_logic lab=tip_m24}
C {lab_pin.sym} 280 230 1 0 {name=p_RLD2_P2_RM4_top sig_type=std_logic lab=vx}
C {symbols/rm1.sym} 340 200 0 0 {name=RLD2_P2_TM11K
W=1.75e-6
L=0.5e-6
model=tm11k
spiceprefix=X
m=1
}
C {lab_pin.sym} 340 170 3 0 {name=p_RLD2_P2_TM11K_bot sig_type=std_logic lab=tip_tm}
C {lab_pin.sym} 340 230 1 0 {name=p_RLD2_P2_TM11K_top sig_type=std_logic lab=vx}
