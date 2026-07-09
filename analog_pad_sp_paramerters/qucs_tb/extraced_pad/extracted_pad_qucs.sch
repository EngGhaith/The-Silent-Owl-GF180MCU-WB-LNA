<Qucs Schematic 26.1.1>
<Properties>
  <View=-119,0,1165,673,1.23363,0,0>
  <Grid=10,10,1>
  <DataSet=extracted_pad_qucs.dat>
  <DataDisplay=extracted_pad_qucs.dpl>
  <OpenDisplay=0>
  <Script=qucs.m>
  <RunScript=0>
  <showFrame=1>
  <FrameText0=Title: 5V Analog ESD Pad GF180mcuD\nThe Silent Owl - SSCS Chipathon 2026>
  <FrameText1=Drawn By: Ahmed M. Elnaggar>
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
  <GND * 1 200 300 0 0 0 0>
  <GND * 1 410 300 0 0 0 0>
  <Vdc V1 1 520 160 18 -26 0 1 "5 V" 1>
  <SpiceLib SpiceLib1 1 110 390 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "typical" 1>
  <SpiceLib SpiceLib2 1 110 560 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "diode_typical" 1>
  <SpiceLib SpiceLib3 1 110 480 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "moscap_typical" 1>
  <Pac P1 1 200 210 18 -26 0 1 "1" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <.SP SP1 1 650 390 0 50 0 0 "log" 1 "10 MHz" 1 "10 GHz" 1 "300" 1 "no" 0 "1" 0 "2" 0 "no" 0 "no" 0>
  <SpicePar SpicePar1 1 680 550 -29 16 0 0 "fnoicor=0" 1 "mc_mm_switch=0" 1>
  <Pac P2 1 780 210 18 -26 0 1 "2" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <GND * 1 780 300 0 0 0 0>
  <R R1 1 630 210 15 -26 0 1 "50 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 1 630 300 0 0 0 0>
  <NutmegEq NutmegEq1 1 830 400 -31 16 0 0 "ALL" 1 "DB_S11=dB(s_1_1)" 1>
  <SPICE X1 1 410 160 -26 -119 0 0 "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/extracted_gf180mcu_fd_io__asig_5p0_manually_scaled.spice" 0 "_netASIG5V,_netDVDD,_netDVSS,_netVDD,_netVSS" 0 "yes" 0 "none" 0 "" 0>
</Components>
<Wires>
  <200 240 200 300 "" 0 0 0 "">
  <410 250 410 260 "" 0 0 0 "">
  <360 220 360 260 "" 0 0 0 "">
  <410 260 410 270 "" 0 0 0 "">
  <340 160 340 270 "" 0 0 0 "">
  <520 100 520 130 "" 0 0 0 "">
  <440 100 470 100 "" 0 0 0 "">
  <520 190 520 290 "" 0 0 0 "">
  <410 290 520 290 "" 0 0 0 "">
  <470 100 470 160 "" 0 0 0 "">
  <440 160 470 160 "" 0 0 0 "">
  <410 270 410 290 "" 0 0 0 "">
  <340 160 380 160 "" 0 0 0 "">
  <340 270 410 270 "" 0 0 0 "">
  <360 220 380 220 "" 0 0 0 "">
  <360 260 410 260 "" 0 0 0 "">
  <470 100 520 100 "" 0 0 0 "">
  <780 240 780 300 "" 0 0 0 "">
  <200 100 200 180 "" 0 0 0 "">
  <200 100 380 100 "" 0 0 0 "">
  <630 240 630 300 "" 0 0 0 "">
  <780 100 780 180 "" 0 0 0 "">
  <630 100 780 100 "" 0 0 0 "">
  <630 100 630 180 "" 0 0 0 "">
  <410 290 410 300 "" 0 0 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
</Paintings>
