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
lab=vbias}
N 640 -520 660 -520 {
lab=match_in}
N 550 -520 580 -520 {
lab=rf_in_ext}
N 1010 -330 1050 -330 {
lab=d}
N 1220 -330 1260 -330 {
lab=rf_out_ext}
N 1010 -230 1010 -220 {
lab=s}
N 1010 -220 1010 -190 {
lab=s}
N 950 -260 970 -260 {
lab=g}
N 1010 -130 1010 -100 {
lab=GND}
N 670 -430 750 -430 {
lab=s}
N 750 -430 750 -390 {
lab=s}
N 570 -430 610 -430 {
lab=match_in}
N 750 -330 750 -290 {
lab=GND}
N 750 -430 850 -430 {
lab=s}
N -320 -310 -320 -110 {
lab=GND}
N 550 -180 570 -180 {
lab=vbias}
N 630 -180 660 -180 {
lab=g}
N 1140 -330 1140 -290 {
lab=d}
N 1140 -230 1140 -180 {
lab=GND}
N -320 -270 -290 -270 {
lab=GND}
N -230 -270 -200 -270 {
lab=vddio}
N 680 -180 680 -150 {
lab=g}
N 680 -90 680 -50 {
lab=GND}
N 660 -180 770 -180 {
lab=g}
N 1050 -330 1160 -330 {
lab=d}
N 720 -520 780 -520 {
lab=match_in}
N 1010 -540 1010 -520 {
lab=vdcbias}
N 660 -520 720 -520 {
lab=match_in}
N 1010 -520 1010 -460 {
lab=vdcbias}
C {vsource.sym} -240 -390 1 0 {name=VGG value="dc 1.8" savecurrent=false}
C {gnd.sym} 1010 -100 0 0 {name=l1 lab=GND}
C {vsource.sym} -320 -470 0 0 {name=VDD value="dc 5" savecurrent=false}
C {ind.sym} 1010 -400 2 0 {name=LDD
m=1
value=4n
footprint=1206
device=inductor}
C {capa.sym} 1190 -330 3 0 {name=COUT
m=1
value=0.2p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1010 -320 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} -460 -510 2 0 {name=p5 sig_type=std_logic lab=rf_in_ext}
C {lab_pin.sym} -460 -450 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} -460 -300 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 640 -430 3 0 {name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"
}
C {gnd.sym} -320 -110 0 0 {name=l3 lab=GND}
C {lab_pin.sym} -320 -530 0 0 {name=p10 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 950 -260 0 0 {name=p4 sig_type=std_logic lab=g}
C {lab_pin.sym} -180 -390 2 0 {name=p9 sig_type=std_logic lab=vbias}
C {lab_pin.sym} 1010 -540 0 0 {name=p11 sig_type=std_logic lab=vdcbias
}
C {port_diff.sym} -500 -480 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} -500 -330 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {lab_pin.sym} 1010 -200 2 0 {name=p1 sig_type=std_logic lab=s}
C {lab_pin.sym} 1030 -260 2 0 {name=p2 sig_type=std_logic lab=GND}
C {ind.sym} 1010 -160 2 0 {name=LSRC
m=1
value=10u
footprint=1206
device=inductor}
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

.option savecurrents

.param fnoicor=0
.param sw_stat_mismatch=0

