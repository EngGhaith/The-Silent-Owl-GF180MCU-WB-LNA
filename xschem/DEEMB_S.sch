v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 120 -20 220 -20 {lab=G}
N 120 -1120 220 -1120 {lab=G}
N 120 -570 300 -570 {lab=DEEMB}
N 210 -1120 220 -1120 {lab=G}
N 220 -1120 220 -20 {lab=G}
C {iopin.sym} 120 -1120 0 1 {name=p1 lab=G}
C {iopin.sym} 120 -570 0 1 {name=p2 lab=DEEMB}
C {iopin.sym} 120 -20 0 1 {name=p3 lab=G}
C {lab_pin.sym} 300 -570 0 0 {name=p4 sig_type=std_logic lab=DEEMB}
C {lab_pin.sym} 300 -510 0 0 {name=p5 sig_type=std_logic lab=G}
C {gf180mcu_fd_pr/rm1.sym} 300 -540 0 0 {name=R1
W=1.62e-6
L=1e-6
model=rm1
spiceprefix=X
m=1}
