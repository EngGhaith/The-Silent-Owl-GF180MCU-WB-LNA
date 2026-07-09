<Qucs Schematic 26.1.1>
<Properties>
  <View=-163,10,1197,723,1.16433,0,0>
  <Grid=10,10,0>
  <DataSet=unextracted_pad_qucs.dat>
  <DataDisplay=unextracted_pad_qucs.dpl>
  <OpenDisplay=0>
  <Script=qucs.m>
  <RunScript=0>
  <showFrame=1>
  <FrameText0=Title: 5V Analog ESD Pad GF180mcuD\nThe Silent Owl - SSCS Chipathon 2026>
  <FrameText1=Drawn By: Ahmed M. ElNaggar>
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
  <GND * 1 200 310 0 0 0 0>
  <GND * 1 460 300 0 0 0 0>
  <Vdc V1 1 580 170 18 -26 0 1 "5 V" 1>
  <SpiceLib SpiceLib1 1 90 410 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "typical" 1>
  <SpiceLib SpiceLib2 1 90 510 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "diode_typical" 1>
  <SpiceLib SpiceLib3 1 90 610 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "moscap_typical" 1>
  <SpicePar SpicePar1 1 830 430 -29 16 0 0 "fnoicor=0" 1 "mc_mm_switch=0" 1>
  <Pac P2 1 800 210 18 -26 0 1 "2" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <GND * 1 730 300 0 0 0 0>
  <Pac P1 1 200 220 18 -26 0 1 "1" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <R R1 1 670 200 15 -26 0 1 "50 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <NutmegEq NutmegEq1 1 840 540 -31 16 0 0 "ALL" 1 "DB_S11=db(s_1_1)" 1>
  <.SP SP1 1 650 420 0 50 0 0 "lin" 1 "10 MHz" 1 "10 GHz" 1 "10000" 1 "no" 0 "1" 0 "2" 0 "no" 0 "no" 0>
  <SPICE X1 1 460 170 -26 -119 0 0 "/foss/designs/The-Silent-Owl-GF180MCU-WB-LNA/analog_pad_sp_paramerters/spice_files/unextracted_gf180mcu_fd_io__asig_5p0.spice" 0 "_netASIG5V,_netDVDD,_netDVSS,_netVDD,_netVSS" 0 "yes" 0 "none" 0 "" 0>
</Components>
<Wires>
  <200 250 200 310 "" 0 0 0 "">
  <460 260 460 270 "" 0 0 0 "">
  <420 230 420 270 "" 0 0 0 "">
  <460 270 460 280 "" 0 0 0 "">
  <420 270 460 270 "" 0 0 0 "">
  <400 170 430 170 "" 0 0 0 "">
  <400 170 400 280 "" 0 0 0 "">
  <460 280 460 290 "" 0 0 0 "">
  <580 110 580 140 "" 0 0 0 "">
  <580 200 580 290 "" 0 0 0 "">
  <520 110 520 170 "" 0 0 0 "">
  <800 110 800 180 "" 0 0 0 "">
  <670 110 670 170 "" 0 0 0 "">
  <420 230 430 230 "" 0 0 0 "">
  <670 290 730 290 "" 0 0 0 "">
  <460 290 460 300 "" 0 0 0 "">
  <670 230 670 290 "" 0 0 0 "">
  <800 240 800 290 "" 0 0 0 "">
  <730 290 730 300 "" 0 0 0 "">
  <670 110 800 110 "" 0 0 0 "">
  <730 290 800 290 "" 0 0 0 "">
  <460 290 580 290 "" 0 0 0 "">
  <520 110 580 110 "" 0 0 0 "">
  <490 110 520 110 "" 0 0 0 "">
  <490 170 520 170 "" 0 0 0 "">
  <400 280 460 280 "" 0 0 0 "">
  <200 110 200 190 "" 0 0 0 "">
  <200 110 430 110 "" 0 0 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
</Paintings>
