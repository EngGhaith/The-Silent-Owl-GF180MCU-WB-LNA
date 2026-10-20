v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 510 -390 590 -390 {lab=#net1}
N 590 -390 640 -390 {lab=#net1}
N 610 -340 640 -340 {lab=vbias_cs}
N 610 -320 640 -320 {lab=vbias_cg}
N 610 -300 640 -300 {lab=g_cg}
N 970 -390 1070 -390 {lab=#net2}
N 1030 -300 1070 -300 {lab=vbias_cas}
N 1370 -390 1480 -390 {lab=#net3}
N 1760 -390 1810 -390 {lab=rf_out_pad}
N 190 -390 230 -390 {lab=rf_in_pad}
N 1220 -460 1220 -430 {lab=vdd}
N 790 -460 790 -430 {lab=vdd}
N 190 -740 220 -740 {lab=vdd}
N 190 -710 220 -710 {lab=vss}
N 370 -235 370 -215 {lab=vss}
N 790 -270 790 -245 {lab=vss}
N 1220 -270 1220 -245 {lab=vss}
N 190 -610 240 -610 {lab=vbias_cg}
N 190 -580 235 -580 {lab=vbias_cs}
N 235 -580 240 -580 {lab=vbias_cs}
N 190 -545 240 -545 {lab=vbias_cas}
N 940 -390 970 -390 {lab=#net2}
N 190 -515 240 -515 {lab=g_cg}
C {lna_core_output_match.sym} 1620 -250 0 0 {name=x1}
C {lna_core_input_match.sym} 610 -240 0 1 {name=x2}
C {lna_core_cg.sym} 790 -290 0 0 {name=x3}
C {lna_core_cs.sym} 1220 -270 0 0 {name=x4}
C {ipin.sym} 190 -390 2 1 {name=p56 lab=rf_in_pad}
C {iopin.sym} 190 -610 2 0 {name=p57 lab=vbias_cg}
C {iopin.sym} 190 -580 2 0 {name=p59 lab=vbias_cs
}
C {opin.sym} 1810 -390 0 0 {name=p58 lab=rf_out_pad}
C {iopin.sym} 190 -740 2 0 {name=p1 lab=vdd
}
C {iopin.sym} 190 -710 2 0 {name=p2 lab=vss
}
C {lab_pin.sym} 220 -740 2 0 {name=p11 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 220 -710 2 0 {name=p3 sig_type=std_logic lab=vss
}
C {lab_pin.sym} 370 -215 3 0 {name=p4 sig_type=std_logic lab=vss
}
C {lab_pin.sym} 790 -245 3 0 {name=p5 sig_type=std_logic lab=vss
}
C {lab_pin.sym} 1220 -245 3 0 {name=p6 sig_type=std_logic lab=vss
}
C {lab_pin.sym} 240 -610 2 0 {name=p8 sig_type=std_logic lab=vbias_cg
}
C {lab_pin.sym} 610 -320 0 0 {name=p9 sig_type=std_logic lab=vbias_cg
}
C {lab_pin.sym} 240 -580 2 0 {name=p10 sig_type=std_logic lab=vbias_cs
}
C {lab_pin.sym} 610 -340 0 0 {name=p12 sig_type=std_logic lab=vbias_cs
}
C {iopin.sym} 190 -545 0 1 {name=p61 lab=vbias_cas}
C {lab_pin.sym} 240 -545 2 0 {name=p13 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 1030 -300 0 0 {name=p14 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 790 -460 1 0 {name=p15 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 1220 -460 1 0 {name=p16 sig_type=std_logic lab=vdd
}
C {lab_pin.sym} 610 -300 0 0 {name=p17 sig_type=std_logic lab=g_cg
}
C {iopin.sym} 190 -515 0 1 {name=p18 lab=g_cg}
C {lab_pin.sym} 240 -515 2 0 {name=p19 sig_type=std_logic lab=g_cg}
