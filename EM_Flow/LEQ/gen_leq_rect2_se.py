"""
Final correction of LEQ_RECT's own outer_half_y (back to the validated,
real-reference-backed N=2/W=26/S=2 family after the N=1 single-turn path
turned out to have no real production-GDS route without a brand new
via-stacked reference -- see good_tries/LEQ_N1_RECT3_X250.5_Y314.0's own
DRC findings). outer_half_x stays fixed at 100.0 (pushed near this family's
own ~82 geometric floor, per the user's "minimum coil width" directive);
LEQ's own height ends up ~432um (world-Y = 2*(202.5+16) = 437.0), short of
the uniform 660um L1/LSHUNT_OUT achieve, but using the SAME validated
infrastructure (build_real_coil_rect.py) with zero new engineering risk.

LEQ_RECT (100.0, 200.0) came in at L=1.3548nH, 1.3% below the 1.3723nH
target -- small miss, proportional correction (reliable at this aspect
ratio, ~2.0, much less extreme than L1/LSHUNT_OUT's own 2.9+ candidates):
  outer_half_y = 200.0 * (1.3723/1.3548) = 202.58 -> rounded to 202.5
"""
import sys
sys.path.insert(0, '/foss/designs/rapidpassives/try4/newflow')  # newflow/ (scale_dout.py, scale_dout_rect.py, se_convert.py)

from scale_dout_rect import scale_outer_diameter_rect
import se_convert

OLD_OUTER_HALF = 125.0
N, W, S = 2, 26.0, 2.0
OUTER_HALF_X = 100.0
OUTER_HALF_Y = 202.5

SRC = '/foss/designs/rapidpassives/try4/newflow/Ind2_D250_N2_W26_SC4.gds'
SCALED = 'Ind2_LEQ_RECT2_X100.0_Y202.5_2port.gds'
SE_OUT = 'Ind2_LEQ_RECT2_X100.0_Y202.5_SE.gds'

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
