v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 480 -1080 480 -1040 {lab=vdd}
N 300 -990 330 -990 {lab=rf_in_pad}
N 300 -930 330 -930 {lab=vbias_csc}
N 300 -910 330 -910 {lab=vbias_icg}
N 300 -890 330 -890 {lab=vbias_cg}
N 300 -870 330 -870 {lab=vbias_cs}
N 300 -850 330 -850 {lab=vbias_cas}
N 300 -830 330 -830 {lab=vbias_casc}
N 300 -810 330 -810 {lab=vbias_buf}
N 480 -780 480 -740 {lab=vss}
N 630 -910 660 -910 {lab=rf_out_pad}
N -200 -480 -200 -450 {
lab=GND}
N -200 -570 -200 -540 {
lab=vdd}
N -380 -840 -340 -840 {
lab=rf_in_ext}
N -380 -780 -340 -780 {
lab=GND}
N -380 -690 -340 -690 {
lab=rf_out_ext}
N -380 -630 -340 -630 {
lab=GND}
N -35 -1460 15 -1460 {
lab=rf_in_pad
}
N -195 -1390 -195 -1360 {
lab=GND
}
N -155 -1390 -155 -1360 {
lab=GND
}
N -195 -1560 -195 -1530 {
lab=vddio
}
N -155 -1560 -155 -1530 {
lab=vddio
}
N -35 -1095 15 -1095 {
lab=rf_out_pad
}
N -195 -1025 -195 -995 {
lab=GND
}
N -155 -1025 -155 -995 {
lab=GND
}
N -195 -1195 -195 -1165 {
lab=vddio
}
N -155 -1195 -155 -1165 {
lab=vddio
}
N -108.75 -450 -78.75 -450 {
lab=vss}
N -200 -450 -168.75 -450 {
lab=GND}
N 280 -1210 320 -1210 {
lab=rf_in_pad}
N 180 -1210 220 -1210 {
lab=#net1}
N 80 -1210 120 -1210 {
lab=rf_in_ext}
N 280 -1370 320 -1370 {
lab=rf_out_pad}
N 180 -1370 220 -1370 {
lab=#net2}
N 80 -1370 120 -1370 {
lab=rf_out_ext}
N -200 -450 -200 -390 {lab=GND}
N -680 -1400 -680 -1370 {
lab=GND}
N -680 -1370 -680 -1270 {
lab=GND}
N -680 -1350 -630 -1350 {
lab=GND}
N -570 -1350 -540 -1350 {
lab=vbias_cg}
N -680 -1270 -680 -1070 {
lab=GND}
N -680 -1230 -650 -1230 {
lab=GND}
N -580 -950 -550 -950 {
lab=vddio}
N -680 -950 -640 -950 {
lab=GND}
N -590 -1230 -560 -1230 {
lab=vbias_cs}
N -680 -1070 -680 -940 {
lab=GND}
N -590 -1120 -560 -1120 {
lab=vbias_cas}
N -680 -1120 -650 -1120 {
lab=GND}
N -830 -1000 -800 -1000 {
lab=vbias_buf}
N -740 -1000 -680 -1000 {
lab=GND}
N -840 -1110 -810 -1110 {
lab=vbias_icg}
N -750 -1110 -680 -1110 {
lab=GND}
N -590 -1230 -560 -1230 {lab=vbias_cs}
N -710 -1000 -710 -970 {
lab=GND}
N -710 -910 -710 -880 {
lab=vbias_csc}
N -590 -1020 -560 -1020 {
lab=vbias_casc}
N -680 -1020 -650 -1020 {
lab=GND}
C {lna_core.sym} 480 -910 0 0 {name=x1}
C {vsource.sym} -200 -510 0 0 {name=VDD value=\{VDD\} savecurrent=false}
C {lab_pin.sym} -340 -840 2 0 {name=p5 sig_type=std_logic lab=rf_in_ext}
C {lab_pin.sym} -340 -780 2 0 {name=p6 sig_type=std_logic lab=GND

}
C {lab_pin.sym} -340 -630 2 0 {name=p8 sig_type=std_logic lab=GND}
C {gnd.sym} -200 -390 0 0 {name=l3 lab=GND}
C {lab_pin.sym} -200 -570 0 0 {name=p10 sig_type=std_logic lab=vdd
}
C {port_diff.sym} -380 -810 0 0 {name=V1 portnum=1 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {port_diff.sym} -380 -660 0 0 {name=V2 portnum=2 Z0=50 DCval=0 ACmag=1 ACphase=0 TRANval=""}
C {lab_pin.sym} -340 -690 2 0 {name=p7 sig_type=std_logic lab=rf_out_ext}
C {lab_pin.sym} 15 -1460 2 0 {name=p56 sig_type=std_logic lab=rf_in_pad
}
C {lab_pin.sym} -195 -1560 1 0 {name=p57 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} -155 -1560 1 0 {name=p58 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} -195 -1360 3 0 {name=p59 sig_type=std_logic lab=GND
}
C {lab_pin.sym} -155 -1360 3 0 {name=p60 sig_type=std_logic lab=GND
}
C {/home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.sym} -185 -1460 0 0 {name=x3 model=gf180mcu_fd_io__asig_5p0
}
C {lab_pin.sym} -195 -1195 1 0 {name=p61 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} -155 -1195 1 0 {name=p62 sig_type=std_logic lab=vddio
}
C {lab_pin.sym} -195 -995 3 0 {name=p63 sig_type=std_logic lab=GND
}
C {lab_pin.sym} -155 -995 3 0 {name=p64 sig_type=std_logic lab=GND
}
C {lab_pin.sym} 15 -1095 2 0 {name=p65 sig_type=std_logic lab=rf_out_pad
}
C {/home/arjun/eda/projects/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/xschem/gf180mcu_fd_io__asig_5p0.sym} -185 -1095 0 0 {name=x4 model=gf180mcu_fd_io__asig_5p0
}
C {vsource.sym} -138.75 -450 1 0 {name=VSS value=0 savecurrent=false}
C {lab_pin.sym} -78.75 -450 2 0 {name=p73 sig_type=std_logic lab=vss}
C {lab_pin.sym} 300 -990 0 0 {name=p1 sig_type=std_logic lab=rf_in_pad}
C {lab_pin.sym} 300 -930 0 0 {name=p2 sig_type=std_logic lab=vbias_csc}
C {lab_pin.sym} 300 -910 0 0 {name=p3 sig_type=std_logic lab=vbias_icg}
C {lab_pin.sym} 300 -890 0 0 {name=p4 sig_type=std_logic lab=vbias_cg}
C {lab_pin.sym} 300 -870 0 0 {name=p11 sig_type=std_logic lab=vbias_cs}
C {lab_pin.sym} 300 -850 0 0 {name=p13 sig_type=std_logic lab=vbias_cas}
C {lab_pin.sym} 300 -830 0 0 {name=p14 sig_type=std_logic lab=vbias_casc}
C {lab_pin.sym} 300 -810 0 0 {name=p15 sig_type=std_logic lab=vbias_buf}
C {lab_pin.sym} 480 -1080 1 0 {name=p16 sig_type=std_logic lab=vdd}
C {lab_pin.sym} 480 -740 3 0 {name=p17 sig_type=std_logic lab=vss}
C {lab_pin.sym} 660 -910 2 0 {name=p18 sig_type=std_logic lab=rf_out_pad}
C {ind.sym} 250 -1210 1 0 {name=LBW_IN
m=1
value=\{L_BW\}
footprint=1206
device=inductor}
C {res.sym} 150 -1210 1 0 {name=RBW_IN
value=\{R_BW\}
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 80 -1210 0 0 {name=p22 sig_type=std_logic lab=rf_in_ext}
C {lab_pin.sym} 320 -1210 2 0 {name=p25 sig_type=std_logic lab=rf_in_pad}
C {ind.sym} 250 -1370 1 0 {name=LBW_IN1
m=1
value=\{L_BW\}
footprint=1206
device=inductor}
C {res.sym} 150 -1370 1 0 {name=RBW_IN1
value=\{R_BW\}
footprint=1206
device=resistor
m=1}
C {lab_pin.sym} 80 -1370 0 0 {name=p37 sig_type=std_logic lab=rf_out_ext}
C {lab_pin.sym} 320 -1370 2 0 {name=p38 sig_type=std_logic lab=rf_out_pad}
C {code_shown.sym} 50 -505 0 0 {name=MODELS only_toplevel=true
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
C {code_shown.sym} 840 -870 0 0 {name=s1 only_toplevel=false value="

.param VDD=5.0

.param L_BW=3n
.param R_BW=0.2

.param RNC_TEST=1m

.param WPMOS=50u
.param LPMOS=2u

"}
C {code.sym} 1152.5 -856.25 0 0 {name=s4 only_toplevel=false value="

.control

set noaskquit
set wr_singlescale
set wr_vecnames
set numdgt=10

let target_gain_bw=10.0

echo ============================================================ > lna_core_06V_cgcs_report.txt
echo GF180MCU_LNA_CORE_06V_CGCS_DETAILED_REPORT >> lna_core_06V_cgcs_report.txt
echo TARGET_FREQUENCY_HZ 2.400e9 >> lna_core_06V_cgcs_report.txt
echo TARGET_BAND_HZ 2.300e9 2.500e9 >> lna_core_06V_cgcs_report.txt
echo GAIN_BANDWIDTH_THRESHOLD_DB 10.0 >> lna_core_06V_cgcs_report.txt
echo PORT_REFERENCE_OHM 50 >> lna_core_06V_cgcs_report.txt
echo NOTE_HIERARCHY LNA_CORE_INSTANCE_IS_X1 >> lna_core_06V_cgcs_report.txt
echo ============================================================ >> lna_core_06V_cgcs_report.txt

* =============================================================================
* DC OPERATING POINT
* =============================================================================

op

* Top-level supply and bias-generator values.
let pdcop=1e3*abs(i(VDD))*v(vdd)
let icoreop=abs(i(VDD))
let iioop=0

let v_vddop=v(vdd)
let v_vpop=v(vp)
let v_vrefop=v(vref)
let v_vsenseop=v(vsense)
let v_vbias_casop=v(vbias_cas)
let v_vbias_3v3op=v(vbias_3v3)
let v_vbias_cascop=v(vbias_casc)
let v_vbias_cgop=v(vbias_cg)
let v_vbias_icgop=v(vbias_icg)
let v_vbias_bufop=v(vbias_buf)
let v_vbias_csop=v(vbias_cs)
let v_vbias_cscop=v(vbias_csc)

let i_r1=(v(vbias_cas)-v(vbias_3v3))/20k
let i_r2=(v(vbias_3v3)-v(vbias_casc))/5k
let i_r3=(v(vbias_casc)-v(vbias_cg))/50k
let i_r4=(v(vbias_cg)-v(vbias_icg))/15k
let i_r5=(v(vbias_icg)-v(vbias_buf))/30k
let i_r6=(v(vbias_buf)-v(vbias_cs))/5k
let i_r7=(v(vbias_cs)-v(vsense))/3.066k
let i_r8=(v(vsense)-v(vbias_csc))/11.934k
let i_r9=v(vbias_csc)/45k
let i_ladder_avg=(i_r1+i_r2+i_r3+i_r4+i_r5+i_r6+i_r7+i_r8+i_r9)/9

* LNA internal nodes are inside instance x1.
let vsop=v(x1.s)
let vdop=v(x1.vm2)
let vnet3op=v(x1.net3)
let vnet8op=v(x1.net8)
let vbufop=v(x1.vbuf)
let vgcsop=v(x1.g_cs)
let vgcgop=v(x1.g_cg)
let vgcsccop=v(x1.g_csc)
let vxop=v(x1.vx)
let vm1op=v(x1.vm1)
let vm2op=v(x1.vm2)

* XM1: main CS device.
let id1op=abs(@m.x1.xm1.m0[id])
let gm1op=@m.x1.xm1.m0[gm]
let gmb1op=@m.x1.xm1.m0[gmbs]
let gds1op=@m.x1.xm1.m0[gds]
let vgs1op=@m.x1.xm1.m0[vgs]
let vds1op=@m.x1.xm1.m0[vds]
let vbs1op=@m.x1.xm1.m0[vbs]
let vth1op=@m.x1.xm1.m0[vth]
let vov1op=vgs1op-vth1op
let vdsat1op=abs(@m.x1.xm1.m0[vdsat])
let sat1op=vds1op-vdsat1op
let gmid1op=gm1op/(id1op+1e-30)
let ro1op=1/(gds1op+1e-30)

* XM2: CG input device.
let id2op=abs(@m.x1.xm2.m0[id])
let gm2op=@m.x1.xm2.m0[gm]
let gmb2op=@m.x1.xm2.m0[gmbs]
let gds2op=@m.x1.xm2.m0[gds]
let vgs2op=@m.x1.xm2.m0[vgs]
let vds2op=@m.x1.xm2.m0[vds]
let vbs2op=@m.x1.xm2.m0[vbs]
let vth2op=@m.x1.xm2.m0[vth]
let vov2op=vgs2op-vth2op
let vdsat2op=abs(@m.x1.xm2.m0[vdsat])
let sat2op=vds2op-vdsat2op
let gmid2op=gm2op/(id2op+1e-30)
let ro2op=1/(gds2op+1e-30)

* XM3: source follower.
let id3op=abs(@m.x1.xm3.m0[id])
let gm3op=@m.x1.xm3.m0[gm]
let gmb3op=@m.x1.xm3.m0[gmbs]
let gds3op=@m.x1.xm3.m0[gds]
let vgs3op=@m.x1.xm3.m0[vgs]
let vds3op=@m.x1.xm3.m0[vds]
let vbs3op=@m.x1.xm3.m0[vbs]
let vth3op=@m.x1.xm3.m0[vth]
let vov3op=vgs3op-vth3op
let vdsat3op=abs(@m.x1.xm3.m0[vdsat])
let sat3op=vds3op-vdsat3op
let gmid3op=gm3op/(id3op+1e-30)
let ro3op=1/(gds3op+1e-30)

* XM4: CS cascode.
let id4op=abs(@m.x1.xm4.m0[id])
let gm4op=@m.x1.xm4.m0[gm]
let gmb4op=@m.x1.xm4.m0[gmbs]
let gds4op=@m.x1.xm4.m0[gds]
let vgs4op=@m.x1.xm4.m0[vgs]
let vds4op=@m.x1.xm4.m0[vds]
let vbs4op=@m.x1.xm4.m0[vbs]
let vth4op=@m.x1.xm4.m0[vth]
let vov4op=vgs4op-vth4op
let vdsat4op=abs(@m.x1.xm4.m0[vdsat])
let sat4op=vds4op-vdsat4op
let gmid4op=gm4op/(id4op+1e-30)
let ro4op=1/(gds4op+1e-30)

* XM5: CG current sink.
let id5op=abs(@m.x1.xm5.m0[id])
let gm5op=@m.x1.xm5.m0[gm]
let gmb5op=@m.x1.xm5.m0[gmbs]
let gds5op=@m.x1.xm5.m0[gds]
let vgs5op=@m.x1.xm5.m0[vgs]
let vds5op=@m.x1.xm5.m0[vds]
let vbs5op=@m.x1.xm5.m0[vbs]
let vth5op=@m.x1.xm5.m0[vth]
let vov5op=vgs5op-vth5op
let vdsat5op=abs(@m.x1.xm5.m0[vdsat])
let sat5op=vds5op-vdsat5op
let gmid5op=gm5op/(id5op+1e-30)
let ro5op=1/(gds5op+1e-30)

* XM6: buffer current sink.
let id6op=abs(@m.x1.xm6.m0[id])
let gm6op=@m.x1.xm6.m0[gm]
let gmb6op=@m.x1.xm6.m0[gmbs]
let gds6op=@m.x1.xm6.m0[gds]
let vgs6op=@m.x1.xm6.m0[vgs]
let vds6op=@m.x1.xm6.m0[vds]
let vbs6op=@m.x1.xm6.m0[vbs]
let vth6op=@m.x1.xm6.m0[vth]
let vov6op=vgs6op-vth6op
let vdsat6op=abs(@m.x1.xm6.m0[vdsat])
let sat6op=vds6op-vdsat6op
let gmid6op=gm6op/(id6op+1e-30)
let ro6op=1/(gds6op+1e-30)

* XM7: CG cascode.
let id7op=abs(@m.x1.xm7.m0[id])
let gm7op=@m.x1.xm7.m0[gm]
let gmb7op=@m.x1.xm7.m0[gmbs]
let gds7op=@m.x1.xm7.m0[gds]
let vgs7op=@m.x1.xm7.m0[vgs]
let vds7op=@m.x1.xm7.m0[vds]
let vbs7op=@m.x1.xm7.m0[vbs]
let vth7op=@m.x1.xm7.m0[vth]
let vov7op=vgs7op-vth7op
let vdsat7op=abs(@m.x1.xm7.m0[vdsat])
let sat7op=vds7op-vdsat7op
let gmid7op=gm7op/(id7op+1e-30)
let ro7op=1/(gds7op+1e-30)

* XM9: cancellation CS.
let id9op=abs(@m.x1.xm9.m0[id])
let gm9op=@m.x1.xm9.m0[gm]
let gmb9op=@m.x1.xm9.m0[gmbs]
let gds9op=@m.x1.xm9.m0[gds]
let vgs9op=@m.x1.xm9.m0[vgs]
let vds9op=@m.x1.xm9.m0[vds]
let vbs9op=@m.x1.xm9.m0[vbs]
let vth9op=@m.x1.xm9.m0[vth]
let vov9op=vgs9op-vth9op
let vdsat9op=abs(@m.x1.xm9.m0[vdsat])
let sat9op=vds9op-vdsat9op
let gmid9op=gm9op/(id9op+1e-30)
let ro9op=1/(gds9op+1e-30)

let vnet9op=vnet3op+vds1op
let vnet9check=vnet8op-vds4op
let vnet9diff=vnet9op-vnet9check
let vnet10op=vsop+vds2op
let vnet10check=vdop-vds7op
let vnet10diff=vnet10op-vnet10check

set op_pdc=$&pdcop
set op_icore=$&icoreop
set op_iio=$&iioop
set op_vs=$&vsop
set op_vnet10=$&vnet10op
set op_vnet10check=$&vnet10check
set op_vnet10diff=$&vnet10diff
set op_vd=$&vdop
set op_vnet3=$&vnet3op
set op_vnet9=$&vnet9op
set op_vnet9check=$&vnet9check
set op_vnet9diff=$&vnet9diff
set op_vnet8=$&vnet8op
set op_vbuf=$&vbufop
set op_vgcs=$&vgcsop
set op_vgcg=$&vgcgop
set op_vgcsc=$&vgcsccop
set op_vx=$&vxop
set op_vm1=$&vm1op
set op_vm2=$&vm2op

set op_vdd=$&v_vddop
set op_vp=$&v_vpop
set op_vref=$&v_vrefop
set op_vsense=$&v_vsenseop
set op_vbias_cas=$&v_vbias_casop
set op_vbias_3v3=$&v_vbias_3v3op
set op_vbias_casc=$&v_vbias_cascop
set op_vbias_cg=$&v_vbias_cgop
set op_vbias_icg=$&v_vbias_icgop
set op_vbias_buf=$&v_vbias_bufop
set op_vbias_cs=$&v_vbias_csop
set op_vbias_csc=$&v_vbias_cscop
set op_iladder=$&i_ladder_avg

set op_id1=$&id1op
set op_gm1=$&gm1op
set op_gmb1=$&gmb1op
set op_gds1=$&gds1op
set op_vgs1=$&vgs1op
set op_vds1=$&vds1op
set op_vbs1=$&vbs1op
set op_vth1=$&vth1op
set op_vov1=$&vov1op
set op_vdsat1=$&vdsat1op
set op_sat1=$&sat1op
set op_gmid1=$&gmid1op
set op_ro1=$&ro1op

set op_id2=$&id2op
set op_gm2=$&gm2op
set op_gmb2=$&gmb2op
set op_gds2=$&gds2op
set op_vgs2=$&vgs2op
set op_vds2=$&vds2op
set op_vbs2=$&vbs2op
set op_vth2=$&vth2op
set op_vov2=$&vov2op
set op_vdsat2=$&vdsat2op
set op_sat2=$&sat2op
set op_gmid2=$&gmid2op
set op_ro2=$&ro2op

set op_id3=$&id3op
set op_gm3=$&gm3op
set op_gmb3=$&gmb3op
set op_gds3=$&gds3op
set op_vgs3=$&vgs3op
set op_vds3=$&vds3op
set op_vbs3=$&vbs3op
set op_vth3=$&vth3op
set op_vov3=$&vov3op
set op_vdsat3=$&vdsat3op
set op_sat3=$&sat3op
set op_gmid3=$&gmid3op
set op_ro3=$&ro3op

set op_id4=$&id4op
set op_gm4=$&gm4op
set op_gmb4=$&gmb4op
set op_gds4=$&gds4op
set op_vgs4=$&vgs4op
set op_vds4=$&vds4op
set op_vbs4=$&vbs4op
set op_vth4=$&vth4op
set op_vov4=$&vov4op
set op_vdsat4=$&vdsat4op
set op_sat4=$&sat4op
set op_gmid4=$&gmid4op
set op_ro4=$&ro4op

set op_id5=$&id5op
set op_gm5=$&gm5op
set op_gmb5=$&gmb5op
set op_gds5=$&gds5op
set op_vgs5=$&vgs5op
set op_vds5=$&vds5op
set op_vbs5=$&vbs5op
set op_vth5=$&vth5op
set op_vov5=$&vov5op
set op_vdsat5=$&vdsat5op
set op_sat5=$&sat5op
set op_gmid5=$&gmid5op
set op_ro5=$&ro5op

set op_id6=$&id6op
set op_gm6=$&gm6op
set op_gmb6=$&gmb6op
set op_gds6=$&gds6op
set op_vgs6=$&vgs6op
set op_vds6=$&vds6op
set op_vbs6=$&vbs6op
set op_vth6=$&vth6op
set op_vov6=$&vov6op
set op_vdsat6=$&vdsat6op
set op_sat6=$&sat6op
set op_gmid6=$&gmid6op
set op_ro6=$&ro6op

set op_id7=$&id7op
set op_gm7=$&gm7op
set op_gmb7=$&gmb7op
set op_gds7=$&gds7op
set op_vgs7=$&vgs7op
set op_vds7=$&vds7op
set op_vbs7=$&vbs7op
set op_vth7=$&vth7op
set op_vov7=$&vov7op
set op_vdsat7=$&vdsat7op
set op_sat7=$&sat7op
set op_gmid7=$&gmid7op
set op_ro7=$&ro7op

set op_id9=$&id9op
set op_gm9=$&gm9op
set op_gmb9=$&gmb9op
set op_gds9=$&gds9op
set op_vgs9=$&vgs9op
set op_vds9=$&vds9op
set op_vbs9=$&vbs9op
set op_vth9=$&vth9op
set op_vov9=$&vov9op
set op_vdsat9=$&vdsat9op
set op_sat9=$&sat9op
set op_gmid9=$&gmid9op
set op_ro9=$&ro9op

echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo DC_SUPPLY_AND_BIAS_GENERATOR >> lna_core_06V_cgcs_report.txt
echo PDC_mW $op_pdc ICORE_A $op_icore IIO_A $op_iio >> lna_core_06V_cgcs_report.txt
echo BIAS_TOP_LEVEL_V VDD $op_vdd VP_BANDGAP $op_vp OTA_OUT_VREF $op_vref VSENSE $op_vsense ILADDER_A $op_iladder >> lna_core_06V_cgcs_report.txt
echo BIAS_LADDER_V VBIAS_CAS $op_vbias_cas VBIAS_3V3 $op_vbias_3v3 VBIAS_CASC $op_vbias_casc VBIAS_CG $op_vbias_cg VBIAS_ICG $op_vbias_icg VBIAS_BUF $op_vbias_buf VBIAS_CS $op_vbias_cs VBIAS_CSC $op_vbias_csc >> lna_core_06V_cgcs_report.txt
echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo DC_LNA_INTERNAL_NODE_VOLTAGES >> lna_core_06V_cgcs_report.txt
echo NODES_V S $op_vs VX $op_vx VM1 $op_vm1 VM2 $op_vm2 NET10_DERIVED $op_vnet10 NET3 $op_vnet3 NET9_DERIVED $op_vnet9 NET8 $op_vnet8 VBUF $op_vbuf G_CS $op_vgcs G_CG $op_vgcg G_CSC $op_vgcsc >> lna_core_06V_cgcs_report.txt
echo HIDDEN_NODE_CHECKS NET10_FROM_XM2 $op_vnet10 NET10_FROM_XM7 $op_vnet10check DIFFERENCE $op_vnet10diff NET9_FROM_XM1 $op_vnet9 NET9_FROM_XM4 $op_vnet9check DIFFERENCE $op_vnet9diff >> lna_core_06V_cgcs_report.txt
echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo TRANSISTOR_OPERATING_POINTS >> lna_core_06V_cgcs_report.txt
echo FIELDS ID_A GM_S GMBS_S GDS_S VGS_V VDS_V VBS_V VTH_V VOV_V VDSAT_V SAT_MARGIN_V GM_OVER_ID_1_PER_V RO_OHM >> lna_core_06V_cgcs_report.txt
echo XM1_CS ID $op_id1 GM $op_gm1 GMBS $op_gmb1 GDS $op_gds1 VGS $op_vgs1 VDS $op_vds1 VBS $op_vbs1 VTH $op_vth1 VOV $op_vov1 VDSAT $op_vdsat1 SAT_MARGIN $op_sat1 GMID $op_gmid1 RO $op_ro1 >> lna_core_06V_cgcs_report.txt
echo XM2_CG ID $op_id2 GM $op_gm2 GMBS $op_gmb2 GDS $op_gds2 VGS $op_vgs2 VDS $op_vds2 VBS $op_vbs2 VTH $op_vth2 VOV $op_vov2 VDSAT $op_vdsat2 SAT_MARGIN $op_sat2 GMID $op_gmid2 RO $op_ro2 >> lna_core_06V_cgcs_report.txt
echo XM3_SOURCE_FOLLOWER ID $op_id3 GM $op_gm3 GMBS $op_gmb3 GDS $op_gds3 VGS $op_vgs3 VDS $op_vds3 VBS $op_vbs3 VTH $op_vth3 VOV $op_vov3 VDSAT $op_vdsat3 SAT_MARGIN $op_sat3 GMID $op_gmid3 RO $op_ro3 >> lna_core_06V_cgcs_report.txt
echo XM4_CS_CASCODE ID $op_id4 GM $op_gm4 GMBS $op_gmb4 GDS $op_gds4 VGS $op_vgs4 VDS $op_vds4 VBS $op_vbs4 VTH $op_vth4 VOV $op_vov4 VDSAT $op_vdsat4 SAT_MARGIN $op_sat4 GMID $op_gmid4 RO $op_ro4 >> lna_core_06V_cgcs_report.txt
echo XM5_CG_CURRENT_SINK ID $op_id5 GM $op_gm5 GMBS $op_gmb5 GDS $op_gds5 VGS $op_vgs5 VDS $op_vds5 VBS $op_vbs5 VTH $op_vth5 VOV $op_vov5 VDSAT $op_vdsat5 SAT_MARGIN $op_sat5 GMID $op_gmid5 RO $op_ro5 >> lna_core_06V_cgcs_report.txt
echo XM6_BUFFER_CURRENT_SINK ID $op_id6 GM $op_gm6 GMBS $op_gmb6 GDS $op_gds6 VGS $op_vgs6 VDS $op_vds6 VBS $op_vbs6 VTH $op_vth6 VOV $op_vov6 VDSAT $op_vdsat6 SAT_MARGIN $op_sat6 GMID $op_gmid6 RO $op_ro6 >> lna_core_06V_cgcs_report.txt
echo XM7_CG_CASCODE ID $op_id7 GM $op_gm7 GMBS $op_gmb7 GDS $op_gds7 VGS $op_vgs7 VDS $op_vds7 VBS $op_vbs7 VTH $op_vth7 VOV $op_vov7 VDSAT $op_vdsat7 SAT_MARGIN $op_sat7 GMID $op_gmid7 RO $op_ro7 >> lna_core_06V_cgcs_report.txt
echo XM9_CANCELLATION_CS ID $op_id9 GM $op_gm9 GMBS $op_gmb9 GDS $op_gds9 VGS $op_vgs9 VDS $op_vds9 VBS $op_vbs9 VTH $op_vth9 VOV $op_vov9 VDSAT $op_sat9 SAT_MARGIN $op_sat9 GMID $op_gmid9 RO $op_ro9 >> lna_core_06V_cgcs_report.txt

destroy $curplot

* =============================================================================
* SINGLE BROADBAND RF ANALYSIS
* One reset and one SP run are used for all 1 MHz to 7 GHz RF results.
* Target-band values are extracted from the same dataset.
* =============================================================================

reset
sp lin 7000 1Meg 7Gig 1
set rfplot=$curplot

let fghz=frequency/1e9

let s11db=db(s_1_1)
let s21db=db(s_2_1)
let s12db=db(s_1_2)
let s22db=db(s_2_2)

let s11re=real(s_1_1)
let s11im=imag(s_1_1)
let s21re=real(s_2_1)
let s21im=imag(s_2_1)
let s12re=real(s_1_2)
let s12im=imag(s_1_2)
let s22re=real(s_2_2)
let s22im=imag(s_2_2)

let nfdb=real(NF)
let nfmin_db=real(NFmin)

let delta=s_1_1*s_2_2-s_1_2*s_2_1
let delta_mag=mag(delta)
let a11=mag(s_1_1)
let a12=mag(s_1_2)
let a21=mag(s_2_1)
let a22=mag(s_2_2)
let mu=(1-a11*a11)/(mag(s_2_2-delta*conj(s_1_1))+mag(s_1_2*s_2_1))
let mup=(1-a22*a22)/(mag(s_1_1-delta*conj(s_2_2))+mag(s_1_2*s_2_1))
let kval=(1-a11*a11-a22*a22+delta_mag*delta_mag)/(2*a12*a21)

let zin=50*(1+s_1_1)/(1-s_1_1)
let zout=50*(1+s_2_2)/(1-s_2_2)
let zin_re=real(zin)
let zin_im=imag(zin)
let zout_re=real(zout)
let zout_im=imag(zout)

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

let center_freq=frequency[icenter]
let s11c=s11db[icenter]
let s21c=s21db[icenter]
let s12c=s12db[icenter]
let s22c=s22db[icenter]
let s11rc=s11re[icenter]
let s11ic=s11im[icenter]
let s21rc=s21re[icenter]
let s21ic=s21im[icenter]
let s12rc=s12re[icenter]
let s12ic=s12im[icenter]
let s22rc=s22re[icenter]
let s22ic=s22im[icenter]
let nfc=nfdb[icenter]
let nfminc=nfmin_db[icenter]
let muc=mu[icenter]
let mupc=mup[icenter]
let kc=kval[icenter]
let dmc=delta_mag[icenter]
let zinrc=zin_re[icenter]
let zinic=zin_im[icenter]
let zoutrc=zout_re[icenter]
let zoutic=zout_im[icenter]

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
let nfminbandmin=nfmin_db[ilo]
let nfminbandmax=nfmin_db[ilo]
let mumin=mu[ilo]
let mupmin=mup[ilo]
let kmin=kval[ilo]
let dmax=delta_mag[ilo]

let s11min_i=ilo
let s11max_i=ilo
let s21min_i=ilo
let s21max_i=ilo
let s12min_i=ilo
let s12max_i=ilo
let s22min_i=ilo
let s22max_i=ilo
let nfmin_i=ilo
let nfmax_i=ilo
let nfminpar_min_i=ilo
let nfminpar_max_i=ilo
let mumin_i=ilo
let mupmin_i=ilo
let kmin_i=ilo
let dmax_i=ilo

let ii=ilo
while ii <= ihi
if s11db[ii] < s11min
let s11min=s11db[ii]
let s11min_i=ii
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
let s12min_i=ii
end
if s12db[ii] > s12max
let s12max=s12db[ii]
let s12max_i=ii
end
if s22db[ii] < s22min
let s22min=s22db[ii]
let s22min_i=ii
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
if nfmin_db[ii] < nfminbandmin
let nfminbandmin=nfmin_db[ii]
let nfminpar_min_i=ii
end
if nfmin_db[ii] > nfminbandmax
let nfminbandmax=nfmin_db[ii]
let nfminpar_max_i=ii
end
if mu[ii] < mumin
let mumin=mu[ii]
let mumin_i=ii
end
if mup[ii] < mupmin
let mupmin=mup[ii]
let mupmin_i=ii
end
if kval[ii] < kmin
let kmin=kval[ii]
let kmin_i=ii
end
if delta_mag[ii] > dmax
let dmax=delta_mag[ii]
let dmax_i=ii
end
let ii=ii+1
end

let gain_ripple=s21max-s21min

let s11min_f=frequency[s11min_i]
let s11max_f=frequency[s11max_i]
let s21min_f=frequency[s21min_i]
let s21max_f=frequency[s21max_i]
let s12min_f=frequency[s12min_i]
let s12max_f=frequency[s12max_i]
let s22min_f=frequency[s22min_i]
let s22max_f=frequency[s22max_i]
let nfmin_f=frequency[nfmin_i]
let nfmax_f=frequency[nfmax_i]
let nfminpar_min_f=frequency[nfminpar_min_i]
let nfminpar_max_f=frequency[nfminpar_max_i]
let mumin_f=frequency[mumin_i]
let mupmin_f=frequency[mupmin_i]
let kmin_f=frequency[kmin_i]
let dmax_f=frequency[dmax_i]

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

echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo RF_AT_2P400_GHZ_FROM_SINGLE_BROADBAND_SWEEP >> lna_core_06V_cgcs_report.txt
echo ACTUAL_SAMPLE_HZ $&center_freq >> lna_core_06V_cgcs_report.txt
echo S11_DB $&s11c REAL $&s11rc IMAG $&s11ic >> lna_core_06V_cgcs_report.txt
echo S21_DB $&s21c REAL $&s21rc IMAG $&s21ic >> lna_core_06V_cgcs_report.txt
echo S12_DB $&s12c REAL $&s12rc IMAG $&s12ic >> lna_core_06V_cgcs_report.txt
echo S22_DB $&s22c REAL $&s22rc IMAG $&s22ic >> lna_core_06V_cgcs_report.txt
echo NF_DB $&nfc NFMIN_DB $&nfminc >> lna_core_06V_cgcs_report.txt
echo MU $&muc MUP $&mupc K $&kc DELTA_MAG $&dmc >> lna_core_06V_cgcs_report.txt
echo ZIN_OHM RE $&zinrc IM $&zinic >> lna_core_06V_cgcs_report.txt
echo ZOUT_OHM RE $&zoutrc IM $&zoutic >> lna_core_06V_cgcs_report.txt

echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo RF_MIN_MAX_FROM_2P300_TO_2P500_GHZ >> lna_core_06V_cgcs_report.txt
echo S11_MIN_DB $&s11min AT_HZ $&s11min_f S11_MAX_DB $&s11max AT_HZ $&s11max_f >> lna_core_06V_cgcs_report.txt
echo S21_MIN_DB $&s21min AT_HZ $&s21min_f S21_MAX_DB $&s21max AT_HZ $&s21max_f GAIN_RIPPLE_DB $&gain_ripple >> lna_core_06V_cgcs_report.txt
echo S12_MIN_DB $&s12min AT_HZ $&s12min_f S12_MAX_DB $&s12max AT_HZ $&s12max_f >> lna_core_06V_cgcs_report.txt
echo S22_MIN_DB $&s22min AT_HZ $&s22min_f S22_MAX_DB $&s22max AT_HZ $&s22max_f >> lna_core_06V_cgcs_report.txt
echo NF_MIN_DB $&nfbandmin AT_HZ $&nfmin_f NF_MAX_DB $&nfbandmax AT_HZ $&nfmax_f >> lna_core_06V_cgcs_report.txt
echo NFMIN_PARAMETER_MIN_DB $&nfminbandmin AT_HZ $&nfminpar_min_f NFMIN_PARAMETER_MAX_DB $&nfminbandmax AT_HZ $&nfminpar_max_f >> lna_core_06V_cgcs_report.txt
echo MU_MIN $&mumin AT_HZ $&mumin_f MUP_MIN $&mupmin AT_HZ $&mupmin_f >> lna_core_06V_cgcs_report.txt
echo K_MIN $&kmin AT_HZ $&kmin_f DELTA_MAX $&dmax AT_HZ $&dmax_f >> lna_core_06V_cgcs_report.txt

echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo BROADBAND_GAIN_CHECK_1MHZ_TO_7GHZ >> lna_core_06V_cgcs_report.txt
echo GAIN_AT_2P4_DB $&s21c >> lna_core_06V_cgcs_report.txt
echo BROADBAND_PEAK_HZ $&peakfreq PEAK_GAIN_DB $&gainmax >> lna_core_06V_cgcs_report.txt

echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo TARGET_CENTERED_S21_GE_10DB_BAND >> lna_core_06V_cgcs_report.txt
if s21c >= 10.0
let bwlo=icenter
let bwhi=icenter
let search=1
while search = 1
if bwlo > 0
if s21db[bwlo-1] >= 10.0
let bwlo=bwlo-1
else
let search=0
end
else
let search=0
end
end
let search=1
while search = 1
if bwhi < npts-1
if s21db[bwhi+1] >= 10.0
let bwhi=bwhi+1
else
let search=0
end
else
let search=0
end
end
let bwflo=frequency[bwlo]
let bwfhi=frequency[bwhi]
let bwval=bwfhi-bwflo
let bwcenter=0.5*(bwfhi+bwflo)
let bwfbw=100*bwval/(bwcenter+1e-30)
echo LOWER_HZ $&bwflo UPPER_HZ $&bwfhi BANDWIDTH_HZ $&bwval BAND_CENTER_HZ $&bwcenter FRACTIONAL_BW_PERCENT $&bwfbw >> lna_core_06V_cgcs_report.txt
else
echo NO_VALID_TARGET_CENTERED_BAND S21_AT_2P4_DB $&s21c >> lna_core_06V_cgcs_report.txt
end

echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo GLOBAL_CONTIGUOUS_S21_GE_10DB_BAND_AROUND_PEAK >> lna_core_06V_cgcs_report.txt
if gainmax >= 10.0
let bwlo=imax
let bwhi=imax
let search=1
while search = 1
if bwlo > 0
if s21db[bwlo-1] >= 10.0
let bwlo=bwlo-1
else
let search=0
end
else
let search=0
end
end
let search=1
while search = 1
if bwhi < npts-1
if s21db[bwhi+1] >= 10.0
let bwhi=bwhi+1
else
let search=0
end
else
let search=0
end
end
let bwflo=frequency[bwlo]
let bwfhi=frequency[bwhi]
let bwval=bwfhi-bwflo
let bwcenter=0.5*(bwfhi+bwflo)
let bwfbw=100*bwval/(bwcenter+1e-30)
echo LOWER_HZ $&bwflo UPPER_HZ $&bwfhi BANDWIDTH_HZ $&bwval BAND_CENTER_HZ $&bwcenter FRACTIONAL_BW_PERCENT $&bwfbw >> lna_core_06V_cgcs_report.txt
else
echo NO_S21_ABOVE_10DB_FROM_1MHZ_TO_7GHZ PEAK_GAIN_DB $&gainmax PEAK_FREQUENCY_HZ $&peakfreq >> lna_core_06V_cgcs_report.txt
end

wrdata lna_core_06V_cgcs_target_band.dat frequency s_1_1 s_2_1 s_1_2 s_2_2 s11db s21db s12db s22db nfdb nfmin_db kval mu mup delta_mag zin_re zin_im zout_re zout_im
wrdata lna_core_06V_cgcs_broadband.dat frequency s11db s21db s12db s22db nfdb nfmin_db kval mu mup delta_mag zin_re zin_im zout_re zout_im

* =============================================================================
* NOISE-CANCELLATION A/B PROOF
* Same method as before. For this to work, XC10 must use:
* c_width=\{CNC_WIDTH\} c_length=\{CNC_LENGTH\}
* =============================================================================

set nc_on_plot=$rfplot

alterparam CNC_WIDTH = 1e-6u
alterparam CNC_LENGTH = 1e-6u
reset

sp lin 7000 1Meg 7Gig 1
set nc_off_plot=$curplot

let fghz_nc=frequency/1e9

let nf_nc_on=\{$nc_on_plot\}.nfdb
let s21_nc_on=\{$nc_on_plot\}.s21db
let s11_nc_on=\{$nc_on_plot\}.s11db
let s22_nc_on=\{$nc_on_plot\}.s22db

let nf_nc_off=real(NF)
let s21_nc_off=db(s_2_1)
let s11_nc_off=db(s_1_1)
let s22_nc_off=db(s_2_2)

let nf_improvement_db=nf_nc_off-nf_nc_on
let gain_change_on_minus_off_db=s21_nc_on-s21_nc_off

let nc_npts=length(frequency)

let nc_ilo=0
let nc_icenter=0
let nc_ihi=0
let nc_errlo=abs(frequency[0]-2.3e9)
let nc_errcenter=abs(frequency[0]-2.4e9)
let nc_errhi=abs(frequency[0]-2.5e9)
let nc_ii=1

while nc_ii < nc_npts
let nc_newerr=abs(frequency[nc_ii]-2.3e9)
if nc_newerr < nc_errlo
let nc_errlo=nc_newerr
let nc_ilo=nc_ii
end
let nc_newerr=abs(frequency[nc_ii]-2.4e9)
if nc_newerr < nc_errcenter
let nc_errcenter=nc_newerr
let nc_icenter=nc_ii
end
let nc_newerr=abs(frequency[nc_ii]-2.5e9)
if nc_newerr < nc_errhi
let nc_errhi=nc_newerr
let nc_ihi=nc_ii
end
let nc_ii=nc_ii+1
end

let nc_freq_center=frequency[nc_icenter]
let nc_nf_on_c=nf_nc_on[nc_icenter]
let nc_nf_off_c=nf_nc_off[nc_icenter]
let nc_imp_c=nf_improvement_db[nc_icenter]

let nc_s21_on_c=s21_nc_on[nc_icenter]
let nc_s21_off_c=s21_nc_off[nc_icenter]
let nc_gain_delta_c=gain_change_on_minus_off_db[nc_icenter]

let nc_s11_on_c=s11_nc_on[nc_icenter]
let nc_s11_off_c=s11_nc_off[nc_icenter]
let nc_s22_on_c=s22_nc_on[nc_icenter]
let nc_s22_off_c=s22_nc_off[nc_icenter]

let nc_imp_min=nf_improvement_db[nc_ilo]
let nc_imp_max=nf_improvement_db[nc_ilo]
let nc_imp_min_i=nc_ilo
let nc_imp_max_i=nc_ilo

let nc_ii=nc_ilo
while nc_ii <= nc_ihi
if nf_improvement_db[nc_ii] < nc_imp_min
let nc_imp_min=nf_improvement_db[nc_ii]
let nc_imp_min_i=nc_ii
end
if nf_improvement_db[nc_ii] > nc_imp_max
let nc_imp_max=nf_improvement_db[nc_ii]
let nc_imp_max_i=nc_ii
end
let nc_ii=nc_ii+1
end

let nc_imp_min_f=frequency[nc_imp_min_i]
let nc_imp_max_f=frequency[nc_imp_max_i]

let nc_practical_threshold_db=0.20

echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo NOISE_CANCELLATION_AB_PROOF >> lna_core_06V_cgcs_report.txt
echo METHOD ON_CNC_8P2PF OFF_CNC_1E_MINUS18F_XM7_XM9_STILL_BIASED_AND_LOADING_RETAINED >> lna_core_06V_cgcs_report.txt
echo ACTUAL_CENTER_SAMPLE_HZ $&nc_freq_center >> lna_core_06V_cgcs_report.txt
echo NF_ON_DB $&nc_nf_on_c NF_OFF_DB $&nc_nf_off_c NF_IMPROVEMENT_DB $&nc_imp_c >> lna_core_06V_cgcs_report.txt
echo S21_ON_DB $&nc_s21_on_c S21_OFF_DB $&nc_s21_off_c S21_ON_MINUS_OFF_DB $&nc_gain_delta_c >> lna_core_06V_cgcs_report.txt
echo S11_ON_DB $&nc_s11_on_c S11_OFF_DB $&nc_s11_off_c >> lna_core_06V_cgcs_report.txt
echo S22_ON_DB $&nc_s22_on_c S22_OFF_DB $&nc_s22_off_c >> lna_core_06V_cgcs_report.txt
echo NF_IMPROVEMENT_MIN_DB_2P3_TO_2P5 $&nc_imp_min AT_HZ $&nc_imp_min_f >> lna_core_06V_cgcs_report.txt
echo NF_IMPROVEMENT_MAX_DB_2P3_TO_2P5 $&nc_imp_max AT_HZ $&nc_imp_max_f >> lna_core_06V_cgcs_report.txt
echo PRACTICAL_CENTER_THRESHOLD_DB $&nc_practical_threshold_db >> lna_core_06V_cgcs_report.txt

if nc_imp_c > 0
echo CENTER_DIRECTIONAL_TEST PASS_CANCELLATION_LOWERS_NF >> lna_core_06V_cgcs_report.txt
else
echo CENTER_DIRECTIONAL_TEST FAIL_CANCELLATION_DOES_NOT_LOWER_NF >> lna_core_06V_cgcs_report.txt
end

if nc_imp_min > 0
echo FULL_TARGET_BAND_TEST PASS_CANCELLATION_LOWERS_NF_ACROSS_2P3_TO_2P5_GHZ >> lna_core_06V_cgcs_report.txt
else
echo FULL_TARGET_BAND_TEST FAIL_NF_IMPROVEMENT_NOT_POSITIVE_ACROSS_ENTIRE_TARGET_BAND >> lna_core_06V_cgcs_report.txt
end

if nc_imp_c >= nc_practical_threshold_db
echo PRACTICAL_CENTER_TEST PASS_IMPROVEMENT_AT_LEAST_0P20_DB >> lna_core_06V_cgcs_report.txt
else
echo PRACTICAL_CENTER_TEST FAIL_IMPROVEMENT_BELOW_0P20_DB >> lna_core_06V_cgcs_report.txt
end

wrdata lna_core_06V_cgcs_noise_cancellation.dat nf_nc_on nf_nc_off nf_improvement_db s21_nc_on s21_nc_off s11_nc_on s11_nc_off s22_nc_on s22_nc_off

alterparam CNC_WIDTH = 63.9529u
alterparam CNC_LENGTH = 63.9529u
reset

* =============================================================================
* WIDEBAND STABILITY 10 MHZ TO 30 GHZ
* =============================================================================

sp dec 101 10Meg 30G 1
set stabilityplot=$curplot

let wbdelta=s_1_1*s_2_2-s_1_2*s_2_1
let wbmd=mag(wbdelta)
let wba11=mag(s_1_1)
let wba12=mag(s_1_2)
let wba21=mag(s_2_1)
let wba22=mag(s_2_2)
let wbmu=(1-wba11*wba11)/(mag(s_2_2-wbdelta*conj(s_1_1))+mag(s_1_2*s_2_1))
let wbmup=(1-wba22*wba22)/(mag(s_1_1-wbdelta*conj(s_2_2))+mag(s_1_2*s_2_1))
let wbk=(1-wba11*wba11-wba22*wba22+wbmd*wbmd)/(2*wba12*wba21)

let wbkmin=minimum(wbk)
let wbmumin=minimum(wbmu)
let wbmupmin=minimum(wbmup)
let wbdmax=maximum(wbmd)

set final_wbkmin=$&wbkmin
set final_wbmumin=$&wbmumin
set final_wbmupmin=$&wbmupmin
set final_wbdmax=$&wbdmax

echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo WIDEBAND_STABILITY_10MHZ_TO_30GHZ >> lna_core_06V_cgcs_report.txt
echo K_MIN $final_wbkmin MU_MIN $final_wbmumin MUP_MIN $final_wbmupmin DELTA_MAX $final_wbdmax >> lna_core_06V_cgcs_report.txt

wrdata lna_core_06V_cgcs_stability.dat frequency wbk wbmu wbmup wbmd

let wbfghz=frequency/1e9

echo ============================================================ >> lna_core_06V_cgcs_report.txt
echo OUTPUT_FILES >> lna_core_06V_cgcs_report.txt
echo REPORT lna_core_06V_cgcs_report.txt >> lna_core_06V_cgcs_report.txt
echo TARGET_DATA lna_core_06V_cgcs_target_band.dat >> lna_core_06V_cgcs_report.txt
echo BROADBAND_DATA lna_core_06V_cgcs_broadband.dat >> lna_core_06V_cgcs_report.txt
echo STABILITY_DATA lna_core_06V_cgcs_stability.dat >> lna_core_06V_cgcs_report.txt
echo NOISE_CANCELLATION_DATA lna_core_06V_cgcs_noise_cancellation.dat >> lna_core_06V_cgcs_report.txt
echo PLOTS S_PARAMETERS NF_NFMIN NOISE_CANCELLATION_ON_OFF NF_IMPROVEMENT S21_ON_OFF >> lna_core_06V_cgcs_report.txt
echo ============================================================ >> lna_core_06V_cgcs_report.txt

* =============================================================================
* VISIBLE PLOTS
* =============================================================================

setplot $rfplot
setscale fghz

plot s11db xlimit 2.3 2.5
plot s21db xlimit 2.3 2.5
plot s12db xlimit 2.3 2.5
plot s22db xlimit 2.3 2.5
plot nfdb nfmin_db xlimit 2.3 2.5

plot s11db xlimit 0 7
plot s21db xlimit 0 7
plot s12db xlimit 0 7
plot s22db xlimit 0 7
plot nfdb nfmin_db xlimit 0 7

setplot $nc_off_plot
setscale fghz_nc
set xbrushwidth=2

plot nf_nc_on nf_nc_off xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'Noise figure (dB)'
plot nf_improvement_db xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'NF OFF - NF ON (dB)'
plot s21_nc_on s21_nc_off xlimit 2.3 2.5 xlabel 'Frequency (GHz)' ylabel 'S21 (dB)'

.endc
"
}
C {vsource.sym} -600 -1350 1 0 {name=VBCG value=\{VBIAS_CG\} savecurrent=false}
C {gnd.sym} -680 -940 0 0 {name=l1 lab=GND}
C {lab_pin.sym} -540 -1350 2 0 {name=p21 sig_type=std_logic lab=vbias_cg}
C {vsource.sym} -610 -950 1 0 {name=VDDIO value=\{VDDIO_SUP\} savecurrent=false}
C {lab_pin.sym} -550 -950 1 0 {name=p27 sig_type=std_logic lab=vddio
}
C {vsource.sym} -620 -1230 1 0 {name=VBCS value=\{VBIAS_CS\} savecurrent=false}
C {lab_pin.sym} -560 -1230 2 0 {name=p24 sig_type=std_logic lab=vbias_cs}
C {vsource.sym} -620 -1120 1 0 {name=VBCS1 value=\{VBIAS_CAS\} savecurrent=false}
C {lab_pin.sym} -560 -1120 2 0 {name=p49 sig_type=std_logic lab=vbias_cas}
C {vsource.sym} -770 -1000 3 0 {name=VBCS2 value=\{VBIAS_BUF\} savecurrent=false}
C {lab_pin.sym} -830 -1000 0 0 {name=p53 sig_type=std_logic lab=vbias_buf}
C {vsource.sym} -780 -1110 3 0 {name=VBCS3 value=\{VBIAS_ICG\} savecurrent=false}
C {lab_pin.sym} -840 -1110 0 0 {name=p54 sig_type=std_logic lab=vbias_icg}
C {vsource.sym} -710 -940 2 0 {name=VBCS4 value=\{VBIAS_CSC\} savecurrent=false}
C {lab_pin.sym} -710 -880 3 0 {name=p35 sig_type=std_logic lab=vbias_csc}
C {vsource.sym} -620 -1020 1 0 {name=VBCS5 value=\{VBIAS_CASC\} savecurrent=false}
C {lab_pin.sym} -560 -1020 2 0 {name=p67 sig_type=std_logic lab=vbias_casc}
C {code_shown.sym} 1350 -990 0 0 {name=s2 only_toplevel=false value="
.param VBIAS_CAS_CG=3.30



.param VDS=5.0
.param VDDIO_SUP=5.0

.param L_BW=3n
.param R_BW=0.2


.param VBIAS_CG=2.20
.param VBIAS_CS=1.20

.param VBIAS_CAS=3.70
.param VBIAS_ICG=1.90
.param VBIAS_BUF=1.30

.param VBIAS_CSC=0.90


.param VBIAS_CASC=3.20
.param RNC_TEST=1m

"}
