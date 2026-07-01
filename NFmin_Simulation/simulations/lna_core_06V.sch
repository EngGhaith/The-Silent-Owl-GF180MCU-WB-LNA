v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 320 -360 320 -330 {
lab=GND}
N 740 -250 760 -250 {
lab=GND}
N 320 -330 320 -230 {
lab=GND}
N 320 -450 320 -420 {
lab=vdcbias}
N 320 -310 370 -310 {
lab=GND}
N 140 -430 180 -430 {
lab=in}
N 140 -370 180 -370 {
lab=GND}
N 140 -280 180 -280 {
lab=out}
N 140 -220 180 -220 {
lab=GND}
N 740 -360 740 -280 {
lab=d}
N 740 -450 740 -420 {
lab=vdcbias}
N 430 -310 460 -310 {
lab=vbias}
N 1050 -330 1070 -330 {
lab=match_in}
N 960 -330 990 -330 {
lab=in}
N 740 -320 780 -320 {
lab=d}
N 840 -320 880 -320 {
lab=out}
N 740 -220 740 -210 {
lab=s}
N 740 -210 740 -180 {
lab=s}
N 680 -250 700 -250 {
lab=g}
N 740 -120 740 -90 {
lab=GND}
N 1110 -270 1190 -270 {
lab=s}
N 1190 -270 1190 -230 {
lab=s}
N 1010 -270 1050 -270 {
lab=match_in}
N 1190 -170 1190 -130 {
lab=GND}
N 1190 -270 1290 -270 {
lab=s}
N 320 -230 320 -30 {
lab=GND}
N 490 -40 510 -40 {
lab=vbias}
N 570 -40 600 -40 {
lab=g}
N 470 -120 500 -120 {
lab=g}
N 560 -120 600 -120 {
lab=GND}
N 790 -400 830 -400 {
lab=d}
N 890 -400 940 -400 {
lab=GND}
N 780 -400 790 -400 {
lab=d}
C {vsource.sym} 400 -310 1 0 {name=VGG value=\{VBIAS\} savecurrent=false}
C {gnd.sym} 740 -90 0 0 {name=l1 lab=GND}
C {vsource.sym} 320 -390 0 0 {name=VDD value=\{VDS\} savecurrent=false}
C {ind.sym} 740 -390 2 0 {name=LDD
m=1
value=\{L_load\}
footprint=1206
device=inductor}
C {capa.sym} 810 -320 3 0 {name=COUT
m=1
value=\{C_out\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 740 -310 0 0 {name=p3 sig_type=std_logic lab=d}
C {lab_pin.sym} 180 -430 2 0 {name=p5 sig_type=std_logic lab=in}
C {lab_pin.sym} 180 -370 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} 180 -280 2 0 {name=p7 sig_type=std_logic lab=out}
C {lab_pin.sym} 180 -220 2 0 {name=p8 sig_type=std_logic lab=GND}
C {capa.sym} 1020 -330 3 0 {name=CIN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 320 -30 0 0 {name=l3 lab=GND}
C {lab_pin.sym} 320 -450 0 0 {name=p10 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 680 -250 0 0 {name=p4 sig_type=std_logic lab=g}
C {lab_pin.sym} 460 -310 2 0 {name=p9 sig_type=std_logic lab=vbias}
C {lab_pin.sym} 740 -450 0 0 {name=p11 sig_type=std_logic lab=vdcbias
}
C {lab_pin.sym} 960 -330 0 0 {name=p13 sig_type=std_logic lab=in}
C {lab_pin.sym} 880 -320 2 0 {name=p14 sig_type=std_logic lab=out}
C {port_diff.sym} 140 -400 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} 140 -250 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {lab_pin.sym} 740 -190 2 0 {name=p1 sig_type=std_logic lab=s}
C {lab_pin.sym} 760 -250 2 0 {name=p2 sig_type=std_logic lab=GND}
C {ind.sym} 740 -150 2 0 {name=LSRC
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

.include /foss/pdks/gf180mcuD/libs.ref/gf180mcu_fd_io/spice/gf180mcu_fd_io.spice
"}
C {code.sym} 910 50 0 0 {name=s2 only_toplevel=false value="
* ============================================================
* 6 V common-gate LNA
* Best fixed point after W/VBIAS/passive retune
*
* Assumes model .include/.lib lines are already elsewhere.
* ============================================================
.param VBIAS=1.80
.param VDS=5.0

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
C {symbols/nfet_06v0.sym} 720 -250 0 0 {name=M2
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
C {ind.sym} 1080 -270 3 1 {name=LIN
m=1
value=\{L_series\}
footprint=1206
device=inductor}
C {capa.sym} 1190 -200 0 0 {name=CSHUNT
m=1
value=\{C_shunt\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 1010 -270 0 0 {name=p12 sig_type=std_logic lab=match_in}
C {lab_pin.sym} 1190 -130 3 0 {name=p15 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1290 -270 2 0 {name=p16 sig_type=std_logic lab=s}
C {lab_pin.sym} 1070 -330 2 0 {name=p17 sig_type=std_logic lab=match_in}
C {res.sym} 540 -40 1 0 {name=RBIAS
value=\{Rbias\}
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 490 -40 0 0 {name=p20 sig_type=std_logic lab=vbias}
C {lab_pin.sym} 600 -40 2 0 {name=p21 sig_type=std_logic lab=g}
C {capa.sym} 530 -120 3 0 {name=CGBYP
m=1
value=\{Cgbyp\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 470 -120 0 0 {name=p18 sig_type=std_logic lab=g}
C {lab_pin.sym} 600 -120 2 0 {name=p19 sig_type=std_logic lab=GND}
C {capa.sym} 860 -400 3 0 {name=CLOAD
m=1
value=\{C_load\}
footprint=1206
device="ceramic capacitor"}
C {lab_pin.sym} 780 -400 0 0 {name=p23 sig_type=std_logic lab=d}
C {lab_pin.sym} 940 -400 2 0 {name=p24 sig_type=std_logic lab=GND}
