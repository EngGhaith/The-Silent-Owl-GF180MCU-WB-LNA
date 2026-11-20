v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 120 -20 220 -20 {lab=G}
N 120 -1120 220 -1120 {lab=G}
N 120 -570 300 -570 {lab=deemb_o}
N 210 -1120 220 -1120 {lab=G}
N 220 -1120 220 -20 {lab=G}
C {iopin.sym} 120 -1120 0 1 {name=p1 lab=G}
C {iopin.sym} 120 -570 0 1 {name=p2 lab=deemb_o}
C {iopin.sym} 120 -20 0 1 {name=p3 lab=G}
C {iopin.sym} 300 -510 0 1 {name=p5 lab=open_dummy_lvs}
C {gf180mcu_fd_pr/rm1.sym} 300 -540 0 0 {name=R1
W=1.62e-6
L=1e-6
model=rm1
spiceprefix=X
m=1}
