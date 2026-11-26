# LD4 rectangular reshape -- iteration 1 (EM RESULT CONFIRMED -- FINAL,
# no correction iteration needed)

## EM RESULT (confirmed)

  openEMS run completed (PID 3092100, run_ld4_rect1.log):
    Frequency: 2.400 GHz
    Series L : 8.4824 nH   (+0.502% vs 8.44nH target -- WITHIN this
               project's established ~0.1-1% tolerance, same ballpark as
               LD2_RECT_CAND2's own confirmed -0.458% miss -- CONFIRMED,
               NO CAND2 correction warranted)
    Series R : 30.2594 Ohm (+3.88% vs 29.13ohm -- secondary metric, per
               this task's own explicit guidance not worth a further
               correction iteration once L is on target; same order as
               LD2_RECT's own +3.08% R overshoot from its analogous
               reshape -- consistent family behavior)
    Q factor : 4.227       (-3.3% vs 4.370 -- also secondary, consistent)

  Geometry: OUTER_HALF_X=216.0, OUTER_HALF_Y=93.0 (N=3, W=2um, S=2um, SC2
  shunt family) -> **rx=232.0, ry=109.0** (confirmed via BOTH the SE GDS's
  own bounding box AND the final real multi-layer GDS's own bounding box --
  exact match, ind_mk keepout marker included).

  Net result vs the original square LD4 (r=rx=ry=166.0):
    ry: 166.0 -> 109.0   (-34.3% reduction -- the floorplan-side goal,
        landing in the middle of the required [105,113] window)
    rx: 166.0 -> 232.0   (+39.8% growth, compensating to conserve L)
    L : 8.4401 (square, on-target) -> 8.4824 (rect, +0.50% vs target)

  Floorplan check with these confirmed numbers: cx4 = 627+167+25+109 = 928,
  east_edge = cx4+ry = 928+109 = **1037** -- comfortably under LSHUNT_OUT's
  1044 floor (7um margin), achieving this task's actual goal (LD4 no longer
  the binding constraint on MACRO_W). South-fit: pe~=rx-0.5=231.5,
  cy4~=330-231.5=98.5, cy4-rx=98.5-232.0=-133.5 >= -329 required -- huge
  margin, confirmed.

  The single first-guess candidate (CAND1: ox=216.0, oy=93.0, derived from
  the LD2_RECT precedent's own found ~+16% over-correction factor beyond
  naive ox+oy conservation -- see "Why this guess" below) landed within
  tolerance on the FIRST try. No further iteration (CAND2) is warranted.

## FINAL deliverable files (this folder)
  Ind_LD4_RECT_REAL_X216.0_Y93.0.gds -- the final real, tape-out-style
    5-metal-guard-ring / TM+M4-shunted-trace layout (shunt_metal=46,
    LD4/SC2-style), built via build_real_drain_rect.build_drain_gds_rect(3,
    2.0, 2.0, 216.0, 93.0, ..., shunt_metal=46). Confirmed bbox
    (+-232.0, +-109.0), matching the ind_mk keepout marker exactly.
    NOT yet DRC/LVS-checked (that -- plus klayout/ floorplan integration --
    is explicitly out of scope for this R&D task; orchestrating session's
    job once it picks this result up).
  Ind_LD4_RECT_X216.0_Y93.0_SE.gds -- the single-ended GDS actually fed to
    openEMS for the confirmed result above.
  run_ld4_rect1.py / run_ld4_rect1.log -- the confirmed openEMS run.

---

# LD4 rectangular reshape -- iteration 1 (ORIGINAL NOTES, pre-EM-result)

Task: reshape LD4 (`The-Silent-Owl-GF180MCU-WB-LNA/klayout/LD4_coil.gds`, the
cg-stage drain inductor, intentionally low-Q R=29.13ohm/Q~4.4 by design --
L=8.44nH target) into a rectangle that shrinks its world-X half-extent
(local axis `ry` in `lna_lib`'s reporting, since LD4 is placed with
`rot=90, mirror=True` in `build_cg`) from 166 down into the 105-113 range
(floorplan math: LD4's east edge needs to land at/below ~1040-1050 so
LSHUNT_OUT, not LD4, becomes the sole binding constraint on MACRO_W), while
growing world-Y half-extent (local `rx`) to conserve L=8.44nH. Pure R&D in
`rapidpassives/try4/newflow/` -- the klayout layout repo is NOT touched by
this work (integration is the orchestrating session's job, after EM results
are confirmed), same discipline as every other coil reshape this session
(LEQ/L1/LSHUNT_OUT/LD2).

## Step 0 -- LD4's confirmed family/baseline (re-verified from existing files,
not re-derived)

