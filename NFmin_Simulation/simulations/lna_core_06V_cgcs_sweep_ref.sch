v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N -320 -440 -320 -410 {
lab=GND}
N 1010 -260 1030 -260 {
lab=GND}
N -320 -410 -320 -310 {
lab=GND}
N -320 -530 -320 -500 {
lab=vdcbias}
N -320 -390 -270 -390 {
lab=GND}
N -500 -510 -460 -510 {
lab=rf_in_ext}
N -500 -450 -460 -450 {
lab=GND}
N -500 -360 -460 -360 {
lab=rf_out_ext}
N -500 -300 -460 -300 {
lab=GND}
N 1010 -370 1010 -290 {
lab=d}
N 1010 -460 1010 -430 {
lab=vdcbias}
N -210 -390 -180 -390 {
lab=vbias_cg}
N 880 -520 900 -520 {
lab=s}
N 550 -520 580 -520 {
lab=rf_in_pad}
N 1010 -330 1050 -330 {
lab=d}
N 1110 -330 1150 -330 {
lab=g_cs}
N 1010 -230 1010 -220 {
lab=s}
N 1010 -220 1010 -190 {
lab=s}
N 950 -260 970 -260 {
lab=g_cg}
N 1010 -130 1010 -100 {
lab=GND}
N -320 -310 -320 -110 {
lab=GND}
N 640 -70 660 -70 {
lab=vbias_cg}
N 720 -70 750 -70 {
lab=g_cg}
N 620 -150 650 -150 {
lab=g_cg}
N 710 -150 750 -150 {
lab=GND}
N 300 -580 340 -580 {
lab=rf_in_pad}
N 200 -580 240 -580 {
lab=#net1}
N 100 -580 140 -580 {
lab=rf_in_ext}
N 310 -300 360 -300 {
lab=rf_in_pad}
N 150 -230 150 -200 {
lab=GND}
N 190 -230 190 -200 {
lab=GND}
N 150 -400 150 -370 {
lab=vddio}
N 190 -400 190 -370 {
lab=vddio}
N -320 -270 -290 -270 {
lab=GND}
N -220 10 -190 10 {
lab=vddio}
N 1830 -740 1880 -740 {
lab=rf_out_pad}
N 1670 -670 1670 -640 {
lab=GND}
N 1710 -670 1710 -640 {
lab=GND}
N 1670 -840 1670 -810 {
lab=vddio}
N 1710 -840 1710 -810 {
lab=vddio}
N 1770 -920 1810 -920 {
lab=rf_out_pad}
N 1670 -920 1710 -920 {
lab=#net2}
N 1570 -920 1610 -920 {
lab=rf_out_ext}
N -320 10 -280 10 {
lab=GND}
N -230 -270 -200 -270 {
lab=vbias_cs}
N 1540 -260 1560 -260 {
lab=GND}
N 1540 -230 1540 -220 {
lab=GND}
N 1480 -260 1500 -260 {
lab=g_cs}
N 1260 -420 1280 -420 {
lab=vbias_cs}
N 1340 -420 1370 -420 {
lab=g_cs}
N 1540 -220 1540 -160 {
lab=GND}
N 1560 -260 1560 -220 {
lab=GND}
N 1540 -220 1560 -220 {
lab=GND}
N 1540 -580 1540 -540 {
lab=vdcbias}
N 1750 -550 1750 -480 {
lab=vdcbias}
N 1750 -420 1750 -350 {
lab=vbuf}
N 1750 -290 1750 -260 {
lab=GND}
N 1750 -450 1770 -450 {
lab=vbuf}
N 1920 -350 1960 -350 {
lab=vbuf}
N 2020 -350 2060 -350 {
lab=#net3}
N 2120 -350 2170 -350 {
lab=#net4}
N 2230 -350 2270 -350 {
lab=rf_out_pad}
N 2250 -350 2250 -270 {
lab=rf_out_pad}
N 2250 -210 2250 -170 {
lab=GND}
N 560 -520 560 -480 {
lab=rf_in_pad}
N 560 -420 560 -380 {
lab=GND}
N 580 -520 610 -520 {
lab=rf_in_pad}
N 670 -520 720 -520 {
lab=#net5}
N 780 -520 820 -520 {
lab=#net6}
N 1540 -370 1560 -370 {
lab=GND}
N 1540 -340 1540 -330 {
lab=#net7}
N 1480 -370 1500 -370 {
lab=vbias_cas}
N 1540 -480 1540 -400 {
lab=#net8}
N 1540 -330 1540 -290 {
lab=#net7}
N -320 -110 -320 20 {
lab=GND}
N -230 -160 -200 -160 {
lab=vbias_cas}
N -320 -160 -290 -160 {
lab=GND}
N 1540 -450 1710 -450 {
lab=#net8}
N 1770 -450 1770 -400 {
lab=vbuf}
N 1750 -400 1770 -400 {
lab=vbuf}
C {vsource.sym} -240 -390 1 0 {name=VBCG value=\{VBIAS_CG\} savecurrent=false}
C {gnd.sym} 1010 -100 0 0 {name=l1 lab=GND}
C {vsource.sym} -320 -470 0 0 {name=VDD value=\{VDS\} savecurrent=false}
C {capa.sym} 1080 -330 3 0 {name=C12
m=1
value=\{C12_VAL\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1010 -320 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} -460 -510 2 0 {name=p5 sig_type=std_logic lab=rf_in_ext}
C {lab_pin.sym} -460 -450 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} -460 -300 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 850 -520 3 0 {name=CIN
m=1
value=\{CIN_VAL\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} -320 20 0 0 {name=l3 lab=GND}
C {lab_pin.sym} -320 -530 0 0 {name=p10 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} -180 -390 2 0 {name=p9 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 1010 -460 0 0 {name=p11 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 1150 -330 2 0 {name=p14 sig_type=std_logic lab=g_cs}
C {port_diff.sym} -500 -480 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} -500 -330 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {lab_pin.sym} 1010 -200 2 0 {name=p1 sig_type=std_logic lab=s}
C {lab_pin.sym} 1030 -260 2 0 {name=p2 sig_type=std_logic lab=GND}
C {code_shown.sym} 40 45 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice

.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice moscap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice diode_typical

*.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
.include /media/sf_LNA_chipathon/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.spice 
"}
C {code.sym} 1150 40 0 0 {name=s2 only_toplevel=false value="

* =============================================================================
* PARAMETERS
* =============================================================================

.param VDS=5.0
.param VDDIO_SUP=5.0

* Fixed package bondwires.
.param L_BW=2n
.param R_BW=0.2

* Input matching network, intentionally limited to <= 1 nH.
.param L_IN=1n
.param R_L_IN=1.5
.param CIN_VAL=100p
.param C_SH_IN=1f

* Common-gate stage.
.param VBIAS_CG=1.70
.param I_CG=4m
.param W_CG=100u
.param M_CG=2
.param L_CG=0.60u
.param RD1=560
.param RBIAS_CG=50k
.param CBYP_CG=20p

* Lower common-source stage.
.param C12_VAL=50p
.param VBIAS_CS=1.20
.param W_CS=100u
.param M_CS=2
.param L_CS=0.60u
.param RBIAS_CS=50k

* Upper cascode device.
.param VBIAS_CAS=2.50
.param W_CAS=100u
.param M_CAS=1
.param L_CAS=0.60u

* CS-cascode drain load.
.param RD2=560


* Isolated-body NMOS source follower.
* REQUIRED: isolated-DNWELL XM3 body terminal connected to vbuf.
* Layout/LVS: use the GF180 6V NMOS inside DNWELL device supported by your local PDK.
.param W_SF=100u
.param M_SF=2
.param L_SF=0.60u
.param I_BUF=25m

* Output matching network, intentionally limited to <= 1 nH.
.param COUT_VAL=100p
.param L_OUT=1n
.param R_L_OUT=1.5
.param C_SH_OUT=1f


.control

set noaskquit
set wr_singlescale
set wr_vecnames
set numdgt=10

echo ============================================================
echo RUNNING_CODE_VERSION_GAIN_RECOVERY_V7_COMPLIANCE_NO_RC_FIXED_LIN_1nH_LOUT_1nH
echo DETAILED_REPORT_lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo SUMMARY_REPORT_lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo STABILITY_TRACE_10M_10G_lna_gain_recovery_v7_compliance_no_rc_stability_10m_10g_trace.txt
echo STABILITY_TRACE_10M_30G_lna_gain_recovery_v7_compliance_no_rc_stability_10m_30g_trace.txt
echo IMPORTANT_USE_NFET_06V0_DN_OR_EQUIVALENT_ISOLATED_NMOS
echo LOCAL_PWELL_BODY_TO_VBUF_DNWELL_BIAS_PER_PDK_WELL_RULES_PSUB_GUARD_TO_GND
echo DETAILED_REPORT_lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo SUMMARY_REPORT_lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================

* =============================================================================
* SPECIFICATIONS AND OPTIMIZER TARGETS
* =============================================================================

let target_s11 = -10
let target_s22 = -10
let target_gain_spec = 12.0
let target_gain_opt = 13.00
let target_gain_margin = 12.80
let target_nf_margin = 3.70
let target_nf = 4.0
let target_ripple = 0.80
let target_mu = 1.10
let target_mup = 1.10
let target_vds = 0.40
let target_vsrc = 0.40
let target_vbuf = 0.75
let target_pdc = 220

echo ============================================================ > lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo CG-CS-CASCODE-SF EXTERNAL-50-OHM GAIN-RECOVERY V7 COMPLIANCE NO-RC SWEEP >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo L_BW_FIXED_2nH_LIN_1nH_LOUT_1nH_NO_EXTRA_INDUCTOR >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo CG_SOURCE_DC_TARGET_GE_0P35V_FOR_REAL_CURRENT_SINK >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo NO_NET8_RC_DAMPER_V6_PROVED_INEFFECTIVE >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo SF_BODY_CONNECTED_TO_SOURCE_VBUF_INSIDE_DNWELL_REQUIRED >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo stage MCG ICG_A VBCG_V RD1_Ohm MCS VBCS_V MCAS VBCAS_V RD2_Ohm C12_F MSF IBUF_A LIN_H CSHIN_F CIN_F LOUT_H CSHOUT_F COUT_F Pdc_mW gmCGtot_mS gmCS_mS gmCAS_mS RoutSF_Ohm S11worst_dB S21min_dB S21_2p30_dB S21_2p50_dB S21ripple_dB S22worst_dB NFworst_dB Kmin MUmin MUPmin DeltaMax Vsource_V VdCG_V Vx_CSdrain_V VcasOut_V Vbuf_V VDS_CG_V VDS_CS_V VDS_CAS_V WCS_m WSF_m Score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

* =============================================================================
* BEST-VALUE STORAGE
* =============================================================================

let best_score_cg = 1e99
let best_mcg = 2
let best_icg = 4m
let best_vbcg = 1.70
let best_rd1 = 560

let best_score_casc = 1e99
let best_mcs = 2
let best_vbcs = 1.20
let best_mcas = 1
let best_vbcas = 2.50
let best_rd2 = 560
let best_c12 = 50p

let best_score_sf = 1e99
let best_msf = 2
let best_ibuf = 25m

let best_score_in = 1e99
let best_lin = 1n
let best_cshin = 25f
let best_cin = 3.9p

let best_score_out = 1e99
let best_lout = 1n
let best_cshout = 50f
let best_cout = 20p

let best_score_active_final = 1e99
let best_rd1_final = 560
let best_wcs_final = 100u
let best_vbcs_final = 1.20
let best_vbcas_final = 2.50
let best_rd2_final = 560

let best_score_sf_final = 1e99
let best_wsf_final = 100u
let best_ibuf_final = 25m

let best_score_c12_final = 1e99
let best_c12_final = 50p

let best_score_in_final = 1e99
let best_lin_final = 1n
let best_cshin_final = 25f
let best_cin_final = 3.9p

let best_score_out_final = 1e99
let best_lout_final = 1n
let best_cshout_final = 50f
let best_cout_final = 20p

* =============================================================================
* STAGE 1: COMMON-GATE DEVICE AND LOAD
* =============================================================================

echo Starting Stage 1: common-gate sweep

foreach mcg 2 3
  foreach icg 4m 5m 6m
    foreach vbcg 1.55 1.60 1.65 1.70 1.75 1.80 1.85
      foreach rd1val 470 510 560 620
              alterparam L_BW = 2n
              alterparam M_CG = $mcg
              alterparam I_CG = $icg
              alterparam VBIAS_CG = $vbcg
              alterparam RD1 = $rd1val
              alterparam M_CS = 2
              alterparam W_CS = 100u
              alterparam VBIAS_CS = 1.20
              alterparam M_CAS = 1
              alterparam VBIAS_CAS = 2.40
              alterparam RD2 = 560
              alterparam C12_VAL = 50p
              alterparam M_SF = 2
              alterparam W_SF = 100u
              alterparam I_BUF = 25m
              alterparam L_IN = 1n
              alterparam C_SH_IN = 25f
              alterparam CIN_VAL = 3.9p
              alterparam L_OUT = 1n
              alterparam C_SH_OUT = 50f
              alterparam COUT_VAL = 20p

              reset
              op

              let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

              let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
              let gm_cs = @m.xm1.m0[gm]
              let gm_cas = @m.xm4.m0[gm]
              let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

              let vsrc = v(s)
              let vdcg = v(d)
              let vnx = v(net7)
              let voutint = v(net8)
              let vbf = v(vbuf)

              let vds_cg = v(d)-v(s)
              let vds_cs = v(net7)
              let vds_cas = v(net8)-v(net7)
              let vds_sf = v(vdcbias)-v(vbuf)

              let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
              let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
              let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
              let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
              let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
              let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
              let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

              let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

              set pdc_save = $&pdc_mw
              set gmcg_save = $&gm_cg_tot
              set gmcs_save = $&gm_cs
              set gmcas_save = $&gm_cas
              set rout_save = $&rout_sf
              set vsrc_save = $&vsrc
              set vdcg_save = $&vdcg
              set vnx_save = $&vnx
              set voutint_save = $&voutint
              set vbf_save = $&vbf
              set vdscg_save = $&vds_cg
              set vdscs_save = $&vds_cs
              set vdscas_save = $&vds_cas
              set opp_save = $&op_penalty

              destroy $curplot

              sp lin 9 2.30G 2.50G 1

              let s11db = db(s_1_1)
              let s21db = db(s_2_1)
              let s22db = db(s_2_2)
              let nfdb = real(NF)

              let delta = s_1_1*s_2_2-s_1_2*s_2_1
              let md = mag(delta)
              let a11 = mag(s_1_1)
              let a12 = mag(s_1_2)
              let a21 = mag(s_2_1)
              let a22 = mag(s_2_2)

              let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
              let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
              let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

              let s11w = maximum(s11db)
              let s21m = minimum(s21db)
              let s21x = maximum(s21db)
              let s21lo = s21db[0]
              let s21hi = s21db[8]
              let ripple = s21x-s21m
              let s22w = maximum(s22db)
              let nfw = maximum(nfdb)
              let kmin = minimum(kval)
              let mumin = minimum(mu)
              let mupmin = minimum(mup)
              let dmax = maximum(md)

              let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
              let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
              let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
              let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
              let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
              let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
              let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
              let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
              let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

              let gmcg_ms = $gmcg_save*1000
              let gmcs_ms = $gmcs_save*1000
              let gmcas_ms = $gmcas_save*1000

              let score = 110*ps11*ps11+20*ps22*ps22+160*pgain*pgain+50*pedge*pedge+15*pflat*pflat+90*pnf*pnf+400*pmu*pmu+400*pmup*pmup+400*pdel*pdel+0.025*$pdc_save+$opp_save

              if $vsrc_save < 0.35
                let score = score + 1e6
              end
              if $vbf_save < 0.30
                let score = score + 1e6
              end
              if $vdscg_save < 0.40
                let score = score + 1e6
              end
              if $vdscs_save < 0.40
                let score = score + 1e6
              end
              if $vdscas_save < 0.40
                let score = score + 1e6
              end
              if $pdc_save > 220
                let score = score + 1e6+1000*($pdc_save-220)
              end
              if mumin < 1
                let score = score + 1e6
              end
              if mupmin < 1
                let score = score + 1e6
              end
              if dmax >= 1
                let score = score + 1e6
              end

              echo S1 $mcg $icg $vbcg $rd1val 2 1.20 1 2.40 560 50p 2 25m 1n 25f 3.9p 1n 50f 20p $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save 100u 100u $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

              if score < best_score_cg
                let best_score_cg = score
                let best_mcg = $mcg
                let best_icg = $icg
                let best_vbcg = $vbcg
                let best_rd1 = $rd1val
              end

              destroy $curplot
      end
    end
  end
end

echo Best CG: M_CG=$&best_mcg I_CG=$&best_icg VBIAS_CG=$&best_vbcg RD1=$&best_rd1

* =============================================================================
* STAGE 2: CS-CASCODE ACTIVE CORE
* =============================================================================

echo Starting Stage 2: CS-cascode joint sweep

foreach mcs 1 2 3
  foreach mcas 1 2
    foreach vbcs 1.10 1.20 1.30
      foreach vbcas 2.00 2.20 2.40 2.60
        foreach rd2val 560 680 820 910
          foreach c12val 20p 50p
                  alterparam L_BW = 2n
                  alterparam M_CG = $&best_mcg
                  alterparam I_CG = $&best_icg
                  alterparam VBIAS_CG = $&best_vbcg
                  alterparam RD1 = $&best_rd1
                  alterparam M_CS = $mcs
              alterparam W_CS = 100u
                  alterparam VBIAS_CS = $vbcs
                  alterparam M_CAS = $mcas
                  alterparam VBIAS_CAS = $vbcas
                  alterparam RD2 = $rd2val
                  alterparam C12_VAL = $c12val
                  alterparam M_SF = 2
              alterparam W_SF = 100u
                  alterparam I_BUF = 25m
                  alterparam L_IN = 1n
                  alterparam C_SH_IN = 25f
                  alterparam CIN_VAL = 3.9p
                  alterparam L_OUT = 1n
                  alterparam C_SH_OUT = 50f
                  alterparam COUT_VAL = 20p

                  reset
                  op

                  let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

                  let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
                  let gm_cs = @m.xm1.m0[gm]
                  let gm_cas = @m.xm4.m0[gm]
                  let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

                  let vsrc = v(s)
                  let vdcg = v(d)
                  let vnx = v(net7)
                  let voutint = v(net8)
                  let vbf = v(vbuf)

                  let vds_cg = v(d)-v(s)
                  let vds_cs = v(net7)
                  let vds_cas = v(net8)-v(net7)
                  let vds_sf = v(vdcbias)-v(vbuf)

                  let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
                  let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
                  let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
                  let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
                  let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
                  let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
                  let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

                  let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

                  set pdc_save = $&pdc_mw
                  set gmcg_save = $&gm_cg_tot
                  set gmcs_save = $&gm_cs
                  set gmcas_save = $&gm_cas
                  set rout_save = $&rout_sf
                  set vsrc_save = $&vsrc
                  set vdcg_save = $&vdcg
                  set vnx_save = $&vnx
                  set voutint_save = $&voutint
                  set vbf_save = $&vbf
                  set vdscg_save = $&vds_cg
                  set vdscs_save = $&vds_cs
                  set vdscas_save = $&vds_cas
                  set opp_save = $&op_penalty

                  destroy $curplot

                  sp lin 9 2.30G 2.50G 1

                  let s11db = db(s_1_1)
                  let s21db = db(s_2_1)
                  let s22db = db(s_2_2)
                  let nfdb = real(NF)

                  let delta = s_1_1*s_2_2-s_1_2*s_2_1
                  let md = mag(delta)
                  let a11 = mag(s_1_1)
                  let a12 = mag(s_1_2)
                  let a21 = mag(s_2_1)
                  let a22 = mag(s_2_2)

                  let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
                  let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
                  let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

                  let s11w = maximum(s11db)
                  let s21m = minimum(s21db)
                  let s21x = maximum(s21db)
                  let s21lo = s21db[0]
                  let s21hi = s21db[8]
                  let ripple = s21x-s21m
                  let s22w = maximum(s22db)
                  let nfw = maximum(nfdb)
                  let kmin = minimum(kval)
                  let mumin = minimum(mu)
                  let mupmin = minimum(mup)
                  let dmax = maximum(md)

                  let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
                  let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
                  let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
                  let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
                  let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
                  let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
                  let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
                  let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
                  let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

                  let gmcg_ms = $gmcg_save*1000
                  let gmcs_ms = $gmcs_save*1000
                  let gmcas_ms = $gmcas_save*1000

                  let score = 70*ps11*ps11+25*ps22*ps22+280*pgain*pgain+100*pedge*pedge+30*pflat*pflat+55*pnf*pnf+450*pmu*pmu+450*pmup*pmup+450*pdel*pdel+0.025*$pdc_save+$opp_save

                  if $vsrc_save < 0.35
                    let score = score + 1e6
                  end
                  if $vbf_save < 0.30
                    let score = score + 1e6
                  end
                  if $vdscg_save < 0.40
                    let score = score + 1e6
                  end
                  if $vdscs_save < 0.40
                    let score = score + 1e6
                  end
                  if $vdscas_save < 0.40
                    let score = score + 1e6
                  end
                  if $pdc_save > 220
                    let score = score + 1e6+1000*($pdc_save-220)
                  end
                  if mumin < 1
                    let score = score + 1e6
                  end
                  if mupmin < 1
                    let score = score + 1e6
                  end
                  if dmax >= 1
                    let score = score + 1e6
                  end

                  echo S2 $&best_mcg $&best_icg $&best_vbcg $&best_rd1 $mcs $vbcs $mcas $vbcas $rd2val $c12val 2 25m 1n 25f 3.9p 1n 50f 20p $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save 100u 100u $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

                  if score < best_score_casc
                    let best_score_casc = score
                    let best_mcs = $mcs
                    let best_vbcs = $vbcs
                    let best_mcas = $mcas
                    let best_vbcas = $vbcas
                    let best_rd2 = $rd2val
                    let best_c12 = $c12val
                  end

                  destroy $curplot
          end
        end
      end
    end
  end
end

echo Best cascode: M_CS=$&best_mcs VBIAS_CS=$&best_vbcs M_CAS=$&best_mcas VBIAS_CAS=$&best_vbcas RD2=$&best_rd2 C12=$&best_c12

* =============================================================================
* STAGE 3: BODY-TIED SOURCE FOLLOWER AND RD2
* =============================================================================

echo Starting Stage 3: body-tied source-follower and RD2 sweep

foreach msf 1 2
  foreach ibuf 12.5m 15m 20m 25m 30m
    foreach rd2val 390 430 470 510 560 620 680
              alterparam L_BW = 2n
              alterparam M_CG = $&best_mcg
              alterparam I_CG = $&best_icg
              alterparam VBIAS_CG = $&best_vbcg
              alterparam RD1 = $&best_rd1
              alterparam M_CS = $&best_mcs
              alterparam W_CS = 100u
              alterparam VBIAS_CS = $&best_vbcs
              alterparam M_CAS = $&best_mcas
              alterparam VBIAS_CAS = $&best_vbcas
              alterparam RD2 = $rd2val
              alterparam C12_VAL = $&best_c12
              alterparam M_SF = $msf
              alterparam W_SF = 100u
              alterparam I_BUF = $ibuf
              alterparam L_IN = 1n
              alterparam C_SH_IN = 25f
              alterparam CIN_VAL = 3.9p
              alterparam L_OUT = 1n
              alterparam C_SH_OUT = 50f
              alterparam COUT_VAL = 20p

              reset
              op

              let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

              let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
              let gm_cs = @m.xm1.m0[gm]
              let gm_cas = @m.xm4.m0[gm]
              let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

              let vsrc = v(s)
              let vdcg = v(d)
              let vnx = v(net7)
              let voutint = v(net8)
              let vbf = v(vbuf)

              let vds_cg = v(d)-v(s)
              let vds_cs = v(net7)
              let vds_cas = v(net8)-v(net7)
              let vds_sf = v(vdcbias)-v(vbuf)

              let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
              let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
              let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
              let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
              let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
              let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
              let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

              let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

              set pdc_save = $&pdc_mw
              set gmcg_save = $&gm_cg_tot
              set gmcs_save = $&gm_cs
              set gmcas_save = $&gm_cas
              set rout_save = $&rout_sf
              set vsrc_save = $&vsrc
              set vdcg_save = $&vdcg
              set vnx_save = $&vnx
              set voutint_save = $&voutint
              set vbf_save = $&vbf
              set vdscg_save = $&vds_cg
              set vdscs_save = $&vds_cs
              set vdscas_save = $&vds_cas
              set opp_save = $&op_penalty

              destroy $curplot

              sp lin 9 2.30G 2.50G 1

              let s11db = db(s_1_1)
              let s21db = db(s_2_1)
              let s22db = db(s_2_2)
              let nfdb = real(NF)

              let delta = s_1_1*s_2_2-s_1_2*s_2_1
              let md = mag(delta)
              let a11 = mag(s_1_1)
              let a12 = mag(s_1_2)
              let a21 = mag(s_2_1)
              let a22 = mag(s_2_2)

              let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
              let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
              let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

              let s11w = maximum(s11db)
              let s21m = minimum(s21db)
              let s21x = maximum(s21db)
              let s21lo = s21db[0]
              let s21hi = s21db[8]
              let ripple = s21x-s21m
              let s22w = maximum(s22db)
              let nfw = maximum(nfdb)
              let kmin = minimum(kval)
              let mumin = minimum(mu)
              let mupmin = minimum(mup)
              let dmax = maximum(md)

              let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
              let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
              let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
              let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
              let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
              let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
              let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
              let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
              let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

              let gmcg_ms = $gmcg_save*1000
              let gmcs_ms = $gmcs_save*1000
              let gmcas_ms = $gmcas_save*1000

              let score = 60*ps11*ps11+45*ps22*ps22+300*pgain*pgain+140*pedge*pedge+45*pflat*pflat+45*pnf*pnf+500*pmu*pmu+500*pmup*pmup+500*pdel*pdel+0.04*$pdc_save+$opp_save

              if $vsrc_save < 0.35
                let score = score + 1e6
              end
              if $vbf_save < 0.30
                let score = score + 1e6
              end
              if $vdscg_save < 0.40
                let score = score + 1e6
              end
              if $vdscs_save < 0.40
                let score = score + 1e6
              end
              if $vdscas_save < 0.40
                let score = score + 1e6
              end
              if $pdc_save > 220
                let score = score + 1e6+1000*($pdc_save-220)
              end
              if mumin < 1
                let score = score + 1e6
              end
              if mupmin < 1
                let score = score + 1e6
              end
              if dmax >= 1
                let score = score + 1e6
              end

              echo S3 $&best_mcg $&best_icg $&best_vbcg $&best_rd1 $&best_mcs $&best_vbcs $&best_mcas $&best_vbcas $rd2val $&best_c12 $msf $ibuf 1n 25f 3.9p 1n 50f 20p $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save 100u 100u $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

              if score < best_score_sf
                let best_score_sf = score
                let best_msf = $msf
                let best_ibuf = $ibuf
                let best_rd2 = $rd2val
              end

              destroy $curplot
    end
  end
end

echo Best source follower: M_SF=$&best_msf I_BUF=$&best_ibuf RD2=$&best_rd2

* =============================================================================
* STAGE 4: CORRECTED INPUT MATCH
* =============================================================================

echo Starting Stage 4: input-match sweep with few-pF CIN

  foreach cshinval 1f 25f 50f 100f 200f 350f
    foreach cinval 2.7p 3.3p 3.9p 4.7p 5.6p 6.8p 8.2p 12p 20p 50p 100p
            alterparam L_BW = 2n
            alterparam M_CG = $&best_mcg
            alterparam I_CG = $&best_icg
            alterparam VBIAS_CG = $&best_vbcg
            alterparam RD1 = $&best_rd1
            alterparam M_CS = $&best_mcs
              alterparam W_CS = 100u
            alterparam VBIAS_CS = $&best_vbcs
            alterparam M_CAS = $&best_mcas
            alterparam VBIAS_CAS = $&best_vbcas
            alterparam RD2 = $&best_rd2
            alterparam C12_VAL = $&best_c12
            alterparam M_SF = $&best_msf
              alterparam W_SF = 100u
            alterparam I_BUF = $&best_ibuf
            alterparam L_IN = 1n
            alterparam C_SH_IN = $cshinval
            alterparam CIN_VAL = $cinval
            alterparam L_OUT = 1n
            alterparam C_SH_OUT = 50f
            alterparam COUT_VAL = 20p

            reset
            op

            let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

            let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
            let gm_cs = @m.xm1.m0[gm]
            let gm_cas = @m.xm4.m0[gm]
            let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

            let vsrc = v(s)
            let vdcg = v(d)
            let vnx = v(net7)
            let voutint = v(net8)
            let vbf = v(vbuf)

            let vds_cg = v(d)-v(s)
            let vds_cs = v(net7)
            let vds_cas = v(net8)-v(net7)
            let vds_sf = v(vdcbias)-v(vbuf)

            let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
            let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
            let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
            let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
            let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
            let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
            let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

            let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

            set pdc_save = $&pdc_mw
            set gmcg_save = $&gm_cg_tot
            set gmcs_save = $&gm_cs
            set gmcas_save = $&gm_cas
            set rout_save = $&rout_sf
            set vsrc_save = $&vsrc
            set vdcg_save = $&vdcg
            set vnx_save = $&vnx
            set voutint_save = $&voutint
            set vbf_save = $&vbf
            set vdscg_save = $&vds_cg
            set vdscs_save = $&vds_cs
            set vdscas_save = $&vds_cas
            set opp_save = $&op_penalty

            destroy $curplot

            sp lin 9 2.30G 2.50G 1

            let s11db = db(s_1_1)
            let s21db = db(s_2_1)
            let s22db = db(s_2_2)
            let nfdb = real(NF)

            let delta = s_1_1*s_2_2-s_1_2*s_2_1
            let md = mag(delta)
            let a11 = mag(s_1_1)
            let a12 = mag(s_1_2)
            let a21 = mag(s_2_1)
            let a22 = mag(s_2_2)

            let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
            let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
            let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

            let s11w = maximum(s11db)
            let s21m = minimum(s21db)
            let s21x = maximum(s21db)
            let s21lo = s21db[0]
            let s21hi = s21db[8]
            let ripple = s21x-s21m
            let s22w = maximum(s22db)
            let nfw = maximum(nfdb)
            let kmin = minimum(kval)
            let mumin = minimum(mu)
            let mupmin = minimum(mup)
            let dmax = maximum(md)

            let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
            let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
            let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
            let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
            let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
            let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
            let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
            let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
            let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

            let gmcg_ms = $gmcg_save*1000
            let gmcs_ms = $gmcs_save*1000
            let gmcas_ms = $gmcas_save*1000

            let score = 260*ps11*ps11+20*ps22*ps22+160*pgain*pgain+60*pedge*pedge+20*pflat*pflat+85*pnf*pnf+450*pmu*pmu+450*pmup*pmup+450*pdel*pdel+0.025*$pdc_save+$opp_save

            if $vsrc_save < 0.35
              let score = score + 1e6
            end
            if $vbf_save < 0.30
              let score = score + 1e6
            end
            if $vdscg_save < 0.40
              let score = score + 1e6
            end
            if $vdscs_save < 0.40
              let score = score + 1e6
            end
            if $vdscas_save < 0.40
              let score = score + 1e6
            end
            if $pdc_save > 220
              let score = score + 1e6+1000*($pdc_save-220)
            end
            if mumin < 1
              let score = score + 1e6
            end
            if mupmin < 1
              let score = score + 1e6
            end
            if dmax >= 1
              let score = score + 1e6
            end

            echo S4 $&best_mcg $&best_icg $&best_vbcg $&best_rd1 $&best_mcs $&best_vbcs $&best_mcas $&best_vbcas $&best_rd2 $&best_c12 $&best_msf $&best_ibuf 1n $cshinval $cinval 1n 50f 20p $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save 100u 100u $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

            if score < best_score_in
              let best_score_in = score
              let best_cshin = $cshinval
              let best_cin = $cinval
            end

            destroy $curplot
  end
end

echo Best input match: L_IN=1n C_SH_IN=$&best_cshin CIN=$&best_cin

* =============================================================================
* STAGE 5: CORRECTED OUTPUT MATCH
* =============================================================================

echo Starting Stage 5: output-match sweep with useful COUT values

  foreach cshoutval 1f 25f 50f 100f 200f 350f 500f
    foreach coutval 2.7p 3.9p 5.6p 8.2p 12p 20p 50p 100p
            alterparam L_BW = 2n
            alterparam M_CG = $&best_mcg
            alterparam I_CG = $&best_icg
            alterparam VBIAS_CG = $&best_vbcg
            alterparam RD1 = $&best_rd1
            alterparam M_CS = $&best_mcs
              alterparam W_CS = 100u
            alterparam VBIAS_CS = $&best_vbcs
            alterparam M_CAS = $&best_mcas
            alterparam VBIAS_CAS = $&best_vbcas
            alterparam RD2 = $&best_rd2
            alterparam C12_VAL = $&best_c12
            alterparam M_SF = $&best_msf
              alterparam W_SF = 100u
            alterparam I_BUF = $&best_ibuf
            alterparam L_IN = 1n
            alterparam C_SH_IN = $&best_cshin
            alterparam CIN_VAL = $&best_cin
            alterparam L_OUT = 1n
            alterparam C_SH_OUT = $cshoutval
            alterparam COUT_VAL = $coutval

            reset
            op

            let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

            let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
            let gm_cs = @m.xm1.m0[gm]
            let gm_cas = @m.xm4.m0[gm]
            let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

            let vsrc = v(s)
            let vdcg = v(d)
            let vnx = v(net7)
            let voutint = v(net8)
            let vbf = v(vbuf)

            let vds_cg = v(d)-v(s)
            let vds_cs = v(net7)
            let vds_cas = v(net8)-v(net7)
            let vds_sf = v(vdcbias)-v(vbuf)

            let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
            let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
            let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
            let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
            let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
            let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
            let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

            let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

            set pdc_save = $&pdc_mw
            set gmcg_save = $&gm_cg_tot
            set gmcs_save = $&gm_cs
            set gmcas_save = $&gm_cas
            set rout_save = $&rout_sf
            set vsrc_save = $&vsrc
            set vdcg_save = $&vdcg
            set vnx_save = $&vnx
            set voutint_save = $&voutint
            set vbf_save = $&vbf
            set vdscg_save = $&vds_cg
            set vdscs_save = $&vds_cs
            set vdscas_save = $&vds_cas
            set opp_save = $&op_penalty

            destroy $curplot

            sp lin 9 2.30G 2.50G 1

            let s11db = db(s_1_1)
            let s21db = db(s_2_1)
            let s22db = db(s_2_2)
            let nfdb = real(NF)

            let delta = s_1_1*s_2_2-s_1_2*s_2_1
            let md = mag(delta)
            let a11 = mag(s_1_1)
            let a12 = mag(s_1_2)
            let a21 = mag(s_2_1)
            let a22 = mag(s_2_2)

            let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
            let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
            let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

            let s11w = maximum(s11db)
            let s21m = minimum(s21db)
            let s21x = maximum(s21db)
            let s21lo = s21db[0]
            let s21hi = s21db[8]
            let ripple = s21x-s21m
            let s22w = maximum(s22db)
            let nfw = maximum(nfdb)
            let kmin = minimum(kval)
            let mumin = minimum(mu)
            let mupmin = minimum(mup)
            let dmax = maximum(md)

            let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
            let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
            let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
            let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
            let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
            let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
            let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
            let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
            let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

            let gmcg_ms = $gmcg_save*1000
            let gmcs_ms = $gmcs_save*1000
            let gmcas_ms = $gmcas_save*1000

            let score = 80*ps11*ps11+180*ps22*ps22+260*pgain*pgain+110*pedge*pedge+35*pflat*pflat+55*pnf*pnf+500*pmu*pmu+500*pmup*pmup+500*pdel*pdel+0.025*$pdc_save+$opp_save

            if $vsrc_save < 0.35
              let score = score + 1e6
            end
            if $vbf_save < 0.30
              let score = score + 1e6
            end
            if $vdscg_save < 0.40
              let score = score + 1e6
            end
            if $vdscs_save < 0.40
              let score = score + 1e6
            end
            if $vdscas_save < 0.40
              let score = score + 1e6
            end
            if $pdc_save > 220
              let score = score + 1e6+1000*($pdc_save-220)
            end
            if mumin < 1
              let score = score + 1e6
            end
            if mupmin < 1
              let score = score + 1e6
            end
            if dmax >= 1
              let score = score + 1e6
            end

            echo S5 $&best_mcg $&best_icg $&best_vbcg $&best_rd1 $&best_mcs $&best_vbcs $&best_mcas $&best_vbcas $&best_rd2 $&best_c12 $&best_msf $&best_ibuf 1n $&best_cshin $&best_cin 1n $cshoutval $coutval $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save 100u 100u $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

            if score < best_score_out
              let best_score_out = score
              let best_cshout = $cshoutval
              let best_cout = $coutval
            end

            destroy $curplot
  end
end

echo Best output match: L_OUT=1n C_SH_OUT=$&best_cshout COUT=$&best_cout

* =============================================================================
* STAGE 6: FINAL ACTIVE-CORE AND HEADROOM REFINEMENT
* =============================================================================

echo Starting Stage 6: W_CS, CS bias, cascode bias, and RD2 gain-recovery sweep

foreach rd1val 560
  foreach wcs 60u 70u 80u 90u 100u 110u
    foreach vbcs 1.20 1.25 1.30 1.35 1.40 1.45 1.50
      foreach vbcas 2.70 2.80 2.90 3.00 3.10 3.20 3.30
        foreach rd2val 270 300 330 360 390 430 470
              alterparam L_BW = 2n
              alterparam M_CG = $&best_mcg
              alterparam I_CG = $&best_icg
              alterparam VBIAS_CG = $&best_vbcg
              alterparam RD1 = $rd1val
              alterparam M_CS = $&best_mcs
              alterparam W_CS = $wcs
              alterparam VBIAS_CS = $vbcs
              alterparam M_CAS = $&best_mcas
              alterparam VBIAS_CAS = $vbcas
              alterparam RD2 = $rd2val
              alterparam C12_VAL = $&best_c12
              alterparam M_SF = $&best_msf
              alterparam W_SF = 100u
              alterparam I_BUF = $&best_ibuf
              alterparam L_IN = 1n
              alterparam C_SH_IN = $&best_cshin
              alterparam CIN_VAL = $&best_cin
              alterparam L_OUT = 1n
              alterparam C_SH_OUT = $&best_cshout
              alterparam COUT_VAL = $&best_cout

              reset
              op

              let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

              let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
              let gm_cs = @m.xm1.m0[gm]
              let gm_cas = @m.xm4.m0[gm]
              let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

              let vsrc = v(s)
              let vdcg = v(d)
              let vnx = v(net7)
              let voutint = v(net8)
              let vbf = v(vbuf)

              let vds_cg = v(d)-v(s)
              let vds_cs = v(net7)
              let vds_cas = v(net8)-v(net7)
              let vds_sf = v(vdcbias)-v(vbuf)

              let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
              let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
              let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
              let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
              let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
              let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
              let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

              let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

              set pdc_save = $&pdc_mw
              set gmcg_save = $&gm_cg_tot
              set gmcs_save = $&gm_cs
              set gmcas_save = $&gm_cas
              set rout_save = $&rout_sf
              set vsrc_save = $&vsrc
              set vdcg_save = $&vdcg
              set vnx_save = $&vnx
              set voutint_save = $&voutint
              set vbf_save = $&vbf
              set vdscg_save = $&vds_cg
              set vdscs_save = $&vds_cs
              set vdscas_save = $&vds_cas
              set opp_save = $&op_penalty

              destroy $curplot

              sp lin 9 2.30G 2.50G 1

              let s11db = db(s_1_1)
              let s21db = db(s_2_1)
              let s22db = db(s_2_2)
              let nfdb = real(NF)

              let delta = s_1_1*s_2_2-s_1_2*s_2_1
              let md = mag(delta)
              let a11 = mag(s_1_1)
              let a12 = mag(s_1_2)
              let a21 = mag(s_2_1)
              let a22 = mag(s_2_2)

              let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
              let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
              let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

              let s11w = maximum(s11db)
              let s21m = minimum(s21db)
              let s21x = maximum(s21db)
              let s21lo = s21db[0]
              let s21hi = s21db[8]
              let ripple = s21x-s21m
              let s22w = maximum(s22db)
              let nfw = maximum(nfdb)
              let kmin = minimum(kval)
              let mumin = minimum(mu)
              let mupmin = minimum(mup)
              let dmax = maximum(md)

              let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
              let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
              let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
              let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
              let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
              let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
              let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
              let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
              let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

              let gmcg_ms = $gmcg_save*1000
              let gmcs_ms = $gmcs_save*1000
              let gmcas_ms = $gmcas_save*1000

              let score = 70*ps11*ps11+25*ps22*ps22+650*pgain*pgain+360*pedge*pedge+70*pflat*pflat+70*pnf*pnf+600*pmu*pmu+600*pmup*pmup+600*pdel*pdel+0.030*$pdc_save+$opp_save

              if $vsrc_save < 0.35
                let score = score + 1e6
              end
              if $vbf_save < 0.50
                let score = score + 1e6
              end
              if $voutint_save < 2.70
                let score = score + 1e6
              end
              if $vdscg_save < 0.40
                let score = score + 1e6
              end
              if $vdscs_save < 0.40
                let score = score + 1e6
              end
              if $vdscas_save < 0.40
                let score = score + 1e6
              end
              if $pdc_save > 220
                let score = score + 1e6+1000*($pdc_save-220)
              end
              if mumin < 1
                let score = score + 1e6
              end
              if mupmin < 1
                let score = score + 1e6
              end
              if dmax >= 1
                let score = score + 1e6
              end

              echo S6 $&best_mcg $&best_icg $&best_vbcg $rd1val $&best_mcs $vbcs $&best_mcas $vbcas $rd2val $&best_c12 $&best_msf $&best_ibuf 1n $&best_cshin $&best_cin 1n $&best_cshout $&best_cout $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save $wcs 100u $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

              if score < best_score_active_final
                let best_score_active_final = score
                let best_rd1_final = $rd1val
                let best_wcs_final = $wcs
                let best_vbcs_final = $vbcs
                let best_vbcas_final = $vbcas
                let best_rd2_final = $rd2val
              end

              destroy $curplot
        end
      end
    end
  end
end

echo Best active refinement: RD1=$&best_rd1_final W_CS=$&best_wcs_final VBIAS_CS=$&best_vbcs_final VBIAS_CAS=$&best_vbcas_final RD2=$&best_rd2_final

* =============================================================================
* STAGE 7: FINAL SOURCE-FOLLOWER AND RD2 REFINEMENT
* =============================================================================

echo Starting Stage 7: W_SF, I_BUF, and RD2 refinement

foreach wsf 40u 50u 60u 70u 80u 90u 100u 110u
  foreach ibuf 12.5m 15m 17.5m 20m 22.5m 25m 27.5m 30m
    foreach rd2val 270 300 330 360 390 430 470
            alterparam L_BW = 2n
            alterparam M_CG = $&best_mcg
            alterparam I_CG = $&best_icg
            alterparam VBIAS_CG = $&best_vbcg
            alterparam RD1 = $&best_rd1_final
            alterparam M_CS = $&best_mcs
            alterparam W_CS = $&best_wcs_final
            alterparam VBIAS_CS = $&best_vbcs_final
            alterparam M_CAS = $&best_mcas
            alterparam VBIAS_CAS = $&best_vbcas_final
            alterparam RD2 = $rd2val
            alterparam C12_VAL = $&best_c12
            alterparam M_SF = $&best_msf
            alterparam W_SF = $wsf
            alterparam I_BUF = $ibuf
            alterparam L_IN = 1n
            alterparam C_SH_IN = $&best_cshin
            alterparam CIN_VAL = $&best_cin
            alterparam L_OUT = 1n
            alterparam C_SH_OUT = $&best_cshout
            alterparam COUT_VAL = $&best_cout

            reset
            op

            let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

            let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
            let gm_cs = @m.xm1.m0[gm]
            let gm_cas = @m.xm4.m0[gm]
            let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

            let vsrc = v(s)
            let vdcg = v(d)
            let vnx = v(net7)
            let voutint = v(net8)
            let vbf = v(vbuf)

            let vds_cg = v(d)-v(s)
            let vds_cs = v(net7)
            let vds_cas = v(net8)-v(net7)
            let vds_sf = v(vdcbias)-v(vbuf)

            let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
            let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
            let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
            let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
            let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
            let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
            let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

            let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

            set pdc_save = $&pdc_mw
            set gmcg_save = $&gm_cg_tot
            set gmcs_save = $&gm_cs
            set gmcas_save = $&gm_cas
            set rout_save = $&rout_sf
            set vsrc_save = $&vsrc
            set vdcg_save = $&vdcg
            set vnx_save = $&vnx
            set voutint_save = $&voutint
            set vbf_save = $&vbf
            set vdscg_save = $&vds_cg
            set vdscs_save = $&vds_cs
            set vdscas_save = $&vds_cas
            set opp_save = $&op_penalty

            destroy $curplot

            sp lin 9 2.30G 2.50G 1

            let s11db = db(s_1_1)
            let s21db = db(s_2_1)
            let s22db = db(s_2_2)
            let nfdb = real(NF)

            let delta = s_1_1*s_2_2-s_1_2*s_2_1
            let md = mag(delta)
            let a11 = mag(s_1_1)
            let a12 = mag(s_1_2)
            let a21 = mag(s_2_1)
            let a22 = mag(s_2_2)

            let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
            let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
            let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

            let s11w = maximum(s11db)
            let s21m = minimum(s21db)
            let s21x = maximum(s21db)
            let s21lo = s21db[0]
            let s21hi = s21db[8]
            let ripple = s21x-s21m
            let s22w = maximum(s22db)
            let nfw = maximum(nfdb)
            let kmin = minimum(kval)
            let mumin = minimum(mu)
            let mupmin = minimum(mup)
            let dmax = maximum(md)

            let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
            let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
            let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
            let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
            let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
            let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
            let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
            let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
            let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

            let gmcg_ms = $gmcg_save*1000
            let gmcs_ms = $gmcs_save*1000
            let gmcas_ms = $gmcas_save*1000

            let score = 65*ps11*ps11+20*ps22*ps22+700*pgain*pgain+400*pedge*pedge+75*pflat*pflat+65*pnf*pnf+700*pmu*pmu+700*pmup*pmup+700*pdel*pdel+0.035*$pdc_save+$opp_save

            if $vsrc_save < 0.35
              let score = score + 1e6
            end
            if $vbf_save < 0.50
              let score = score + 1e6
            end
            if $voutint_save < 2.70
              let score = score + 1e6
            end
            if $vdscg_save < 0.40
              let score = score + 1e6
            end
            if $vdscs_save < 0.40
              let score = score + 1e6
            end
            if $vdscas_save < 0.40
              let score = score + 1e6
            end
            if $pdc_save > 220
              let score = score + 1e6+1000*($pdc_save-220)
            end
            if mumin < 1
              let score = score + 1e6
            end
            if mupmin < 1
              let score = score + 1e6
            end
            if dmax >= 1
              let score = score + 1e6
            end

            echo S7 $&best_mcg $&best_icg $&best_vbcg $&best_rd1_final $&best_mcs $&best_vbcs_final $&best_mcas $&best_vbcas_final $rd2val $&best_c12 $&best_msf $ibuf 1n $&best_cshin $&best_cin 1n $&best_cshout $&best_cout $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save $&best_wcs_final $wsf $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

            if score < best_score_sf_final
              let best_score_sf_final = score
              let best_wsf_final = $wsf
              let best_ibuf_final = $ibuf
              let best_rd2_final = $rd2val
            end

            destroy $curplot
    end
  end
end

echo Best final source follower: W_SF=$&best_wsf_final I_BUF=$&best_ibuf_final RD2=$&best_rd2_final

* =============================================================================
* STAGE 8: INTERSTAGE COUPLING AND GAIN-FLATNESS CHECK
* =============================================================================

echo Starting Stage 8: C12 gain-flatness sweep

foreach c12val 15p 20p 30p 50p 75p 100p
        alterparam L_BW = 2n
        alterparam M_CG = $&best_mcg
        alterparam I_CG = $&best_icg
        alterparam VBIAS_CG = $&best_vbcg
        alterparam RD1 = $&best_rd1_final
        alterparam M_CS = $&best_mcs
        alterparam W_CS = $&best_wcs_final
        alterparam VBIAS_CS = $&best_vbcs_final
        alterparam M_CAS = $&best_mcas
        alterparam VBIAS_CAS = $&best_vbcas_final
        alterparam RD2 = $&best_rd2_final
        alterparam C12_VAL = $c12val
        alterparam M_SF = $&best_msf
        alterparam W_SF = $&best_wsf_final
        alterparam I_BUF = $&best_ibuf_final
        alterparam L_IN = 1n
        alterparam C_SH_IN = $&best_cshin
        alterparam CIN_VAL = $&best_cin
        alterparam L_OUT = 1n
        alterparam C_SH_OUT = $&best_cshout
        alterparam COUT_VAL = $&best_cout

        reset
        op

        let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

        let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
        let gm_cs = @m.xm1.m0[gm]
        let gm_cas = @m.xm4.m0[gm]
        let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

        let vsrc = v(s)
        let vdcg = v(d)
        let vnx = v(net7)
        let voutint = v(net8)
        let vbf = v(vbuf)

        let vds_cg = v(d)-v(s)
        let vds_cs = v(net7)
        let vds_cas = v(net8)-v(net7)
        let vds_sf = v(vdcbias)-v(vbuf)

        let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
        let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
        let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
        let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
        let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
        let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
        let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

        let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

        set pdc_save = $&pdc_mw
        set gmcg_save = $&gm_cg_tot
        set gmcs_save = $&gm_cs
        set gmcas_save = $&gm_cas
        set rout_save = $&rout_sf
        set vsrc_save = $&vsrc
        set vdcg_save = $&vdcg
        set vnx_save = $&vnx
        set voutint_save = $&voutint
        set vbf_save = $&vbf
        set vdscg_save = $&vds_cg
        set vdscs_save = $&vds_cs
        set vdscas_save = $&vds_cas
        set opp_save = $&op_penalty

        destroy $curplot

        sp lin 9 2.30G 2.50G 1

        let s11db = db(s_1_1)
        let s21db = db(s_2_1)
        let s22db = db(s_2_2)
        let nfdb = real(NF)

        let delta = s_1_1*s_2_2-s_1_2*s_2_1
        let md = mag(delta)
        let a11 = mag(s_1_1)
        let a12 = mag(s_1_2)
        let a21 = mag(s_2_1)
        let a22 = mag(s_2_2)

        let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
        let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
        let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

        let s11w = maximum(s11db)
        let s21m = minimum(s21db)
        let s21x = maximum(s21db)
        let s21lo = s21db[0]
        let s21hi = s21db[8]
        let ripple = s21x-s21m
        let s22w = maximum(s22db)
        let nfw = maximum(nfdb)
        let kmin = minimum(kval)
        let mumin = minimum(mu)
        let mupmin = minimum(mup)
        let dmax = maximum(md)

        let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
        let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
        let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
        let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
        let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
        let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
        let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
        let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
        let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

        let gmcg_ms = $gmcg_save*1000
        let gmcs_ms = $gmcs_save*1000
        let gmcas_ms = $gmcas_save*1000

        let score = 70*ps11*ps11+20*ps22*ps22+750*pgain*pgain+420*pedge*pedge+180*pflat*pflat+65*pnf*pnf+700*pmu*pmu+700*pmup*pmup+700*pdel*pdel+0.030*$pdc_save+$opp_save

        if $vsrc_save < 0.35
          let score = score + 1e6
        end
        if $vbf_save < 0.50
          let score = score + 1e6
        end
        if $voutint_save < 2.70
          let score = score + 1e6
        end
        if $vdscg_save < 0.40
          let score = score + 1e6
        end
        if $vdscs_save < 0.40
          let score = score + 1e6
        end
        if $vdscas_save < 0.40
          let score = score + 1e6
        end
        if $pdc_save > 220
          let score = score + 1e6+1000*($pdc_save-220)
        end
        if mumin < 1
          let score = score + 1e6
        end
        if mupmin < 1
          let score = score + 1e6
        end
        if dmax >= 1
          let score = score + 1e6
        end

        echo S8 $&best_mcg $&best_icg $&best_vbcg $&best_rd1_final $&best_mcs $&best_vbcs_final $&best_mcas $&best_vbcas_final $&best_rd2_final $c12val $&best_msf $&best_ibuf_final 1n $&best_cshin $&best_cin 1n $&best_cshout $&best_cout $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save $&best_wcs_final $&best_wsf_final $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

        if score < best_score_c12_final
          let best_score_c12_final = score
          let best_c12_final = $c12val
        end

        destroy $curplot
end

echo Best final C12=$&best_c12_final

* =============================================================================
* STAGE 9: FINAL INPUT REMATCH AFTER ACTIVE CHANGES
* =============================================================================

echo Starting Stage 9: final input rematch

  foreach cshinval 1f 25f 50f 100f 200f 350f
    foreach cinval 2.7p 3.3p 3.9p 4.7p 5.6p 6.8p 8.2p 12p 20p 50p 100p
            alterparam L_BW = 2n
            alterparam M_CG = $&best_mcg
            alterparam I_CG = $&best_icg
            alterparam VBIAS_CG = $&best_vbcg
            alterparam RD1 = $&best_rd1_final
            alterparam M_CS = $&best_mcs
            alterparam W_CS = $&best_wcs_final
            alterparam VBIAS_CS = $&best_vbcs_final
            alterparam M_CAS = $&best_mcas
            alterparam VBIAS_CAS = $&best_vbcas_final
            alterparam RD2 = $&best_rd2_final
            alterparam C12_VAL = $&best_c12_final
            alterparam M_SF = $&best_msf
            alterparam W_SF = $&best_wsf_final
            alterparam I_BUF = $&best_ibuf_final
            alterparam L_IN = 1n
            alterparam C_SH_IN = $cshinval
            alterparam CIN_VAL = $cinval
            alterparam L_OUT = 1n
            alterparam C_SH_OUT = $&best_cshout
            alterparam COUT_VAL = $&best_cout

            reset
            op

            let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

            let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
            let gm_cs = @m.xm1.m0[gm]
            let gm_cas = @m.xm4.m0[gm]
            let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

            let vsrc = v(s)
            let vdcg = v(d)
            let vnx = v(net7)
            let voutint = v(net8)
            let vbf = v(vbuf)

            let vds_cg = v(d)-v(s)
            let vds_cs = v(net7)
            let vds_cas = v(net8)-v(net7)
            let vds_sf = v(vdcbias)-v(vbuf)

            let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
            let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
            let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
            let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
            let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
            let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
            let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

            let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

            set pdc_save = $&pdc_mw
            set gmcg_save = $&gm_cg_tot
            set gmcs_save = $&gm_cs
            set gmcas_save = $&gm_cas
            set rout_save = $&rout_sf
            set vsrc_save = $&vsrc
            set vdcg_save = $&vdcg
            set vnx_save = $&vnx
            set voutint_save = $&voutint
            set vbf_save = $&vbf
            set vdscg_save = $&vds_cg
            set vdscs_save = $&vds_cs
            set vdscas_save = $&vds_cas
            set opp_save = $&op_penalty

            destroy $curplot

            sp lin 9 2.30G 2.50G 1

            let s11db = db(s_1_1)
            let s21db = db(s_2_1)
            let s22db = db(s_2_2)
            let nfdb = real(NF)

            let delta = s_1_1*s_2_2-s_1_2*s_2_1
            let md = mag(delta)
            let a11 = mag(s_1_1)
            let a12 = mag(s_1_2)
            let a21 = mag(s_2_1)
            let a22 = mag(s_2_2)

            let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
            let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
            let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

            let s11w = maximum(s11db)
            let s21m = minimum(s21db)
            let s21x = maximum(s21db)
            let s21lo = s21db[0]
            let s21hi = s21db[8]
            let ripple = s21x-s21m
            let s22w = maximum(s22db)
            let nfw = maximum(nfdb)
            let kmin = minimum(kval)
            let mumin = minimum(mu)
            let mupmin = minimum(mup)
            let dmax = maximum(md)

            let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
            let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
            let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
            let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
            let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
            let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
            let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
            let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
            let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

            let gmcg_ms = $gmcg_save*1000
            let gmcs_ms = $gmcs_save*1000
            let gmcas_ms = $gmcas_save*1000

            let score = 330*ps11*ps11+40*ps22*ps22+300*pgain*pgain+160*pedge*pedge+70*pflat*pflat+100*pnf*pnf+700*pmu*pmu+700*pmup*pmup+700*pdel*pdel+0.035*$pdc_save+$opp_save

            if $vsrc_save < 0.35
              let score = score + 1e6
            end
            if $vbf_save < 0.50
              let score = score + 1e6
            end
            if $vdscg_save < 0.40
              let score = score + 1e6
            end
            if $vdscs_save < 0.40
              let score = score + 1e6
            end
            if $vdscas_save < 0.40
              let score = score + 1e6
            end
            if $pdc_save > 220
              let score = score + 1e6+1000*($pdc_save-220)
            end
            if mumin < 1
              let score = score + 1e6
            end
            if mupmin < 1
              let score = score + 1e6
            end
            if dmax >= 1
              let score = score + 1e6
            end

            echo S9 $&best_mcg $&best_icg $&best_vbcg $&best_rd1_final $&best_mcs $&best_vbcs_final $&best_mcas $&best_vbcas_final $&best_rd2_final $&best_c12_final $&best_msf $&best_ibuf_final 1n $cshinval $cinval 1n $&best_cshout $&best_cout $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save $&best_wcs_final $&best_wsf_final $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

            if score < best_score_in_final
              let best_score_in_final = score
              let best_cshin_final = $cshinval
              let best_cin_final = $cinval
            end

            destroy $curplot
  end
end

echo Best final input match: L_IN=1n C_SH_IN=$&best_cshin_final CIN=$&best_cin_final

* =============================================================================
* STAGE 10: FINAL OUTPUT REMATCH AFTER ACTIVE CHANGES
* =============================================================================

echo Starting Stage 10: final output rematch

  foreach cshoutval 1f 25f 50f 100f 200f 350f 500f
    foreach coutval 2.7p 3.9p 5.6p 8.2p 12p 20p 50p 100p
            alterparam L_BW = 2n
            alterparam M_CG = $&best_mcg
            alterparam I_CG = $&best_icg
            alterparam VBIAS_CG = $&best_vbcg
            alterparam RD1 = $&best_rd1_final
            alterparam M_CS = $&best_mcs
            alterparam W_CS = $&best_wcs_final
            alterparam VBIAS_CS = $&best_vbcs_final
            alterparam M_CAS = $&best_mcas
            alterparam VBIAS_CAS = $&best_vbcas_final
            alterparam RD2 = $&best_rd2_final
            alterparam C12_VAL = $&best_c12_final
            alterparam M_SF = $&best_msf
            alterparam W_SF = $&best_wsf_final
            alterparam I_BUF = $&best_ibuf_final
            alterparam L_IN = 1n
            alterparam C_SH_IN = $&best_cshin_final
            alterparam CIN_VAL = $&best_cin_final
            alterparam L_OUT = 1n
            alterparam C_SH_OUT = $cshoutval
            alterparam COUT_VAL = $coutval

            reset
            op

            let pdc_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

            let gm_cg_tot = @m.xm2.m0[gm]+@m.xm2.m0[gmbs]
            let gm_cs = @m.xm1.m0[gm]
            let gm_cas = @m.xm4.m0[gm]
            let rout_sf = 1/(@m.xm3.m0[gm]+@m.xm3.m0[gds])

            let vsrc = v(s)
            let vdcg = v(d)
            let vnx = v(net7)
            let voutint = v(net8)
            let vbf = v(vbuf)

            let vds_cg = v(d)-v(s)
            let vds_cs = v(net7)
            let vds_cas = v(net8)-v(net7)
            let vds_sf = v(vdcbias)-v(vbuf)

            let p_vsrc = 0.5*((target_vsrc-vsrc)+abs(target_vsrc-vsrc))
            let p_vbuf = 0.5*((target_vbuf-vbf)+abs(target_vbuf-vbf))
            let p_vdscg = 0.5*((target_vds-vds_cg)+abs(target_vds-vds_cg))
            let p_vdscs = 0.5*((target_vds-vds_cs)+abs(target_vds-vds_cs))
            let p_vdscas = 0.5*((target_vds-vds_cas)+abs(target_vds-vds_cas))
            let p_vdssf = 0.5*((target_vds-vds_sf)+abs(target_vds-vds_sf))
            let p_pdc = 0.5*((pdc_mw-target_pdc)+abs(pdc_mw-target_pdc))

            let op_penalty = 4000*p_vsrc*p_vsrc+3000*p_vbuf*p_vbuf+300*p_vdscg*p_vdscg+700*p_vdscs*p_vdscs+700*p_vdscas*p_vdscas+100*p_vdssf*p_vdssf+0.05*p_pdc*p_pdc

            set pdc_save = $&pdc_mw
            set gmcg_save = $&gm_cg_tot
            set gmcs_save = $&gm_cs
            set gmcas_save = $&gm_cas
            set rout_save = $&rout_sf
            set vsrc_save = $&vsrc
            set vdcg_save = $&vdcg
            set vnx_save = $&vnx
            set voutint_save = $&voutint
            set vbf_save = $&vbf
            set vdscg_save = $&vds_cg
            set vdscs_save = $&vds_cs
            set vdscas_save = $&vds_cas
            set opp_save = $&op_penalty

            destroy $curplot

            sp lin 9 2.30G 2.50G 1

            let s11db = db(s_1_1)
            let s21db = db(s_2_1)
            let s22db = db(s_2_2)
            let nfdb = real(NF)

            let delta = s_1_1*s_2_2-s_1_2*s_2_1
            let md = mag(delta)
            let a11 = mag(s_1_1)
            let a12 = mag(s_1_2)
            let a21 = mag(s_2_1)
            let a22 = mag(s_2_2)

            let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
            let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
            let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

            let s11w = maximum(s11db)
            let s21m = minimum(s21db)
            let s21x = maximum(s21db)
            let s21lo = s21db[0]
            let s21hi = s21db[8]
            let ripple = s21x-s21m
            let s22w = maximum(s22db)
            let nfw = maximum(nfdb)
            let kmin = minimum(kval)
            let mumin = minimum(mu)
            let mupmin = minimum(mup)
            let dmax = maximum(md)

            let ps11 = 0.5*((s11w-target_s11)+abs(s11w-target_s11))
            let ps22 = 0.5*((s22w-target_s22)+abs(s22w-target_s22))
            let pgain = 0.5*((target_gain_opt-s21m)+abs(target_gain_opt-s21m))
            let pedge = 0.5*((target_gain_spec-s21hi)+abs(target_gain_spec-s21hi))
            let pflat = 0.5*((ripple-target_ripple)+abs(ripple-target_ripple))
            let pnf = 0.5*((nfw-target_nf)+abs(nfw-target_nf))
            let pmu = 0.5*((target_mu-mumin)+abs(target_mu-mumin))
            let pmup = 0.5*((target_mup-mupmin)+abs(target_mup-mupmin))
            let pdel = 0.5*((dmax-0.95)+abs(dmax-0.95))

            let gmcg_ms = $gmcg_save*1000
            let gmcs_ms = $gmcs_save*1000
            let gmcas_ms = $gmcas_save*1000

            let score = 120*ps11*ps11+260*ps22*ps22+360*pgain*pgain+190*pedge*pedge+80*pflat*pflat+70*pnf*pnf+750*pmu*pmu+750*pmup*pmup+750*pdel*pdel+0.035*$pdc_save+$opp_save

            if $vsrc_save < 0.35
              let score = score + 1e6
            end
            if $vbf_save < 0.50
              let score = score + 1e6
            end
            if $vdscg_save < 0.40
              let score = score + 1e6
            end
            if $vdscs_save < 0.40
              let score = score + 1e6
            end
            if $vdscas_save < 0.40
              let score = score + 1e6
            end
            if $pdc_save > 220
              let score = score + 1e6+1000*($pdc_save-220)
            end
            if mumin < 1
              let score = score + 1e6
            end
            if mupmin < 1
              let score = score + 1e6
            end
            if dmax >= 1
              let score = score + 1e6
            end

            echo S10 $&best_mcg $&best_icg $&best_vbcg $&best_rd1_final $&best_mcs $&best_vbcs_final $&best_mcas $&best_vbcas_final $&best_rd2_final $&best_c12_final $&best_msf $&best_ibuf_final 1n $&best_cshin_final $&best_cin_final 1n $cshoutval $coutval $pdc_save $&gmcg_ms $&gmcs_ms $&gmcas_ms $rout_save $&s11w $&s21m $&s21lo $&s21hi $&ripple $&s22w $&nfw $&kmin $&mumin $&mupmin $&dmax $vsrc_save $vdcg_save $vnx_save $voutint_save $vbf_save $vdscg_save $vdscs_save $vdscas_save $&best_wcs_final $&best_wsf_final $&score >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt

            if score < best_score_out_final
              let best_score_out_final = score
              let best_cshout_final = $cshoutval
              let best_cout_final = $coutval
            end

            destroy $curplot
  end
end

echo Best final output match: L_OUT=1n C_SH_OUT=$&best_cshout_final COUT=$&best_cout_final

* =============================================================================
* APPLY FINAL VALUES
* =============================================================================

alterparam L_BW = 2n

alterparam M_CG = $&best_mcg
alterparam I_CG = $&best_icg
alterparam VBIAS_CG = $&best_vbcg
alterparam RD1 = $&best_rd1_final

alterparam M_CS = $&best_mcs
alterparam W_CS = $&best_wcs_final
alterparam VBIAS_CS = $&best_vbcs_final
alterparam M_CAS = $&best_mcas
alterparam VBIAS_CAS = $&best_vbcas_final
alterparam RD2 = $&best_rd2_final
alterparam C12_VAL = $&best_c12_final

alterparam M_SF = $&best_msf
alterparam W_SF = $&best_wsf_final
alterparam I_BUF = $&best_ibuf_final

alterparam L_IN = 1n
alterparam C_SH_IN = $&best_cshin_final
alterparam CIN_VAL = $&best_cin_final

alterparam L_OUT = 1n
alterparam C_SH_OUT = $&best_cshout_final
alterparam COUT_VAL = $&best_cout_final

reset

* =============================================================================
* FINAL SUMMARY AND OPERATING POINT
* =============================================================================

echo ============================================================ > lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CG-CS-CASCODE-SF LNA GAIN-RECOVERY V7 COMPLIANCE NO-RC SUMMARY >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CODE_VERSION_GAIN_RECOVERY_V7_COMPLIANCE_NO_RC_NO_EXTRA_INDUCTOR_RD2_RESISTIVE_LOAD_RETAINED >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo L_BW_FIXED_2nH_LIN_1nH_LOUT_1nH_NO_EXTRA_INDUCTOR >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CG_SOURCE_DC_TARGET_GE_0P35V_FOR_REAL_CURRENT_SINK >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo NO_NET8_RC_DAMPER_V6_PROVED_INEFFECTIVE >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo SF_BODY_CONNECTED_TO_SOURCE_VBUF_INSIDE_DNWELL_REQUIRED >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

echo FINAL_PARAMETERS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo M_CG $&best_mcg >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo I_CG_A $&best_icg >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo VBIAS_CG_V $&best_vbcg >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo RD1_Ohm $&best_rd1_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

echo M_CS $&best_mcs >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo W_CS_m $&best_wcs_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo VBIAS_CS_V $&best_vbcs_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo M_CAS $&best_mcas >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo VBIAS_CAS_V $&best_vbcas_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo RD2_Ohm $&best_rd2_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo C12_F $&best_c12_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

echo M_SF $&best_msf >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo W_SF_m $&best_wsf_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo I_BUF_A $&best_ibuf_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt


echo L_IN_H 1e-9 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo C_SH_IN_F $&best_cshin_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CIN_F $&best_cin_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

echo L_OUT_H 1e-9 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo L_INTENTIONAL_TOTAL_H 2e-9 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo C_SH_OUT_F $&best_cshout_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo COUT_F $&best_cout_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

echo L_BW_H 2e-9 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo R_BW_Ohm 0.2 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo R_L_IN_Ohm 1.5 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo R_L_OUT_Ohm 1.5 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

op

let pdc_total_mw = 1e3*(abs(i(VDD))*v(vdcbias)+abs(i(VDDIO))*v(vddio))

let gm_cg = @m.xm2.m0[gm]
let gmb_cg = @m.xm2.m0[gmbs]
let gds_cg = @m.xm2.m0[gds]
let gm_cs = @m.xm1.m0[gm]
let gds_cs = @m.xm1.m0[gds]
let gm_cas = @m.xm4.m0[gm]
let gds_cas = @m.xm4.m0[gds]
let gm_sf = @m.xm3.m0[gm]
let gmb_sf = @m.xm3.m0[gmbs]
let gds_sf = @m.xm3.m0[gds]

let rin_cg = 1/(gm_cg+gmb_cg)
let rout_sf = 1/(gm_sf+gds_sf)
let av_sf_50_est = gm_sf/(gm_sf+gds_sf+0.02)

let node_s = v(s)
let node_d = v(d)
let node_x = v(net7)
let node_casout = v(net8)
let node_vbuf = v(vbuf)
let vds_cg_final = v(d)-v(s)
let vds_cs_final = v(net7)
let vds_cas_final = v(net8)-v(net7)
let vds_sf_final = v(vdcbias)-v(vbuf)

echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo FINAL_OPERATING_POINT >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo Pdc_total_mW $&pdc_total_mw >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo node_s_V $&node_s >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo node_d_CG_V $&node_d >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo node_net7_CS_drain_CAS_source_V $&node_x >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo node_net8_CAS_drain_SF_gate_V $&node_casout >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo node_vbuf_V $&node_vbuf >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo VDS_CG_V $&vds_cg_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo VDS_CS_V $&vds_cs_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo VDS_CAS_V $&vds_cas_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo VDS_SF_V $&vds_sf_final >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CG_gm_S $&gm_cg >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CG_gmb_S $&gmb_cg >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CG_gds_S $&gds_cg >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CG_Rin_est_Ohm $&rin_cg >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CS_gm_S $&gm_cs >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CS_gds_S $&gds_cs >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CAS_gm_S $&gm_cas >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo CAS_gds_S $&gds_cas >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo SF_gm_S $&gm_sf >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo SF_gmb_S $&gmb_sf >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo SF_gds_S $&gds_sf >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo SF_Rout_body_tied_est_Ohm $&rout_sf >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo SF_Av_50Ohm_est_linear $&av_sf_50_est >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo FINAL_DC_HEADROOM_PASS_FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

if pdc_total_mw <= target_pdc
  echo PDC PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo PDC FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if vds_cg_final >= target_vds
  echo VDS_CG PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo VDS_CG FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if vds_cs_final >= target_vds
  echo VDS_CS PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo VDS_CS FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if vds_cas_final >= target_vds
  echo VDS_CAS PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo VDS_CAS FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if node_vbuf >= 0.50
  echo VBUF PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo VBUF FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if node_casout >= 2.70
  echo VCASOUT PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo VCASOUT FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

destroy $curplot

* =============================================================================
* EXACT 2.4 GHz
* =============================================================================

sp lin 1 2.4G 2.4G 1

let s11_24 = db(s_1_1)
let s21_24 = db(s_2_1)
let s12_24 = db(s_1_2)
let s22_24 = db(s_2_2)
let nf_24 = real(NF)
let nfmin_24 = real(NFmin)

let zin_24 = 50*(1+s_1_1)/(1-s_1_1)
let zout_24 = 50*(1+s_2_2)/(1-s_2_2)

let zin_re_24 = real(zin_24)
let zin_im_24 = imag(zin_24)
let zout_re_24 = real(zout_24)
let zout_im_24 = imag(zout_24)

let s11_phase_deg_24 = 57.2957795*ph(s_1_1)
let s22_phase_deg_24 = 57.2957795*ph(s_2_2)

let delta_24 = s_1_1*s_2_2-s_1_2*s_2_1
let md_24 = mag(delta_24)
let a11_24 = mag(s_1_1)
let a12_24 = mag(s_1_2)
let a21_24 = mag(s_2_1)
let a22_24 = mag(s_2_2)

let k_24 = (1-a11_24*a11_24-a22_24*a22_24+md_24*md_24)/(2*a12_24*a21_24)
let mu_24 = (1-a11_24*a11_24)/(mag(s_2_2-delta_24*conj(s_1_1))+mag(s_1_2*s_2_1))
let mup_24 = (1-a22_24*a22_24)/(mag(s_1_1-delta_24*conj(s_2_2))+mag(s_1_2*s_2_1))

echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo EXACT_2P4_GHZ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S11_dB $&s11_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S21_dB $&s21_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S12_dB $&s12_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S22_dB $&s22_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo NF_dB $&nf_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo NFmin_dB $&nfmin_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo Zin_real_Ohm $&zin_re_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo Zin_imag_Ohm $&zin_im_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo Zout_real_Ohm $&zout_re_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo Zout_imag_Ohm $&zout_im_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S11_phase_deg $&s11_phase_deg_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S22_phase_deg $&s22_phase_deg_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo K $&k_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo MU $&mu_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo MUP $&mup_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo Delta_mag $&md_24 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

destroy $curplot

* =============================================================================
* TARGET BAND: DENSE FINAL VERIFICATION
* =============================================================================

sp lin 81 2.30G 2.50G 1

let s11db = db(s_1_1)
let s21db = db(s_2_1)
let s12db = db(s_1_2)
let s22db = db(s_2_2)
let nfdb = real(NF)
let nfmindb = real(NFmin)

let delta = s_1_1*s_2_2-s_1_2*s_2_1
let md = mag(delta)
let a11 = mag(s_1_1)
let a12 = mag(s_1_2)
let a21 = mag(s_2_1)
let a22 = mag(s_2_2)

let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

let s11w = maximum(s11db)
let s21m = minimum(s21db)
let s21x = maximum(s21db)
let s21_230 = s21db[0]
let s21_240 = s21db[40]
let s21_250 = s21db[80]
let gain_ripple = s21x-s21m
let s22w = maximum(s22db)
let nfw = maximum(nfdb)
let kmin = minimum(kval)
let mumin = minimum(mu)
let mupmin = minimum(mup)
let dmax = maximum(md)

echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo TARGET_BAND_2P30_TO_2P50_GHZ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S11_worst_dB $&s11w >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S21_min_dB $&s21m >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S21_max_dB $&s21x >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S21_2p30_dB $&s21_230 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S21_2p40_dB $&s21_240 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S21_2p50_dB $&s21_250 >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S21_ripple_dB $&gain_ripple >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo S22_worst_dB $&s22w >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo NF_worst_dB $&nfw >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo K_min $&kmin >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo MU_min $&mumin >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo MUP_min $&mupmin >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo Delta_max $&dmax >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo TARGET_BAND_PASS_FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

if s11w <= target_s11
  echo S11 PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo S11 FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if s22w <= target_s22
  echo S22 PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo S22 FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if s21m >= target_gain_spec
  echo GAIN PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo GAIN FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end
if s21m >= target_gain_margin
  echo GAIN_MARGIN_0P8DB PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo GAIN_MARGIN_0P8DB FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if gain_ripple <= target_ripple
  echo GAIN_RIPPLE PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo GAIN_RIPPLE FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if nfw <= target_nf
  echo NF PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo NF FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end
if nfw <= target_nf_margin
  echo NF_MARGIN_0P3DB PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo NF_MARGIN_0P3DB FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if mumin >= 1
  echo MU PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo MU FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if mupmin >= 1
  echo MUP PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo MUP FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if dmax < 1
  echo DELTA PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo DELTA FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo FINAL_TARGET_BAND_TABLE >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo frequency S11dB S21dB S12dB S22dB NFdB NFmindB K MU MUP DeltaMag >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
set appendwrite
wrdata lna_gain_recovery_v7_compliance_no_rc_detailed.txt s11db s21db s12db s22db nfdb nfmindb kval mu mup md
unset appendwrite

destroy $curplot

* =============================================================================
* RECEIVER-RANGE STABILITY: 10 MHz TO 10 GHz
* =============================================================================

sp dec 30 10Meg 10Gig

let delta_10g = s_1_1*s_2_2-s_1_2*s_2_1
let md_10g = mag(delta_10g)
let a11_10g = mag(s_1_1)
let a12_10g = mag(s_1_2)
let a21_10g = mag(s_2_1)
let a22_10g = mag(s_2_2)

let kval_10g = (1-a11_10g*a11_10g-a22_10g*a22_10g+md_10g*md_10g)/(2*a12_10g*a21_10g)
let mu_10g = (1-a11_10g*a11_10g)/(mag(s_2_2-delta_10g*conj(s_1_1))+mag(s_1_2*s_2_1))
let mup_10g = (1-a22_10g*a22_10g)/(mag(s_1_1-delta_10g*conj(s_2_2))+mag(s_1_2*s_2_1))

let kmin_10g = minimum(kval_10g)
let mumin_10g = minimum(mu_10g)
let mupmin_10g = minimum(mup_10g)
let dmax_10g = maximum(md_10g)

let s11db_10g = db(s_1_1)
let s21db_10g = db(s_2_1)
let s12db_10g = db(s_1_2)
let s22db_10g = db(s_2_2)
wrdata lna_gain_recovery_v7_compliance_no_rc_stability_10m_10g_trace.txt frequency mu_10g mup_10g md_10g kval_10g s11db_10g s21db_10g s12db_10g s22db_10g


echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo RECEIVER_RANGE_STABILITY_10MHZ_TO_10GHZ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo K_min $&kmin_10g >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo MU_min $&mumin_10g >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo MUP_min $&mupmin_10g >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo Delta_max $&dmax_10g >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

destroy $curplot

* =============================================================================
* WIDEBAND STABILITY
* =============================================================================

sp dec 30 10Meg 30Gig

let s11db = db(s_1_1)
let s21db = db(s_2_1)
let s12db = db(s_1_2)
let s22db = db(s_2_2)

let delta = s_1_1*s_2_2-s_1_2*s_2_1
let md = mag(delta)
let a11 = mag(s_1_1)
let a12 = mag(s_1_2)
let a21 = mag(s_2_1)
let a22 = mag(s_2_2)

let kval = (1-a11*a11-a22*a22+md*md)/(2*a12*a21)
let mu = (1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
let mup = (1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))

let kmin = minimum(kval)
let mumin = minimum(mu)
let mupmin = minimum(mup)
let dmax = maximum(md)

wrdata lna_gain_recovery_v7_compliance_no_rc_stability_10m_30g_trace.txt frequency mu mup md kval s11db s21db s12db s22db


echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo WIDEBAND_STABILITY_10MHZ_TO_30GHZ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo K_min $&kmin >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo MU_min $&mumin >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo MUP_min $&mupmin >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo Delta_max $&dmax >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo WIDEBAND_STABILITY_PASS_FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_summary.txt

if mumin >= 1
  echo MU_STRICT PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo MU_STRICT FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if mupmin >= 1
  echo MUP_STRICT PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo MUP_STRICT FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if dmax < 1
  echo DELTA_STRICT PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo DELTA_STRICT FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if mumin >= 1.05
  echo MU_1P05_MARGIN PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo MU_1P05_MARGIN FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

if mupmin >= 1.05
  echo MUP_1P05_MARGIN PASS >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
else
  echo MUP_1P05_MARGIN FAIL >> lna_gain_recovery_v7_compliance_no_rc_summary.txt
end

echo ============================================================ >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo FINAL_WIDEBAND_STABILITY_TABLE >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo frequency S11dB S21dB S12dB S22dB K MU MUP DeltaMag >> lna_gain_recovery_v7_compliance_no_rc_detailed.txt
set appendwrite
wrdata lna_gain_recovery_v7_compliance_no_rc_detailed.txt s11db s21db s12db s22db kval mu mup md
unset appendwrite

destroy $curplot

echo ============================================================
echo Cascode LNA optimization complete.
echo Generated:
echo   lna_gain_recovery_v7_compliance_no_rc_summary.txt
echo   lna_gain_recovery_v7_compliance_no_rc_detailed.txt
echo ============================================================

.endc

"}
C {symbols/nfet_06v0.sym} 990 -260 0 0 {name=M2
L=\{L_CG\}
W=\{W_CG\}
nf=10
m=\{M_CG\}
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {lab_pin.sym} 900 -520 2 0 {name=p17 sig_type=std_logic lab=s}
C {res.sym} 690 -70 1 0 {name=RBCG
value=\{RBIAS_CG\}
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 640 -70 0 0 {name=p20 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 750 -70 2 0 {name=p21 sig_type=std_logic lab=g_cg}
C {capa.sym} 680 -150 3 0 {name=CBCG
m=1
value=\{CBYP_CG\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 750 -150 2 0 {name=p19 sig_type=std_logic lab=GND}
C {/media/sf_LNA_chipathon/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.sym} 160 -300 0 0 {name=x1 model=gf180mcu_fd_io__asig_5p0}
C {ind.sym} 270 -580 1 0 {name=LBW_IN
m=1
value=\{L_BW\}
footprint=1206
device=inductor}
C {res.sym} 170 -580 1 0 {name=RBW_IN
value=\{R_BW\}
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 100 -580 0 0 {name=p22 sig_type=std_logic lab=rf_in_ext}
C {lab_pin.sym} 340 -580 2 0 {name=p25 sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 360 -300 2 0 {name=p26 sig_type=std_logic lab=rf_in_pad}
C {vsource.sym} -250 10 1 0 {name=VDDIO value=\{VDDIO_SUP\} savecurrent=false}
C {lab_pin.sym} -190 10 1 0 {name=p27 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 150 -400 1 0 {name=p28 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 190 -400 1 0 {name=p29 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 150 -200 3 0 {name=p30 sig_type=std_logic lab=GND}
C {lab_pin.sym} 190 -200 3 0 {name=p31 sig_type=std_logic lab=GND}
C {lab_pin.sym} 550 -520 0 0 {name=p13 sig_type=std_logic lab=rf_in_pad}
C {/media/sf_LNA_chipathon/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.sym} 1680 -740 0 0 {name=x2 model=gf180mcu_fd_io__asig_5p0}
C {lab_pin.sym} 1670 -840 1 0 {name=p33 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 1710 -840 1 0 {name=p34 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 1670 -640 3 0 {name=p35 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1710 -640 3 0 {name=p36 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1880 -740 2 0 {name=p32 sig_type=std_logic lab=rf_out_pad}
C {ind.sym} 1740 -920 1 0 {name=LBW_IN1
m=1
value=\{L_BW\}
footprint=1206
device=inductor}
C {res.sym} 1640 -920 1 0 {name=RBW_IN1
value=\{R_BW\}
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 1570 -920 0 0 {name=p37 sig_type=std_logic lab=rf_out_ext}
C {lab_pin.sym} 1810 -920 2 0 {name=p38 sig_type=std_logic lab=rf_out_pad}
C {lab_pin.sym} -460 -360 2 0 {name=p7 sig_type=std_logic lab=rf_out_ext}
C {vsource.sym} -260 -270 1 0 {name=VBCS value=\{VBIAS_CS\} savecurrent=false}
C {lab_pin.sym} -200 -270 2 0 {name=p12 sig_type=std_logic lab=vbias_cs}
C {isource.sym} 1010 -160 0 0 {name=ICG value=\{I_CG\}}
C {lab_pin.sym} 950 -260 0 0 {name=p4 sig_type=std_logic lab=g_cg}
C {lab_pin.sym} 620 -150 0 0 {name=p15 sig_type=std_logic lab=g_cg}
C {res.sym} 1010 -400 0 0 {name=RD1_LOAD
value=\{RD1\}
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 1540 -160 3 0 {name=p16 sig_type=std_logic lab=GND}
C {symbols/nfet_06v0.sym} 1520 -260 0 0 {name=M1
L=\{L_CS\}
W=\{W_CS\}
nf=10
m=\{M_CS\}
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {lab_pin.sym} 1480 -260 0 0 {name=p18 sig_type=std_logic lab=g_cs}
C {res.sym} 1310 -420 1 0 {name=RBCS
value=\{RBIAS_CS\}
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 1260 -420 0 0 {name=p23 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 1370 -420 2 0 {name=p24 sig_type=std_logic lab=g_cs}
C {res.sym} 1540 -510 0 0 {name=RD2_LOAD
value=\{RD2\}
footprint=1206
device=resistor
m=1
}
C {lab_pin.sym} 1540 -580 0 0 {name=p39 sig_type=std_logic lab=vdcbias
}
C {symbols/nfet_06v0.sym} 1730 -450 0 0 {name=M3
L=\{L_SF\}
W=\{W_SF\}
nf=10
m=\{M_SF\}
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {lab_pin.sym} 1750 -550 0 0 {name=p40 sig_type=std_logic lab=vdcbias
}
C {gnd.sym} 1750 -260 0 0 {name=l2 lab=GND}
C {isource.sym} 1750 -320 0 0 {name=IBUF value=\{I_BUF\}}
C {capa.sym} 1990 -350 3 0 {name=COUT
m=1
value=\{COUT_VAL\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1750 -390 0 0 {name=p43 sig_type=std_logic lab=vbuf}
C {lab_pin.sym} 1920 -350 0 0 {name=p44 sig_type=std_logic lab=vbuf}
C {lab_pin.sym} 2270 -350 2 0 {name=p45 sig_type=std_logic lab=rf_out_pad}
C {ind.sym} 2090 -350 1 0 {name=LOUT
m=1
value=\{L_OUT\}
footprint=1206
device=inductor
}
C {res.sym} 2200 -350 1 0 {name=RLOUT
value=\{R_L_OUT\}
footprint=1206
device=resistor
m=1}
C {capa.sym} 2250 -240 0 0 {name=CSHOUT
m=1
value=\{C_SH_OUT\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 2250 -170 3 0 {name=p42 sig_type=std_logic lab=GND}
C {capa.sym} 560 -450 0 0 {name=CSHIN
m=1
value=\{C_SH_IN\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 560 -380 3 0 {name=p46 sig_type=std_logic lab=GND}
C {ind.sym} 640 -520 1 0 {name=LIN
m=1
value=\{L_IN\}
footprint=1206
device=inductor
}
C {res.sym} 750 -520 1 0 {name=RLIN
value=\{R_L_IN\}
footprint=1206
device=resistor
m=1}
C {symbols/nfet_06v0.sym} 1520 -370 0 0 {name=M4
L=\{L_CAS\}
W=\{W_CAS\}
nf=10
m=\{M_CAS\}
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {lab_pin.sym} 1480 -370 0 0 {name=p47 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 1560 -370 2 0 {name=p48 sig_type=std_logic lab=GND}
C {vsource.sym} -260 -160 1 0 {name=VBCS1 value=\{VBIAS_CAS\} savecurrent=false}
C {lab_pin.sym} -200 -160 2 0 {name=p49 sig_type=std_logic lab=vbias_cas}
