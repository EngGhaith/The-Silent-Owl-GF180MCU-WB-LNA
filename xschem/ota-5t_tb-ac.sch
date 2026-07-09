v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 550 -260 550 -240 {
lab=GND}
N 630 -260 630 -240 {
lab=GND}
N 630 -340 630 -320 {
lab=v_ss}
N 1120 -340 1330 -340 {
lab=v_ss}
N 1080 -790 1120 -790 {
lab=v_dd}
N 1080 -510 1080 -340 {
lab=v_ss}
N 1330 -490 1330 -340 {
lab=v_ss}
N 1330 -590 1330 -550 {
lab=v_out}
N 1250 -590 1330 -590 {
lab=v_out}
N 1250 -590 1250 -470 {
lab=v_out}
N 1180 -590 1250 -590 {
lab=v_out}
N 930 -470 1250 -470 {
lab=v_out}
N 930 -560 930 -470 {
lab=v_out}
N 930 -560 1000 -560 {
lab=v_out}
N 730 -470 730 -340 {
lab=v_ss}
N 630 -340 730 -340 {
lab=v_ss}
N 730 -620 730 -530 {
lab=v_in}
N 730 -620 1000 -620 {
lab=v_in}
N 1120 -790 1120 -770 {
lab=v_dd}
N 1120 -710 1120 -670 {
lab=#net1}
N 1080 -720 1080 -670 {
lab=v_dd}
N 550 -720 1080 -720 {
lab=v_dd}
N 550 -720 550 -320 {
lab=v_dd}
N 1080 -790 1080 -720 {
lab=v_dd}
N 1120 -360 1120 -340 {
lab=v_ss}
N 1080 -340 1120 -340 {
lab=v_ss}
N 730 -340 1080 -340 {
lab=v_ss}
N 1120 -510 1120 -420 {
lab=v_ena}
C {devices/code_shown.sym} 30 -710 0 0 {name=NGSPICE only_toplevel=true 
value="
.temp 27
.control
option sparse
save all
op
write ota-5t_tb-ac.raw
set appendwrite

ac dec 101 1k 100MEG
write ota-5t_tb-ac.raw
plot 20*log10(v_out)

meas ac dcgain MAX vmag(v_out) FROM=10 TO=10k
let f3db = dcgain/sqrt(2)
meas ac fbw WHEN vmag(v_out)=f3db FALL=1
let gainerror=(dcgain-1)/1
print dcgain
print fbw
print gainerror

noise v(v_out) Vin dec 101 1k 100MEG
print onoise_total

.endc
"}
C {devices/vsource.sym} 550 -290 0 0 {name=Vdd value=5}
C {devices/gnd.sym} 550 -240 0 0 {name=l3 lab=GND}
C {devices/launcher.sym} 530 -120 0 0 {name=h2
descr="simulate" 
tclcommand="xschem save; xschem netlist; xschem simulate"
}
C {devices/launcher.sym} 770 -120 0 0 {name=h3
descr="annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {lab_pin.sym} 550 -340 0 0 {name=p2 sig_type=std_logic lab=v_dd}
C {devices/vsource.sym} 630 -290 0 0 {name=Vss value=0}
C {devices/gnd.sym} 630 -240 0 0 {name=l1 lab=GND}
C {lab_pin.sym} 630 -340 0 0 {name=p1 sig_type=std_logic lab=v_ss}
C {capa.sym} 1330 -520 0 0 {name=C1
value=50f}
C {lab_wire.sym} 1330 -590 0 0 {name=p3 sig_type=std_logic lab=v_out}
C {devices/vsource.sym} 730 -500 0 0 {name=Vin value="dc 0.8 ac 1"}
C {lab_wire.sym} 790 -620 0 0 {name=p4 sig_type=std_logic lab=v_in}
C {isource.sym} 1120 -740 0 0 {name=I0 value=20u pwl(0 0 10u 0 11u 20u)"}
C {vsource.sym} 1120 -390 0 0 {name=Venable value=5 savecurrent=false}
C {spice_probe.sym} 850 -620 0 0 {name=p5 attrs=""}
C {spice_probe.sym} 1210 -590 0 0 {name=p6 attrs=""}
C {spice_probe.sym} 1120 -430 0 0 {name=p7 attrs=""}
C {lab_wire.sym} 1120 -490 0 0 {name=p8 sig_type=std_logic lab=v_ena}
C {ota-5t.sym} 990 -510 0 0 {name=x1}
C {devices/code_shown.sym} 50 -60 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

"
spice_ignore=true}
C {devices/code_shown.sym} 580 -60 0 0 {name=MODELS2 only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"
}
C {devices/code_shown.sym} 1140 -100 0 0 {name=MODELS1 only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"
spice_ignore=true}
