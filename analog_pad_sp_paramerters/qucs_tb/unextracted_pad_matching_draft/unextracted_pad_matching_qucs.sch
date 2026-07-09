<Qucs Schematic 26.1.1>
<Properties>
  <View=-185,0,1208,723,1.13712,0,0>
  <Grid=10,10,0>
  <DataSet=unextracted_pad_matching_qucs.dat>
  <DataDisplay=unextracted_pad_matching_qucs.dpl>
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
  <GND * 1 70 300 0 0 0 0>
  <GND * 1 520 290 0 0 0 0>
  <Vdc V1 1 640 160 18 -26 0 1 "5 V" 1>
  <SpiceLib SpiceLib1 1 90 410 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "typical" 1>
  <SpiceLib SpiceLib2 1 90 510 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "diode_typical" 1>
  <SpiceLib SpiceLib3 1 90 610 -14 16 0 0 "/foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice" 1 "moscap_typical" 1>
  <SpicePar SpicePar1 1 830 460 -29 16 0 0 "fnoicor=0" 1 "mc_mm_switch=0" 1>
  <Pac P2 1 860 200 18 -26 0 1 "2" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <GND * 1 790 290 0 0 0 0>
  <Pac P1 1 70 210 18 -26 0 1 "1" 1 "50 Ohm" 1 "0 dBm" 0 "1 MHz" 0 "26.85" 0 "true" 0 "false" 0>
  <R R1 1 730 190 15 -26 0 1 "50 Ohm" 1 "26.85" 0 "0.0" 0 "0.0" 0 "26.85" 0 "US" 0>
  <GND * 1 160 160 0 0 0 0>
  <L L1 1 320 100 -26 10 0 0 "4.7 nH" 1 "" 0>
  <C C1 1 160 130 17 -26 0 1 "20.75 pF" 1 "" 0 "neutral" 0>
  <NutmegEq NutmegEq1 1 830 560 -31 16 0 0 "ALL" 1 "DB_S11=db(s_1_1)" 1>
  <.SP SP1 1 650 450 0 50 0 0 "lin" 1 "10 MHz" 1 "10 GHz" 1 "1000" 1 "no" 0 "1" 0 "2" 0 "no" 0 "no" 0>
  <SPICE X1 1 520 160 -26 -119 0 0 "/foss/designs/GF180/sscs_chipathon_26/LNA/analog_pad_sp_paramerters/spice_files/unextracted_gf180mcu_fd_io__asig_5p0.spice" 0 "_netASIG5V,_netDVDD,_netDVSS,_netVDD,_netVSS" 0 "yes" 0 "none" 0 "" 0>
</Components>
<Wires>
  <70 240 70 300 "" 0 0 0 "">
  <520 250 520 260 "" 0 0 0 "">
  <480 220 480 260 "" 0 0 0 "">
  <520 260 520 270 "" 0 0 0 "">
  <480 260 520 260 "" 0 0 0 "">
  <460 160 490 160 "" 0 0 0 "">
  <460 160 460 270 "" 0 0 0 "">
  <520 270 520 280 "" 0 0 0 "">
  <640 100 640 130 "" 0 0 0 "">
  <640 190 640 280 "" 0 0 0 "">
  <580 100 580 160 "" 0 0 0 "">
  <860 100 860 170 "" 0 0 0 "">
  <730 100 730 160 "" 0 0 0 "">
  <480 220 490 220 "" 0 0 0 "">
  <730 280 790 280 "" 0 0 0 "">
  <520 280 520 290 "" 0 0 0 "">
  <730 220 730 280 "" 0 0 0 "">
  <860 230 860 280 "" 0 0 0 "">
  <790 280 790 290 "" 0 0 0 "">
  <730 100 860 100 "" 0 0 0 "">
  <790 280 860 280 "" 0 0 0 "">
  <520 280 640 280 "" 0 0 0 "">
  <580 100 640 100 "" 0 0 0 "">
  <550 100 580 100 "" 0 0 0 "">
  <550 160 580 160 "" 0 0 0 "">
  <460 270 520 270 "" 0 0 0 "">
  <350 100 490 100 "" 0 0 0 "">
  <70 100 70 180 "" 0 0 0 "">
  <160 100 290 100 "" 0 0 0 "">
  <70 100 160 100 "" 0 0 0 "">
</Wires>
<Diagrams>
</Diagrams>
<Paintings>
</Paintings>
