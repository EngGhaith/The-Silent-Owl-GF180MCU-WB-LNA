v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 980 -400 980 -360 {lab=vdd}
N 800 -300 840 -300 {lab=rf_in_pad}
N 1120 -300 1160 -300 {lab=rf_out_pad}
N 980 -220 980 -180 {lab=vss}
N 480 -190 520 -190 {lab=rf_in_pad}
N 320 -300 320 -260 {lab=vddio}
N 320 -120 320 -80 {lab=0}
N 360 -300 360 -260 {lab=vddio}
N 360 -120 360 -80 {lab=0}
N 1770 -240 1810 -240 {lab=rf_out_pad}
N 1610 -350 1610 -310 {lab=vddio}
N 1610 -170 1610 -130 {lab=0}
N 1650 -350 1650 -310 {lab=vddio}
N 1650 -170 1650 -130 {lab=0}
N 270 -450 310 -450 {lab=rf_in_pad}
N 370 -450 410 -450 {lab=nbw1}
N 410 -450 450 -450 {lab=nbw1}
N 510 -450 550 -450 {lab=rf_in_ext}
N 1530 -490 1570 -490 {lab=rf_out_pad}
N 1630 -490 1670 -490 {lab=nbw2}
N 1670 -490 1710 -490 {lab=nbw2}
N 1770 -490 1810 -490 {lab=rf_out_ext}
N -400 -370 -400 -330 {lab=vdd}
N -400 -270 -400 -230 {lab=0}
N -250 -370 -250 -330 {lab=vss}
N -250 -270 -250 -230 {lab=0}
N -100 -370 -100 -330 {lab=vddio}
N -100 -270 -100 -230 {lab=0}
N -190 -700 -150 -700 {
lab=rf_in_ext}
N -190 -640 -150 -640 {
lab=GND}
N -190 -550 -150 -550 {
lab=rf_out_ext}
N -190 -490 -150 -490 {
lab=GND}
C {lab_pin.sym} 980 -400 1 0 {name=l1 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 800 -300 0 0 {name=l2 sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 1160 -300 2 0 {name=l3 sig_type=std_logic lab=rf_out_pad}
C {lab_pin.sym} 980 -180 3 0 {name=l4 sig_type=std_logic lab=vss}
C {/home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.sym} 330 -190 0 0 {name=x3
model=gf180mcu_fd_io__asig_5p0
}
C {lab_pin.sym} 520 -190 2 0 {name=l5 sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 320 -300 1 0 {name=l6 sig_type=std_logic lab=vddio}
C {lab_pin.sym} 360 -300 1 0 {name=l8 sig_type=std_logic lab=vddio}
C {/home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.sym} 1620 -240 0 0 {name=x4
model=gf180mcu_fd_io__asig_5p0
}
C {lab_pin.sym} 1810 -240 2 0 {name=l10 sig_type=std_logic lab=rf_out_pad}
C {lab_pin.sym} 1610 -350 1 0 {name=l11 sig_type=std_logic lab=vddio}
C {lab_pin.sym} 1650 -350 1 0 {name=l13 sig_type=std_logic lab=vddio}
C {ind.sym} 340 -450 1 0 {name=LBW_IN
m=1
value=\{L_BW\}
}
C {lab_pin.sym} 270 -450 0 0 {name=l15 sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 400 -450 1 0 {name=l16 sig_type=std_logic lab=nbw1}
C {res.sym} 480 -450 3 0 {name=RBW_IN
value=\{R_BW\}
m=1
}
C {lab_pin.sym} 550 -450 2 0 {name=l18 sig_type=std_logic lab=rf_in_ext}
C {ind.sym} 1600 -490 1 0 {name=LBW_OUT
m=1
value=\{L_BW\}
}
C {lab_pin.sym} 1530 -490 0 0 {name=l19 sig_type=std_logic lab=rf_out_pad}
C {res.sym} 1740 -490 3 0 {name=RBW_OUT
value=\{R_BW\}
m=1
}
C {lab_pin.sym} 1680 -490 1 0 {name=l21 sig_type=std_logic lab=nbw2}
C {lab_pin.sym} 1810 -490 2 0 {name=l22 sig_type=std_logic lab=rf_out_ext}
C {vsource.sym} -400 -300 0 0 {name=VDD
value=\{VDD\}
savecurrent=false
}
C {lab_pin.sym} -400 -370 1 0 {name=l23 sig_type=std_logic lab=vdd}
C {vsource.sym} -250 -300 0 0 {name=VSS
value=0
savecurrent=false
}
C {lab_pin.sym} -250 -370 1 0 {name=l25 sig_type=std_logic lab=vss}
C {vsource.sym} -100 -300 0 0 {name=VDDIO
value=\{VDDIO_SUP\}
savecurrent=false
}
C {lab_pin.sym} -100 -370 1 0 {name=l27 sig_type=std_logic lab=vddio}
C {code_shown.sym} 90 80 0 0 {name=MODELS only_toplevel=false
format="tcleval( @value )"
value="
.include $\{::180MCU_MODELS\}/design.ngspice
.lib $\{::180MCU_MODELS\}/sm141064.ngspice typical
.lib $\{::180MCU_MODELS\}/sm141064.ngspice res_typical
.lib $\{::180MCU_MODELS\}/sm141064.ngspice moscap_typical
.lib $\{::180MCU_MODELS\}/sm141064.ngspice diode_typical
.lib $\{::180MCU_MODELS\}/sm141064.ngspice bjt_typical
.lib $\{::180MCU_MODELS\}/sm141064.ngspice mimcap_typical
"}
C {code_shown.sym} -900 480 0 0 {name=PADS only_toplevel=false
value="
* extracted RC pad network (magic flat RC extraction, nominal); high-C corner: pad_rcxhrhc.spice
*.include /home/arjun/.xschem/simulations/lna_test/optimization/pad_audit/pad_rcxnom.spice
.include /home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/extracted_gf180mcu_fd_io__asig_5p0_manually_scaled.spice
"}
C {code_shown.sym} 1070 70 0 0 {name=PARAMS only_toplevel=false
value="
.param VDD=5.0 VDDIO_SUP=5.0 L_BW=3n R_BW=0.2
.temp 27
"}
C {code_shown.sym} 1100 210 0 0 {name=CONTROL only_toplevel=false
value="
.control
op
print all
sp lin 201 2.3G 2.5G 0
write lna_c5_top_tb_sp.raw
.endc
"
spice_ignore=true}
C {gnd.sym} -100 -230 0 0 {name=l17 lab=0}
C {gnd.sym} -250 -230 0 0 {name=l7 lab=0}
C {gnd.sym} -400 -230 0 0 {name=l9 lab=0}
C {gnd.sym} 320 -80 0 0 {name=l12 lab=0}
C {gnd.sym} 360 -80 0 0 {name=l14 lab=0}
C {gnd.sym} 1610 -130 0 0 {name=l20 lab=0}
C {gnd.sym} 1650 -130 0 0 {name=l24 lab=0}
C {lab_pin.sym} -150 -700 2 0 {name=p5 sig_type=std_logic lab=rf_in_ext}
C {lab_pin.sym} -150 -640 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} -150 -490 2 0 {name=p8 sig_type=std_logic lab=GND}
C {lab_pin.sym} -150 -550 2 0 {name=p7 sig_type=std_logic lab=rf_out_ext}
C {/home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/NFmin_Simulation/simulations/port_diff.sym} -190 -670 0 0 {name=V3 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=}
C {/home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/NFmin_Simulation/simulations/port_diff.sym} -190 -520 0 0 {name=V4 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=}
C {lna_top.sym} 980 -300 0 0 {name=x1}
C {code_shown.sym} 1110 480 0 0 {name=CONTROL1 only_toplevel=false
value="

.control

set noaskquit
set wr_singlescale
set wr_vecnames
set numdgt=10

option klu
set num_threads=6

let spec_gain_min_db = 10
let spec_s11_max_db  = -10
let spec_s22_max_db  = -10
let spec_nf_max_db   = 2.0
let spec_mu_min      = 1.0
let spec_k_min       = 1.0
let spec_delta_max   = 1.0
let spec_pdc_max_mw  = 130

let f_target_lo = 2.3e9
let f_target    = 2.4e9
let f_target_hi = 2.5e9



echo ============================================================ > lna_final_report.txt
echo GF180MCU_WIDEBAND_LNA_FINAL_CHARACTERIZATION >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt
echo TARGET_CENTER_HZ 2.400e9 >> lna_final_report.txt
echo TARGET_BAND_HZ 2.300e9 2.500e9 >> lna_final_report.txt
echo PORT_REFERENCE_OHM 50 >> lna_final_report.txt
echo VDD_NOMINAL_V 5.0 >> lna_final_report.txt
echo HIERARCHY TB_X1_LNA_TOP_X1_LNA_CORE >> lna_final_report.txt
echo S_PARAMETER_REFERENCE_PLANE EXTERNAL_PORTS_INCLUDING_PADS_BONDWIRES >> lna_final_report.txt

echo SPEC_GAIN_MIN_DB $&spec_gain_min_db >> lna_final_report.txt
echo SPEC_S11_MAX_DB $&spec_s11_max_db >> lna_final_report.txt
echo SPEC_S22_MAX_DB $&spec_s22_max_db >> lna_final_report.txt
echo SPEC_NF_MAX_DB $&spec_nf_max_db >> lna_final_report.txt
echo SPEC_PDC_MAX_MW $&spec_pdc_max_mw >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt


op


let pdc_lna_mw = 1e3*abs(i(VDD))*v(vdd)
let pdc_io_mw  = 1e3*abs(i(VDDIO))*v(vddio)
let pdc_total_mw = pdc_lna_mw+pdc_io_mw

let idd_lna = abs(i(VDD))
let idd_io  = abs(i(VDDIO))

set op_pdc_lna   = $&pdc_lna_mw
set op_pdc_io    = $&pdc_io_mw
set op_pdc_total = $&pdc_total_mw
set op_idd_lna   = $&idd_lna
set op_idd_io    = $&idd_io



let vbias_cg_op   = v(x1.vbias_cg)
let vbias_cs_op   = v(x1.vbias_cs)
let vbias_csc_op  = v(x1.vbias_csc)
let vbias_cas_op  = v(x1.vbias_cas)
let vbias_casc_op = v(x1.vbias_casc)

set op_vbias_cg   = $&vbias_cg_op
set op_vbias_cs   = $&vbias_cs_op
set op_vbias_csc  = $&vbias_csc_op
set op_vbias_cas  = $&vbias_cas_op
set op_vbias_casc = $&vbias_casc_op


let vm2_op     = v(x1.x1.vm2)
let gcg_op     = v(x1.x1.g_cg)

let gcs_op     = v(x1.x1.g_cs)
let xm1s_op    = v(x1.x1.xm1_s)
let vm1_op     = v(x1.x1.vm1)

let gcsc_op    = v(x1.x1.g_csc)
let xm9s_op    = v(x1.x1.xm9_s)
let xm9d_op    = v(x1.x1.xm9_d)

let vx_op      = v(x1.x1.vx)

let vbp3_op    = v(x1.x1.vbp3)
let ngp3_op    = v(x1.x1.ngp3)
let np3d_op    = v(x1.x1.np3d)
let noutc_op   = v(x1.x1.nout_c)

set op_vm2   = $&vm2_op
set op_gcg   = $&gcg_op
set op_gcs   = $&gcs_op
set op_xm1s  = $&xm1s_op
set op_vm1   = $&vm1_op
set op_gcsc  = $&gcsc_op
set op_xm9s  = $&xm9s_op
set op_xm9d  = $&xm9d_op
set op_vx    = $&vx_op
set op_vbp3  = $&vbp3_op
set op_ngp3  = $&ngp3_op
set op_np3d  = $&np3d_op
set op_noutc = $&noutc_op

let id1    = abs(@m.x1.x1.xm1.m0[id])
let gm1    = abs(@m.x1.x1.xm1.m0[gm])
let gmb1   = abs(@m.x1.x1.xm1.m0[gmbs])
let gds1   = abs(@m.x1.x1.xm1.m0[gds])

let vgs1   = @m.x1.x1.xm1.m0[vgs]
let vds1   = @m.x1.x1.xm1.m0[vds]
let vth1   = @m.x1.x1.xm1.m0[vth]
let vdsat1 = @m.x1.x1.xm1.m0[vdsat]

let gmid1  = gm1/(id1+1e-30)
let ro1    = 1/(gds1+1e-30)
let sat1   = abs(vds1)-abs(vdsat1)

let id2    = abs(@m.x1.x1.xm2.m0[id])
let gm2    = abs(@m.x1.x1.xm2.m0[gm])
let gmb2   = abs(@m.x1.x1.xm2.m0[gmbs])
let gds2   = abs(@m.x1.x1.xm2.m0[gds])

let vgs2   = @m.x1.x1.xm2.m0[vgs]
let vds2   = @m.x1.x1.xm2.m0[vds]
let vth2   = @m.x1.x1.xm2.m0[vth]
let vdsat2 = @m.x1.x1.xm2.m0[vdsat]

let gmid2  = gm2/(id2+1e-30)
let ro2    = 1/(gds2+1e-30)
let sat2   = abs(vds2)-abs(vdsat2)

let id4    = abs(@m.x1.x1.xm4.m0[id])
let gm4    = abs(@m.x1.x1.xm4.m0[gm])
let gmb4   = abs(@m.x1.x1.xm4.m0[gmbs])
let gds4   = abs(@m.x1.x1.xm4.m0[gds])

let vgs4   = @m.x1.x1.xm4.m0[vgs]
let vds4   = @m.x1.x1.xm4.m0[vds]
let vth4   = @m.x1.x1.xm4.m0[vth]
let vdsat4 = @m.x1.x1.xm4.m0[vdsat]

let gmid4  = gm4/(id4+1e-30)
let ro4    = 1/(gds4+1e-30)
let sat4   = abs(vds4)-abs(vdsat4)

let id9    = abs(@m.x1.x1.xm9.m0[id])
let gm9    = abs(@m.x1.x1.xm9.m0[gm])
let gmb9   = abs(@m.x1.x1.xm9.m0[gmbs])
let gds9   = abs(@m.x1.x1.xm9.m0[gds])

let vgs9   = @m.x1.x1.xm9.m0[vgs]
let vds9   = @m.x1.x1.xm9.m0[vds]
let vth9   = @m.x1.x1.xm9.m0[vth]
let vdsat9 = @m.x1.x1.xm9.m0[vdsat]

let gmid9  = gm9/(id9+1e-30)
let ro9    = 1/(gds9+1e-30)
let sat9   = abs(vds9)-abs(vdsat9)

let id7    = abs(@m.x1.x1.xm7.m0[id])
let gm7    = abs(@m.x1.x1.xm7.m0[gm])
let gmb7   = abs(@m.x1.x1.xm7.m0[gmbs])
let gds7   = abs(@m.x1.x1.xm7.m0[gds])

let vgs7   = @m.x1.x1.xm7.m0[vgs]
let vds7   = @m.x1.x1.xm7.m0[vds]
let vth7   = @m.x1.x1.xm7.m0[vth]
let vdsat7 = @m.x1.x1.xm7.m0[vdsat]

let gmid7  = gm7/(id7+1e-30)
let ro7    = 1/(gds7+1e-30)
let sat7   = abs(vds7)-abs(vdsat7)

let idp3    = abs(@m.x1.x1.xmp3.m0[id])
let gmp3    = abs(@m.x1.x1.xmp3.m0[gm])
let gmbp3   = abs(@m.x1.x1.xmp3.m0[gmbs])
let gdsp3   = abs(@m.x1.x1.xmp3.m0[gds])

let vgsp3   = @m.x1.x1.xmp3.m0[vgs]
let vdsp3   = @m.x1.x1.xmp3.m0[vds]
let vthp3   = @m.x1.x1.xmp3.m0[vth]
let vdsatp3 = @m.x1.x1.xmp3.m0[vdsat]

let gmidp3  = gmp3/(idp3+1e-30)
let rop3    = 1/(gdsp3+1e-30)
let satp3   = abs(vdsp3)-abs(vdsatp3)


let idbp3    = abs(@m.x1.x1.xbp3.m0[id])
let gmbp3x   = abs(@m.x1.x1.xbp3.m0[gm])
let gdsbp3   = abs(@m.x1.x1.xbp3.m0[gds])

let vgsbp3   = @m.x1.x1.xbp3.m0[vgs]
let vdsbp3   = @m.x1.x1.xbp3.m0[vds]
let vthbp3   = @m.x1.x1.xbp3.m0[vth]
let vdsatbp3 = @m.x1.x1.xbp3.m0[vdsat]

let gmidbp3 = gmbp3x/(idbp3+1e-30)
let robp3   = 1/(gdsbp3+1e-30)
let satbp3  = abs(vdsbp3)-abs(vdsatbp3)

set op_id1=$&id1
set op_gm1=$&gm1
set op_gmid1=$&gmid1
set op_ro1=$&ro1
set op_vgs1=$&vgs1
set op_vds1=$&vds1
set op_vdsat1=$&vdsat1
set op_sat1=$&sat1

set op_id2=$&id2
set op_gm2=$&gm2
set op_gmid2=$&gmid2
set op_ro2=$&ro2
set op_vgs2=$&vgs2
set op_vds2=$&vds2
set op_vdsat2=$&vdsat2
set op_sat2=$&sat2

set op_id4=$&id4
set op_gm4=$&gm4
set op_gmid4=$&gmid4
set op_ro4=$&ro4
set op_vgs4=$&vgs4
set op_vds4=$&vds4
set op_vdsat4=$&vdsat4
set op_sat4=$&sat4

set op_id9=$&id9
set op_gm9=$&gm9
set op_gmid9=$&gmid9
set op_ro9=$&ro9
set op_vgs9=$&vgs9
set op_vds9=$&vds9
set op_vdsat9=$&vdsat9
set op_sat9=$&sat9

set op_id7=$&id7
set op_gm7=$&gm7
set op_gmid7=$&gmid7
set op_ro7=$&ro7
set op_vgs7=$&vgs7
set op_vds7=$&vds7
set op_vdsat7=$&vdsat7
set op_sat7=$&sat7

set op_idp3=$&idp3
set op_gmp3=$&gmp3
set op_gmidp3=$&gmidp3
set op_rop3=$&rop3
set op_vgsp3=$&vgsp3
set op_vdsp3=$&vdsp3
set op_vdsatp3=$&vdsatp3
set op_satp3=$&satp3

set op_idbp3=$&idbp3
set op_gmbp3=$&gmbp3x
set op_gmidbp3=$&gmidbp3
set op_robp3=$&robp3
set op_vgsbp3=$&vgsbp3
set op_vdsbp3=$&vdsbp3
set op_vdsatbp3=$&vdsatbp3
set op_satbp3=$&satbp3


* ============================================================================
* WRITE DC REPORT
* ============================================================================

echo ============================================================ >> lna_final_report.txt
echo DC_POWER >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

echo LNA_TOP_POWER_MW $op_pdc_lna >> lna_final_report.txt
echo IO_PAD_POWER_MW $op_pdc_io >> lna_final_report.txt
echo TOTAL_POWER_MW $op_pdc_total >> lna_final_report.txt
echo LNA_TOP_CURRENT_A $op_idd_lna >> lna_final_report.txt
echo IO_CURRENT_A $op_idd_io >> lna_final_report.txt


echo ============================================================ >> lna_final_report.txt
echo BIAS_VOLTAGES >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

echo VBIAS_CG_V $op_vbias_cg >> lna_final_report.txt
echo VBIAS_CS_V $op_vbias_cs >> lna_final_report.txt
echo VBIAS_CSC_V $op_vbias_csc >> lna_final_report.txt
echo VBIAS_CAS_V $op_vbias_cas >> lna_final_report.txt
echo VBIAS_CASC_V $op_vbias_casc >> lna_final_report.txt


echo ============================================================ >> lna_final_report.txt
echo CORE_DC_NODE_VOLTAGES >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

echo VM2_V $op_vm2 >> lna_final_report.txt
echo G_CG_V $op_gcg >> lna_final_report.txt

echo G_CS_V $op_gcs >> lna_final_report.txt
echo XM1_SOURCE_V $op_xm1s >> lna_final_report.txt
echo VM1_V $op_vm1 >> lna_final_report.txt

echo G_CSC_V $op_gcsc >> lna_final_report.txt
echo XM9_SOURCE_V $op_xm9s >> lna_final_report.txt
echo XM9_DRAIN_V $op_xm9d >> lna_final_report.txt

echo VX_V $op_vx >> lna_final_report.txt

echo VBP3_V $op_vbp3 >> lna_final_report.txt
echo NGP3_V $op_ngp3 >> lna_final_report.txt
echo NP3D_V $op_np3d >> lna_final_report.txt
echo NOUT_C_V $op_noutc >> lna_final_report.txt


echo ============================================================ >> lna_final_report.txt
echo TRANSISTOR_OPERATING_POINTS >> lna_final_report.txt
echo FIELDS ID_A GM_S GMID_1_PER_V RO_OHM VGS_V VDS_V VDSAT_V SAT_MARGIN_V >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

echo XM1_MAIN_CS ID $op_id1 GM $op_gm1 GMID $op_gmid1 RO $op_ro1 VGS $op_vgs1 VDS $op_vds1 VDSAT $op_vdsat1 SAT_MARGIN $op_sat1 >> lna_final_report.txt

echo XM2_INPUT_CG ID $op_id2 GM $op_gm2 GMID $op_gmid2 RO $op_ro2 VGS $op_vgs2 VDS $op_vds2 VDSAT $op_vdsat2 SAT_MARGIN $op_sat2 >> lna_final_report.txt

echo XM4_MAIN_CASCODE ID $op_id4 GM $op_gm4 GMID $op_gmid4 RO $op_ro4 VGS $op_vgs4 VDS $op_vds4 VDSAT $op_vdsat4 SAT_MARGIN $op_sat4 >> lna_final_report.txt

echo XM9_CANCELLATION_CS ID $op_id9 GM $op_gm9 GMID $op_gmid9 RO $op_ro9 VGS $op_vgs9 VDS $op_vds9 VDSAT $op_vdsat9 SAT_MARGIN $op_sat9 >> lna_final_report.txt

echo XM7_CANCELLATION_CASCODE ID $op_id7 GM $op_gm7 GMID $op_gmid7 RO $op_ro7 VGS $op_vgs7 VDS $op_vds7 VDSAT $op_vdsat7 SAT_MARGIN $op_sat7 >> lna_final_report.txt

echo XMP3_OUTPUT_PMOS ID $op_idp3 GM $op_gmp3 GMID $op_gmidp3 RO $op_rop3 VGS $op_vgsp3 VDS $op_vdsp3 VDSAT $op_vdsatp3 SAT_MARGIN $op_satp3 >> lna_final_report.txt

echo XBP3_PMOS_BIAS ID $op_idbp3 GM $op_gmbp3 GMID $op_gmidbp3 RO $op_robp3 VGS $op_vgsbp3 VDS $op_vdsbp3 VDSAT $op_vdsatbp3 SAT_MARGIN $op_satbp3 >> lna_final_report.txt


* ============================================================================
* POWER SPECIFICATION CHECK
* ============================================================================

echo ============================================================ >> lna_final_report.txt
echo DC_SPEC_CHECK >> lna_final_report.txt

if pdc_lna_mw <= spec_pdc_max_mw
    echo POWER PASS >> lna_final_report.txt
else
    echo POWER FAIL >> lna_final_report.txt
end


* We no longer require OP plot vectors after storing scalar values.
destroy $curplot



* ============================================================================
* 2. BROADBAND S-PARAMETER + NOISE ANALYSIS
*
* SP noise flag = 1.
*
* 7000 linearly spaced points:
*   1 MHz --> 7 GHz
*
* This gives roughly 1 MHz resolution, including the complete 2.3-2.5 GHz
* target band.
* ============================================================================

reset
sp lin 7000 1Meg 7Gig 1

set rfplot=$curplot

let fghz=frequency/1e9


* ============================================================================
* S PARAMETERS
* ============================================================================

let s11db=db(s_1_1)
let s21db=db(s_2_1)
let s12db=db(s_1_2)
let s22db=db(s_2_2)

let a11=mag(s_1_1)
let a21=mag(s_2_1)
let a12=mag(s_1_2)
let a22=mag(s_2_2)


* ============================================================================
* NOISE
* ============================================================================

let nfdb=real(NF)
let nfmin_db=real(NFmin)


* ============================================================================
* STABILITY FROM S-PARAMETERS
* ============================================================================

let delta=s_1_1*s_2_2-s_1_2*s_2_1
let delta_mag=mag(delta)

let kval=(1-a11*a11-a22*a22+delta_mag*delta_mag)/(2*a12*a21+1e-30)

let mu=(1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1)+1e-30)

let mup=(1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1)+1e-30)


* ============================================================================
* INPUT / OUTPUT IMPEDANCE
* ============================================================================

let zin=50*(1+s_1_1)/(1-s_1_1)
let zout=50*(1+s_2_2)/(1-s_2_2)

let zin_re=real(zin)
let zin_im=imag(zin)

let zout_re=real(zout)
let zout_im=imag(zout)


* ============================================================================
* INPUT / OUTPUT VSWR
* ============================================================================

let vswr_in=(1+a11)/(1-a11+1e-30)
let vswr_out=(1+a22)/(1-a22+1e-30)


* ============================================================================
* FIND 2.3 / 2.4 / 2.5 GHz INDICES
* ============================================================================

let npts=length(frequency)

let ilo=0
let icenter=0
let ihi=0

let errlo=abs(frequency[0]-2.3e9)
let errcenter=abs(frequency[0]-2.4e9)
let errhi=abs(frequency[0]-2.5e9)

let ii=1

while ii < npts

    let newerr=abs(frequency[ii]-2.3e9)

    if newerr < errlo
        let errlo=newerr
        let ilo=ii
    end

    let newerr=abs(frequency[ii]-2.4e9)

    if newerr < errcenter
        let errcenter=newerr
        let icenter=ii
    end

    let newerr=abs(frequency[ii]-2.5e9)

    if newerr < errhi
        let errhi=newerr
        let ihi=ii
    end

    let ii=ii+1

end


* ============================================================================
* VALUES AT 2.4 GHz
* ============================================================================

let fc=frequency[icenter]

let s11c=s11db[icenter]
let s21c=s21db[icenter]
let s12c=s12db[icenter]
let s22c=s22db[icenter]

let nfc=nfdb[icenter]
let nfminc=nfmin_db[icenter]

let kc=kval[icenter]
let muc=mu[icenter]
let mupc=mup[icenter]
let deltac=delta_mag[icenter]

let zinrc=zin_re[icenter]
let zinic=zin_im[icenter]

let zoutrc=zout_re[icenter]
let zoutic=zout_im[icenter]

let vswrinc=vswr_in[icenter]
let vswroutc=vswr_out[icenter]


* ============================================================================
* TARGET-BAND MIN / MAX INITIALIZATION
* ============================================================================

let s11min=s11db[ilo]
let s11max=s11db[ilo]

let s21min=s21db[ilo]
let s21max=s21db[ilo]

let s12min=s12db[ilo]
let s12max=s12db[ilo]

let s22min=s22db[ilo]
let s22max=s22db[ilo]

let nfbandmin=nfdb[ilo]
let nfbandmax=nfdb[ilo]

let nfminpar_min=nfmin_db[ilo]
let nfminpar_max=nfmin_db[ilo]

let kbandmin=kval[ilo]
let mubandmin=mu[ilo]
let mupbandmin=mup[ilo]

let deltabandmax=delta_mag[ilo]

let zinremin=zin_re[ilo]
let zinremax=zin_re[ilo]

let vswrinmax=vswr_in[ilo]
let vswroutmax=vswr_out[ilo]


* indices
let s11max_i=ilo
let s21min_i=ilo
let s21max_i=ilo
let s22max_i=ilo

let nfmax_i=ilo
let nfmin_i=ilo

let kmin_i=ilo
let mumin_i=ilo
let mupmin_i=ilo
let deltamax_i=ilo

let vswrinmax_i=ilo
let vswroutmax_i=ilo


* ============================================================================
* TARGET-BAND SEARCH
* ============================================================================

let ii=ilo

while ii <= ihi

    if s11db[ii] < s11min
        let s11min=s11db[ii]
    end

    if s11db[ii] > s11max
        let s11max=s11db[ii]
        let s11max_i=ii
    end


    if s21db[ii] < s21min
        let s21min=s21db[ii]
        let s21min_i=ii
    end

    if s21db[ii] > s21max
        let s21max=s21db[ii]
        let s21max_i=ii
    end


    if s12db[ii] < s12min
        let s12min=s12db[ii]
    end

    if s12db[ii] > s12max
        let s12max=s12db[ii]
    end


    if s22db[ii] < s22min
        let s22min=s22db[ii]
    end

    if s22db[ii] > s22max
        let s22max=s22db[ii]
        let s22max_i=ii
    end


    if nfdb[ii] < nfbandmin
        let nfbandmin=nfdb[ii]
        let nfmin_i=ii
    end

    if nfdb[ii] > nfbandmax
        let nfbandmax=nfdb[ii]
        let nfmax_i=ii
    end


    if nfmin_db[ii] < nfminpar_min
        let nfminpar_min=nfmin_db[ii]
    end

    if nfmin_db[ii] > nfminpar_max
        let nfminpar_max=nfmin_db[ii]
    end


    if kval[ii] < kbandmin
        let kbandmin=kval[ii]
        let kmin_i=ii
    end

    if mu[ii] < mubandmin
        let mubandmin=mu[ii]
        let mumin_i=ii
    end

    if mup[ii] < mupbandmin
        let mupbandmin=mup[ii]
        let mupmin_i=ii
    end

    if delta_mag[ii] > deltabandmax
        let deltabandmax=delta_mag[ii]
        let deltamax_i=ii
    end


    if vswr_in[ii] > vswrinmax
        let vswrinmax=vswr_in[ii]
        let vswrinmax_i=ii
    end

    if vswr_out[ii] > vswroutmax
        let vswroutmax=vswr_out[ii]
        let vswroutmax_i=ii
    end

    let ii=ii+1

end


* ============================================================================
* DERIVED BAND METRICS
* ============================================================================

let gain_ripple=s21max-s21min

let s11worst_f=frequency[s11max_i]
let s21min_f=frequency[s21min_i]
let s21max_f=frequency[s21max_i]
let s22worst_f=frequency[s22max_i]

let nfmin_f=frequency[nfmin_i]
let nfmax_f=frequency[nfmax_i]

let kmin_f=frequency[kmin_i]
let mumin_f=frequency[mumin_i]
let mupmin_f=frequency[mupmin_i]
let deltamax_f=frequency[deltamax_i]

let vswrinmax_f=frequency[vswrinmax_i]
let vswroutmax_f=frequency[vswroutmax_i]


* ============================================================================
* BROADBAND GAIN PEAK
* ============================================================================

let imax=0
let gainmax=s21db[0]

let ii=1

while ii < npts

    if s21db[ii] > gainmax
        let gainmax=s21db[ii]
        let imax=ii
    end

    let ii=ii+1

end

let peakfreq=frequency[imax]


* ============================================================================
* TARGET-CENTERED 10-dB GAIN BANDWIDTH
* ============================================================================

let bw_valid=0
let bwflo=0
let bwfhi=0
let bwval=0
let bwcenter=0
let bwfbw=0

if s21c >= spec_gain_min_db

    let bwlo=icenter
    let bwhi=icenter

    let searching=1

    while searching = 1

        if bwlo > 0

            if s21db[bwlo-1] >= spec_gain_min_db
                let bwlo=bwlo-1
            else
                let searching=0
            end

        else
            let searching=0
        end

    end


    let searching=1

    while searching = 1

        if bwhi < npts-1

            if s21db[bwhi+1] >= spec_gain_min_db
                let bwhi=bwhi+1
            else
                let searching=0
            end

        else
            let searching=0
        end

    end


    let bwflo=frequency[bwlo]
    let bwfhi=frequency[bwhi]

    let bwval=bwfhi-bwflo

    let bwcenter=0.5*(bwfhi+bwflo)

    let bwfbw=100*bwval/(bwcenter+1e-30)

    let bw_valid=1

end


* ============================================================================
* RF REPORT
* ============================================================================

echo ============================================================ >> lna_final_report.txt
echo RF_AT_2P4_GHZ >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

echo ACTUAL_SAMPLE_HZ $&fc >> lna_final_report.txt

echo S11_DB $&s11c >> lna_final_report.txt
echo S21_DB $&s21c >> lna_final_report.txt
echo S12_DB $&s12c >> lna_final_report.txt
echo S22_DB $&s22c >> lna_final_report.txt

echo NF_DB $&nfc >> lna_final_report.txt
echo NFMIN_DB $&nfminc >> lna_final_report.txt

echo K $&kc >> lna_final_report.txt
echo MU $&muc >> lna_final_report.txt
echo MUP $&mupc >> lna_final_report.txt
echo DELTA_MAG $&deltac >> lna_final_report.txt

echo ZIN_OHM_REAL $&zinrc IMAG $&zinic >> lna_final_report.txt
echo ZOUT_OHM_REAL $&zoutrc IMAG $&zoutic >> lna_final_report.txt

echo VSWR_IN $&vswrinc >> lna_final_report.txt
echo VSWR_OUT $&vswroutc >> lna_final_report.txt


echo ============================================================ >> lna_final_report.txt
echo TARGET_BAND_2P3_TO_2P5_GHZ >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

echo S11_BEST_DB $&s11min >> lna_final_report.txt
echo S11_WORST_DB $&s11max AT_HZ $&s11worst_f >> lna_final_report.txt

echo S21_MIN_DB $&s21min AT_HZ $&s21min_f >> lna_final_report.txt
echo S21_MAX_DB $&s21max AT_HZ $&s21max_f >> lna_final_report.txt
echo S21_RIPPLE_DB $&gain_ripple >> lna_final_report.txt

echo S12_MIN_DB $&s12min >> lna_final_report.txt
echo S12_MAX_DB $&s12max >> lna_final_report.txt

echo S22_BEST_DB $&s22min >> lna_final_report.txt
echo S22_WORST_DB $&s22max AT_HZ $&s22worst_f >> lna_final_report.txt

echo NF_MIN_DB $&nfbandmin AT_HZ $&nfmin_f >> lna_final_report.txt
echo NF_MAX_DB $&nfbandmax AT_HZ $&nfmax_f >> lna_final_report.txt

echo NFMIN_PARAMETER_MIN_DB $&nfminpar_min >> lna_final_report.txt
echo NFMIN_PARAMETER_MAX_DB $&nfminpar_max >> lna_final_report.txt

echo K_MIN $&kbandmin AT_HZ $&kmin_f >> lna_final_report.txt
echo MU_MIN $&mubandmin AT_HZ $&mumin_f >> lna_final_report.txt
echo MUP_MIN $&mupbandmin AT_HZ $&mupmin_f >> lna_final_report.txt
echo DELTA_MAX $&deltabandmax AT_HZ $&deltamax_f >> lna_final_report.txt

echo VSWR_IN_MAX $&vswrinmax AT_HZ $&vswrinmax_f >> lna_final_report.txt
echo VSWR_OUT_MAX $&vswroutmax AT_HZ $&vswroutmax_f >> lna_final_report.txt


echo ============================================================ >> lna_final_report.txt
echo BROADBAND_GAIN >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

echo PEAK_GAIN_DB $&gainmax >> lna_final_report.txt
echo PEAK_GAIN_FREQUENCY_HZ $&peakfreq >> lna_final_report.txt


echo ============================================================ >> lna_final_report.txt
echo TARGET_CENTERED_GAIN_BANDWIDTH >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

if bw_valid = 1

    echo LOWER_HZ $&bwflo >> lna_final_report.txt
    echo UPPER_HZ $&bwfhi >> lna_final_report.txt
    echo BANDWIDTH_HZ $&bwval >> lna_final_report.txt
    echo BAND_CENTER_HZ $&bwcenter >> lna_final_report.txt
    echo FRACTIONAL_BW_PERCENT $&bwfbw >> lna_final_report.txt

else

    echo NO_CONTIGUOUS_TARGET_CENTERED_GAIN_BAND >> lna_final_report.txt

end


* ============================================================================
* TARGET-BAND PASS / FAIL
* ============================================================================

echo ============================================================ >> lna_final_report.txt
echo TARGET_BAND_SPECIFICATION_CHECK >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt


if s21min >= spec_gain_min_db
    echo GAIN PASS >> lna_final_report.txt
else
    echo GAIN FAIL >> lna_final_report.txt
end


if s11max <= spec_s11_max_db
    echo INPUT_MATCH_S11 PASS >> lna_final_report.txt
else
    echo INPUT_MATCH_S11 FAIL >> lna_final_report.txt
end


if s22max <= spec_s22_max_db
    echo OUTPUT_MATCH_S22 PASS >> lna_final_report.txt
else
    echo OUTPUT_MATCH_S22 FAIL >> lna_final_report.txt
end


if nfbandmax <= spec_nf_max_db
    echo NOISE_FIGURE PASS >> lna_final_report.txt
else
    echo NOISE_FIGURE FAIL >> lna_final_report.txt
end


if mubandmin > spec_mu_min

    if mupbandmin > spec_mu_min
        echo MU_STABILITY_TARGET_BAND PASS >> lna_final_report.txt
    else
        echo MU_STABILITY_TARGET_BAND FAIL >> lna_final_report.txt
    end

else

    echo MU_STABILITY_TARGET_BAND FAIL >> lna_final_report.txt

end


if kbandmin > spec_k_min

    if deltabandmax < spec_delta_max
        echo ROLLETT_K_DELTA_TARGET_BAND PASS >> lna_final_report.txt
    else
        echo ROLLETT_K_DELTA_TARGET_BAND FAIL >> lna_final_report.txt
    end

else

    echo ROLLETT_K_DELTA_TARGET_BAND FAIL >> lna_final_report.txt

end


* ============================================================================
* SAVE RF DATA
* ============================================================================

wrdata lna_final_target_and_broadband.dat frequency s11db s21db s12db s22db nfdb nfmin_db kval mu mup delta_mag zin_re zin_im zout_re zout_im vswr_in vswr_out

write lna_final_rf.raw


* ============================================================================
* 3. VERY-WIDEBAND STABILITY ANALYSIS
*
* Deliberately much wider than operating band.
* No noise calculation required here.
* ============================================================================

reset
sp dec 101 10Meg 30Gig 0

set stabilityplot=$curplot

let wbfghz=frequency/1e9

let wba11=mag(s_1_1)
let wba21=mag(s_2_1)
let wba12=mag(s_1_2)
let wba22=mag(s_2_2)

let wbdelta=s_1_1*s_2_2-s_1_2*s_2_1
let wbdelta_mag=mag(wbdelta)

let wbk=(1-wba11*wba11-wba22*wba22+wbdelta_mag*wbdelta_mag)/(2*wba12*wba21+1e-30)

let wbmu=(1-wba11*wba11)/(mag(s_2_2-wbdelta*conj(s_1_1))+mag(s_1_2*s_2_1)+1e-30)

let wbmup=(1-wba22*wba22)/(mag(s_1_1-wbdelta*conj(s_2_2))+mag(s_1_2*s_2_1)+1e-30)


* ============================================================================
* SEARCH WIDEBAND WORST-CASE STABILITY + FREQUENCIES
* ============================================================================

let wbnpts=length(frequency)

let wbkmin=wbk[0]
let wbmumin=wbmu[0]
let wbmupmin=wbmup[0]
let wbdeltamax=wbdelta_mag[0]

let wbkmin_i=0
let wbmumin_i=0
let wbmupmin_i=0
let wbdeltamax_i=0

let ii=1

while ii < wbnpts

    if wbk[ii] < wbkmin
        let wbkmin=wbk[ii]
        let wbkmin_i=ii
    end

    if wbmu[ii] < wbmumin
        let wbmumin=wbmu[ii]
        let wbmumin_i=ii
    end

    if wbmup[ii] < wbmupmin
        let wbmupmin=wbmup[ii]
        let wbmupmin_i=ii
    end

    if wbdelta_mag[ii] > wbdeltamax
        let wbdeltamax=wbdelta_mag[ii]
        let wbdeltamax_i=ii
    end

    let ii=ii+1

end

let wbkmin_f=frequency[wbkmin_i]
let wbmumin_f=frequency[wbmumin_i]
let wbmupmin_f=frequency[wbmupmin_i]
let wbdeltamax_f=frequency[wbdeltamax_i]


echo ============================================================ >> lna_final_report.txt
echo WIDEBAND_STABILITY_10MHZ_TO_30GHZ >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

echo K_MIN $&wbkmin AT_HZ $&wbkmin_f >> lna_final_report.txt
echo MU_MIN $&wbmumin AT_HZ $&wbmumin_f >> lna_final_report.txt
echo MUP_MIN $&wbmupmin AT_HZ $&wbmupmin_f >> lna_final_report.txt
echo DELTA_MAX $&wbdeltamax AT_HZ $&wbdeltamax_f >> lna_final_report.txt


* ============================================================================
* WIDEBAND STABILITY PASS / FAIL
*
* μ and μ' > 1 across entire range is the preferred robust test.
* K > 1 and |Delta| < 1 is also reported.
* ============================================================================

if wbmumin > 1

    if wbmupmin > 1
        echo WIDEBAND_MU_STABILITY PASS >> lna_final_report.txt
    else
        echo WIDEBAND_MU_STABILITY FAIL >> lna_final_report.txt
    end

else

    echo WIDEBAND_MU_STABILITY FAIL >> lna_final_report.txt

end


if wbkmin > 1

    if wbdeltamax < 1
        echo WIDEBAND_K_DELTA_STABILITY PASS >> lna_final_report.txt
    else
        echo WIDEBAND_K_DELTA_STABILITY FAIL >> lna_final_report.txt
    end

else

    echo WIDEBAND_K_DELTA_STABILITY FAIL >> lna_final_report.txt

end


wrdata lna_final_stability.dat frequency wbk wbmu wbmup wbdelta_mag

write lna_final_stability.raw


* ============================================================================
* FINAL SUMMARY
* ============================================================================

echo ============================================================ >> lna_final_report.txt
echo FINAL_OUTPUT_FILES >> lna_final_report.txt
echo ============================================================ >> lna_final_report.txt

echo REPORT lna_final_report.txt >> lna_final_report.txt
echo RF_DATA lna_final_target_and_broadband.dat >> lna_final_report.txt
echo RF_RAW lna_final_rf.raw >> lna_final_report.txt
echo STABILITY_DATA lna_final_stability.dat >> lna_final_report.txt
echo STABILITY_RAW lna_final_stability.raw >> lna_final_report.txt

echo ============================================================ >> lna_final_report.txt


* ============================================================================
* TERMINAL SUMMARY
* ============================================================================

echo
echo ============================================================
echo LNA FINAL CHARACTERIZATION SUMMARY
echo ============================================================

echo LNA_TOP_POWER_MW $op_pdc_lna
echo IO_POWER_MW $op_pdc_io
echo TOTAL_POWER_MW $op_pdc_total

echo
echo CENTER_2P4_GHZ
print s11c s21c s12c s22c
print nfc nfminc
print kc muc mupc deltac
print zinrc zinic
print zoutrc zoutic

echo
echo TARGET_BAND_WORST_CASE
print s11max s21min s22max
print nfbandmax
print kbandmin mubandmin mupbandmin deltabandmax
print gain_ripple

echo
echo WIDEBAND_STABILITY_10MHZ_TO_30GHZ
print wbkmin wbmumin wbmupmin wbdeltamax


* ============================================================================
* 4. VISIBLE PLOTS
* ============================================================================


* ---------------------------------------------------------------------------
* Target-band RF plots
* ---------------------------------------------------------------------------

setplot $rfplot
setscale fghz

plot s21db xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'S21 Gain (dB)'

plot s11db xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'S11 (dB)'

plot s22db xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'S22 (dB)'

plot s12db xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'S12 Reverse Isolation (dB)'


* Gain + return losses together
plot s21db s11db s22db xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'S Parameters (dB)'


* Noise
plot nfdb nfmin_db xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'Noise Figure (dB)'


* Stability inside target band
plot mu mup xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'Mu Stability Factor'

plot kval xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'Rollett K'

plot delta_mag xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel '|Delta|'


* Impedance
plot zin_re zin_im xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'Input Impedance (Ohm)'

plot zout_re zout_im xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'Output Impedance (Ohm)'


* VSWR
plot vswr_in vswr_out xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'VSWR'


* ---------------------------------------------------------------------------
* Broadband response
* ---------------------------------------------------------------------------

plot s21db xlimit 0.01 7 xlabel 'Frequency (GHz)' ylabel 'S21 Gain (dB)'

plot s11db s22db xlimit 0.01 7 xlabel 'Frequency (GHz)' ylabel 'Return Loss (dB)'

plot nfdb nfmin_db xlimit 0.01 7 xlabel 'Frequency (GHz)' ylabel 'Noise Figure (dB)'


* ---------------------------------------------------------------------------
* Very-wide-band stability
* ---------------------------------------------------------------------------

setplot $stabilityplot
setscale wbfghz

plot wbmu wbmup xlimit 0.01 30 xlabel 'Frequency (GHz)' ylabel 'Mu / Mu Prime'

plot wbk xlimit 0.01 30 xlabel 'Frequency (GHz)' ylabel 'Rollett K'

plot wbdelta_mag xlimit 0.01 30 xlabel 'Frequency (GHz)' ylabel '|Delta|'


echo
echo ============================================================
echo FINAL CHARACTERIZATION COMPLETE
echo See: lna_final_report.txt
echo ============================================================

.endc

"}