.control
  set noaskquit
  set wr_singlescale
  set wr_vecnames
  set filetype=ascii

  
  echo 6 V CG LNA
  
  * Operating point
  
  op

  let id_op      = abs(i(vdd))
  let gm_op      = @m.xm2.m0[gm]
  let gds_op     = @m.xm2.m0[gds]

  let vgs_op     = v(g)-v(s)
  let vds_op     = v(d)-v(s)
  let vbs_op     = -v(s)

  let pdc_op     = 1e3*id_op*5
  let gm_id_op   = gm_op/id_op
  let ro_op      = 1/gds_op
  let gmro_op    = gm_op/gds_op
  let rin_cg_op  = 1/gm_op

  echo OPERATING POINT 
  print v(g) v(s) v(d)
  print vgs_op vds_op vbs_op
  print id_op pdc_op
  print gm_op gds_op gm_id_op ro_op gmro_op rin_cg_op

  wrdata lna06_op.txt v(g) v(s) v(d) vgs_op vds_op vbs_op id_op pdc_op gm_op gds_op gm_id_op ro_op gmro_op rin_cg_op
  destroy $curplot

  
  echo ============================================================
  echo Exact 2.4 GHz S-parameter/noise point
  echo ============================================================

  sp lin 1 2.4e9 2.4e9 1

  let s11_db = db(s_1_1)
  let s21_db = db(s_2_1)
  let s12_db = db(s_1_2)
  let s22_db = db(s_2_2)

  let nf_db    = real(NF)
  let nfmin_db = real(NFmin)

  let mag_s11 = mag(s_1_1)
  let mag_s12 = mag(s_1_2)
  let mag_s21 = mag(s_2_1)
  let mag_s22 = mag(s_2_2)

  let delta     = s_1_1*s_2_2 - s_1_2*s_2_1
  let mag_delta = mag(delta)

  let k_stab = (1 - mag_s11*mag_s11 - mag_s22*mag_s22 + mag_delta*mag_delta)/(2*mag_s12*mag_s21)

  let vswr_in  = (1 + mag_s11)/(1 - mag_s11)
  let vswr_out = (1 + mag_s22)/(1 - mag_s22)

  let mismatch_loss_in_db  = -10*log10(1 - mag_s11*mag_s11)
  let mismatch_loss_out_db = -10*log10(1 - mag_s22*mag_s22)

  echo ----------2.4 GHz RESULTS --------------
  print s11_db s21_db s12_db s22_db
  print nf_db nfmin_db
  print k_stab mag_delta
  print vswr_in vswr_out
  print mismatch_loss_in_db mismatch_loss_out_db

  wrdata lna06_2p4GHz_point.txt s11_db s21_db s12_db s22_db nf_db nfmin_db k_stab mag_delta vswr_in vswr_out mismatch_loss_in_db mismatch_loss_out_db

  write lna06_2p4GHz.raw all

  destroy $curplot

  
  echo ============================================================
  echo Broadband sweep: 100 MHz to 20 GHz
  echo ============================================================

  sp dec 201 100Meg 20Gig 1

  let freqGHz = frequency/1e9

  let s11_db = db(s_1_1)
  let s21_db = db(s_2_1)
  let s12_db = db(s_1_2)
  let s22_db = db(s_2_2)

  let nf_db    = real(NF)
  let nfmin_db = real(NFmin)

  let mag_s11 = mag(s_1_1)
  let mag_s12 = mag(s_1_2)
  let mag_s21 = mag(s_2_1)
  let mag_s22 = mag(s_2_2)

  let delta     = s_1_1*s_2_2 - s_1_2*s_2_1
  let mag_delta = mag(delta)

  let k_stab = (1 - mag_s11*mag_s11 - mag_s22*mag_s22 + mag_delta*mag_delta)/(2*mag_s12*mag_s21)

  let vswr_in  = (1 + mag_s11)/(1 - mag_s11)
  let vswr_out = (1 + mag_s22)/(1 - mag_s22)

  let mismatch_loss_in_db  = -10*log10(1 - mag_s11*mag_s11)
  let mismatch_loss_out_db = -10*log10(1 - mag_s22*mag_s22)

  * Approximate available power gain if ports are reasonably matched:
  let gt_approx_db = s21_db + 10*log10(1 - mag_s11*mag_s11) + 10*log10(1 - mag_s22*mag_s22)

    echo BROADBAND SUMMARY

  let s21_max_db      = vecmax(s21_db)
  let s11_best_db     = vecmin(s11_db)
  let s22_best_db     = vecmin(s22_db)
  let nf_min_db       = vecmin(nf_db)
  let k_min           = vecmin(k_stab)
  let delta_max       = vecmax(mag_delta)

  print s21_max_db
  print s11_best_db
  print s22_best_db
  print nf_min_db
  print k_min
  print delta_max

  wrdata lna06_broadband_all.txt s11_db s21_db s12_db s22_db nf_db nfmin_db k_stab mag_delta vswr_in vswr_out mismatch_loss_in_db mismatch_loss_out_db gt_approx_db
  write lna06_broadband.raw all
  
  * Plots from ngspice

  plot s21_db s11_db s22_db s12_db
  hardcopy lna06_sparams.ps s21_db s11_db s22_db s12_db

  plot nf_db nfmin_db
  hardcopy lna06_noise.ps nf_db nfmin_db

  plot k_stab
  hardcopy lna06_k_stability.ps k_stab

  plot mag_delta
  hardcopy lna06_delta.ps mag_delta

  plot vswr_in vswr_out
  hardcopy lna06_vswr.ps vswr_in vswr_out

  plot mismatch_loss_in_db mismatch_loss_out_db
  hardcopy lna06_mismatch_loss.ps mismatch_loss_in_db mismatch_loss_out_db

  plot gt_approx_db s21_db
  hardcopy lna06_gain_comparison.ps gt_approx_db s21_db

  echo Done.

.endc

"
}
C {symbols/nfet_06v0.sym} 990 -260 0 0 {name=M2
L=0.6u
W=80u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0
spiceprefix=X
}
C {ind.sym} 610 -520 3 1 {name=LIN
m=1
value=4.8n
footprint=1206
device=inductor}
C {capa.sym} 750 -360 0 0 {name=CSHUNT
m=1
value=0.5p
footprint=1206
device="ceramic capacitor"
}
C {lab_pin.sym} 570 -430 0 0 {name=p12 sig_type=std_logic lab=match_in}
C {lab_pin.sym} 750 -290 3 0 {name=p15 sig_type=std_logic lab=GND}
C {lab_pin.sym} 850 -430 2 0 {name=p16 sig_type=std_logic lab=s}
C {lab_pin.sym} 780 -520 2 0 {name=p17 sig_type=std_logic lab=match_in}
C {res.sym} 600 -180 1 0 {name=RBIAS
value=50k
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 550 -180 0 0 {name=p20 sig_type=std_logic lab=vbias}
C {lab_pin.sym} 770 -180 2 0 {name=p21 sig_type=std_logic lab=g}
C {capa.sym} 1140 -260 0 0 {name=CLOAD
m=1
value=0.85p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1140 -180 3 0 {name=p24 sig_type=std_logic lab=GND}
C {vsource.sym} -260 -270 1 0 {name=VDDIO value="dc 5" savecurrent=false}
C {lab_pin.sym} -200 -270 1 0 {name=p27 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} -460 -360 2 0 {name=p7 sig_type=std_logic lab=rf_out_ext}
C {capa.sym} 680 -120 0 0 {name=CGBYP1
m=1
value=20p
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 680 -50 3 0 {name=p39 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1260 -330 2 0 {name=p14 sig_type=std_logic lab=rf_out_ext}
C {lab_pin.sym} 550 -520 0 0 {name=p13 sig_type=std_logic lab=rf_in_ext}
