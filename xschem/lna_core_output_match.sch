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
N 440 -220 440 -120 {lab=rf_out_pad}
N 440 -300 440 -220 {lab=rf_out_pad}
C {ipin.sym} 230 -300 0 0 {name=p3 lab=output_cs}
C {symbols/cap_mim_2f0fF.sym} 350 -300 3 0 {name=C1
W=64.61u
L=54.0u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {iopin.sym} 170 -380 0 1 {name=p1 lab=vss}
C {lab_pin.sym} 210 -380 2 0 {name=p4 sig_type=std_logic lab=vss
}
C {opin.sym} 470 -300 0 0 {name=p5 lab=rf_out_pad}
C {code_shown.sym} -2000 -2000 0 0 {name=LVS_RESISTORS_OUTPUT_MATCH only_toplevel=false
format="tcleval( @value )"
value="
* LVS-only: coil flattened to its own metal-resistor stand-in directly in
* this schematic (no subcircuit boundary), tied straight to the real nets.
R1_LSHUNT_OUT rf_out_pad vss tm11k W=10u L=1u
"}
