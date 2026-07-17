v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
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
C {bandgap.sym} 730 -270 0 0 {name=x1}
C {code.sym} 1050 -530 0 0 {name=s2 only_toplevel=false value="

.control

set filetype=ascii
set numdgt=8
set wr_singlescale

* ============================================================
* Constants
* ============================================================

let t_cold = -30
let t_nom = 27
let t_hot = 125
let temp_span = t_hot - t_cold

* ============================================================
* Create report files
* ============================================================

echo GF180MCU_Bandgap_Ideal_First_Detailed_Report > bandgap_detailed_report.txt
echo ============================================================ >> bandgap_detailed_report.txt
echo . >> bandgap_detailed_report.txt

echo GF180MCU_Bandgap_Ideal_First_Summary > bandgap_summary.txt
echo ============================================================ >> bandgap_summary.txt
echo . >> bandgap_summary.txt

* ============================================================
* Save important results
* ============================================================

save all

* ============================================================
* Print nominal design information
* ============================================================

echo NOMINAL_DESIGN_PARAMETERS >> bandgap_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_detailed_report.txt
echo VDDNOM_V = 5 >> bandgap_detailed_report.txt
echo QBIG = 40 >> bandgap_detailed_report.txt
echo QSMALL = 2 >> bandgap_detailed_report.txt
echo BJT_RATIO_QBIG_OVER_QSMALL = 20 >> bandgap_detailed_report.txt
echo RPTAT_OHM = 6000 >> bandgap_detailed_report.txt
echo RREF_OHM = 39000 >> bandgap_detailed_report.txt
echo RBIAS_OHM = 10000 >> bandgap_detailed_report.txt
echo PMOS_MAIN_W_L_NF = 50u_1u_1 >> bandgap_detailed_report.txt
echo NMOS_MAIN_W_L_NF = 15u_1u_1 >> bandgap_detailed_report.txt
echo STARTUP_PMOS_W_L_NF = 0.5u_10u_1 >> bandgap_detailed_report.txt
echo . >> bandgap_detailed_report.txt

* ============================================================
* 1. Nominal operating point
* ============================================================

alter Vdd = 5
alter Iload = 0

op

let idd_op = -i(vdd)
let pdc_op = v(v_dd) * idd_op

echo 1_NOMINAL_OPERATING_POINT_T_27C_VDD_5V >> bandgap_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_detailed_report.txt
print v(vref) >> bandgap_detailed_report.txt
print v(v_dd) >> bandgap_detailed_report.txt
print idd_op >> bandgap_detailed_report.txt
print pdc_op >> bandgap_detailed_report.txt
echo . >> bandgap_detailed_report.txt

echo INTERNAL_BIAS_NODES >> bandgap_detailed_report.txt
print v(x1.vg1) >> bandgap_detailed_report.txt
print v(x1.vg2) >> bandgap_detailed_report.txt
print v(x1.vg3) >> bandgap_detailed_report.txt
print v(x1.vg4) >> bandgap_detailed_report.txt
print v(x1.net1) >> bandgap_detailed_report.txt
print v(x1.net2) >> bandgap_detailed_report.txt
print v(x1.net3) >> bandgap_detailed_report.txt
print v(x1.net4) >> bandgap_detailed_report.txt
print v(x1.net5) >> bandgap_detailed_report.txt
print v(x1.net6) >> bandgap_detailed_report.txt
print v(x1.net7) >> bandgap_detailed_report.txt
print v(x1.net8) >> bandgap_detailed_report.txt
print v(x1.net9) >> bandgap_detailed_report.txt
echo . >> bandgap_detailed_report.txt

write bandgap_op.raw

* ============================================================
* 2. Temperature sweep
* ============================================================

dc temp -30 125 1

meas dc vref_cold find v(vref) at=-30
meas dc vref_nom find v(vref) at=27
meas dc vref_hot find v(vref) at=125
meas dc vref_min min v(vref) from=-30 to=125
meas dc vref_max max v(vref) from=-30 to=125

let vref_span = vref_max - vref_min
let vref_end_delta = vref_hot - vref_cold
let tempco_endpoint_ppm = 1e6 * vref_end_delta / (vref_nom * temp_span)
let tempco_span_ppm = 1e6 * vref_span / (vref_nom * temp_span)
let idd_temp = -i(vdd)

echo 2_TEMPERATURE_SWEEP_MINUS30C_TO_125C >> bandgap_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_detailed_report.txt
echo VREF_COLD_V = $&vref_cold >> bandgap_detailed_report.txt
echo VREF_NOMINAL_V = $&vref_nom >> bandgap_detailed_report.txt
echo VREF_HOT_V = $&vref_hot >> bandgap_detailed_report.txt
echo VREF_MIN_V = $&vref_min >> bandgap_detailed_report.txt
echo VREF_MAX_V = $&vref_max >> bandgap_detailed_report.txt
echo VREF_SPAN_V = $&vref_span >> bandgap_detailed_report.txt
echo ENDPOINT_TEMP_DELTA_V = $&vref_end_delta >> bandgap_detailed_report.txt
echo ENDPOINT_TEMP_COEFF_PPM_PER_C = $&tempco_endpoint_ppm >> bandgap_detailed_report.txt
echo WORST_SPAN_TEMP_COEFF_PPM_PER_C = $&tempco_span_ppm >> bandgap_detailed_report.txt
echo . >> bandgap_detailed_report.txt

wrdata bandgap_temp_sweep.txt v(vref) idd_temp
write bandgap_temp.raw

* ============================================================
* 3. Supply sweep and line regulation
* ============================================================

alter Iload = 0
dc Vdd 3.0 5.5 0.01

meas dc vref_vdd3p0 find v(vref) at=3.0
meas dc vref_vdd5p0 find v(vref) at=5.0
meas dc vref_line_min min v(vref) from=3.0 to=5.5
meas dc vref_line_max max v(vref) from=3.0 to=5.5

let vref_line_span = vref_line_max - vref_line_min
let line_reg_mv_per_v = 1000 * (vref_line_max - vref_line_min) / (5.5 - 3.0)
let idd_line = -i(vdd)

echo 3_SUPPLY_SWEEP_LINE_REGULATION_3V_TO_5P5V >> bandgap_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_detailed_report.txt
echo VREF_AT_VDD_3P0_V = $&vref_vdd3p0 >> bandgap_detailed_report.txt
echo VREF_AT_VDD_5P0_V = $&vref_vdd5p0 >> bandgap_detailed_report.txt
echo VREF_LINE_MAX_V = $&vref_line_max >> bandgap_detailed_report.txt
echo VREF_LINE_MIN_V = $&vref_line_min >> bandgap_detailed_report.txt
echo VREF_LINE_SPAN_V = $&vref_line_span >> bandgap_detailed_report.txt
echo LINE_REG_MV_PER_V = $&line_reg_mv_per_v >> bandgap_detailed_report.txt
echo . >> bandgap_detailed_report.txt

wrdata bandgap_line_sweep.txt v(vref) idd_line
write bandgap_line.raw

echo LINE_RESULTS >> bandgap_summary.txt
echo VREF_AT_VDD_3P0_V = $&vref_vdd3p0 >> bandgap_summary.txt
echo VREF_AT_VDD_5P0_V = $&vref_vdd5p0 >> bandgap_summary.txt
echo LINE_REG_MV_PER_V = $&line_reg_mv_per_v >> bandgap_summary.txt
echo . >> bandgap_summary.txt

* ============================================================
* 4. Load regulation
* Requires Iload vref GND 0 in testbench
* ============================================================

alter Vdd = 5
alter Iload = 0

dc Iload 0 1u 0.01u

meas dc vref_load0 find v(vref) at=0
meas dc vref_load100n find v(vref) at=100n
meas dc vref_load500n find v(vref) at=500n
meas dc vref_load1u find v(vref) at=1u
meas dc vref_load_min min v(vref) from=0 to=1u
meas dc vref_load_max max v(vref) from=0 to=1u

let load_reg_0_1u_mv = 1000 * (vref_load1u - vref_load0)
let load_reg_uv_per_ua = 1e6 * (vref_load1u - vref_load0)
let idd_load = -i(vdd)
echo 4_LOAD_REGULATION_0_TO_1UA >> bandgap_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_detailed_report.txt
echo VREF_AT_ILOAD_0UA_V = $&vref_load0 >> bandgap_detailed_report.txt
echo VREF_AT_ILOAD_100NA_V = $&vref_load100n >> bandgap_detailed_report.txt
echo VREF_AT_ILOAD_500NA_V = $&vref_load500n >> bandgap_detailed_report.txt
echo VREF_AT_ILOAD_1UA_V = $&vref_load1u >> bandgap_detailed_report.txt
echo VREF_LOAD_MIN_V = $&vref_load_min >> bandgap_detailed_report.txt
echo VREF_LOAD_MAX_V = $&vref_load_max >> bandgap_detailed_report.txt
echo LOAD_REG_0_TO_1UA_MV = $&load_reg_0_1u_mv >> bandgap_detailed_report.txt
echo LOAD_REG_UV_PER_UA = $&load_reg_uv_per_ua >> bandgap_detailed_report.txt
echo . >> bandgap_detailed_report.txt

wrdata bandgap_load_sweep.txt v(vref) idd_load
write bandgap_load.raw

echo LOAD_RESULTS >> bandgap_summary.txt
echo VREF_AT_ILOAD_0UA_V = $&vref_load0 >> bandgap_summary.txt
echo VREF_AT_ILOAD_1UA_V = $&vref_load1u >> bandgap_summary.txt
echo LOAD_REG_0_TO_1UA_MV = $&load_reg_0_1u_mv >> bandgap_summary.txt
echo LOAD_REG_UV_PER_UA = $&load_reg_uv_per_ua >> bandgap_summary.txt
echo . >> bandgap_summary.txt
* ============================================================
* 5. Startup transient
* Uses VDD step from 0V to 5V by alter before transient
* ============================================================

alter Vdd = 0
alter Iload = 0
op

alter Vdd = 5

tran 1u 10m uic

meas tran vref_start_100us find v(vref) at=100u
meas tran vref_start_1ms find v(vref) at=1m
meas tran vref_start_5ms find v(vref) at=5m
meas tran vref_start_10ms find v(vref) at=10m

let idd_start = -i(vdd)

echo 5_STARTUP_TRANSIENT_FROM_ZERO_SUPPLY >> bandgap_detailed_report.txt
echo ------------------------------------------------------------ >> bandgap_detailed_report.txt
echo VREF_AT_100US_V = $&vref_start_100us >> bandgap_detailed_report.txt
echo VREF_AT_1MS_V = $&vref_start_1ms >> bandgap_detailed_report.txt
echo VREF_AT_5MS_V = $&vref_start_5ms >> bandgap_detailed_report.txt
echo VREF_AT_10MS_V = $&vref_start_10ms >> bandgap_detailed_report.txt
echo . >> bandgap_detailed_report.txt

wrdata bandgap_startup.txt v(vref) v(x1.vg1) v(x1.vg2) v(x1.vg3) v(x1.vg4) idd_start
write bandgap_startup.raw
echo STARTUP_RESULTS >> bandgap_summary.txt
echo STARTUP_VREF_100US_V = $&vref_start_100us >> bandgap_summary.txt
echo STARTUP_VREF_1MS_V = $&vref_start_1ms >> bandgap_summary.txt
echo STARTUP_VREF_10MS_V = $&vref_start_10ms >> bandgap_summary.txt
echo . >> bandgap_summary.txt

echo TEMP_RESULTS >> bandgap_summary.txt
echo VREF_NOMINAL_27C_V = $&vref_nom >> bandgap_summary.txt
echo VREF_COLD_MINUS30C_V = $&vref_cold >> bandgap_summary.txt
echo VREF_HOT_125C_V = $&vref_hot >> bandgap_summary.txt
echo ENDPOINT_TEMP_COEFF_PPM_PER_C = $&tempco_endpoint_ppm >> bandgap_summary.txt
echo WORST_SPAN_TEMP_COEFF_PPM_PER_C = $&tempco_span_ppm >> bandgap_summary.txt
echo . >> bandgap_summary.txt


.endc
"
}
C {code_shown.sym} 560 45 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice

.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice bjt_typical

*.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
.include /media/sf_LNA_chipathon/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.spice 
"}
C {capa.sym} 570 -170 0 0 {name=CLOAD
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {isource.sym} 670 -170 0 0 {name=ILOAD value=0}
C {devices/lab_pin.sym} 570 -230 1 0 {name=p3 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 670 -230 1 0 {name=p4 sig_type=std_logic lab=vref}
C {devices/lab_pin.sym} 620 -100 3 0 {name=p5 sig_type=std_logic lab=GND}
