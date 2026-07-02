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
lab=rf_in_pad}
N 1010 -330 1050 -330 {
lab=d}
N 1110 -330 1150 -330 {
lab=rf_out_pad}
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
N 640 -70 660 -70 {
lab=vbias}
N 720 -70 750 -70 {
lab=g}
N 620 -150 650 -150 {
lab=g}
N 710 -150 750 -150 {
lab=GND}
N 1060 -410 1100 -410 {
lab=d}
N 1160 -410 1210 -410 {
lab=GND}
N 1050 -410 1060 -410 {
lab=d}
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
N -230 -270 -200 -270 {
lab=vddio}
N 1640 -400 1690 -400 {
lab=rf_out_pad}
N 1480 -330 1480 -300 {
lab=GND}
N 1520 -330 1520 -300 {
lab=GND}
N 1480 -500 1480 -470 {
lab=vddio}
N 1520 -500 1520 -470 {
lab=vddio}
N 1420 -600 1460 -600 {
lab=rf_out_pad}
N 1320 -600 1360 -600 {
lab=#net2}
N 1220 -600 1260 -600 {
lab=rf_out_ext}
C {vsource.sym} -240 -390 1 0 {name=VGG value=\{VBIAS\} savecurrent=false}
C {gnd.sym} 1010 -100 0 0 {name=l1 lab=GND}
C {vsource.sym} -320 -470 0 0 {name=VDD value=\{VDS\} savecurrent=false}
C {ind.sym} 1010 -400 2 0 {name=LDD
m=1
value=\{L_load\}
footprint=1206
device=inductor}
C {capa.sym} 1080 -330 3 0 {name=COUT
m=1
value=\{C_out\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1010 -320 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} -460 -510 2 0 {name=p5 sig_type=std_logic lab=rf_in_ext}
C {lab_pin.sym} -460 -450 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} -460 -300 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 610 -520 3 0 {name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} -320 -110 0 0 {name=l3 lab=GND}
C {lab_pin.sym} -320 -530 0 0 {name=p10 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 950 -260 0 0 {name=p4 sig_type=std_logic lab=g}
C {lab_pin.sym} -180 -390 2 0 {name=p9 sig_type=std_logic lab=vbias}
C {lab_pin.sym} 1010 -460 0 0 {name=p11 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 1150 -330 2 0 {name=p14 sig_type=std_logic lab=rf_out_pad}
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
* ============================================================
* 6 V common-gate LNA
* Best fixed point after W/VBIAS/passive retune
*
* Assumes model .include/.lib lines are already elsewhere.
* ============================================================
.param VBIAS=1.80
.param VDS=5.0

.param VDDIO_SUP=5.0
.param L_BW=1n
.param R_BW=0.2

.param W=80e-6
.param L=0.60e-6

.param L_series=4.8n
.param C_shunt=0.50p

.param L_load=4.0n
.param C_load=0.85p
.param C_out=0.20p

.param Rbias=50k
.param Cgbyp=20p

.option savecurrents

.param fnoicor=0
.param sw_stat_mismatch=0

.control
  set noaskquit
  set wr_singlescale
  set wr_vecnames

  echo ============================================================
  echo 6 V CG LNA final fixed-point verification
  echo VBIAS=1.80 V, W=80 um, L=0.60 um
  echo ============================================================

  op

  let id_op = abs(i(vdd))
  let gm_op = @m.xm2.m0[gm]
  let gds_op = @m.xm2.m0[gds]

  let vgs_op = v(g)-v(s)
  let vds_op = v(d)-v(s)
  let vbs_op = -v(s)

  let pdc_op = 1e3*id_op*vds_op
  let gm_id_op = gm_op/id_op
  let ro_op = 1/gds_op
  let gmro_op = gm_op/gds_op
  let rin_cg_op = 1/gm_op

  set id_s = $&id_op
  set gm_s = $&gm_op
  set gds_s = $&gds_op
  set vgs_s = $&vgs_op
  set vds_s = $&vds_op
  set vbs_s = $&vbs_op
  set pdc_s = $&pdc_op
  set gm_id_s = $&gm_id_op
  set ro_s = $&ro_op
  set gmro_s = $&gmro_op
  set rin_s = $&rin_cg_op

  echo Operating point:
  print v(g) v(s) v(d)
  print vgs_op vds_op vbs_op
  print id_op pdc_op
  print gm_op gds_op gm_id_op ro_op gmro_op rin_cg_op

  destroy $curplot

  echo ============================================================
  echo Exact 2.4 GHz point
  echo ============================================================

  echo VBIAS_V W_m L_m L_series_H C_shunt_F L_load_H C_load_F C_out_F VGS_V VDS_V VBS_V ID_A Pdc_mW gm_S gds_S gm_ID_1_per_V ro_Ohm gmro Rin_CG_Ohm S11_dB S21_dB S12_dB S22_dB NF_dB NFmin_dB K_stab > lna06_cg_final_2p4GHz_point.txt

  sp lin 1 2.4e9 2.4e9 1

  let s11_db = db(s_1_1)
  let s21_db = db(s_2_1)
  let s12_db = db(s_1_2)
  let s22_db = db(s_2_2)

  let nf_db = real(NF)
  let nfmin_db = real(NFmin)

  let mag_s11 = mag(s_1_1)
  let mag_s12 = mag(s_1_2)
  let mag_s21 = mag(s_2_1)
  let mag_s22 = mag(s_2_2)

  let delta = s_1_1*s_2_2 - s_1_2*s_2_1
  let mag_delta = mag(delta)

  let k_stab = (1 - mag_s11*mag_s11 - mag_s22*mag_s22 + mag_delta*mag_delta)/(2*mag_s12*mag_s21)

  print s11_db s21_db s12_db s22_db
  print nf_db nfmin_db k_stab

  let vbias_save = 1.80
  let w_save = 80e-6
  let l_save = 0.60e-6
  let lseries_save = 4.8e-9
  let cshunt_save = 0.50e-12
  let lload_save = 4.0e-9
  let cload_save = 0.85e-12
  let cout_save = 0.20e-12

  echo $&vbias_save $&w_save $&l_save $&lseries_save $&cshunt_save $&lload_save $&cload_save $&cout_save $vgs_s $vds_s $vbs_s $id_s $pdc_s $gm_s $gds_s $gm_id_s $ro_s $gmro_s $rin_s $&s11_db $&s21_db $&s12_db $&s22_db $&nf_db $&nfmin_db $&k_stab >> lna06_cg_final_2p4GHz_point.txt

  destroy $curplot

  echo ============================================================
  echo Broadband sweep: 100 MHz to 20 GHz
  echo ============================================================

  sp dec 101 100Meg 20Gig 1

  let s11_db = db(s_1_1)
  let s21_db = db(s_2_1)
  let s12_db = db(s_1_2)
  let s22_db = db(s_2_2)

  let nf_db = real(NF)
  let nfmin_db = real(NFmin)

  let mag_s11 = mag(s_1_1)
  let mag_s12 = mag(s_1_2)
  let mag_s21 = mag(s_2_1)
  let mag_s22 = mag(s_2_2)

  let delta = s_1_1*s_2_2 - s_1_2*s_2_1
  let mag_delta = mag(delta)

  let k_stab = (1 - mag_s11*mag_s11 - mag_s22*mag_s22 + mag_delta*mag_delta)/(2*mag_s12*mag_s21)

  wrdata lna06_cg_final_broadband.txt s11_db s21_db s12_db s22_db nf_db nfmin_db k_stab

  echo ============================================================
  echo Done.
  echo Files generated:
  echo   lna06_cg_final_2p4GHz_point.txt
  echo   lna06_cg_final_broadband.txt
  echo ============================================================

.endc
"
}
C {symbols/nfet_06v0.sym} 990 -260 0 0 {name=M2
L=\{L\}
W=\{W\}
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
C {ind.sym} 640 -430 3 1 {name=LIN
m=1
value=\{L_series\}
footprint=1206
device=inductor}
C {capa.sym} 750 -360 0 0 {name=CSHUNT
m=1
value=\{C_shunt\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 570 -430 0 0 {name=p12 sig_type=std_logic lab=match_in}
C {lab_pin.sym} 750 -290 3 0 {name=p15 sig_type=std_logic lab=GND}
C {lab_pin.sym} 850 -430 2 0 {name=p16 sig_type=std_logic lab=s}
C {lab_pin.sym} 660 -520 2 0 {name=p17 sig_type=std_logic lab=match_in}
C {res.sym} 690 -70 1 0 {name=RBIAS
value=\{Rbias\}
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 640 -70 0 0 {name=p20 sig_type=std_logic lab=vbias}
C {lab_pin.sym} 750 -70 2 0 {name=p21 sig_type=std_logic lab=g}
C {capa.sym} 680 -150 3 0 {name=CGBYP
m=1
value=\{Cgbyp\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 620 -150 0 0 {name=p18 sig_type=std_logic lab=g}
C {lab_pin.sym} 750 -150 2 0 {name=p19 sig_type=std_logic lab=GND}
C {capa.sym} 1130 -410 3 0 {name=CLOAD
m=1
value=\{C_load\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1050 -410 0 0 {name=p23 sig_type=std_logic lab=d}
C {lab_pin.sym} 1210 -410 2 0 {name=p24 sig_type=std_logic lab=GND}
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
C {vsource.sym} -260 -270 1 0 {name=VDDIO value=\{VDDIO_SUP\} savecurrent=false}
C {lab_pin.sym} -200 -270 1 0 {name=p27 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 150 -400 1 0 {name=p28 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 190 -400 1 0 {name=p29 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 150 -200 3 0 {name=p30 sig_type=std_logic lab=GND}
C {lab_pin.sym} 190 -200 3 0 {name=p31 sig_type=std_logic lab=GND}
C {lab_pin.sym} 550 -520 0 0 {name=p13 sig_type=std_logic lab=rf_in_pad}
C {/media/sf_LNA_chipathon/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.sym} 1490 -400 0 0 {name=x2 model=gf180mcu_fd_io__asig_5p0}
C {lab_pin.sym} 1480 -500 1 0 {name=p33 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 1520 -500 1 0 {name=p34 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} 1480 -300 3 0 {name=p35 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1520 -300 3 0 {name=p36 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1690 -400 2 0 {name=p32 sig_type=std_logic lab=rf_out_pad}
C {ind.sym} 1390 -600 1 0 {name=LBW_IN1
m=1
value=\{L_BW\}
footprint=1206
device=inductor}
C {res.sym} 1290 -600 1 0 {name=RBW_IN1
value=\{R_BW\}
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 1220 -600 0 0 {name=p37 sig_type=std_logic lab=rf_out_ext}
C {lab_pin.sym} 1460 -600 2 0 {name=p38 sig_type=std_logic lab=rf_out_pad}
C {lab_pin.sym} -460 -360 2 0 {name=p7 sig_type=std_logic lab=rf_out_ext}
