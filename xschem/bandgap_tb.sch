v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 550 -410 580 -410 {lab=v_dd}
N 480 -410 550 -410 {lab=v_dd}
N 480 -410 480 -390 {lab=v_dd}
N 580 -340 580 -320 {lab=GND}
N 480 -320 580 -320 {lab=GND}
N 480 -330 480 -320 {lab=GND}
N 480 -320 480 -300 {lab=GND}
N 880 -370 910 -370 {lab=vref}
N 570 -230 570 -200 {
lab=vref}
N 570 -140 570 -100 {
lab=GND}
N 670 -230 670 -200 {
lab=vref}
N 670 -140 670 -100 {
lab=GND}
N 570 -100 670 -100 {
lab=GND}
C {devices/code_shown.sym} 70 -570 0 0 {name=NGSPICE only_toplevel=true 
value="
*.option klu
.option method=gear
.option reltol=1e-5
.option abstol=1e-12
.option vabstol=1e-6
.option gmin=1e-12
.option maxord=2

.temp 27



"
}
C {devices/gnd.sym} 480 -300 0 0 {name=l3 lab=GND}
C {devices/vsource.sym} 480 -360 0 0 {name=Vdd value=5}
C {devices/lab_pin.sym} 520 -410 1 0 {name=p2 sig_type=std_logic lab=v_dd}
C {devices/lab_wire.sym} 910 -370 2 0 {name=p1 sig_type=std_logic lab=vref}
C {code.sym} 1050 -530 0 0 {name=s2 only_toplevel=false value="

.control

* ============================================================
* GF180MCU Bandgap Dedicated Line Regulation Test
* Robust ngspice-42 version
*
* Testbench assumptions:
*   Vdd   v_dd GND 5
*   ILOAD vref GND 0
*   x1    v_dd vref GND bandgap
*
* Output files:
*   bandgap_line_reg_detailed_report.txt
*   bandgap_line_reg_sweep_3p0_5p5.txt
*   bandgap_line_reg_sweep_4p5_5p5.txt
*   bandgap_line_reg.raw
* ============================================================

set noaskquit
set filetype=ascii
set numdgt=10
set wr_singlescale
set wr_vecnames

save all

* ============================================================
* Create report
* ============================================================

echo GF180MCU_BANDGAP_DEDICATED_LINE_REGULATION_REPORT > bandgap_line_reg_detailed_report.txt
echo ============================================================ >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

echo TEST_DESCRIPTION >> bandgap_line_reg_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_line_reg_detailed_report.txt
echo This report measures DC bandgap line regulation with zero load current. >> bandgap_line_reg_detailed_report.txt
echo It avoids persistent ngspice plots and writes all results directly. >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

echo DEVICE_SIZE_NOTE >> bandgap_line_reg_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_line_reg_detailed_report.txt
echo Main PMOS mirror devices should match the current schematic. >> bandgap_line_reg_detailed_report.txt
echo If using the updated schematic: pfet_05v0 L=2u W=100u nf=10. >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

* ============================================================
* 1. Nominal operating point at VDD=5 V
* ============================================================

alter Vdd = 5
alter ILOAD = 0
set temp = 27
op

let vref_nom = v(vref)
let vdd_nom = v(v_dd)
let idd_nom = -i(vdd)
let pdc_nom = v(v_dd)*idd_nom
let pdc_nom_uw = 1e6*pdc_nom

echo 1_NOMINAL_OP_27C_VDD_5V >> bandgap_line_reg_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_line_reg_detailed_report.txt
echo VDD_V $&vdd_nom >> bandgap_line_reg_detailed_report.txt
echo VREF_V $&vref_nom >> bandgap_line_reg_detailed_report.txt
echo IDD_A $&idd_nom >> bandgap_line_reg_detailed_report.txt
echo PDC_W $&pdc_nom >> bandgap_line_reg_detailed_report.txt
echo PDC_uW $&pdc_nom_uw >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

echo INTERNAL_NODES_AT_NOMINAL >> bandgap_line_reg_detailed_report.txt
echo X1_VG1_V $&v(x1.vg1) >> bandgap_line_reg_detailed_report.txt
echo X1_VG2_V $&v(x1.vg2) >> bandgap_line_reg_detailed_report.txt
echo X1_VG3_V $&v(x1.vg3) >> bandgap_line_reg_detailed_report.txt
echo X1_VG4_V $&v(x1.vg4) >> bandgap_line_reg_detailed_report.txt
echo X1_NET1_V $&v(x1.net1) >> bandgap_line_reg_detailed_report.txt
echo X1_NET2_V $&v(x1.net2) >> bandgap_line_reg_detailed_report.txt
echo X1_NET3_V $&v(x1.net3) >> bandgap_line_reg_detailed_report.txt
echo X1_NET4_V $&v(x1.net4) >> bandgap_line_reg_detailed_report.txt
echo X1_NET5_V $&v(x1.net5) >> bandgap_line_reg_detailed_report.txt
echo X1_NET6_V $&v(x1.net6) >> bandgap_line_reg_detailed_report.txt
echo X1_NET7_V $&v(x1.net7) >> bandgap_line_reg_detailed_report.txt
echo X1_NET8_V $&v(x1.net8) >> bandgap_line_reg_detailed_report.txt
echo X1_NET9_V $&v(x1.net9) >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

write bandgap_line_reg_op.raw

* ============================================================
* 2. Wide supply sweep: 3.0 V to 5.5 V
* ============================================================

alter ILOAD = 0
dc Vdd 3.0 5.5 0.01

let idd_line = -i(vdd)
let pdc_line = v(v_dd)*idd_line

meas dc vref_3p0 find v(vref) at=3.0
meas dc vref_3p3 find v(vref) at=3.3
meas dc vref_4p0 find v(vref) at=4.0
meas dc vref_4p5 find v(vref) at=4.5
meas dc vref_5p0 find v(vref) at=5.0
meas dc vref_5p5 find v(vref) at=5.5

meas dc vref_min_3p0_5p5 min v(vref) from=3.0 to=5.5
meas dc vref_max_3p0_5p5 max v(vref) from=3.0 to=5.5

let vref_span_3p0_5p5 = vref_max_3p0_5p5-vref_min_3p0_5p5
let line_reg_3p0_5p5_mv_per_v = 1000*vref_span_3p0_5p5/(5.5-3.0)
let line_reg_3p0_5p5_v_per_v = vref_span_3p0_5p5/(5.5-3.0)
let psrr_dc_3p0_5p5_db = 20*log10(1/line_reg_3p0_5p5_v_per_v)

let vref_delta_3p0_to_5p5 = vref_5p5-vref_3p0
let line_reg_endpoint_3p0_5p5_mv_per_v = 1000*vref_delta_3p0_to_5p5/(5.5-3.0)

echo 2_WIDE_LINE_REGULATION_3P0V_TO_5P5V >> bandgap_line_reg_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_3P0_V $&vref_3p0 >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_3P3_V $&vref_3p3 >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_4P0_V $&vref_4p0 >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_4P5_V $&vref_4p5 >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_5P0_V $&vref_5p0 >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_5P5_V $&vref_5p5 >> bandgap_line_reg_detailed_report.txt
echo VREF_MIN_3P0_5P5_V $&vref_min_3p0_5p5 >> bandgap_line_reg_detailed_report.txt
echo VREF_MAX_3P0_5P5_V $&vref_max_3p0_5p5 >> bandgap_line_reg_detailed_report.txt
echo VREF_SPAN_3P0_5P5_V $&vref_span_3p0_5p5 >> bandgap_line_reg_detailed_report.txt
echo LINE_REG_SPAN_3P0_5P5_MV_PER_V $&line_reg_3p0_5p5_mv_per_v >> bandgap_line_reg_detailed_report.txt
echo LINE_REG_ENDPOINT_3P0_5P5_MV_PER_V $&line_reg_endpoint_3p0_5p5_mv_per_v >> bandgap_line_reg_detailed_report.txt
echo EQUIV_DC_PSRR_3P0_5P5_DB $&psrr_dc_3p0_5p5_db >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

wrdata bandgap_line_reg_sweep_3p0_5p5.txt v(v_dd) v(vref) idd_line pdc_line
write bandgap_line_reg.raw

* ============================================================
* 3. Application supply sweep: 4.5 V to 5.5 V
* This is the more relevant 5 V-domain test.
* ============================================================

dc Vdd 4.5 5.5 0.005

let idd_line_5v = -i(vdd)
let pdc_line_5v = v(v_dd)*idd_line_5v

meas dc vref_4p5_app find v(vref) at=4.5
meas dc vref_4p75_app find v(vref) at=4.75
meas dc vref_5p0_app find v(vref) at=5.0
meas dc vref_5p25_app find v(vref) at=5.25
meas dc vref_5p5_app find v(vref) at=5.5

meas dc vref_min_4p5_5p5 min v(vref) from=4.5 to=5.5
meas dc vref_max_4p5_5p5 max v(vref) from=4.5 to=5.5

let vref_span_4p5_5p5 = vref_max_4p5_5p5-vref_min_4p5_5p5
let line_reg_4p5_5p5_mv_per_v = 1000*vref_span_4p5_5p5/(5.5-4.5)
let line_reg_4p5_5p5_v_per_v = vref_span_4p5_5p5/(5.5-4.5)
let psrr_dc_4p5_5p5_db = 20*log10(1/line_reg_4p5_5p5_v_per_v)

let vref_delta_4p5_to_5p5 = vref_5p5_app-vref_4p5_app
let line_reg_endpoint_4p5_5p5_mv_per_v = 1000*vref_delta_4p5_to_5p5/(5.5-4.5)

echo 3_APPLICATION_LINE_REGULATION_4P5V_TO_5P5V >> bandgap_line_reg_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_4P5_V $&vref_4p5_app >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_4P75_V $&vref_4p75_app >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_5P0_V $&vref_5p0_app >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_5P25_V $&vref_5p25_app >> bandgap_line_reg_detailed_report.txt
echo VREF_AT_5P5_V $&vref_5p5_app >> bandgap_line_reg_detailed_report.txt
echo VREF_MIN_4P5_5P5_V $&vref_min_4p5_5p5 >> bandgap_line_reg_detailed_report.txt
echo VREF_MAX_4P5_5P5_V $&vref_max_4p5_5p5 >> bandgap_line_reg_detailed_report.txt
echo VREF_SPAN_4P5_5P5_V $&vref_span_4p5_5p5 >> bandgap_line_reg_detailed_report.txt
echo LINE_REG_SPAN_4P5_5P5_MV_PER_V $&line_reg_4p5_5p5_mv_per_v >> bandgap_line_reg_detailed_report.txt
echo LINE_REG_ENDPOINT_4P5_5P5_MV_PER_V $&line_reg_endpoint_4p5_5p5_mv_per_v >> bandgap_line_reg_detailed_report.txt
echo EQUIV_DC_PSRR_4P5_5P5_DB $&psrr_dc_4p5_5p5_db >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

wrdata bandgap_line_reg_sweep_4p5_5p5.txt v(v_dd) v(vref) idd_line_5v pdc_line_5v

* ============================================================
* 4. Internal node sensitivity at selected VDD points
* Use OPs instead of trying to save internal nodes from dc plot.
* ============================================================

echo 4_INTERNAL_NODE_OP_SAMPLES >> bandgap_line_reg_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_line_reg_detailed_report.txt

alter Vdd = 3.0
op
let idd_3p0 = -i(vdd)
echo SAMPLE_VDD_3P0 >> bandgap_line_reg_detailed_report.txt
echo VREF_V $&v(vref) >> bandgap_line_reg_detailed_report.txt
echo IDD_A $&idd_3p0 >> bandgap_line_reg_detailed_report.txt
echo X1_VG1_V $&v(x1.vg1) >> bandgap_line_reg_detailed_report.txt
echo X1_VG2_V $&v(x1.vg2) >> bandgap_line_reg_detailed_report.txt
echo X1_VG3_V $&v(x1.vg3) >> bandgap_line_reg_detailed_report.txt
echo X1_VG4_V $&v(x1.vg4) >> bandgap_line_reg_detailed_report.txt
echo X1_NET1_V $&v(x1.net1) >> bandgap_line_reg_detailed_report.txt
echo X1_NET2_V $&v(x1.net2) >> bandgap_line_reg_detailed_report.txt
echo X1_NET3_V $&v(x1.net3) >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

alter Vdd = 4.5
op
let idd_4p5 = -i(vdd)
echo SAMPLE_VDD_4P5 >> bandgap_line_reg_detailed_report.txt
echo VREF_V $&v(vref) >> bandgap_line_reg_detailed_report.txt
echo IDD_A $&idd_4p5 >> bandgap_line_reg_detailed_report.txt
echo X1_VG1_V $&v(x1.vg1) >> bandgap_line_reg_detailed_report.txt
echo X1_VG2_V $&v(x1.vg2) >> bandgap_line_reg_detailed_report.txt
echo X1_VG3_V $&v(x1.vg3) >> bandgap_line_reg_detailed_report.txt
echo X1_VG4_V $&v(x1.vg4) >> bandgap_line_reg_detailed_report.txt
echo X1_NET1_V $&v(x1.net1) >> bandgap_line_reg_detailed_report.txt
echo X1_NET2_V $&v(x1.net2) >> bandgap_line_reg_detailed_report.txt
echo X1_NET3_V $&v(x1.net3) >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

alter Vdd = 5.0
op
let idd_5p0 = -i(vdd)
echo SAMPLE_VDD_5P0 >> bandgap_line_reg_detailed_report.txt
echo VREF_V $&v(vref) >> bandgap_line_reg_detailed_report.txt
echo IDD_A $&idd_5p0 >> bandgap_line_reg_detailed_report.txt
echo X1_VG1_V $&v(x1.vg1) >> bandgap_line_reg_detailed_report.txt
echo X1_VG2_V $&v(x1.vg2) >> bandgap_line_reg_detailed_report.txt
echo X1_VG3_V $&v(x1.vg3) >> bandgap_line_reg_detailed_report.txt
echo X1_VG4_V $&v(x1.vg4) >> bandgap_line_reg_detailed_report.txt
echo X1_NET1_V $&v(x1.net1) >> bandgap_line_reg_detailed_report.txt
echo X1_NET2_V $&v(x1.net2) >> bandgap_line_reg_detailed_report.txt
echo X1_NET3_V $&v(x1.net3) >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

alter Vdd = 5.5
op
let idd_5p5 = -i(vdd)
echo SAMPLE_VDD_5P5 >> bandgap_line_reg_detailed_report.txt
echo VREF_V $&v(vref) >> bandgap_line_reg_detailed_report.txt
echo IDD_A $&idd_5p5 >> bandgap_line_reg_detailed_report.txt
echo X1_VG1_V $&v(x1.vg1) >> bandgap_line_reg_detailed_report.txt
echo X1_VG2_V $&v(x1.vg2) >> bandgap_line_reg_detailed_report.txt
echo X1_VG3_V $&v(x1.vg3) >> bandgap_line_reg_detailed_report.txt
echo X1_VG4_V $&v(x1.vg4) >> bandgap_line_reg_detailed_report.txt
echo X1_NET1_V $&v(x1.net1) >> bandgap_line_reg_detailed_report.txt
echo X1_NET2_V $&v(x1.net2) >> bandgap_line_reg_detailed_report.txt
echo X1_NET3_V $&v(x1.net3) >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

* ============================================================
* 5. Final interpretation notes
* ============================================================

echo 5_INTERPRETATION_NOTES >> bandgap_line_reg_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_line_reg_detailed_report.txt
echo Smaller mV_per_V is better. >> bandgap_line_reg_detailed_report.txt
echo EQUIV_DC_PSRR_DB is computed as 20log10(1/line_reg_v_per_v). >> bandgap_line_reg_detailed_report.txt
echo For LNA bias ladder, VTOP error is approximately 3.166 times VBG error. >> bandgap_line_reg_detailed_report.txt
echo If line regulation remains above about 5mV_per_V, improve core current-source output resistance or add regulation. >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

echo FILES_WRITTEN >> bandgap_line_reg_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_line_reg_detailed_report.txt
echo bandgap_line_reg_detailed_report.txt >> bandgap_line_reg_detailed_report.txt
echo bandgap_line_reg_sweep_3p0_5p5.txt >> bandgap_line_reg_detailed_report.txt
echo bandgap_line_reg_sweep_4p5_5p5.txt >> bandgap_line_reg_detailed_report.txt
echo bandgap_line_reg.raw >> bandgap_line_reg_detailed_report.txt
echo bandgap_line_reg_op.raw >> bandgap_line_reg_detailed_report.txt
echo . >> bandgap_line_reg_detailed_report.txt

echo ============================================================ >> bandgap_line_reg_detailed_report.txt
echo END_OF_LINE_REGULATION_REPORT >> bandgap_line_reg_detailed_report.txt
echo ============================================================ >> bandgap_line_reg_detailed_report.txt

.endc
"
spice_ignore=true}
C {capa.sym} 570 -170 0 0 {name=CLOAD
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {isource.sym} 670 -170 0 0 {name=ILOAD value=0}
C {devices/lab_pin.sym} 570 -230 1 0 {name=p3 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 670 -230 1 0 {name=p4 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 620 -100 3 0 {name=p5 sig_type=std_logic lab=GND}
C {/home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/xschem/bandgap.sym} 730 -270 0 0 {name=x1}
C {code_shown.sym} 390 55 0 0 {name=MODELS1 only_toplevel=true
format="tcleval( @value )"
value="
.include $\{::180MCU_MODELS\}/design.ngspice

.lib $\{::180MCU_MODELS\}/sm141064.ngspice typical

.lib $\{::180MCU_MODELS\}/sm141064.ngspice res_typical
.lib $\{::180MCU_MODELS\}/sm141064.ngspice moscap_typical
.lib $\{::180MCU_MODELS\}/sm141064.ngspice diode_typical
.lib $\{::180MCU_MODELS\}/sm141064.ngspice bjt_typical

.lib /home/arjun/eda/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
.include /home/arjun/eda/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
*.include /home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/extracted_gf180mcu_fd_io__asig_5p0.spice
"}
C {code.sym} 1180 -270 0 0 {name=s1 only_toplevel=false value="

.control

* ============================================================
* GF180MCU Bandgap MOS OP Diagnostic
* Corrected version:
*   - No @m.$dev.m0[...] variable substitution
*   - Uses explicit hierarchical device paths
*
* Files:
*   bandgap_mos_op_detailed_report.txt
*   bandgap_mos_op_table.txt
* ============================================================

set noaskquit
set filetype=ascii
set numdgt=10
set wr_singlescale
set wr_vecnames

save all

echo GF180MCU_BANDGAP_ALL_MOS_OP_DETAILED_REPORT > bandgap_mos_op_detailed_report.txt
echo ============================================================ >> bandgap_mos_op_detailed_report.txt
echo . >> bandgap_mos_op_detailed_report.txt

echo NOTE >> bandgap_mos_op_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_mos_op_detailed_report.txt
echo This block uses explicit hierarchical OP paths. >> bandgap_mos_op_detailed_report.txt
echo Example path: @m.x1.xm8.m0[id]. >> bandgap_mos_op_detailed_report.txt
echo No device-name foreach substitution is used. >> bandgap_mos_op_detailed_report.txt
echo . >> bandgap_mos_op_detailed_report.txt

echo DEVICE VDD_V TEMP_C ID_A GM_S GMBS_S GDS_S VGS_V VDS_V VBS_V VTH_V VOV_ABS_V VDSAT_ABS_V SAT_MARGIN_V GMID_1_PER_V RO_OHM GMRO > bandgap_mos_op_table.txt

foreach vddtest 3.0 4.5 5.0 5.5

  alter Vdd = $vddtest
  alter ILOAD = 0
  set temp = 27
  op

  let vdd_now = v(v_dd)
  let vref_now = v(vref)
  let idd_now = -i(vdd)
  let pdc_now = v(v_dd)*idd_now
  let pdc_now_uw = 1e6*pdc_now

  echo OP_SAMPLE VDD $vddtest TEMP_C 27 >> bandgap_mos_op_detailed_report.txt
  echo ============================================================ >> bandgap_mos_op_detailed_report.txt

  echo TOP_LEVEL_VALUES >> bandgap_mos_op_detailed_report.txt
  echo VDD_V $&vdd_now >> bandgap_mos_op_detailed_report.txt
  echo VREF_V $&vref_now >> bandgap_mos_op_detailed_report.txt
  echo IDD_A $&idd_now >> bandgap_mos_op_detailed_report.txt
  echo PDC_W $&pdc_now >> bandgap_mos_op_detailed_report.txt
  echo PDC_uW $&pdc_now_uw >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt

  echo INTERNAL_NODE_VOLTAGES >> bandgap_mos_op_detailed_report.txt
  echo X1_VG1_V $&v(x1.vg1) >> bandgap_mos_op_detailed_report.txt
  echo X1_VG2_V $&v(x1.vg2) >> bandgap_mos_op_detailed_report.txt
  echo X1_VG3_V $&v(x1.vg3) >> bandgap_mos_op_detailed_report.txt
  echo X1_VG4_V $&v(x1.vg4) >> bandgap_mos_op_detailed_report.txt
  echo X1_NET1_V $&v(x1.net1) >> bandgap_mos_op_detailed_report.txt
  echo X1_NET2_V $&v(x1.net2) >> bandgap_mos_op_detailed_report.txt
  echo X1_NET3_V $&v(x1.net3) >> bandgap_mos_op_detailed_report.txt
  echo X1_NET4_V $&v(x1.net4) >> bandgap_mos_op_detailed_report.txt
  echo X1_NET5_V $&v(x1.net5) >> bandgap_mos_op_detailed_report.txt
  echo X1_NET6_V $&v(x1.net6) >> bandgap_mos_op_detailed_report.txt
  echo X1_NET7_V $&v(x1.net7) >> bandgap_mos_op_detailed_report.txt
  echo X1_NET8_V $&v(x1.net8) >> bandgap_mos_op_detailed_report.txt
  echo X1_NET9_V $&v(x1.net9) >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt

  * ============================================================
  * XM8
  * ============================================================

  let xm8_id = abs(@m.x1.xm8.m0[id])
  let xm8_gm = @m.x1.xm8.m0[gm]
  let xm8_gmbs = @m.x1.xm8.m0[gmbs]
  let xm8_gds = @m.x1.xm8.m0[gds]
  let xm8_vgs = @m.x1.xm8.m0[vgs]
  let xm8_vds = @m.x1.xm8.m0[vds]
  let xm8_vbs = @m.x1.xm8.m0[vbs]
  let xm8_vth = @m.x1.xm8.m0[vth]
  let xm8_vdsat = abs(@m.x1.xm8.m0[vdsat])
  let xm8_vov = abs(xm8_vgs)-abs(xm8_vth)
  let xm8_sat = abs(xm8_vds)-xm8_vdsat
  let xm8_gmid = xm8_gm/(xm8_id+1e-30)
  let xm8_ro = 1/(xm8_gds+1e-30)
  let xm8_gmro = xm8_gm*xm8_ro

  echo DEVICE XM8 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm8_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm8_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm8_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm8_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm8_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm8_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm8_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm8_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm8_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm8_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm8_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm8_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm8_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm8_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM8 $&vdd_now 27 $&xm8_id $&xm8_gm $&xm8_gmbs $&xm8_gds $&xm8_vgs $&xm8_vds $&xm8_vbs $&xm8_vth $&xm8_vov $&xm8_vdsat $&xm8_sat $&xm8_gmid $&xm8_ro $&xm8_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM10
  * ============================================================

  let xm10_id = abs(@m.x1.xm10.m0[id])
  let xm10_gm = @m.x1.xm10.m0[gm]
  let xm10_gmbs = @m.x1.xm10.m0[gmbs]
  let xm10_gds = @m.x1.xm10.m0[gds]
  let xm10_vgs = @m.x1.xm10.m0[vgs]
  let xm10_vds = @m.x1.xm10.m0[vds]
  let xm10_vbs = @m.x1.xm10.m0[vbs]
  let xm10_vth = @m.x1.xm10.m0[vth]
  let xm10_vdsat = abs(@m.x1.xm10.m0[vdsat])
  let xm10_vov = abs(xm10_vgs)-abs(xm10_vth)
  let xm10_sat = abs(xm10_vds)-xm10_vdsat
  let xm10_gmid = xm10_gm/(xm10_id+1e-30)
  let xm10_ro = 1/(xm10_gds+1e-30)
  let xm10_gmro = xm10_gm*xm10_ro

  echo DEVICE XM10 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm10_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm10_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm10_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm10_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm10_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm10_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm10_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm10_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm10_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm10_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm10_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm10_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm10_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm10_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM10 $&vdd_now 27 $&xm10_id $&xm10_gm $&xm10_gmbs $&xm10_gds $&xm10_vgs $&xm10_vds $&xm10_vbs $&xm10_vth $&xm10_vov $&xm10_vdsat $&xm10_sat $&xm10_gmid $&xm10_ro $&xm10_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM3
  * ============================================================

  let xm3_id = abs(@m.x1.xm3.m0[id])
  let xm3_gm = @m.x1.xm3.m0[gm]
  let xm3_gmbs = @m.x1.xm3.m0[gmbs]
  let xm3_gds = @m.x1.xm3.m0[gds]
  let xm3_vgs = @m.x1.xm3.m0[vgs]
  let xm3_vds = @m.x1.xm3.m0[vds]
  let xm3_vbs = @m.x1.xm3.m0[vbs]
  let xm3_vth = @m.x1.xm3.m0[vth]
  let xm3_vdsat = abs(@m.x1.xm3.m0[vdsat])
  let xm3_vov = abs(xm3_vgs)-abs(xm3_vth)
  let xm3_sat = abs(xm3_vds)-xm3_vdsat
  let xm3_gmid = xm3_gm/(xm3_id+1e-30)
  let xm3_ro = 1/(xm3_gds+1e-30)
  let xm3_gmro = xm3_gm*xm3_ro

  echo DEVICE XM3 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm3_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm3_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm3_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm3_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm3_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm3_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm3_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm3_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm3_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm3_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm3_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm3_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm3_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm3_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM3 $&vdd_now 27 $&xm3_id $&xm3_gm $&xm3_gmbs $&xm3_gds $&xm3_vgs $&xm3_vds $&xm3_vbs $&xm3_vth $&xm3_vov $&xm3_vdsat $&xm3_sat $&xm3_gmid $&xm3_ro $&xm3_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM11
  * ============================================================

  let xm11_id = abs(@m.x1.xm11.m0[id])
  let xm11_gm = @m.x1.xm11.m0[gm]
  let xm11_gmbs = @m.x1.xm11.m0[gmbs]
  let xm11_gds = @m.x1.xm11.m0[gds]
  let xm11_vgs = @m.x1.xm11.m0[vgs]
  let xm11_vds = @m.x1.xm11.m0[vds]
  let xm11_vbs = @m.x1.xm11.m0[vbs]
  let xm11_vth = @m.x1.xm11.m0[vth]
  let xm11_vdsat = abs(@m.x1.xm11.m0[vdsat])
  let xm11_vov = abs(xm11_vgs)-abs(xm11_vth)
  let xm11_sat = abs(xm11_vds)-xm11_vdsat
  let xm11_gmid = xm11_gm/(xm11_id+1e-30)
  let xm11_ro = 1/(xm11_gds+1e-30)
  let xm11_gmro = xm11_gm*xm11_ro

  echo DEVICE XM11 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm11_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm11_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm11_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm11_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm11_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm11_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm11_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm11_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm11_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm11_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm11_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm11_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm11_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm11_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM11 $&vdd_now 27 $&xm11_id $&xm11_gm $&xm11_gmbs $&xm11_gds $&xm11_vgs $&xm11_vds $&xm11_vbs $&xm11_vth $&xm11_vov $&xm11_vdsat $&xm11_sat $&xm11_gmid $&xm11_ro $&xm11_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM12
  * ============================================================

  let xm12_id = abs(@m.x1.xm12.m0[id])
  let xm12_gm = @m.x1.xm12.m0[gm]
  let xm12_gmbs = @m.x1.xm12.m0[gmbs]
  let xm12_gds = @m.x1.xm12.m0[gds]
  let xm12_vgs = @m.x1.xm12.m0[vgs]
  let xm12_vds = @m.x1.xm12.m0[vds]
  let xm12_vbs = @m.x1.xm12.m0[vbs]
  let xm12_vth = @m.x1.xm12.m0[vth]
  let xm12_vdsat = abs(@m.x1.xm12.m0[vdsat])
  let xm12_vov = abs(xm12_vgs)-abs(xm12_vth)
  let xm12_sat = abs(xm12_vds)-xm12_vdsat
  let xm12_gmid = xm12_gm/(xm12_id+1e-30)
  let xm12_ro = 1/(xm12_gds+1e-30)
  let xm12_gmro = xm12_gm*xm12_ro

  echo DEVICE XM12 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm12_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm12_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm12_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm12_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm12_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm12_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm12_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm12_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm12_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm12_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm12_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm12_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm12_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm12_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM12 $&vdd_now 27 $&xm12_id $&xm12_gm $&xm12_gmbs $&xm12_gds $&xm12_vgs $&xm12_vds $&xm12_vbs $&xm12_vth $&xm12_vov $&xm12_vdsat $&xm12_sat $&xm12_gmid $&xm12_ro $&xm12_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM14
  * ============================================================

  let xm14_id = abs(@m.x1.xm14.m0[id])
  let xm14_gm = @m.x1.xm14.m0[gm]
  let xm14_gmbs = @m.x1.xm14.m0[gmbs]
  let xm14_gds = @m.x1.xm14.m0[gds]
  let xm14_vgs = @m.x1.xm14.m0[vgs]
  let xm14_vds = @m.x1.xm14.m0[vds]
  let xm14_vbs = @m.x1.xm14.m0[vbs]
  let xm14_vth = @m.x1.xm14.m0[vth]
  let xm14_vdsat = abs(@m.x1.xm14.m0[vdsat])
  let xm14_vov = abs(xm14_vgs)-abs(xm14_vth)
  let xm14_sat = abs(xm14_vds)-xm14_vdsat
  let xm14_gmid = xm14_gm/(xm14_id+1e-30)
  let xm14_ro = 1/(xm14_gds+1e-30)
  let xm14_gmro = xm14_gm*xm14_ro

  echo DEVICE XM14 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm14_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm14_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm14_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm14_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm14_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm14_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm14_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm14_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm14_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm14_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm14_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm14_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm14_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm14_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM14 $&vdd_now 27 $&xm14_id $&xm14_gm $&xm14_gmbs $&xm14_gds $&xm14_vgs $&xm14_vds $&xm14_vbs $&xm14_vth $&xm14_vov $&xm14_vdsat $&xm14_sat $&xm14_gmid $&xm14_ro $&xm14_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM5
  * ============================================================

  let xm5_id = abs(@m.x1.xm5.m0[id])
  let xm5_gm = @m.x1.xm5.m0[gm]
  let xm5_gmbs = @m.x1.xm5.m0[gmbs]
  let xm5_gds = @m.x1.xm5.m0[gds]
  let xm5_vgs = @m.x1.xm5.m0[vgs]
  let xm5_vds = @m.x1.xm5.m0[vds]
  let xm5_vbs = @m.x1.xm5.m0[vbs]
  let xm5_vth = @m.x1.xm5.m0[vth]
  let xm5_vdsat = abs(@m.x1.xm5.m0[vdsat])
  let xm5_vov = abs(xm5_vgs)-abs(xm5_vth)
  let xm5_sat = abs(xm5_vds)-xm5_vdsat
  let xm5_gmid = xm5_gm/(xm5_id+1e-30)
  let xm5_ro = 1/(xm5_gds+1e-30)
  let xm5_gmro = xm5_gm*xm5_ro

  echo DEVICE XM5 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm5_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm5_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm5_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm5_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm5_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm5_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm5_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm5_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm5_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm5_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm5_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm5_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm5_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm5_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM5 $&vdd_now 27 $&xm5_id $&xm5_gm $&xm5_gmbs $&xm5_gds $&xm5_vgs $&xm5_vds $&xm5_vbs $&xm5_vth $&xm5_vov $&xm5_vdsat $&xm5_sat $&xm5_gmid $&xm5_ro $&xm5_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM6
  * ============================================================

  let xm6_id = abs(@m.x1.xm6.m0[id])
  let xm6_gm = @m.x1.xm6.m0[gm]
  let xm6_gmbs = @m.x1.xm6.m0[gmbs]
  let xm6_gds = @m.x1.xm6.m0[gds]
  let xm6_vgs = @m.x1.xm6.m0[vgs]
  let xm6_vds = @m.x1.xm6.m0[vds]
  let xm6_vbs = @m.x1.xm6.m0[vbs]
  let xm6_vth = @m.x1.xm6.m0[vth]
  let xm6_vdsat = abs(@m.x1.xm6.m0[vdsat])
  let xm6_vov = abs(xm6_vgs)-abs(xm6_vth)
  let xm6_sat = abs(xm6_vds)-xm6_vdsat
  let xm6_gmid = xm6_gm/(xm6_id+1e-30)
  let xm6_ro = 1/(xm6_gds+1e-30)
  let xm6_gmro = xm6_gm*xm6_ro

  echo DEVICE XM6 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm6_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm6_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm6_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm6_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm6_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm6_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm6_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm6_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm6_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm6_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm6_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm6_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm6_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm6_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM6 $&vdd_now 27 $&xm6_id $&xm6_gm $&xm6_gmbs $&xm6_gds $&xm6_vgs $&xm6_vds $&xm6_vbs $&xm6_vth $&xm6_vov $&xm6_vdsat $&xm6_sat $&xm6_gmid $&xm6_ro $&xm6_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM7
  * ============================================================

  let xm7_id = abs(@m.x1.xm7.m0[id])
  let xm7_gm = @m.x1.xm7.m0[gm]
  let xm7_gmbs = @m.x1.xm7.m0[gmbs]
  let xm7_gds = @m.x1.xm7.m0[gds]
  let xm7_vgs = @m.x1.xm7.m0[vgs]
  let xm7_vds = @m.x1.xm7.m0[vds]
  let xm7_vbs = @m.x1.xm7.m0[vbs]
  let xm7_vth = @m.x1.xm7.m0[vth]
  let xm7_vdsat = abs(@m.x1.xm7.m0[vdsat])
  let xm7_vov = abs(xm7_vgs)-abs(xm7_vth)
  let xm7_sat = abs(xm7_vds)-xm7_vdsat
  let xm7_gmid = xm7_gm/(xm7_id+1e-30)
  let xm7_ro = 1/(xm7_gds+1e-30)
  let xm7_gmro = xm7_gm*xm7_ro

  echo DEVICE XM7 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm7_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm7_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm7_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm7_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm7_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm7_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm7_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm7_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm7_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm7_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm7_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm7_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm7_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm7_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM7 $&vdd_now 27 $&xm7_id $&xm7_gm $&xm7_gmbs $&xm7_gds $&xm7_vgs $&xm7_vds $&xm7_vbs $&xm7_vth $&xm7_vov $&xm7_vdsat $&xm7_sat $&xm7_gmid $&xm7_ro $&xm7_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM9
  * ============================================================

  let xm9_id = abs(@m.x1.xm9.m0[id])
  let xm9_gm = @m.x1.xm9.m0[gm]
  let xm9_gmbs = @m.x1.xm9.m0[gmbs]
  let xm9_gds = @m.x1.xm9.m0[gds]
  let xm9_vgs = @m.x1.xm9.m0[vgs]
  let xm9_vds = @m.x1.xm9.m0[vds]
  let xm9_vbs = @m.x1.xm9.m0[vbs]
  let xm9_vth = @m.x1.xm9.m0[vth]
  let xm9_vdsat = abs(@m.x1.xm9.m0[vdsat])
  let xm9_vov = abs(xm9_vgs)-abs(xm9_vth)
  let xm9_sat = abs(xm9_vds)-xm9_vdsat
  let xm9_gmid = xm9_gm/(xm9_id+1e-30)
  let xm9_ro = 1/(xm9_gds+1e-30)
  let xm9_gmro = xm9_gm*xm9_ro

  echo DEVICE XM9 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm9_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm9_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm9_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm9_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm9_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm9_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm9_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm9_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm9_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm9_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm9_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm9_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm9_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm9_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM9 $&vdd_now 27 $&xm9_id $&xm9_gm $&xm9_gmbs $&xm9_gds $&xm9_vgs $&xm9_vds $&xm9_vbs $&xm9_vth $&xm9_vov $&xm9_vdsat $&xm9_sat $&xm9_gmid $&xm9_ro $&xm9_gmro >> bandgap_mos_op_table.txt

  * ============================================================
  * XM13
  * ============================================================

  let xm13_id = abs(@m.x1.xm13.m0[id])
  let xm13_gm = @m.x1.xm13.m0[gm]
  let xm13_gmbs = @m.x1.xm13.m0[gmbs]
  let xm13_gds = @m.x1.xm13.m0[gds]
  let xm13_vgs = @m.x1.xm13.m0[vgs]
  let xm13_vds = @m.x1.xm13.m0[vds]
  let xm13_vbs = @m.x1.xm13.m0[vbs]
  let xm13_vth = @m.x1.xm13.m0[vth]
  let xm13_vdsat = abs(@m.x1.xm13.m0[vdsat])
  let xm13_vov = abs(xm13_vgs)-abs(xm13_vth)
  let xm13_sat = abs(xm13_vds)-xm13_vdsat
  let xm13_gmid = xm13_gm/(xm13_id+1e-30)
  let xm13_ro = 1/(xm13_gds+1e-30)
  let xm13_gmro = xm13_gm*xm13_ro

  echo DEVICE XM13 >> bandgap_mos_op_detailed_report.txt
  echo ID_A $&xm13_id >> bandgap_mos_op_detailed_report.txt
  echo GM_S $&xm13_gm >> bandgap_mos_op_detailed_report.txt
  echo GMBS_S $&xm13_gmbs >> bandgap_mos_op_detailed_report.txt
  echo GDS_S $&xm13_gds >> bandgap_mos_op_detailed_report.txt
  echo VGS_V $&xm13_vgs >> bandgap_mos_op_detailed_report.txt
  echo VDS_V $&xm13_vds >> bandgap_mos_op_detailed_report.txt
  echo VBS_V $&xm13_vbs >> bandgap_mos_op_detailed_report.txt
  echo VTH_V $&xm13_vth >> bandgap_mos_op_detailed_report.txt
  echo VOV_ABS_V $&xm13_vov >> bandgap_mos_op_detailed_report.txt
  echo VDSAT_ABS_V $&xm13_vdsat >> bandgap_mos_op_detailed_report.txt
  echo SAT_MARGIN_V $&xm13_sat >> bandgap_mos_op_detailed_report.txt
  echo GMID_1_PER_V $&xm13_gmid >> bandgap_mos_op_detailed_report.txt
  echo RO_OHM $&xm13_ro >> bandgap_mos_op_detailed_report.txt
  echo GMRO $&xm13_gmro >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt
  echo XM13 $&vdd_now 27 $&xm13_id $&xm13_gm $&xm13_gmbs $&xm13_gds $&xm13_vgs $&xm13_vds $&xm13_vbs $&xm13_vth $&xm13_vov $&xm13_vdsat $&xm13_sat $&xm13_gmid $&xm13_ro $&xm13_gmro >> bandgap_mos_op_table.txt

  echo END_OP_SAMPLE VDD $vddtest >> bandgap_mos_op_detailed_report.txt
  echo . >> bandgap_mos_op_detailed_report.txt

end

echo INTERPRETATION_GUIDE >> bandgap_mos_op_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_mos_op_detailed_report.txt
echo SAT_MARGIN_V = abs(VDS)-abs(VDSAT). Positive means saturation by first-order check. >> bandgap_mos_op_detailed_report.txt
echo GMID_1_PER_V = gm divided by absolute drain current. >> bandgap_mos_op_detailed_report.txt
echo RO_OHM = 1/gds. Larger ro improves current-source behavior and line regulation. >> bandgap_mos_op_detailed_report.txt
echo GMRO = gm/gds. Larger gmro means higher intrinsic gain. >> bandgap_mos_op_detailed_report.txt
echo Inspect devices with low SAT_MARGIN_V, low RO_OHM, or low GMRO. >> bandgap_mos_op_detailed_report.txt
echo . >> bandgap_mos_op_detailed_report.txt

echo FILES_WRITTEN >> bandgap_mos_op_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_mos_op_detailed_report.txt
echo bandgap_mos_op_detailed_report.txt >> bandgap_mos_op_detailed_report.txt
echo bandgap_mos_op_table.txt >> bandgap_mos_op_detailed_report.txt
echo . >> bandgap_mos_op_detailed_report.txt

echo ============================================================ >> bandgap_mos_op_detailed_report.txt
echo END_OF_ALL_MOS_OP_REPORT >> bandgap_mos_op_detailed_report.txt
echo ============================================================ >> bandgap_mos_op_detailed_report.txt

.endc

"
}
