*****************************************************************************************
*****************************************************************************************
* SSCS-Chipathon 2026, Team A38: The Silent Owl
* File Version: Ver 1.0
* editor: Ahmed M. Elnaggar, elnaggar@email.sc.edu
* github: @elnaggar
*****************************************************************************************
*This Python script aim to automate and check the parasitic extraction using magic layout
*****************************************************************************************
*****************************************************************************************
Requires Python 3.10+.
*****************************************************************************************
Terminal input example:
python3 magic_pex_gf180_v7.py gf180mcu_fd_io__asig_5p0.mag \
  --pdk gf180mcuD \
  --mode rcx \
  --flatten \
  --cthresh 0.1 \
  --extresist-thresh-ohm 10 \
  --merge none \
  --no-wrapper \
  --check-junctions \
  --keep-temp \
  --log asig_5p0_rcx_magic.log \
  --live \
  --progress-interval 15
*****************************************************************************************
Help:
python3 magic_pex_gf180_v7.py -h
*****************************************************************************************