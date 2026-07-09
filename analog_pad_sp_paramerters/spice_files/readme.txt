*****************************************
* SSCS-Chipathon 2026                   *
* Team: The Silent Owl - SSCS Chipathon *
*****************************************
*******************
* Ahmed M Elnagar *
* JUN-26-2026     *
*******************
This directory is for simulating the S-Parameters of 5V Analog ESD Pad for GF180mcuD
Tools used: IIC-OSIC-TOOLS Docker Container by Dr.Herald Pretl

1) extracted_gf180mcu_fd_io__asig_5p0.spice: Capacitance extracted only
2) extracted_gf180mcu_fd_io__asig_5p0_manually_scaled.spice: Capacitance extracted with manual scaling of components "scale=5n"
3) gf180mcu_fd_io__asig_5p0_pex_pdk_gf180mcuD_rcx_cthresh_0p1_extresist_250mohm.spice: R-C extraction without the parasitics diodes with ctheresh 0.1nf and rthresh 0mohm
4) gf180mcu_fd_io__asig_5p0_pex_pdk_gf180mcuD_rcx_cthresh_0p1_extresist_500mohm.spice: R-C extraction without the parasitics diodes with ctheresh 0.1nf and rthresh 500mohm
5) unextracted_gf180mcu_fd_io__asig_5p0.spice: The I/O file from the PDK
