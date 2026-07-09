v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 870 -250 870 -210 {lab=#net1}
N 670 -250 710 -250 {lab=#net2}
N 670 -250 670 -210 {lab=#net2}
N 510 -230 510 -170 {lab=#net3}
N 430 -230 510 -230 {lab=#net3}
N 670 -330 670 -250 {lab=#net2}
N 670 -550 670 -390 {lab=#net4}
N 230 -550 670 -550 {lab=#net4}
N 230 -550 230 -510 {lab=#net4}
N 230 -450 230 -410 {lab=0}
N 390 -370 390 -260 {lab=#net5}
N 510 -110 510 -70 {lab=0}
N 390 -200 390 -150 {lab=#net6}
N 390 -90 390 -50 {lab=0}
N 670 -150 670 -110 {lab=0}
N 870 -150 870 -110 {lab=0}
N -160 -110 -160 -70 {lab=0}
N -160 -190 -160 -170 {lab=#net7}
N 290 -230 390 -230 {lab=0}
N 390 -360 630 -360 {lab=#net5}
N 670 -360 780 -360 {lab=0}
N 390 -430 390 -370 {lab=#net5}
N 390 -550 390 -490 {lab=#net4}
N 280 -230 290 -230 {lab=0}
N 40 -190 100 -190 {lab=#net8}
N -160 -190 -20 -190 {lab=#net7}
N 160 -190 390 -190 {lab=#net6}
N 770 -250 790 -250 {lab=#net9}
N 850 -250 870 -250 {lab=#net1}
C {isource.sym} 390 -120 0 0 {name=I0 value=4.5m}
C {symbols/nfet_03v3.sym} 410 -230 0 1 {name=M1
L=0.28u
W=20u
nf=1
m=7
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {capa.sym} 10 -190 1 0 {name=C1
m=1
value=1n
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 740 -250 1 0 {name=C2
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {symbols/nfet_03v3.sym} 650 -360 0 0 {name=M2
L=0.28u
W=20u
nf=1
m=7
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {isource.sym} 670 -180 0 0 {name=I1 value=4.5m}
C {vsource.sym} -160 -140 0 0 {name=V1 value="dc 0 ac 1 portnum 1 z0 50" savecurrent=false}
C {vsource.sym} 870 -180 0 0 {name=V2 value="dc 0 ac 1 portnum 2 z0 50" savecurrent=false}
C {res.sym} 390 -460 0 0 {name=R1
value=600
footprint=1206
device=resistor
m=1}
C {vsource.sym} 230 -480 0 0 {name=V3 value=3.3 savecurrent=false}
C {gnd.sym} -160 -70 0 0 {name=l1 lab=0}
C {gnd.sym} 510 -70 0 0 {name=l2 lab=0}
C {gnd.sym} 670 -110 0 0 {name=l3 lab=0}
C {gnd.sym} 870 -110 0 0 {name=l4 lab=0}
C {gnd.sym} 230 -410 0 0 {name=l5 lab=0}
C {gnd.sym} 390 -50 0 0 {name=l6 lab=0}
C {gnd.sym} 280 -230 0 0 {name=l7 lab=0}
C {gnd.sym} 780 -360 0 0 {name=l8 lab=0}
C {vsource.sym} 510 -140 0 0 {name=V4 value=1 savecurrent=false}
C {code_shown.sym} 0 -785 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.param sw_stat_mismatch=0
.param mis_vth=0
.param mis_k=0

.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice diode_typical
"}
C {code_shown.sym} 1040 -900 0 0 {name=NGSPICE1
only_toplevel=true
value="
.control

set noaskquit
save all

echo
echo ============================================================
echo 3.3V COMMON-GATE LNA DC CHECK
echo ============================================================

op

echo ---------------- XM1 ----------------
print @m.xm1.m0[id]
print @m.xm1.m0[gm]
print @m.xm1.m0[gds]
print @m.xm1.m0[vgs]
print @m.xm1.m0[vds]

let gmro_xm1 = @m.xm1.m0[gm] / @m.xm1.m0[gds]
let rin_xm1  = 1 / @m.xm1.m0[gm]

print gmro_xm1
print rin_xm1

echo ---------------- XM2 ----------------
print @m.xm2.m0[id]
print @m.xm2.m0[gm]
print @m.xm2.m0[gds]
print @m.xm2.m0[vgs]
print @m.xm2.m0[vds]

let gmro_xm2 = @m.xm2.m0[gm] / @m.xm2.m0[gds]
let rin_xm2  = 1 / @m.xm2.m0[gm]

print gmro_xm2
print rin_xm2

echo
echo ============================================================
echo FINISHED DC CHECK
echo ============================================================

.endc
" 
spice_ignore=true}
C {code_shown.sym} 1640 -900 0 0 {name=NGSPICE2
only_toplevel=true
value="
.control

set noaskquit
set wr_singlescale
set wr_vecnames
save all

echo
echo ============================================================
echo 3.3V CG LNA - 2.4 GHz GAIN DIAGNOSTIC
echo Input match is frozen
echo ============================================================

op

echo
echo ---------------- DC CHECK ----------------
print @m.xm1.m0[id]
print @m.xm1.m0[gm]
print @m.xm1.m0[gds]
print @m.xm1.m0[vgs]
print @m.xm1.m0[vds]

print @m.xm2.m0[id]
print @m.xm2.m0[gm]
print @m.xm2.m0[gds]
print @m.xm2.m0[vgs]
print @m.xm2.m0[vds]

let gmro_xm1 = @m.xm1.m0[gm] / @m.xm1.m0[gds]
let gmro_xm2 = @m.xm2.m0[gm] / @m.xm2.m0[gds]

print gmro_xm1
print gmro_xm2

echo
echo ============================================================
echo RUNNING S-PARAMETER SWEEP
echo ============================================================

sp dec 501 10Meg 10G

let s11_db = db(sp1.s_1_1)
let s21_db = db(sp1.s_2_1)
let s12_db = db(sp1.s_1_2)
let s22_db = db(sp1.s_2_2)

let s11_mag = mag(sp1.s_1_1)
let s21_mag = mag(sp1.s_2_1)
let s22_mag = mag(sp1.s_2_2)

let s11_phase = 180/pi * ph(sp1.s_1_1)
let s21_phase = 180/pi * ph(sp1.s_2_1)
let s22_phase = 180/pi * ph(sp1.s_2_2)

let z0 = 50

let zin = z0 * (1 + sp1.s_1_1) / (1 - sp1.s_1_1)
let zin_re = real(zin)
let zin_im = imag(zin)
let zin_mag = mag(zin)

let zout = z0 * (1 + sp1.s_2_2) / (1 - sp1.s_2_2)
let zout_re = real(zout)
let zout_im = imag(zout)
let zout_mag = mag(zout)

echo
echo ============================================================
echo EXACT RESULTS AT 2.4 GHz
echo ============================================================

meas sp s11_2p4g find s11_db at=2.4G
meas sp s21_2p4g find s21_db at=2.4G
meas sp s12_2p4g find s12_db at=2.4G
meas sp s22_2p4g find s22_db at=2.4G

meas sp s11_mag_2p4g find s11_mag at=2.4G
meas sp s21_mag_2p4g find s21_mag at=2.4G
meas sp s22_mag_2p4g find s22_mag at=2.4G

meas sp zin_re_2p4g find zin_re at=2.4G
meas sp zin_im_2p4g find zin_im at=2.4G
meas sp zin_mag_2p4g find zin_mag at=2.4G

meas sp zout_re_2p4g find zout_re at=2.4G
meas sp zout_im_2p4g find zout_im at=2.4G
meas sp zout_mag_2p4g find zout_mag at=2.4G

echo
echo ============================================================
echo GAIN PEAK SEARCH
echo ============================================================

meas sp s21_peak_100m_6g max s21_db from=100Meg to=6G
meas sp s21_peak_freq_100m_6g when s21_db=s21_peak_100m_6g from=100Meg to=6G

meas sp s21_peak_1g_4g max s21_db from=1G to=4G
meas sp s21_peak_freq_1g_4g when s21_db=s21_peak_1g_4g from=1G to=4G

meas sp s11_min_1g_4g min s11_db from=1G to=4G
meas sp s22_min_1g_4g min s22_db from=1G to=4G

echo
echo ============================================================
echo PLOTS
echo ============================================================

plot s21_db title '3.3V CG LNA - S21 Gain'
plot s11_db s22_db title '3.3V CG LNA - S11 and S22'
plot zin_re zin_im title '3.3V CG LNA - Input Impedance'
plot zout_re zout_im title '3.3V CG LNA - Output Impedance'

echo
echo ============================================================
echo WRITING CSV FILE
echo ============================================================

wrdata lna_3v3_gain_diagnostic.csv frequency s11_db s21_db s12_db s22_db s11_mag s21_mag s22_mag s11_phase s21_phase s22_phase zin_re zin_im zin_mag zout_re zout_im zout_mag

echo
echo ============================================================
echo GAIN DIAGNOSTIC COMPLETE
echo Wrote file:
echo lna_3v3_gain_diagnostic.csv
echo ============================================================

.endc
"
spice_ignore=false}
C {ind.sym} 130 -190 1 0 {name=L9
m=1
value=1n
footprint=1206
device=inductor}
C {ind.sym} 820 -250 1 0 {name=L10
m=1
value=5n
footprint=1206
device=inductor}
