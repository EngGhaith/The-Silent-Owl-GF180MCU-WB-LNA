v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 180 -1240 250 -1240 {lab=vdd}
N 120 -1240 120 -1200 {lab=vdd}
N 120 -1240 180 -1240 {lab=vdd}
N 230 -1170 250 -1170 {lab=0}
N 230 -1170 230 -1150 {lab=0}
N 230 -1150 230 -1140 {lab=0}
N 120 -1140 230 -1140 {lab=0}
N 780 -1090 780 -1070 {lab=0}
N 820 -1090 820 -1020 {lab=#net1}
N 780 -1290 780 -1250 {lab=vdd}
N 820 -1290 820 -1250 {lab=#net2}
N 820 -1370 820 -1350 {
lab=vdd}
N 820 -1380 820 -1370 {lab=vdd}
N 880 -1170 970 -1170 {lab=vref}
N 1010 -1270 1010 -1200 {lab=vdd}
N 1010 -1140 1010 -1080 {lab=vtop}
N 1010 -1100 1260 -1100 {lab=vtop}
N 1160 -1100 1160 -1050 {lab=vtop}
N 1260 -1100 1260 -1060 {lab=vtop}
N 1260 -1000 1260 -960 {lab=#net3}
N 1010 -1170 1030 -1170 {lab=vdd}
N 1030 -1220 1030 -1170 {lab=vdd}
N 1010 -1220 1030 -1220 {lab=vdd}
N 660 -1200 700 -1200 {lab=vsense}
N 550 -1200 620 -1200 {lab=vp}
N 660 -1140 700 -1140 {lab=vp}
N 1010 -1080 1010 -1040 {lab=vtop}
N 1010 -980 1010 -940 {lab=vbias_cas_cg}
N 1010 -880 1010 -840 {lab=vbias_casc}
N 1010 -780 1010 -740 {lab=vbias_cg}
N 1010 -680 1010 -640 {lab=vbias_icg}
N 1010 -580 1010 -540 {lab=vbias_13}
N 1010 -380 1010 -340 {lab=vbias_csc}
N 1010 -280 1010 -240 {lab=0}
N 1010 -480 1010 -440 {lab=vsense}
C {vsource.sym} 120 -1170 0 0 {name=V3 value=\{VDDVAL\} savecurrent=false
}
C {gnd.sym} 120 -1140 0 0 {name=l5 lab=0
}
C {lab_pin.sym} 120 -1240 0 0 {name=p3 sig_type=std_logic lab=vdd}
C {gnd.sym} 780 -1070 0 0 {name=l1 lab=0
}
C {vsource.sym} 820 -990 0 0 {name=V1 value=5 savecurrent=false
}
C {gnd.sym} 820 -960 0 0 {name=l2 lab=0
}
C {lab_pin.sym} 780 -1290 0 0 {name=p1 sig_type=std_logic lab=vdd}
C {isource.sym} 820 -1320 0 0 {name=I0 value=20u pwl(0 0 10u 0 11u 20u)"}
C {lab_pin.sym} 820 -1380 0 0 {name=p2 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 1010 -1270 0 0 {name=p4 sig_type=std_logic lab=vdd}
C {res.sym} 1010 -1010 0 0 {name=R1
value=20k
footprint=1206
device=resistor
m=1}
C {res.sym} 1010 -910 0 0 {name=R2
value=5k
footprint=1206
device=resistor
m=1}
C {gnd.sym} 1010 -240 0 0 {name=l3 lab=0
}
C {capa.sym} 1160 -1020 0 0 {name=C1
m=1
value=10f
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 1160 -990 0 0 {name=l4 lab=0
}
C {ammeter.sym} 1260 -1030 0 0 {name=Vmeas savecurrent=true spice_ignore=0}
C {vsource.sym} 1260 -930 0 0 {name=V2 value=0 savecurrent=false
spice_ignore=true}
C {gnd.sym} 1260 -900 0 0 {name=l6 lab=0
}
C {devices/code_shown.sym} 1960 -1730 0 0 {name=NGSPICE only_toplevel=true 
value="
*.option klu
.option method=gear
.option warn=0
.temp 27


.param VDDVAL=5
.param WPMOS=50u
.param LPMOS=2u

.control

* ============================================================
* GF180MCU Bias Current Generator PMOS Sizing / VDD / Temp Sweep
* Corrected for retuned ladder:
*
*   R1 = 20k
*   R2 = 5k
*   R3 = 50k
*   R4 = 15k
*   R5 = 30k
*   R6 = 8.066k
*   R7 = 11.934k
*   R8 = 45k
*
* Important:
*   This block does NOT rely on i(Vmeas).
*   Your current schematic still has Vmeas not in series, so i(Vmeas)
*   is intentionally ignored here.
*
* Output files:
*   bias_current_pmos_sizing_test_report.txt
*   bias_current_pmos_sizing_table.txt
* ============================================================

set noaskquit
set filetype=ascii
set wr_singlescale
set wr_vecnames
set numdgt=10

save all

echo GF180MCU_BIAS_CURRENT_PMOS_SIZING_TEST_REPORT > bias_current_pmos_sizing_test_report.txt
echo ============================================================ >> bias_current_pmos_sizing_test_report.txt
echo . >> bias_current_pmos_sizing_test_report.txt

echo TEST_DESCRIPTION >> bias_current_pmos_sizing_test_report.txt
echo ------------------------------------------------------------ >> bias_current_pmos_sizing_test_report.txt
echo PMOS sizing, VDD, and temperature sweep for the retuned bias-current ladder. >> bias_current_pmos_sizing_test_report.txt
echo This corrected block uses R6=8.066k and R7=11.934k in all current calculations. >> bias_current_pmos_sizing_test_report.txt
echo It does not use i(Vmeas), because Vmeas is not currently in series with XM1. >> bias_current_pmos_sizing_test_report.txt
echo . >> bias_current_pmos_sizing_test_report.txt

echo LADDER_VALUES >> bias_current_pmos_sizing_test_report.txt
echo ------------------------------------------------------------ >> bias_current_pmos_sizing_test_report.txt
echo R1_VTOP_TO_VBIAS_CAS_CG_OHM 20k >> bias_current_pmos_sizing_test_report.txt
echo R2_VBIAS_CAS_CG_TO_VBIAS_CASC_OHM 5k >> bias_current_pmos_sizing_test_report.txt
echo R3_VBIAS_CASC_TO_VBIAS_CG_OHM 50k >> bias_current_pmos_sizing_test_report.txt
echo R4_VBIAS_CG_TO_VBIAS_ICG_OHM 15k >> bias_current_pmos_sizing_test_report.txt
echo R5_VBIAS_ICG_TO_VBIAS_13_OHM 30k >> bias_current_pmos_sizing_test_report.txt
echo R6_VBIAS_13_TO_VSENSE_OHM 8.066k >> bias_current_pmos_sizing_test_report.txt
echo R7_VSENSE_TO_VBIAS_CSC_OHM 11.934k >> bias_current_pmos_sizing_test_report.txt
echo R8_VBIAS_CSC_TO_GND_OHM 45k >> bias_current_pmos_sizing_test_report.txt
echo . >> bias_current_pmos_sizing_test_report.txt

echo TEST_LIMITS >> bias_current_pmos_sizing_test_report.txt
echo ------------------------------------------------------------ >> bias_current_pmos_sizing_test_report.txt
echo TARGET_I_LADDER_A 20u >> bias_current_pmos_sizing_test_report.txt
echo TARGET_VTOP_V 3.7 >> bias_current_pmos_sizing_test_report.txt
echo MAX_ABS_I_ERROR_A 1u >> bias_current_pmos_sizing_test_report.txt
echo MAX_ABS_VTOP_ERROR_V 30m >> bias_current_pmos_sizing_test_report.txt
echo MAX_ABS_VSENSE_ERROR_V 5m >> bias_current_pmos_sizing_test_report.txt
echo MIN_PMOS_SAT_MARGIN_V 0.2 >> bias_current_pmos_sizing_test_report.txt
echo MIN_PMOS_GATE_V 0.2 >> bias_current_pmos_sizing_test_report.txt
echo MAX_PMOS_GATE_MARGIN_FROM_VDD_V 0.2 >> bias_current_pmos_sizing_test_report.txt
echo NOTE_PASS_IF_ALL_MARGIN_COLUMNS_ARE_POSITIVE >> bias_current_pmos_sizing_test_report.txt
echo . >> bias_current_pmos_sizing_test_report.txt

echo TEST_NAME WPMOS LPMOS TEMP_C VDD_V VBG_V VSENSE_V ERR_VBG_MINUS_VSENSE_V VTOP_V VBIAS_CAS_CG_V VBIAS_CASC_V VBIAS_CG_V VBIAS_ICG_V VBIAS_13_V VBIAS_CSC_V I_R1_A I_R2_A I_R3_A I_R4_A I_R5_A I_R6_A I_R7_A I_R8_A I_LADDER_A I_LADDER_ERR_A I_LADDER_ERR_PCT PMOS_GATE_V PMOS_ID_A PMOS_GM_S PMOS_GMBS_S PMOS_GDS_S PMOS_GMID PMOS_VGS PMOS_VDS PMOS_VBS PMOS_VTH PMOS_VOV_ABS PMOS_VDSAT PMOS_SAT_MARGIN PMOS_RO PMOS_GMRO IDD_TOTAL_A PDC_UW MARGIN_I_A MARGIN_VTOP_V MARGIN_VSENSE_V MARGIN_SAT_V MARGIN_GATE_LOW_V MARGIN_GATE_HIGH_V > bias_current_pmos_sizing_table.txt

* ============================================================
* Sweep
* ============================================================

foreach lval 1u 2u
  foreach wval 20u 30u 40u 50u 70u 100u
    foreach vddtest 4.5 5.0 5.5
      foreach temptest -40 27 125

        alterparam VDDVAL = $vddtest
        alterparam WPMOS = $wval
        alterparam LPMOS = $lval

        reset
        set temp = $temptest
        save all
        op

        * ------------------------------------------------------------
        * Constants, recreated after reset
        * ------------------------------------------------------------

        let target_i_ladder = 20u
        let target_vtop = 3.7

        let limit_i_err = 1u
        let limit_vtop_err = 30m
        let limit_vsense_err = 5m
        let limit_sat_margin = 0.2
        let limit_gate_low = 0.2
        let limit_gate_high_margin = 0.2

        * ------------------------------------------------------------
        * Node voltages
        * ------------------------------------------------------------

        let v_vdd = v(vdd)
        let v_pgate = v(vref)
        let v_vbg = v(vp)
        let v_vtop = v(vtop)

        let v_vbias_cas_cg = v(vbias_cas_cg)
        let v_vbias_casc = v(vbias_casc)
        let v_vbias_cg = v(vbias_cg)
        let v_vbias_icg = v(vbias_icg)
        let v_vbias_13 = v(vbias_13)
        let v_vsense = v(vsense)
        let v_vbias_csc = v(vbias_csc)

        let err_vbg_vsense = v(vp)-v(vsense)
        let abs_err_vsense = abs(err_vbg_vsense)

        let err_vtop = v(vtop)-target_vtop
        let abs_err_vtop = abs(err_vtop)

        * ------------------------------------------------------------
        * Correct ladder currents
        *
        * These values match the actual retuned schematic:
        *   R6 = 8.066k
        *   R7 = 11.934k
        * ------------------------------------------------------------

        let i_r1 = (v(vtop)-v(vbias_cas_cg))/20k
        let i_r2 = (v(vbias_cas_cg)-v(vbias_casc))/5k
        let i_r3 = (v(vbias_casc)-v(vbias_cg))/50k
        let i_r4 = (v(vbias_cg)-v(vbias_icg))/15k
        let i_r5 = (v(vbias_icg)-v(vbias_13))/30k
        let i_r6 = (v(vbias_13)-v(vsense))/8.066k
        let i_r7 = (v(vsense)-v(vbias_csc))/11.934k
        let i_r8 = v(vbias_csc)/45k

        let i_ladder_avg = (i_r1+i_r2+i_r3+i_r4+i_r5+i_r6+i_r7+i_r8)/8
        let i_ladder_err = i_ladder_avg-target_i_ladder
        let abs_i_ladder_err = abs(i_ladder_err)
        let i_ladder_err_pct = 100*i_ladder_err/target_i_ladder

        * ------------------------------------------------------------
        * PMOS operating point for XM1
        * ------------------------------------------------------------

        let id_xm1 = abs(@m.xm1.m0[id])
        let gm_xm1 = @m.xm1.m0[gm]
        let gmb_xm1 = @m.xm1.m0[gmbs]
        let gds_xm1 = @m.xm1.m0[gds]
        let vgs_xm1 = @m.xm1.m0[vgs]
        let vds_xm1 = @m.xm1.m0[vds]
        let vbs_xm1 = @m.xm1.m0[vbs]
        let vth_xm1 = @m.xm1.m0[vth]
        let vdsat_xm1 = abs(@m.xm1.m0[vdsat])

        let vov_xm1 = abs(vgs_xm1)-abs(vth_xm1)
        let sat_xm1 = abs(vds_xm1)-vdsat_xm1
        let gmid_xm1 = gm_xm1/(id_xm1+1e-30)
        let ro_xm1 = 1/(gds_xm1+1e-30)
        let gmro_xm1 = gm_xm1*ro_xm1

        * ------------------------------------------------------------
        * Supply power
        * ------------------------------------------------------------

        let idd_total = -i(v3)
        let pdc_w = v(vdd)*idd_total
        let pdc_uw = 1e6*pdc_w

        * ------------------------------------------------------------
        * Pass/fail margins
        *
        * Positive margin = pass.
        * Negative margin = fail.
        * No < or > operators are used.
        * ------------------------------------------------------------

        let gate_high_limit = v(vdd)-limit_gate_high_margin

        let margin_i = limit_i_err-abs_i_ladder_err
        let margin_vtop = limit_vtop_err-abs_err_vtop
        let margin_vsense = limit_vsense_err-abs_err_vsense
        let margin_sat = sat_xm1-limit_sat_margin
        let margin_gate_low = v(vref)-limit_gate_low
        let margin_gate_high = gate_high_limit-v(vref)

        * ------------------------------------------------------------
        * Detailed report
        * ------------------------------------------------------------

        echo CASE PMOS_SIZE_VDD_TEMP_SWEEP W $wval L $lval TEMP_C $temptest VDD $vddtest >> bias_current_pmos_sizing_test_report.txt
        echo ------------------------------------------------------------ >> bias_current_pmos_sizing_test_report.txt

        echo NODE_VOLTAGES >> bias_current_pmos_sizing_test_report.txt
        echo VDD_V $&v_vdd >> bias_current_pmos_sizing_test_report.txt
        echo VBG_V $&v_vbg >> bias_current_pmos_sizing_test_report.txt
        echo VSENSE_V $&v_vsense >> bias_current_pmos_sizing_test_report.txt
        echo ERR_VBG_MINUS_VSENSE_V $&err_vbg_vsense >> bias_current_pmos_sizing_test_report.txt
        echo VTOP_V $&v_vtop >> bias_current_pmos_sizing_test_report.txt
        echo VBIAS_CAS_CG_V $&v_vbias_cas_cg >> bias_current_pmos_sizing_test_report.txt
        echo VBIAS_CASC_V $&v_vbias_casc >> bias_current_pmos_sizing_test_report.txt
        echo VBIAS_CG_V $&v_vbias_cg >> bias_current_pmos_sizing_test_report.txt
        echo VBIAS_ICG_V $&v_vbias_icg >> bias_current_pmos_sizing_test_report.txt
        echo VBIAS_13_V $&v_vbias_13 >> bias_current_pmos_sizing_test_report.txt
        echo VSENSE_V $&v_vsense >> bias_current_pmos_sizing_test_report.txt
        echo VBIAS_CSC_V $&v_vbias_csc >> bias_current_pmos_sizing_test_report.txt

        echo LADDER_CURRENTS >> bias_current_pmos_sizing_test_report.txt
        echo I_R1_A $&i_r1 >> bias_current_pmos_sizing_test_report.txt
        echo I_R2_A $&i_r2 >> bias_current_pmos_sizing_test_report.txt
        echo I_R3_A $&i_r3 >> bias_current_pmos_sizing_test_report.txt
        echo I_R4_A $&i_r4 >> bias_current_pmos_sizing_test_report.txt
        echo I_R5_A $&i_r5 >> bias_current_pmos_sizing_test_report.txt
        echo I_R6_A $&i_r6 >> bias_current_pmos_sizing_test_report.txt
        echo I_R7_A $&i_r7 >> bias_current_pmos_sizing_test_report.txt
        echo I_R8_A $&i_r8 >> bias_current_pmos_sizing_test_report.txt
        echo I_LADDER_AVG_A $&i_ladder_avg >> bias_current_pmos_sizing_test_report.txt
        echo I_LADDER_ERR_A $&i_ladder_err >> bias_current_pmos_sizing_test_report.txt
        echo I_LADDER_ERR_PCT $&i_ladder_err_pct >> bias_current_pmos_sizing_test_report.txt

        echo PMOS_OPERATING_POINT >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_GATE_V $&v_pgate >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_ID_A $&id_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_GM_S $&gm_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_GMBS_S $&gmb_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_GDS_S $&gds_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_VGS_V $&vgs_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_VDS_V $&vds_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_VBS_V $&vbs_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_VTH_V $&vth_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_VOV_ABS_V $&vov_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_VDSAT_ABS_V $&vdsat_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_SAT_MARGIN_V $&sat_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_GMID_1_PER_V $&gmid_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_RO_OHM $&ro_xm1 >> bias_current_pmos_sizing_test_report.txt
        echo PMOS_GMRO $&gmro_xm1 >> bias_current_pmos_sizing_test_report.txt

        echo SUPPLY_POWER >> bias_current_pmos_sizing_test_report.txt
        echo IDD_TOTAL_A $&idd_total >> bias_current_pmos_sizing_test_report.txt
        echo PDC_UW $&pdc_uw >> bias_current_pmos_sizing_test_report.txt

        echo PASS_FAIL_MARGINS >> bias_current_pmos_sizing_test_report.txt
        echo NOTE_POSITIVE_MARGIN_MEANS_PASS >> bias_current_pmos_sizing_test_report.txt
        echo MARGIN_I_A $&margin_i >> bias_current_pmos_sizing_test_report.txt
        echo MARGIN_VTOP_V $&margin_vtop >> bias_current_pmos_sizing_test_report.txt
        echo MARGIN_VSENSE_V $&margin_vsense >> bias_current_pmos_sizing_test_report.txt
        echo MARGIN_SAT_V $&margin_sat >> bias_current_pmos_sizing_test_report.txt
        echo MARGIN_GATE_LOW_V $&margin_gate_low >> bias_current_pmos_sizing_test_report.txt
        echo MARGIN_GATE_HIGH_V $&margin_gate_high >> bias_current_pmos_sizing_test_report.txt
        echo . >> bias_current_pmos_sizing_test_report.txt

        * ------------------------------------------------------------
        * Compact table
        * ------------------------------------------------------------

        echo PMOS_SWEEP $wval $lval $temptest $&v_vdd $&v_vbg $&v_vsense $&err_vbg_vsense $&v_vtop $&v_vbias_cas_cg $&v_vbias_casc $&v_vbias_cg $&v_vbias_icg $&v_vbias_13 $&v_vbias_csc $&i_r1 $&i_r2 $&i_r3 $&i_r4 $&i_r5 $&i_r6 $&i_r7 $&i_r8 $&i_ladder_avg $&i_ladder_err $&i_ladder_err_pct $&v_pgate $&id_xm1 $&gm_xm1 $&gmb_xm1 $&gds_xm1 $&gmid_xm1 $&vgs_xm1 $&vds_xm1 $&vbs_xm1 $&vth_xm1 $&vov_xm1 $&vdsat_xm1 $&sat_xm1 $&ro_xm1 $&gmro_xm1 $&idd_total $&pdc_uw $&margin_i $&margin_vtop $&margin_vsense $&margin_sat $&margin_gate_low $&margin_gate_high >> bias_current_pmos_sizing_table.txt

      end
    end
  end
end

echo FILES_WRITTEN >> bias_current_pmos_sizing_test_report.txt
echo ------------------------------------------------------------ >> bias_current_pmos_sizing_test_report.txt
echo bias_current_pmos_sizing_test_report.txt >> bias_current_pmos_sizing_test_report.txt
echo bias_current_pmos_sizing_table.txt >> bias_current_pmos_sizing_test_report.txt
echo . >> bias_current_pmos_sizing_test_report.txt

echo INTERPRETATION_GUIDE >> bias_current_pmos_sizing_test_report.txt
echo ------------------------------------------------------------ >> bias_current_pmos_sizing_test_report.txt
echo Positive margin columns indicate pass for that metric. >> bias_current_pmos_sizing_test_report.txt
echo MARGIN_I_A checks absolute average ladder-current error against 1uA. >> bias_current_pmos_sizing_test_report.txt
echo MARGIN_VTOP_V checks absolute VTOP error against 30mV. >> bias_current_pmos_sizing_test_report.txt
echo MARGIN_VSENSE_V checks absolute VP-minus-VSENSE error against 5mV. >> bias_current_pmos_sizing_test_report.txt
echo MARGIN_SAT_V checks PMOS saturation margin beyond the required 0.2V. >> bias_current_pmos_sizing_test_report.txt
echo This report ignores i(Vmeas); use resistor currents and XM1 device current instead. >> bias_current_pmos_sizing_test_report.txt
echo . >> bias_current_pmos_sizing_test_report.txt

echo ============================================================ >> bias_current_pmos_sizing_test_report.txt
echo END_OF_PMOS_SIZING_TEST_REPORT >> bias_current_pmos_sizing_test_report.txt
echo ============================================================ >> bias_current_pmos_sizing_test_report.txt

.endc

"
}
C {devices/launcher.sym} -370 -920 0 0 {name=h2
descr="simulate" 
tclcommand="xschem save; xschem netlist; xschem simulate"
}
C {devices/launcher.sym} -130 -920 0 0 {name=h3
descr="annotate OP" 
tclcommand="set show_hidden_texts 1; xschem annotate_op"
}
C {lab_pin.sym} 620 -1200 0 0 {name=p5 sig_type=std_logic lab=vp}
C {lab_pin.sym} 940 -1170 0 0 {name=p6 sig_type=std_logic lab=vref}
C {/home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/xschem/bandgap.sym} 400 -1100 0 0 {name=x1}
C {/home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/xschem/ota-5t.sym} 690 -1090 0 0 {name=x3}
C {code_shown.sym} 60 55 0 0 {name=MODELS1 only_toplevel=true
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
C {lab_pin.sym} 660 -1140 0 0 {name=p9 sig_type=std_logic lab=vp}
C {res.sym} 1010 -810 0 0 {name=R3
value=50k
footprint=1206
device=resistor
m=1}
C {res.sym} 1010 -710 0 0 {name=R4
value=15k
footprint=1206
device=resistor
m=1}
C {res.sym} 1010 -610 0 0 {name=R5
value=30k
footprint=1206
device=resistor
m=1}
C {res.sym} 1010 -510 0 0 {name=R6
value=8.066k
footprint=1206
device=resistor
m=1}
C {res.sym} 1010 -410 0 0 {name=R7
value=11.934k
footprint=1206
device=resistor
m=1}
C {res.sym} 1010 -310 0 0 {name=R8
value=45k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 1010 -1060 2 0 {name=p10 sig_type=std_logic lab=vtop}
C {lab_pin.sym} 1010 -960 2 0 {name=p11 sig_type=std_logic lab=vbias_cas_cg}
C {lab_pin.sym} 1010 -860 2 0 {name=p12 sig_type=std_logic lab=vbias_casc}
C {lab_pin.sym} 1010 -760 2 0 {name=p13 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 1010 -660 2 0 {name=p14 sig_type=std_logic lab=vbias_icg}
C {lab_pin.sym} 1010 -560 2 0 {name=p15 sig_type=std_logic lab=vbias_13 }
C {lab_pin.sym} 1010 -460 2 0 {name=p16 sig_type=std_logic lab=vsense}
C {lab_pin.sym} 1010 -360 2 0 {name=p17 sig_type=std_logic lab=vbias_csc}
C {lab_pin.sym} 670 -1200 1 0 {name=p7 sig_type=std_logic lab=vsense}
C {symbols/pfet_05v0.sym} 990 -1170 0 0 {name=M1
L=\{LPMOS\}
W=\{WPMOS\}
nf=10
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_05v0
spiceprefix=X
}
