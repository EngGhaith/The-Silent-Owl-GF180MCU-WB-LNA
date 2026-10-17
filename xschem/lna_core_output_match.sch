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
N 440 -300 440 -225 {lab=rf_out_pad
spice_ignore=true}
C {iopin.sym} 470 -300 0 0 {name=p58 lab=rf_out_pad}
C {symbols/cap_mim_2f0fF.sym} 350 -300 3 0 {name=C11
W=33.118u
L=33.118u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {ind.sym} 440 -195 0 0 {name=LSHUNT_OUT
spice_ignore=true
m=1
value=4.0607n
footprint=1206
device=inductor
}
C {res.sym} 440 -135 2 0 {name=RLSHOUT
spice_ignore=true
value=5.1028
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 440 -105 2 0 {name=p915 sig_type=std_logic lab=vss
spice_ignore=true}
C {ipin.sym} 230 -300 0 0 {name=p3 lab=output_cs}
