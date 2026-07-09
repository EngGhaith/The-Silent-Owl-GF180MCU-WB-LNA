<Qucs Schematic 26.1.1>
<Properties>
  <View=-124,0,1153,663,1.24018,0,0>
  <Grid=10,10,1>
  <DataSet=extracted_pad_matching_qucs.dat>
  <DataDisplay=extracted_pad_matching_qucs.dpl>
  <OpenDisplay=0>
  <Script=qucs.m>
  <RunScript=0>
  <showFrame=1>
  <FrameText0=Title: 5V Analog ESD Pad GF180mcuD\nThe Night Owl - SSCS Chipathon 2026>
  <FrameText1=Drawn By: Ahmed M. Elnaggar>
  <FrameText2=Date: June/19/2026>
  <FrameText3=Revision: V 1_0>
</Properties>
<Symbol>
  <.ID -20 -16 SUB>
  <Line -20 20 40 0 #000080 2 1>
  <Line 20 20 0 -40 #000080 2 1>
  <Line -20 -20 40 0 #000080 2 1>
  <Line -20 20 0 -40 #000080 2 1>
</Symbol>
<Components>
  <GND * 1 70 290 0 0 0 0>
  <GND * 1 470 290 0 0 0 0>
  <Vdc V1 1 580 160 18 -26 0 1 "5 V" 1>
  <SpiceLib SpiceLib1 1 100 380 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "typical" 1>
  <SpiceLib SpiceLib2 1 100 550 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "diode_typical" 1>
  <SpiceLib SpiceLib3 1 100 470 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "moscap_typical" 1>
  <Pac P1 1 70 190 18 -26 0 1 "1" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <SpicePar SpicePar1 1 670 540 -29 16 0 0 "fnoicor=0" 1 "mc_mm_switch=0" 1>
  <Pac P2 1 930 190 -106 -26 1 1 "2" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <GND * 1 930 290 0 0 0 0>
  <GND * 1 680 290 0 0 0 0>
  <R R1 1 680 200 15 -26 0 1 "50 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <L L1 1 190 100 -26 10 0 0 "2.83 nH" 1 "" 0>
  <GND * 1 280 210 0 0 0 0>
  <C C1 1 280 160 17 -26 0 1 "2.36 pF" 1 "" 0 "neutral" 0>
  <NutmegEq NutmegEq1 1 850 390 -31 16 0 0 "ALL" 1 "DB_S11=dB(s_1_1)" 1>
  <.SP SP1 1 640 380 0 50 0 0 "log" 1 "10 MHz" 1 "10 GHz" 1 "1000" 1 "no" 0 "1" 0 "2" 0 "no" 0 "no" 0>
  <SPICE X1 1 470 160 -26 -119 0 0 "/foss/designs/GF180/sscs_chipathon_26/LNA/analog_pad_sp_paramerters/spice_files/extracted_gf180mcu_fd_io__asig_5p0_manually_scaled.spice" 0 "_netASIG5V,_netDVDD,_netDVSS,_netVDD,_netVSS" 0 "yes" 0 "none" 0 "" 0>
</Components>
<Wires>
  <70 220 70 290 "" 0 0 0 "">
  <470 250 470 260 "" 0 0 0 "">
  <420 220 420 260 "" 0 0 0 "">
  <470 260 470 270 "" 0 0 0 "">
  <400 160 400 270 "" 0 0 0 "">
  <580 100 580 130 "" 0 0 0 "">
  <500 100 530 100 "" 0 0 0 "">
  <580 190 580 280 "" 0 0 0 "">
  <470 280 470 290 "" 0 0 0 "">
  <470 280 580 280 "" 0 0 0 "">
  <530 100 530 160 "" 0 0 0 "">
  <500 160 530 160 "" 0 0 0 "">
  <470 270 470 280 "" 0 0 0 "">
  <400 160 440 160 "" 0 0 0 "">
  <400 270 470 270 "" 0 0 0 "">
  <420 220 440 220 "" 0 0 0 "">
  <420 260 470 260 "" 0 0 0 "">
  <530 100 580 100 "" 0 0 0 "">
  <930 220 930 290 "" 0 0 0 "">
  <680 230 680 290 "" 0 0 0 "">
  <680 100 930 100 "" 0 0 0 "">
  <70 100 70 160 "" 0 0 0 "">
  <70 100 160 100 "" 0 0 0 "">
  <220 100 280 100 "" 0 0 0 "">
  <280 190 280 210 "" 0 0 0 "">
  <280 100 280 130 "" 0 0 0 "">
  <680 100 680 170 "" 0 0 0 "">
  <930 100 930 160 "" 0 0 0 "">
  <280 100 440 100 "" 0 0 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
</Paintings>
