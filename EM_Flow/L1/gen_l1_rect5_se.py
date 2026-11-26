"""
Clean secant correction of L1_RECT4's own outer_half_y, now bracketed by two
real same-ox=314.0 data points:
  RECT3 (314.0, 118.0) -> 2.7017nH
  RECT4 (314.0, 106.0) -> 2.4684nH   (target 2.5041nH lies between these two)
slope = (2.7017-2.4684)/(118.0-106.0) = 0.019442 nH/um
oy = 106.0 + (2.5041-2.4684)/0.019442 = 107.84 -> rounded to 107.8
"""
import sys
sys.path.insert(0, '/foss/designs/rapidpassives/try4/newflow')  # newflow/ (scale_dout.py, scale_dout_rect.py, se_convert.py)

from scale_dout_rect import scale_outer_diameter_rect
import se_convert

OLD_OUTER_HALF = 125.0
N, W, S = 2, 26.0, 2.0
OUTER_HALF_X = 314.0
OUTER_HALF_Y = 107.8

SRC = '/foss/designs/rapidpassives/try4/newflow/Ind2_D250_N2_W26_SC4.gds'
SCALED = 'Ind2_L1_RECT5_X314.0_Y107.8_2port.gds'
SE_OUT = 'Ind2_L1_RECT5_X314.0_Y107.8_SE.gds'

delta_x = OUTER_HALF_X - OLD_OUTER_HALF
delta_y = OUTER_HALF_Y - OLD_OUTER_HALF

scale_outer_diameter_rect(SRC, SCALED, OLD_OUTER_HALF, OUTER_HALF_X, OUTER_HALF_Y, N=N, W=W, S=S)

se_convert.convert_to_se(
    SCALED, SE_OUT,
    leg_x_start=99.0 + delta_x,
    leg_y_lo=-27.0, leg_y_hi=-1.0,
    via_pad_right_x=125.0 + delta_x,
    ring_inner_x=135.0 + delta_x,
    ring_outer_x=141.0 + delta_x,
    ring_gap_lo=-29.0,
)
print('wrote', SE_OUT)
