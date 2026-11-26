# EM_Flow

Archived EM characterization for each inductor actually used in the current
layout (`klayout/*_coil.gds`). One subdirectory per coil:

- `gen_*.py` (LEQ/L1/LSHUNT_OUT only): builds the fast single-ended 2-port
  geometry from the family's hand-verified reference GDS, via
  `scale_dout_rect.py` + `se_convert.py` (project scripts, live under
  `/foss/designs/rapidpassives/try4/newflow/` -- not duplicated here).
- `run_*.py`: the openEMS single-port simulation (port 2 already shorted to
  the guard ring in the GDS itself -- see each script's own `source_layernum`
  and `excite_portnumbers` for the one live port). Re-running reproduces the
  `.s1p` bit-for-bit modulo the GDS header timestamp.
- `*_SE.gds`: the exact geometry that was simulated.
- `*_REAL*.gds` / `Ind_*_real*.gds`: the real, DRC-clean, via-stitched
  production geometry -- byte-identical to the installed `klayout/*.gds`
  (confirmed for LEQ/L1/LSHUNT_OUT/LD4; LD2's installed file is the same
  family/geometry with a placement-time port-bracket strip, not byte-exact).
- `*.s1p`: the single-port Touchstone result. This is the only EM *output*
  kept -- the full field-solver intermediate data (tens of MB per run, in
  `output/.../sub-1/` next to each script's original location) is NOT copied
  here since it's fully reproducible by re-running `run_*.py` in place
  against the newflow/ tree.

LD2 and LD4 use a different generator (`build_real_drain.py`, parametric
spiral, not a chain-shifted reference) so they have no separate `gen_*.py`;
LD2's own EM data in particular came from a generic N/W/D calibration sweep
script (`run_cal_N3_W1.75_D185_nostack.py`) rather than a coil-named one --
kept as-is rather than renamed, to stay traceable to its real origin.

## Re-deriving the xschem model

Each coil's `.s1p` here is exactly what `xschem/<COIL>_model.lib`'s `snp2le`
section was fitted from:

```
snp2le -b convert <coil>.s1p --mode universal --order 6 --passive \
    --thermal-noise --dc-pin --format ngspice -o /tmp/<coil>_fit.lib
```

(LD2/LD4 auto-select order 4 -- lower-Q coils need fewer poles.) The raw
fit is a single-pin (grounded) subckt; `xschem/<COIL>_model.lib` wraps it in
the project's standard two-pin `p1 p2` interface with `Vp2gnd p2 0 0` added,
matching the `ideal`/`rl` variants' own pin convention. L1 shares
`LSHUNT_OUT_model.lib` rather than getting its own file -- same target L,
same real geometry (`L1_RECT5`/`LSHUNT_OUT_RECT5`, both `X314.0_Y107.8`),
just placed/rotated differently.

Verified against ngspice (AC sweep at 2.4GHz, Z11 -> L/R/Q) for all four
model files: every one reproduces its own `run_*.log`'s reported L/R to
better than 0.1%.
