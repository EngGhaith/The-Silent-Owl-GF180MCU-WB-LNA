"""
Clean secant correction of LSHUNT_OUT_RECT_CAND4's own outer_half_y, now
bracketed by two real same-ox=314.0 data points:
  CAND3 (314.0, 112.5) -> 2.5964nH
  CAND4 (314.0, 109.0) -> 2.5281nH   (target 2.5041nH lies just below CAND4)
slope = (2.5964-2.5281)/(112.5-109.0) = 0.019514 nH/um
oy = 109.0 + (2.5041-2.5281)/0.019514 = 107.77 -> rounded to 107.8
(Notably converges to almost exactly the same outer_half_y as L1_RECT5 --
expected, since both coils share the identical N=2/W=26/S=2 family, the
same fixed outer_half_x=314.0, and the same 2.5041nH target.)
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
SCALED = 'Ind2_LSHUNT_OUT_RECT5_X314.0_Y107.8_2port.gds'
SE_OUT = 'Ind2_LSHUNT_OUT_RECT5_X314.0_Y107.8_SE.gds'

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