Found and confirmed from `drains/good_tries/LD4_FINAL_D300_N3_W2_SC2/` (an
existing, already-EM-validated and DRC-clean LD4 build) and
`drains/run_cal_N3_D300_sc2.py` / `.log` (the exact run behind that folder's
own quoted numbers):

  N = 3 turns, W = 2um trace, S = 2um spacing, Dout = 300um
  (outer_half = 150um), **SC2** stack tier: main trace carried on TM AND M4,
  shunted together via real TV via-stitching across the WHOLE trace (less
  merging than SC3/SC4/SC5 -- deliberately more resistance per unit L, to
  land near LD4's own low-Q target). Guard ring: independently fully-shunted
  5-metal structure (M1/M2/M3/M4/TM + real inter-metal vias), same
  convention as every other coil in this project.

  Confirmed EM baseline (re-run log `drains/run_cal_N3_D300_sc2.log`, GDS
  `drains/cal_N3_W2_D300_sc2_SE.gds`, square outer_half=150):
    Frequency: 2.400 GHz
    Series L : 8.4401 nH
    Series R : 29.1268 Ohm
    Q factor : 4.370 (Peak Q 4.922)
  -- matches `LD4_FINAL_D300_N3_W2_SC2/RESULTS.txt`'s own quoted
  L=8.44nH/R=29.13ohm/Q=4.369 exactly (rounding only).

  **Key mechanism confirmed**: the SE/EM-characterization GDS for this
  family is ALWAYS pure single-TM-layer geometry (`se_gen.py`/
  `se_gen_rect.py`, layer 81 only, generic across N/W/S/outer_half, NO
  shunt_metal parameter anywhere in that path) -- the SC2/SC3/SC4/SC5/
  no-stacking TIER SELECTION happens entirely via which openEMS stackup XML
  is used, NOT via any difference in the GDS fed to openEMS. Confirmed by
  diffing `OPENEMS-GF180MCUD-1P5M-TM11KA-MIMB.xml` (LD2's no-stacking XML)
  against `OPENEMS-GF180MCUD-1P5M-TM11KA-MIMB-STACKED2.xml` (LD4's SC2 XML):
  the only difference is the TM layer definition is replaced with a single
  merged Zmin=4.68 (M4's own bottom)..Zmax=7.3225 (TM's own top) slab using
  material `TM-SC2` (effective conductivity 32818753.56 S/m, modeling the
  parallel M4+TM shunt as one physical conductor for EM purposes) instead of
  the separate M4/MIM/TV/TM layer stack. **This means LD2's already-existing,
  already-validated `se_gen_rect.py` applies to LD4 completely UNMODIFIED**
  -- only the stackup XML passed to openEMS needs to change (STACKED2
  instead of MIMB), not any GDS-generation code.

  Full footprint (coil + 10um ring standoff + 6um ring width, same margin
  convention as LD2/LEQ/LSHUNT_OUT): outer_half=150 -> ring_outer = 150+16 =
  166 -- EXACTLY matches `lna_lib._coil_read()`'s reported
  `r=rx=ry=166.0`/`pe=165.5` for the real `LD4_coil.gds`. Confirms the
  square-footprint baseline used for this reshape is the correct one.

## Tooling: reused LD2's rect tooling, extended for SC2 shunting

`spiral_gen_rect.py` / `se_gen_rect.py` -- copied UNMODIFIED from
`LD2_RECT_CAND2_X130.2_Y60.0_N3_W1.75/` and re-validated for this family's
own N=3/W=2/S=2/outer_half=150 square case (delta=0 self-check against
`se_gen.py`'s own square output, PASSED) before trusting them for a rect
candidate -- see the one-off validation run in this folder's history.
`se_gen_rect.build_se_gds_rect()` needed NO changes at all (SE path is
TM-only regardless of shunt tier, per the "Key mechanism" finding above).

`build_real_drain_rect.py` -- EXTENDED in this folder (the LD2-donor copy
only supported `shunt_metal=None`): added `trace_leg_bands_rect()` and
`via_stitch_trace_rect()`, the rect counterparts of `spiral_gen.
trace_leg_bands()`/`build_real_drain.via_stitch_trace()`, using the SAME
"each chain value plays either an x-role (chain_x) or a y-role (chain_y)"
index-substitution discipline as every other primitive in this module (top/
bottom bands span the full X extent at a chain_y-derived Y-band; left/right
bands span the full Y extent at a chain_x-derived X-band -- mirroring
`ring_rects_rect`'s own axis-role split exactly). `clip_rect_to_polygon`
(from `build_real_drain.py`) is reused completely unchanged -- already
generic (axis-aligned-rect-vs-arbitrary-polygon boolean intersection), no
square-specific assumption in it. Added `validate_rect_delta0_shunt()`:
outer_half_x==outer_half_y==150.0 with shunt_metal=46 reproduces
`build_real_drain.build_drain_gds(3, 2.0, 2.0, 150.0, ..., shunt_metal=46,
...)`'s own output exactly (point-for-point/rect-for-rect per layer,
including every shunt via-stitch block) -- **PASSED**, confirming this
extension is a faithful generalization before trusting it for the final
real/tape-out candidate build. (A gdspy quirk was hit and fixed along the
way: `Cell.__init__` auto-registers into gdspy's GLOBAL `current_library`
regardless of which local `GdsLibrary` instance is held, so
`gdspy.current_library = gdspy.GdsLibrary()` must be reset immediately
before EACH independent build call in the same process, not just once --
otherwise a same-named via-unit cache cell like `via_unit_41`, shared by
both the underpass bridge chain and the shunt stitching, collides across
successive validate_*() calls.)

## Geometry chosen for this iteration (CAND1)

  OUTER_HALF_X = 216.0, OUTER_HALF_Y = 93.0 (N=3, W=2um, S=2um, SC2 family)
  -> rx = 232.0, ry = 109.0 (confirmed via `spiral_gen_rect.ring_rects_rect`
     directly, and matches the SE GDS build)
  -> ry shrinks from 166.0 to 109.0: a **-34.3% reduction** -- lands
     comfortably inside the required [105,113] target window (midpoint-ish),
     well clear of LSHUNT_OUT's 1044 floor with the floorplan math in the
     task brief (cx4 + ry = 819 + 109 = 928, i.e. LD4's east edge would land
     at world-x~928, well under 1044 -- actually MORE margin than the
     "under 1040-1050" requirement called for, consistent with picking the
     middle of the allowed [105,113] window rather than its edge).

  outer_half_x + outer_half_y = 309.0 vs. the original Dout = 300.0 (2x150)
  -- i.e. NOT pure "ox+oy=2*oh0" conservation; includes a deliberate extra
  +9.0 beyond naive symmetric-sensitivity conservation.

### Why this guess (reusing the LD2_RECT precedent's own finding)

No prior rect data exists for THIS exact family (N3/W2/S2/SC2), so the
model continues to borrow the isotropic `dL/d(outer_half)` proxy slope
derived earlier this project from the N=3/W=2 **nostack** square sweep
(same trace geometry -- L is a function of the TM current-path shape only,
NOT of the SC2 shunt, which affects R, not L):
  outer_half=75  (D=150): L=3.1356 nH
  outer_half=90  (D=180): L=4.0499 nH
  outer_half=100 (D=200): L=4.6874 nH
  dL/dD (isotropic) ~= 0.031 nH/um (consistent across adjacent pairs) ->
  dL/d(outer_half)_isotropic = 2*0.031 = 0.062 nH/um -> per-axis separable
  proxy slope a ~= 0.031 nH/um/axis (same reasoning chain used for LD2's own
  CAND1 initial guess).

A PURE naive-conservation guess (ox+oy=300, i.e. ox=150+Δ, oy=150-Δ) was
**deliberately NOT used verbatim** here: LD2's own CAND1/CAND2 history
(same generator family, same per-axis proxy) showed this naive symmetric
model UNDER-predicts the true required ox growth -- shrinking oy costs more
L than the isotropic proxy assumes, so growing ox by the SAME naive amount
under-recovers it (LD2 needed an extra +5.23um beyond the naive +32.5um,
i.e. ~+16% extra, to land within tolerance on CAND2).

Applying the SAME ~+16% relative correction factor to this (larger) shrink:
  Δoy = 93.0 - 150.0 = -57.0
  naive Δox (pure conservation) = +57.0
  LD2-precedent-scaled Δox ~= 57.0 * 1.161 ~= 66.2 -> ox ~= 216.2, rounded
  to **216.0** (oy fixed at 93.0, the chosen ry target).

CAVEAT (flagged honestly, same as every other coil reshape this session):
this reuses a cross-family/cross-W proxy slope and a correction factor
borrowed from a DIFFERENT aspect ratio/shrink magnitude (LD2's own 30%
ry-shrink, vs. this candidate's 34% shrink) -- not a validated same-family
rect data point. Treat the EM result below as the real answer; if off by
more than ~0.5-1%, do ONE Newton-step correction using THIS run's own real
(ox+oy, L) data point (same method as every other coil's correction this
session).

### Physical-sanity / south-fit check

South-edge fit (`cy4 - new_rx - RING >= Y_S + RING`, i.e. `cy4 - new_rx >=
-329`, with `cy4 ~= 330 - pe ~= 330 - (rx - 0.5)`): with rx=232.0, this is
`330 - 232.0 + 0.5 - 232.0 = -133.5 >= -329` -- comfortable margin (~195.5um
of slack), consistent with the task brief's own "very generous ceiling"
prediction (rx<=329.5). Confirmed from THIS candidate's own actual rx, not
assumed. (pe's exact equality to rx-0.5 will be re-confirmed once this
family's own real GDS build reports its bounding box -- see "NOT YET DONE".)

## Files in this folder

  spiral_gen.py, se_gen.py, scale_dout.py, real_multilayer.py,
    build_real_drain.py -- unmodified copies of the existing validated
    square-family tooling (import dependencies + square-reference
    baselines for the validations below).
  spiral_gen_rect.py, se_gen_rect.py -- unmodified copies of LD2's own
    validated rect tooling (re-validated here for this family's own
    N=3/W=2/S=2/outer_half=150 square case, PASSED).
  build_real_drain_rect.py -- EXTENDED this session to support
    shunt_metal=46 (SC2) via trace_leg_bands_rect()/via_stitch_trace_rect(),
    plus validate_rect_delta0_shunt() (PASSED) -- see "Tooling" above.
  OPENEMS-GF180MCUD-1P5M-TM11KA-MIMB-STACKED2.xml -- LD4's own SC2 stackup
    XML (copied unmodified from `drains/`), used instead of LD2's
    `-MIMB.xml` for the openEMS run below.
  Ind_LD4_RECT_X216.0_Y93.0_SE.gds -- single-ended GDS fed to openEMS
    (run_ld4_rect1.py), built via se_gen_rect.build_se_gds_rect(3, 2.0, 2.0,
    216.0, 93.0, ...). Confirmed rx=232.0, ry=109.0 via
    spiral_gen_rect.ring_rects_rect(216.0, 93.0, 2.0) directly.
  run_ld4_rect1.py / run_ld4_rect1.log -- openEMS single-ended
    characterization script (same flow/settings as LD4's own
    `drains/run_cal_N3_D300_sc2.py`: gds2openEMS, PEC boundaries,
    merge_polygon_size=2, energy_limit=-60dB, resonance_estimation=True,
    margin=350um, 2.4GHz target, XML=STACKED2 not MIMB). Launched via
    `nohup python3 run_ld4_rect1.py > run_ld4_rect1.log 2>&1 & disown` for
    true process detachment. Mesh came up at 575k FDTD cells (133x135x32),
    similar order to LD4's own square run (502k cells, ~6.5min solve) and
    LD2's rect runs (~496k cells, ~8-10min each) -- similar runtime
    expected, well within this project's general 15-80 minute guidance.
  output/run_ld4_rect1_data/ -- full openEMS output dir once complete.

## How to check / resume

  tail -f run_ld4_rect1.log   -- or `tail -n 40` for current state
  Look for the final block:
    "Single-ended inductor parameters (LD4_RECT_CAND1_X216.0_Y93.0)"
    Frequency [GHz], Series L [nH], Series R [Ohm], Q factor, Peak Q
  Target: L=8.44nH (R=29.13ohm/Q~4.37 SECONDARY -- per this task's own
  explicit guidance, LD4 is intentionally lossy by design, so do not spend
  extra correction iterations chasing R/Q precision once L is on target).
  If |L-8.44|/8.44 > ~0.1-1% (this project's own established tolerance), do
  ONE Newton-step correction (same method as LD2_RECT_CAND1->CAND2): compute
  the secant slope from (300.0, 8.44) [square baseline, ox+oy sum] and this
  run's own (309.0, L) data point, holding OUTER_HALF_Y FIXED at 93.0 (locks
  in the full ry=109.0 floorplan benefit), then re-run as CAND2 in a sibling
  folder (LD4_RECT_CAND2_X<ox>_Y93.0_N3_W2_SC2).

## NOT YET DONE (explicitly flagged)

  - EM result CONFIRMED (see top of this file) -- no CAND2 needed.
  - Final real tape-out GDS BUILT (Ind_LD4_RECT_REAL_X216.0_Y93.0.gds,
    confirmed bbox) -- see "FINAL deliverable files" above.
  - DRC/LVS on the real build -- NOT done (out of scope for this R&D task,
    same discipline as LD2_RECT's own precedent -- orchestrating session's
    job, or a dedicated follow-up).
  - klayout/ integration (COILS dict entry, LD4_CY/cx4 floorplan
    re-derivation, MACRO_W re-check) -- explicitly OUT OF SCOPE for this
    task (orchestrating session's job, after EM results are confirmed).
  - xschem LD4 model update, if the project's convention is to give a
    reshaped coil its own dedicated model file (lower priority, same as
    LD2_RECT's own precedent, since the schematic model is sized from the
    same L target either way).
