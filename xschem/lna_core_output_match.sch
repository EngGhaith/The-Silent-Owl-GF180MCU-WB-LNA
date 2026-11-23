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
C {iopin.sym} 170 -380 0 1 {name=p1 lab=vss}
C {lab_pin.sym} 210 -380 2 0 {name=p4 sig_type=std_logic lab=vss
}
C {opin.sym} 470 -300 0 0 {name=p5 lab=rf_out_pad}
C {LSHUNT_OUT_model.sym} 580 -120 0 0 {name=XXLSHUNT_OUT}
C {lab_pin.sym} 730 -120 2 0 {name=pRLSHUNT_OUT_T2 sig_type=std_logic lab=vss}
C {code_shown.sym} -2000 -2000 0 0 {name=LVS_MODELS only_toplevel=true
format="tcleval( @value )"
value="
* LVS-only inductor model selection, see lna_core_parts.sch for details.
.lib $::env(PWD)/LSHUNT_OUT_model.lib lvsrm
"}
C {symbols/cap_mim_2f0fF.sym} 350 -300 3 0 {name=C1
W=64.61e-6
L=54.0e-6
model=cap_mim_2f0fF
spiceprefix=X
m=1}
