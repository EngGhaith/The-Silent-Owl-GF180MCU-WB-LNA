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
N 570 -260 570 -120 {lab=rf_in_pad}
C {iopin.sym} 270 -340 0 1 {name=p1 lab=vss}
C {lab_pin.sym} 310 -340 2 0 {name=p2 sig_type=std_logic lab=vss
}
C {opin.sym} 1130 -260 0 0 {name=p3 lab=input_cg}
C {iopin.sym} 410 -260 0 1 {name=p6 lab=rf_in_pad}
C {symbols/cap_mim_2f0fF.sym} 860 -260 3 0 {name=C15
W=24.82u
L=24.82u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {code_shown.sym} -2000 -2000 0 0 {name=LVS_RESISTORS_INPUT_MATCH only_toplevel=false
format="tcleval( @value )"
value="
* LVS-only: coil flattened to its own metal-resistor stand-in directly in
* this schematic (no subcircuit boundary), tied straight to the real nets.
R1_LEQ rf_in_pad vss tm11k W=10u L=1u
"}
