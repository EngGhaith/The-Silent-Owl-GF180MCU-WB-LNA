# LNA optimization scripts (state: 2026-10-05)

All scripts read `lna-core_tb.spice` from this folder. It is a snapshot of the xschem netlist.
After schematic changes, export it again:

    cd xschem && xschem -n -x -q -o ../sim/opt lna-core_tb.sch

| Script | Purpose |
|---|---|
| `lna_eval.py` | Evaluates a variant: Idd, S-params (PDK), NF via `.noise` (poly R idealized), headroom. Overrides as JSON, e.g. `python3 lna_eval.py '{"XM1.m": 4}'`. `_buf` = SF buffer, `_out` = output L/C. |
| `opt_gain.py` | Differential Evolution for the single-stage variant (`--noout` = without output network) |
| `opt_buf.py` | Differential Evolution for the source-follower buffer variant (argument: P_max in mW) |
| `check_buf.py` | 15 corners + stability factor μ, e.g. `python3 check_buf.py best_buf.json` |
| `nc_sweep.py` | Old XMNC/RIBCS sweep |

`best_buf.json` holds the best buffer variant, optimized for typical only: 15.5–17.5 dB, 107 mW. The `*.log` files are the optimizer outputs.
