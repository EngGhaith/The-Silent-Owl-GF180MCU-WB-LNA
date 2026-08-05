v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -310 -480 -310 -450 {
lab=GND}
N -310 -450 -310 -350 {
lab=GND}
N -310 -790 -310 -760 {
lab=vdd}
N -310 -400 -260 -400 {
lab=GND}
N -200 -400 -170 -400 {
lab=Vinn}
N -200 -560 -170 -560 {
lab=Vinp}
N -310 -580 -310 -480 {
lab=GND}
N -310 -700 -310 -580 {
lab=GND}
N -430 -720 -430 -690 {
lab=vss}
N -430 -630 -430 -600 {
lab=GND}
N -430 -600 -310 -600 {
lab=GND}
N -310 -560 -260 -560 {
lab=GND}
N -680 -600 -430 -600 {
lab=GND}
N -220 -660 -190 -660 {
lab=vcm_ref}
N -310 -660 -280 -660 {
lab=GND}
N -390 -510 -390 -480 {
lab=vb1}
N -390 -600 -390 -570 {
lab=GND}
N -500 -510 -500 -480 {
lab=vb2}
N -500 -600 -500 -570 {
lab=GND}
N -600 -510 -600 -480 {
lab=vb3}
N -600 -600 -600 -570 {
lab=GND}
N -680 -510 -680 -480 {
lab=vb4}
N -680 -600 -680 -570 {
lab=GND}
N -680 -720 -680 -690 {
lab=vcm_ref_folded}
N -680 -630 -680 -600 {
lab=GND}
N -560 -280 -530 -280 {
lab=Vbias_cmfb}
N -470 -280 -440 -280 {
lab=GND}
N -440 -370 -310 -370 {
lab=GND}
N -440 -370 -440 -280 {
lab=GND}
N -440 -190 -440 -160 {
lab=vbias_cmfb_fld}
N -440 -280 -440 -250 {
lab=GND}
N 610 -500 610 -460 {
lab=GND}
N 610 -580 610 -560 {
lab=Voutp}
N 550 -580 610 -580 {
lab=Voutp}
N 750 -500 750 -460 {
lab=GND}
N 750 -580 750 -560 {
lab=Voutn}
N 690 -580 750 -580 {
lab=Voutn}
N 360 -990 360 -960 {
lab=vdd}
N 360 -720 360 -690 {
lab=vss}
N 510 -800 540 -800 {
lab=Voutp}
N 510 -880 540 -880 {
lab=#net1}
N 180 -930 210 -930 {
lab=vb4}
N 180 -910 210 -910 {
lab=vb3}
N 180 -890 210 -890 {
lab=vb2}
N 180 -870 210 -870 {
lab=vb1}
N 180 -850 210 -850 {
lab=vcm_ref}
N 180 -830 210 -830 {
lab=Vinn}
N 180 -810 210 -810 {
lab=vcm_ref_folded}
N 180 -790 210 -790 {
lab=Vinp}
N 180 -770 210 -770 {
lab=Vbias_cmfb}
N 180 -750 210 -750 {
lab=vbias_cmfb_fld}
C {vsource.sym} -230 -400 1 0 {name=V_VIN value="dc \{VCM - VDIFF/2\} ac 0.5 180" savecurrent=false}
C {vsource.sym} -310 -730 0 0 {name=VDD_SRC value="dc \{VDD\}" savecurrent=false}
C {gnd.sym} -310 -350 0 0 {name=l3 lab=GND}
C {lab_pin.sym} -310 -790 0 0 {name=p16 sig_type=std_logic lab=vdd

}
C {lab_pin.sym} -170 -400 2 0 {name=p21 sig_type=std_logic lab=Vinn}
C {vsource.sym} -230 -560 1 0 {name=V_VINP value="dc \{VCM + VDIFF/2\} ac 0.5" savecurrent=false}
C {lab_pin.sym} -170 -560 2 0 {name=p33 sig_type=std_logic lab=Vinp}
C {vsource.sym} -430 -660 0 0 {name=V_VSS value="dc 0" savecurrent=false}
C {lab_pin.sym} -430 -720 0 0 {name=p34 sig_type=std_logic lab=vss

}
C {vsource.sym} -250 -660 1 0 {name=V_VCMFB value="dc \{VCM\}" savecurrent=false}
C {lab_pin.sym} -190 -660 1 0 {name=V_VCM sig_type=std_logic lab=vcm_ref

}
C {vsource.sym} -390 -540 2 0 {name=V_B1 value="dc \{VB1\}" savecurrent=false}
C {lab_pin.sym} -390 -480 2 0 {name=V_VCM3 sig_type=std_logic lab=vb1

}
C {vsource.sym} -500 -540 2 0 {name=V_B2 value="dc \{VB2\}" savecurrent=false}
C {lab_pin.sym} -500 -480 2 0 {name=V_VCM5 sig_type=std_logic lab=vb2

}
C {vsource.sym} -600 -540 2 0 {name=V_B3 value="dc \{VB3\}" savecurrent=false}
C {lab_pin.sym} -600 -480 2 0 {name=V_VCM7 sig_type=std_logic lab=vb3

}
C {vsource.sym} -680 -540 2 0 {name=V_B4 value="dc \{VB4\}" savecurrent=false}
C {lab_pin.sym} -680 -480 2 0 {name=V_VCM9 sig_type=std_logic lab=vb4

}
C {vsource.sym} -680 -660 0 0 {name=V_VCM_FOLDED value="dc \{VCM_FOLDED\}" savecurrent=false}
C {lab_pin.sym} -680 -720 0 0 {name=V_VCM11 sig_type=std_logic lab=vcm_ref_folded

}
C {vsource.sym} -500 -280 3 0 {name=V_VBIAS value=\{VBIAS_CMFB\} savecurrent=false}
C {lab_pin.sym} -560 -280 0 0 {name=p49 sig_type=std_logic lab=Vbias_cmfb}
C {vsource.sym} -440 -220 2 0 {name=V_VBIAS1 value="dc \{VBIAS_CMFB_FLD\}" savecurrent=false}
C {lab_pin.sym} -440 -160 3 0 {name=p64 sig_type=std_logic lab=vbias_cmfb_fld}
C {code_shown.sym} -1000 -1125 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice

.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice cap_mim
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical

.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"}
C {code.sym} -130 -1100 0 0 {name=s1
only_toplevel=true
value="

**** begin user architecture code

.param sw_stat_mismatch=0
.param mis_vth=0
.param mis_k=0

.param VDD=3.3
.param VCM=1.65
.param VCM_FOLDED=1.60
.param VDIFF=0

* ============================================================
* Final selected OTA bias
* ============================================================
.param VB1=0.58
.param VB2=2.637
.param VB3=2.25
.param VB4=1.15

.param VBIAS_CMFB=0.82
.param VBIAS_CMFB_FLD=2.55

* ============================================================
* Compensation / load
* ============================================================
.param Cn=500f
.param Rn=8k
.param COUT_LOAD=200f

* Output CMFB sense resistors
.param Rcm=1Meg

* Folded-node CMFB sense resistors
.param Rcm_fld=20Meg

.param CCMFB=500f
.param CCMFB_FLD=1p

.options reltol=1e-4 abstol=1e-12 vntol=1e-6
.options gmin=1e-12
.options plotwinsize=0
.options method=gear maxord=2

* ============================================================
* Operating-point hints only. These do not force final OP.
* ============================================================
.nodeset V(voutp)=1.643
.nodeset V(voutn)=1.643
.nodeset V(vcm_sense)=1.643
.nodeset V(vbias_out)=0.866
.nodeset V(vx)=3.022
.nodeset V(vy)=3.022
.nodeset V(va)=2.401
.nodeset V(vb)=2.401
.nodeset V(net1)=0.887
.nodeset V(net4)=0.426
.nodeset V(net5)=0.426
.nodeset V(vcm_sense_folded)=1.600
.nodeset V(vb5)=0.713
.nodeset V(net8)=0.578
.nodeset V(net9)=2.624

.control

set noaskquit
set wr_singlescale
set appendwrite
set measdgt=8

shell rm -f ota_summary_report.txt
shell rm -f ota_detailed_report.txt
shell rm -f ota_ac_response.txt

echo ================================================== > ota_summary_report.txt
echo FINAL FULLY-DIFFERENTIAL OTA SUMMARY REPORT >> ota_summary_report.txt
echo PMOS-INPUT FOLDED-CMFB VERSION >> ota_summary_report.txt
echo ================================================== >> ota_summary_report.txt

echo ================================================== > ota_detailed_report.txt
echo FINAL FULLY-DIFFERENTIAL OTA DETAILED REPORT >> ota_detailed_report.txt
echo PMOS-INPUT FOLDED-CMFB VERSION >> ota_detailed_report.txt
echo ================================================== >> ota_detailed_report.txt

echo ---------------- PARAMETERS ---------------- >> ota_summary_report.txt
echo VDD=3.3 VCM=1.65 VDIFF=0 VCM_FOLDED=1.60 >> ota_summary_report.txt
echo VB1=0.58 VB2=2.637 VB3=2.25 VB4=1.15 >> ota_summary_report.txt
echo VBIAS_CMFB=0.82 VBIAS_CMFB_FLD=2.55 >> ota_summary_report.txt
echo Cn=500f Rn=8k COUT_LOAD=200f Rcm=1Meg Rcm_fld=20Meg CCMFB=500f CCMFB_FLD=1p >> ota_summary_report.txt
echo -------------------------------------------------- >> ota_summary_report.txt

echo ---------------- PARAMETERS ---------------- >> ota_detailed_report.txt
echo VDD=3.3 VCM=1.65 VDIFF=0 >> ota_detailed_report.txt
echo VCM_FOLDED=1.60 >> ota_detailed_report.txt
echo VB1=0.58 VB2=2.637 VB3=2.25 VB4=1.15 >> ota_detailed_report.txt
echo VBIAS_CMFB=0.82 VBIAS_CMFB_FLD=2.55 >> ota_detailed_report.txt
echo Cn=500f Rn=8k COUT_LOAD=200f >> ota_detailed_report.txt
echo Rcm=1Meg Rcm_fld=20Meg CCMFB=500f CCMFB_FLD=1p >> ota_detailed_report.txt
echo -------------------------------------------------- >> ota_detailed_report.txt

* ============================================================
* DC OPERATING POINT
* ============================================================
op

* Numeric constants for ngspice control expressions.
* Do not use .param names directly inside let expressions.
let vdd_num         = 3.3
let vcm_num         = 1.65

let voutcm_op       = 0.5*(v(voutp)+v(voutn))
let voutdiff_op     = v(voutp)-v(voutn)
let va_cm_op        = 0.5*(v(va)+v(vb))
let vx_cm_op        = 0.5*(v(vx)+v(vy))
let net45_cm_op     = 0.5*(v(net4)+v(net5))

let idd_op          = -i(VDD_SRC)
let pdc_op          = vdd_num*idd_op

let folded_cm_err   = v(vcm_sense_folded)-v(vcm_ref_folded)
let out_cm_err      = voutcm_op-vcm_num

echo ---------------- OP SUMMARY ---------------- >> ota_summary_report.txt
echo VOUTP VOUTN VOUTCM VOUTDIFF OUT_CM_ERR >> ota_summary_report.txt
echo $&v(voutp) $&v(voutn) $&voutcm_op $&voutdiff_op $&out_cm_err >> ota_summary_report.txt
echo VA VB VA_CM VCM_SENSE_FOLDED VCM_REF_FOLDED FOLDED_CM_ERR >> ota_summary_report.txt
echo $&v(va) $&v(vb) $&va_cm_op $&v(vcm_sense_folded) $&v(vcm_ref_folded) $&folded_cm_err >> ota_summary_report.txt
echo VBIAS_OUT VB5 NET8 NET9 IDD PDC >> ota_summary_report.txt
echo $&v(vbias_out) $&v(vb5) $&v(net8) $&v(net9) $&idd_op $&pdc_op >> ota_summary_report.txt
echo -------------------------------------------------- >> ota_summary_report.txt

echo ---------------- OP DETAILED NODES ---------------- >> ota_detailed_report.txt
echo VOUTP=$&v(voutp) >> ota_detailed_report.txt
echo VOUTN=$&v(voutn) >> ota_detailed_report.txt
echo VOUTCM=$&voutcm_op >> ota_detailed_report.txt
echo VOUTDIFF=$&voutdiff_op >> ota_detailed_report.txt
echo OUT_CM_ERR=$&out_cm_err >> ota_detailed_report.txt
echo VCM_SENSE_OUTPUT=$&v(vcm_sense) >> ota_detailed_report.txt
echo VBIAS_OUT=$&v(vbias_out) >> ota_detailed_report.txt
echo VX=$&v(vx) >> ota_detailed_report.txt
echo VY=$&v(vy) >> ota_detailed_report.txt
echo VX_CM=$&vx_cm_op >> ota_detailed_report.txt
echo VA=$&v(va) >> ota_detailed_report.txt
echo VB=$&v(vb) >> ota_detailed_report.txt
echo VA_CM=$&va_cm_op >> ota_detailed_report.txt
echo NET1=$&v(net1) >> ota_detailed_report.txt
echo NET4=$&v(net4) >> ota_detailed_report.txt
echo NET5=$&v(net5) >> ota_detailed_report.txt
echo NET4_NET5_CM=$&net45_cm_op >> ota_detailed_report.txt
echo VCM_REF_FOLDED=$&v(vcm_ref_folded) >> ota_detailed_report.txt
echo VCM_SENSE_FOLDED=$&v(vcm_sense_folded) >> ota_detailed_report.txt
echo FOLDED_CM_ERR=$&folded_cm_err >> ota_detailed_report.txt
echo VB5=$&v(vb5) >> ota_detailed_report.txt
echo NET8=$&v(net8) >> ota_detailed_report.txt
echo NET9=$&v(net9) >> ota_detailed_report.txt
echo IDD=$&idd_op >> ota_detailed_report.txt
echo PDC=$&pdc_op >> ota_detailed_report.txt
echo -------------------------------------------------- >> ota_detailed_report.txt

print v(voutp) v(voutn) voutcm_op voutdiff_op out_cm_err
print v(vcm_sense) v(vbias_out)
print v(vx) v(vy) vx_cm_op
print v(va) v(vb) va_cm_op
print v(net1) v(net4) v(net5) net45_cm_op
print v(vcm_ref_folded) v(vcm_sense_folded) folded_cm_err
print v(vb5) v(net8) v(net9)
print idd_op pdc_op

* ============================================================
* DIFFERENTIAL AC ANALYSIS
* Existing sources should be:
*   Vinp: dc \{VCM + VDIFF/2\} ac 0.5
*   Vinn: dc \{VCM - VDIFF/2\} ac 0.5 180
* This gives vin_diff = 1 V.
* ============================================================
ac dec 200 1 1G

let vin_diff       = v(vinp)-v(vinn)
let vin_cm         = 0.5*(v(vinp)+v(vinn))
let vin_diff_mag   = mag(vin_diff)
let vin_cm_mag     = mag(vin_cm)

let vout_diff      = v(voutp)-v(voutn)
let vout_cm_ac     = 0.5*(v(voutp)+v(voutn))

let avd            = vout_diff/vin_diff
let avd_mag        = mag(avd)
let avd_db         = 20*log10(avd_mag+1e-30)

* In this ngspice setup, cph() is returning radians.
let avd_phase_rad  = cph(avd)
let avd_phase_deg  = 57.2957795*avd_phase_rad

let gain_voutp     = v(voutp)/vin_diff
let gain_voutn     = v(voutn)/vin_diff
let gain_cmout     = vout_cm_ac/vin_diff

let gain_vxvy      = (v(vx)-v(vy))/vin_diff
let gain_vavb      = (v(va)-v(vb))/vin_diff
let gain_stage2    = avd/(gain_vavb+1e-30)

let gain_voutp_db  = 20*log10(mag(gain_voutp)+1e-30)
let gain_voutn_db  = 20*log10(mag(gain_voutn)+1e-30)
let gain_cmout_db  = 20*log10(mag(gain_cmout)+1e-30)

let gain_vxvy_db   = 20*log10(mag(gain_vxvy)+1e-30)
let gain_vavb_db   = 20*log10(mag(gain_vavb)+1e-30)
let gain_stage2_db = 20*log10(mag(gain_stage2)+1e-30)

let gain_vx_db     = 20*log10(mag(v(vx)/vin_diff)+1e-30)
let gain_vy_db     = 20*log10(mag(v(vy)/vin_diff)+1e-30)
let gain_va_db     = 20*log10(mag(v(va)/vin_diff)+1e-30)
let gain_vb_db     = 20*log10(mag(v(vb)/vin_diff)+1e-30)
let gain_net4_db   = 20*log10(mag(v(net4)/vin_diff)+1e-30)
let gain_net5_db   = 20*log10(mag(v(net5)/vin_diff)+1e-30)

* ============================================================
* 1 Hz low-frequency measurements
* ============================================================
meas ac VIN_DIFF_1HZ          find vin_diff_mag   at=1
meas ac VIN_CM_1HZ            find vin_cm_mag     at=1

meas ac AVD_MAG_1HZ           find avd_mag        at=1
meas ac AVD_DB_1HZ            find avd_db         at=1
meas ac AVD_PHASE_1HZ_RAD     find avd_phase_rad  at=1
meas ac AVD_PHASE_1HZ_DEG     find avd_phase_deg  at=1

meas ac GAIN_VOUTP_DB_1HZ     find gain_voutp_db  at=1
meas ac GAIN_VOUTN_DB_1HZ     find gain_voutn_db  at=1
meas ac GAIN_CMOUT_DB_1HZ     find gain_cmout_db  at=1

meas ac GAIN_VX_DB_1HZ        find gain_vx_db     at=1
meas ac GAIN_VY_DB_1HZ        find gain_vy_db     at=1
meas ac GAIN_VA_DB_1HZ        find gain_va_db     at=1
meas ac GAIN_VB_DB_1HZ        find gain_vb_db     at=1
meas ac GAIN_NET4_DB_1HZ      find gain_net4_db   at=1
meas ac GAIN_NET5_DB_1HZ      find gain_net5_db   at=1

meas ac GAIN_VXVY_DB_1HZ      find gain_vxvy_db   at=1
meas ac GAIN_VAVB_DB_1HZ      find gain_vavb_db   at=1
meas ac GAIN_STAGE2_DB_1HZ    find gain_stage2_db at=1

* ============================================================
* Dominant pole, UGF, and phase margin
* ============================================================
let avd_3db_target = avd_db_1hz - 3
meas ac FP_DOM when avd_db=avd_3db_target fall=1

meas ac UGF when avd_db=0 fall=1
meas ac PHASE_AT_UGF_RAD find avd_phase_rad when avd_db=0 fall=1
meas ac PHASE_AT_UGF_DEG find avd_phase_deg when avd_db=0 fall=1

let PM_EST = 180 + phase_at_ugf_deg

* ============================================================
* Useful spot checks
* ============================================================
meas ac AVD_DB_10K         find avd_db        at=10k
meas ac AVD_DB_100K        find avd_db        at=100k
meas ac AVD_DB_1MEG        find avd_db        at=1Meg
meas ac AVD_DB_10MEG       find avd_db        at=10Meg
meas ac AVD_DB_100MEG      find avd_db        at=100Meg

meas ac PHASE_10K_RAD      find avd_phase_rad at=10k
meas ac PHASE_100K_RAD     find avd_phase_rad at=100k
meas ac PHASE_1MEG_RAD     find avd_phase_rad at=1Meg
meas ac PHASE_10MEG_RAD    find avd_phase_rad at=10Meg
meas ac PHASE_100MEG_RAD   find avd_phase_rad at=100Meg

meas ac PHASE_10K_DEG      find avd_phase_deg at=10k
meas ac PHASE_100K_DEG     find avd_phase_deg at=100k
meas ac PHASE_1MEG_DEG     find avd_phase_deg at=1Meg
meas ac PHASE_10MEG_DEG    find avd_phase_deg at=10Meg
meas ac PHASE_100MEG_DEG   find avd_phase_deg at=100Meg

* ============================================================
* WRITE SUMMARY REPORT
* ============================================================
echo ---------------- AC SUMMARY ---------------- >> ota_summary_report.txt
echo VIN_DIFF_1HZ=$&vin_diff_1hz >> ota_summary_report.txt
echo VIN_CM_1HZ=$&vin_cm_1hz >> ota_summary_report.txt
echo DC_DIFF_GAIN_LINEAR=$&avd_mag_1hz >> ota_summary_report.txt
echo DC_DIFF_GAIN_DB=$&avd_db_1hz >> ota_summary_report.txt
echo DC_PHASE_1HZ_RAD=$&avd_phase_1hz_rad >> ota_summary_report.txt
echo DC_PHASE_1HZ_DEG=$&avd_phase_1hz_deg >> ota_summary_report.txt
echo STAGE1_GAIN_VAVB_DB=$&gain_vavb_db_1hz >> ota_summary_report.txt
echo STAGE2_GAIN_EST_DB=$&gain_stage2_db_1hz >> ota_summary_report.txt
echo DOMINANT_POLE_HZ=$&fp_dom >> ota_summary_report.txt
echo UNITY_GAIN_FREQ_HZ=$&ugf >> ota_summary_report.txt
echo PHASE_AT_UGF_RAD=$&phase_at_ugf_rad >> ota_summary_report.txt
echo PHASE_AT_UGF_DEG=$&phase_at_ugf_deg >> ota_summary_report.txt
echo PHASE_MARGIN_EST_DEG=$&PM_EST >> ota_summary_report.txt
echo -------------------------------------------------- >> ota_summary_report.txt

echo ---------------- PASS TARGETS TO CHECK ---------------- >> ota_summary_report.txt
echo Output CM target: VOUTCM should be near 1.65 V >> ota_summary_report.txt
echo Folded CMFB target: vcm_sense_folded should be near VCM_FOLDED >> ota_summary_report.txt
echo IDD target for this revision: roughly 100 uA to 300 uA is reasonable >> ota_summary_report.txt
echo Gain target: AVD should be greater than 70 dB before layout >> ota_summary_report.txt
echo Phase-margin target: PM_EST should be greater than 60 deg >> ota_summary_report.txt
echo Note: In this run cph is treated as radians and converted to degrees. >> ota_summary_report.txt
echo ================================================== >> ota_summary_report.txt

* ============================================================
* WRITE DETAILED REPORT
* ============================================================
echo ---------------- AC DETAILED LOW-FREQUENCY GAINS ---------------- >> ota_detailed_report.txt
echo VIN_DIFF_1HZ=$&vin_diff_1hz >> ota_detailed_report.txt
echo VIN_CM_1HZ=$&vin_cm_1hz >> ota_detailed_report.txt
echo AVD_MAG_1HZ=$&avd_mag_1hz >> ota_detailed_report.txt
echo AVD_DB_1HZ=$&avd_db_1hz >> ota_detailed_report.txt
echo AVD_PHASE_1HZ_RAD=$&avd_phase_1hz_rad >> ota_detailed_report.txt
echo AVD_PHASE_1HZ_DEG=$&avd_phase_1hz_deg >> ota_detailed_report.txt
echo GAIN_VOUTP_DB_1HZ=$&gain_voutp_db_1hz >> ota_detailed_report.txt
echo GAIN_VOUTN_DB_1HZ=$&gain_voutn_db_1hz >> ota_detailed_report.txt
echo GAIN_CMOUT_DB_1HZ=$&gain_cmout_db_1hz >> ota_detailed_report.txt
echo GAIN_VX_DB_1HZ=$&gain_vx_db_1hz >> ota_detailed_report.txt
echo GAIN_VY_DB_1HZ=$&gain_vy_db_1hz >> ota_detailed_report.txt
echo GAIN_VA_DB_1HZ=$&gain_va_db_1hz >> ota_detailed_report.txt
echo GAIN_VB_DB_1HZ=$&gain_vb_db_1hz >> ota_detailed_report.txt
echo GAIN_NET4_DB_1HZ=$&gain_net4_db_1hz >> ota_detailed_report.txt
echo GAIN_NET5_DB_1HZ=$&gain_net5_db_1hz >> ota_detailed_report.txt
echo GAIN_VXVY_DB_1HZ=$&gain_vxvy_db_1hz >> ota_detailed_report.txt
echo GAIN_VAVB_DB_1HZ=$&gain_vavb_db_1hz >> ota_detailed_report.txt
echo GAIN_STAGE2_DB_1HZ=$&gain_stage2_db_1hz >> ota_detailed_report.txt
echo -------------------------------------------------- >> ota_detailed_report.txt

echo ---------------- AC BANDWIDTH AND PHASE ---------------- >> ota_detailed_report.txt
echo AVD_3DB_TARGET=$&avd_3db_target >> ota_detailed_report.txt
echo FP_DOM_HZ=$&fp_dom >> ota_detailed_report.txt
echo UGF_HZ=$&ugf >> ota_detailed_report.txt
echo PHASE_AT_UGF_RAD=$&phase_at_ugf_rad >> ota_detailed_report.txt
echo PHASE_AT_UGF_DEG=$&phase_at_ugf_deg >> ota_detailed_report.txt
echo PHASE_MARGIN_EST_DEG=$&PM_EST >> ota_detailed_report.txt
echo AVD_DB_10K=$&avd_db_10k PHASE_10K_RAD=$&phase_10k_rad PHASE_10K_DEG=$&phase_10k_deg >> ota_detailed_report.txt
echo AVD_DB_100K=$&avd_db_100k PHASE_100K_RAD=$&phase_100k_rad PHASE_100K_DEG=$&phase_100k_deg >> ota_detailed_report.txt
echo AVD_DB_1MEG=$&avd_db_1meg PHASE_1MEG_RAD=$&phase_1meg_rad PHASE_1MEG_DEG=$&phase_1meg_deg >> ota_detailed_report.txt
echo AVD_DB_10MEG=$&avd_db_10meg PHASE_10MEG_RAD=$&phase_10meg_rad PHASE_10MEG_DEG=$&phase_10meg_deg >> ota_detailed_report.txt
echo AVD_DB_100MEG=$&avd_db_100meg PHASE_100MEG_RAD=$&phase_100meg_rad PHASE_100MEG_DEG=$&phase_100meg_deg >> ota_detailed_report.txt
echo -------------------------------------------------- >> ota_detailed_report.txt

echo ---------------- INTERPRETATION NOTES ---------------- >> ota_detailed_report.txt
echo 1. If FOLDED_CM_ERR is near 0, the folded PMOS-CMFB is regulating. >> ota_detailed_report.txt
echo 2. If VBIAS_OUT is around 0.6 to 1.0 V, the output CMFB is in a reasonable range. >> ota_detailed_report.txt
echo 3. If VA_CM is around 2.3 to 2.45 V, the second-stage PMOS gates are no longer over-driven. >> ota_detailed_report.txt
echo 4. If IDD is around hundreds of uA, the previous mA shoot-through state is fixed. >> ota_detailed_report.txt
echo 5. If STAGE1_GAIN_VAVB_DB is much greater than 30 dB, folded-node loading is no longer dominating. >> ota_detailed_report.txt
echo 6. PM_EST is calculated using phase converted from radians to degrees. >> ota_detailed_report.txt
echo 7. This is still pre-layout. Recheck after PEX and corners. >> ota_detailed_report.txt
echo ================================================== >> ota_detailed_report.txt

* ============================================================
* SAVE FULL AC TABLE
* Columns:
* frequency, avd_db, avd_phase_deg, gain_vavb_db,
* gain_stage2_db, gain_cmout_db, gain_voutp_db, gain_voutn_db
* ============================================================
wrdata ota_ac_response.txt avd_db avd_phase_deg gain_vavb_db gain_stage2_db gain_cmout_db gain_voutp_db gain_voutn_db

* ============================================================
* PRINT IMPORTANT VALUES TO TERMINAL
* ============================================================
print avd_mag_1hz avd_db_1hz gain_vavb_db_1hz gain_stage2_db_1hz
print fp_dom ugf phase_at_ugf_rad phase_at_ugf_deg PM_EST
print avd_db_10k avd_db_100k avd_db_1meg avd_db_10meg avd_db_100meg
print phase_10k_deg phase_100k_deg phase_1meg_deg phase_10meg_deg phase_100meg_deg

echo ==================================================
echo Done.
echo Generated:
echo   ota_summary_report.txt
echo   ota_detailed_report.txt
echo   ota_ac_response.txt
echo ==================================================

.endc

**** end user architecture code

"
}
C {capa.sym} 610 -530 0 0 {name=COUT
m=1
value=\{COUT_LOAD\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 610 -460 3 0 {name=p38 sig_type=std_logic lab=GND}
C {capa.sym} 750 -530 0 0 {name=COUT1
m=1
value=\{COUT_LOAD\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 750 -460 3 0 {name=p39 sig_type=std_logic lab=GND}
C {lab_pin.sym} 550 -580 0 0 {name=p40 sig_type=std_logic lab=Voutp}
C {lab_pin.sym} 690 -580 0 0 {name=p41 sig_type=std_logic lab=Voutn}
C {/media/sf_LNA_chipathon/sar_adc_gf180/xschem/op-amp_diff.sym} 360 -840 0 0 {name=x1}
C {lab_pin.sym} 360 -990 0 0 {name=p1 sig_type=std_logic lab=vdd

}
C {lab_pin.sym} 360 -690 0 0 {name=p2 sig_type=std_logic lab=vss

}
C {lab_pin.sym} 180 -850 0 0 {name=V_VCM1 sig_type=std_logic lab=vcm_ref

}
C {lab_pin.sym} 180 -790 0 0 {name=p3 sig_type=std_logic lab=Vinp}
C {lab_pin.sym} 180 -830 0 0 {name=p4 sig_type=std_logic lab=Vinn}
C {lab_pin.sym} 180 -870 0 0 {name=V_VCM2 sig_type=std_logic lab=vb1

}
C {lab_pin.sym} 180 -890 0 0 {name=V_VCM4 sig_type=std_logic lab=vb2

}
C {lab_pin.sym} 180 -910 0 0 {name=V_VCM6 sig_type=std_logic lab=vb3

}
C {lab_pin.sym} 180 -930 0 0 {name=V_VCM8 sig_type=std_logic lab=vb4

}
C {lab_pin.sym} 180 -770 0 0 {name=p5 sig_type=std_logic lab=Vbias_cmfb}
C {lab_pin.sym} 180 -750 0 0 {name=p6 sig_type=std_logic lab=vbias_cmfb_fld}
C {lab_pin.sym} 180 -810 0 0 {name=V_VCM10 sig_type=std_logic lab=vcm_ref_folded

}
C {lab_pin.sym} 540 -800 2 0 {name=p7 sig_type=std_logic lab=Voutp}
C {lab_pin.sym} 540 -880 2 0 {name=p8 sig_type=std_logic lab=Voutn}
