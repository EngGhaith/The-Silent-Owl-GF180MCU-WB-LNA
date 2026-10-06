v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 150 -920 150 -880 {lab=vdd}
N 300 -820 340 -820 {lab=vbias_cg}
N 300 -780 340 -780 {lab=vbias_cs}
N 300 -740 340 -740 {lab=vbias_csc}
N 300 -700 340 -700 {lab=vbias_cas}
N 300 -660 340 -660 {lab=vbias_casc}
N 150 -600 150 -560 {lab=vss}
N 830 -970 830 -930 {lab=vdd}
N 620 -870 660 -870 {lab=rf_in_pad}
N 620 -830 660 -830 {lab=vbias_cg}
N 620 -790 660 -790 {lab=vbias_cs}
N 620 -750 660 -750 {lab=vbias_csc}
N 620 -710 660 -710 {lab=vbias_cas}
N 620 -670 660 -670 {lab=vbias_casc}
N 1000 -770 1040 -770 {lab=rf_out_pad}
N 830 -610 830 -570 {lab=vss}
C {iopin.sym} 370 -1000 0 0 {name=p1 lab=vdd}
C {iopin.sym} 370 -960 0 0 {name=p2 lab=vss}
C {iopin.sym} 470 -1000 0 0 {name=p3 lab=rf_in_pad}
C {iopin.sym} 470 -960 0 0 {name=p4 lab=rf_out_pad}
C {lna_bias_gen.sym} 150 -740 0 0 {name=xbias
}
C {lab_pin.sym} 150 -920 1 0 {name=l5 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 340 -820 2 0 {name=l6 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 340 -780 2 0 {name=l7 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 340 -740 2 0 {name=l8 sig_type=std_logic lab=vbias_csc}
C {lab_pin.sym} 340 -700 2 0 {name=l9 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 340 -660 2 0 {name=l10 sig_type=std_logic lab=vbias_casc}
C {lab_pin.sym} 150 -560 3 0 {name=l11 sig_type=std_logic lab=vss}
C {lab_pin.sym} 830 -970 1 0 {name=l12 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 620 -870 0 0 {name=l13 sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 620 -830 0 0 {name=l14 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 620 -790 0 0 {name=l15 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 620 -750 0 0 {name=l16 sig_type=std_logic lab=vbias_csc}
C {lab_pin.sym} 620 -710 0 0 {name=l17 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 620 -670 0 0 {name=l18 sig_type=std_logic lab=vbias_casc}
C {lab_pin.sym} 1040 -770 2 0 {name=l19 sig_type=std_logic lab=rf_out_pad}
C {lab_pin.sym} 830 -570 3 0 {name=l20 sig_type=std_logic lab=vss}
C {lna_core.sym} 830 -770 0 0 {name=x1}
