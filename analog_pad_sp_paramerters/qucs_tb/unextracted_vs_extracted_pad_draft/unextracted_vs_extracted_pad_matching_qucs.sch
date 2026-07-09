<Qucs Schematic 26.1.1>
<Properties>
  <View=-172,0,1208,723,1.1482,0,0>
  <Grid=10,10,0>
  <DataSet=unextracted_vs_extracted_pad_matching_qucs.dat>
  <DataDisplay=unextracted_vs_extracted_pad_matching_qucs.dpl>
  <OpenDisplay=0>
  <Script=unextracted_pad_matching_qucs.m>
  <RunScript=0>
  <showFrame=1>
  <FrameText0=Title: 5V Analog ESD Pad GF180mcuD\nThe Night Owl - SSCS Chipathon>
  <FrameText1=Drawn By: Ahmed M. ElNaggar>
  <FrameText2=Date: June/19/2026>
  <FrameText3=Revision: V 1.0>
</Properties>
<Symbol>
  <.ID -20 -16 SUB>
  <Line -20 20 40 0 #000080 2 1>
  <Line 20 20 0 -40 #000080 2 1>
  <Line -20 -20 40 0 #000080 2 1>
  <Line -20 20 0 -40 #000080 2 1>
</Symbol>
<Components>
  <GND * 1 60 300 0 0 0 0>
  <GND * 1 320 290 0 0 0 0>
  <Vdc V1 1 440 160 18 -26 0 1 "5 V" 1>
  <SpiceLib SpiceLib1 1 90 410 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "typical" 1>
  <SpiceLib SpiceLib2 1 90 510 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "diode_typical" 1>
  <SpiceLib SpiceLib3 1 90 610 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "moscap_typical" 1>
  <SpicePar SpicePar1 1 840 430 -29 16 0 0 "fnoicor=0" 1 "mc_mm_switch=0" 1>
  <Pac P1 1 60 210 18 -26 0 1 "1" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <.SP SP1 1 660 420 0 50 0 0 "lin" 1 "10 MHz" 1 "10 GHz" 1 "1000" 1 "no" 0 "1" 0 "2" 0 "no" 0 "no" 0>
  <GND * 1 540 300 0 0 0 0>
  <GND * 1 800 310 0 0 0 0>
  <Vdc V2 1 920 160 18 -26 0 1 "5 V" 1>
  <Pac P2 1 540 210 18 -26 0 1 "2" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <NutmegEq NutmegEq1 1 840 530 -31 16 0 0 "ALL" 1 "DB_S11=db(s_1_1)" 1 "DB_S22=db(s_2_2)" 1>
  <SPICE X1 1 320 160 -26 -119 0 0 "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/unextracted_gf180mcu_fd_io__asig_5p0.spice" 0 "_netASIG5V,_netDVDD,_netDVSS,_netVDD,_netVSS" 0 "yes" 0 "none" 0 "" 0>
  <SPICE X2 1 800 160 -26 -119 0 0 "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/extracted_gf180mcu_fd_io__asig_5p0_manually_scaled.spice" 0 "_netASIG5V,_netDVDD,_netDVSS,_netVDD,_netVSS" 0 "yes" 0 "none" 0 "" 0>
</Components>
<Wires>
  <60 240 60 300 "" 0 0 0 "">
  <320 250 320 260 "" 0 0 0 "">
  <280 220 280 260 "" 0 0 0 "">
  <320 260 320 270 "" 0 0 0 "">
  <280 260 320 260 "" 0 0 0 "">
  <260 160 290 160 "" 0 0 0 "">
  <260 160 260 270 "" 0 0 0 "">
  <320 270 320 280 "" 0 0 0 "">
  <440 100 440 130 "" 0 0 0 "">
  <440 190 440 280 "" 0 0 0 "">
  <380 100 380 160 "" 0 0 0 "">
  <280 220 290 220 "" 0 0 0 "">
  <320 280 320 290 "" 0 0 0 "">
  <320 280 440 280 "" 0 0 0 "">
  <380 100 440 100 "" 0 0 0 "">
  <350 100 380 100 "" 0 0 0 "">
  <350 160 380 160 "" 0 0 0 "">
  <260 270 320 270 "" 0 0 0 "">
  <60 100 60 180 "" 0 0 0 "">
  <60 100 290 100 "" 0 0 0 "">
  <540 240 540 300 "" 0 0 0 "">
  <800 250 800 260 "" 0 0 0 "">
  <760 220 760 260 "" 0 0 0 "">
  <800 260 800 270 "" 0 0 0 "">
  <760 260 800 260 "" 0 0 0 "">
  <740 160 770 160 "" 0 0 0 "">
  <740 160 740 270 "" 0 0 0 "">
  <920 100 920 130 "" 0 0 0 "">
  <920 190 920 300 "" 0 0 0 "">
  <860 100 860 160 "" 0 0 0 "">
  <760 220 770 220 "" 0 0 0 "">
  <800 270 800 300 "" 0 0 0 "">
  <800 300 920 300 "" 0 0 0 "">
  <860 100 920 100 "" 0 0 0 "">
  <830 100 860 100 "" 0 0 0 "">
  <830 160 860 160 "" 0 0 0 "">
  <740 270 800 270 "" 0 0 0 "">
  <540 100 540 180 "" 0 0 0 "">
  <540 100 770 100 "" 0 0 0 "">
  <800 300 800 310 "" 0 0 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
</Paintings>
