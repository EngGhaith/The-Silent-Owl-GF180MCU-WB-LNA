# LVS of `lna_core_parts` with the Chipathon integration flow

This folder runs LVS of `klayout/lna_core_parts_filled.gds` (top cell `lna_core_parts`) the same way the Chipathon 2026
integration checked the September tapeout: **Magic extraction + Netgen**, driven by `lvs_config.json`.

## 1. Reference scripts (used for the previous tapeout)

The Chipathon 2026 integration issues ([#200](https://github.com/sscs-ose/sscs-chipathon-2026/issues/200),
[#201](https://github.com/sscs-ose/sscs-chipathon-2026/issues/201),
[#202](https://github.com/sscs-ose/sscs-chipathon-2026/issues/202),
[#203](https://github.com/sscs-ose/sscs-chipathon-2026/issues/203), September 2026, integrator D. Mitch Bailey)
show how the integration was checked:
- **DRC** used the KLayout deck from the PDK, `gf180mcuD/libs.tech/klayout/drc`, variant D, unpatched. Magic DRC was sometimes run as a cross-check.
- **LVS** used each project's `lvs_config.json` (`LVS_SPICE_FILES`, `LVS_VERILOG_FILES`, ...). That is the input format of `run_full_lvs` from **[d-m-bailey/extra_be_checks](https://github.com/d-m-bailey/extra_be_checks)**. It runs Magic (extraction) and Netgen with its own `tech/gf180mcuD/gf180mcuD.tech` and `gf180mcuD_setup.tcl`.

`lvs/extra_be_checks/` is a copy of that repository at commit `4957b99` ("Merge pull request #50 from
d-m-bailey/2409"). The copy leaves out the sky130 tech files and spice files and is otherwise unchanged. It is licensed under Apache-2.0, see `lvs/extra_be_checks/LICENSE`.

## 2. How to: LVS clean

```bash
lvs/run_lvs.sh               # netlist the schematic -> xschem/lna_core_parts_lvs.spice, then run_full_lvs (~25 min)
lvs/run_lvs.sh --nonet       # use the committed xschem/lna_core_parts_lvs.spice as is
lvs/run_lvs.sh --noextract   # re-run netgen only on the previous extraction (fast)
```
The script prints `RESULT: PASS` or `FAIL`. The netgen report is `lvs/work/lna_core_parts/lvs.report` (git-ignored).

The `lvs_config.json` in the repo root needs these settings:

| key | value | why |
|---|---|---|
| `INCLUDE_CONFIGS` | `$LVS_ROOT/tech/$PDK/lvs_config.base.json` | base settings of extra_be_checks (unchanged) |
| `TOP_SOURCE` / `TOP_LAYOUT` | `lna_core_parts` | top cell in both netlist and GDS |
| `LVS_SPICE_FILES` | `$UPRJ_ROOT/xschem/lna_core_parts_lvs.spice` | reference netlist; **must be regenerated from the current schematic** (`lvs/make_lvs_netlist.py`, called by `run_lvs.sh`). The previous file was from 2026-11-08 and had no coils and no DEEMB structures |
| `LVS_VERILOG_FILES` | `[""]` | analog only |
| `LAYOUT_FILE` | `$UPRJ_ROOT/klayout/lna_core_parts_filled.gds` | the signoff layout: COMP/poly2 dummy fill, clean on both DRC decks including density. `klayout/lna_core_parts.gds` is the same layout unfilled (clean except the density rules) |

What `lvs/make_lvs_netlist.py` does to the xschem netlist, so that the names match what Magic extracts:
- `nfet_05v0` becomes `nfet_06v0`. The Magic tech ignores the 5 V marker (112/1) and extracts every thick-oxide nFET as `nfet_06v0`.
- `cap_mim_2f0fF` becomes `cap_mim_2f0_m4m5_noshield`, with W/L snapped to the 10 nm drawing grid.
- Coils come from the `lvsrm` sections of `xschem/*_model.lib` as PDK metal resistors (`tm11k`, `rm4`, `rm3`, `rm2`).
- Ideal inductors and ideal loss resistors are removed.

## 3. Layout changes (in `klayout/lna_core_parts.gds`, carried into the filled variant)

All of these are applied by `lvs/apply_lvs_layout_fixes.py` (re-runnable on a fresh copy of the layout):

1. **VDD/VSS short.** Removed the two M4 `vss` labels at (778.107, 1096.027) and (978.107, 1096.027). They sit on VDD strap metal and merge vdd and vss into one net.
2. **Coils are not extracted.** Magic only creates a metal resistor where **RES_MK (110/5)** overlaps the metal marker (110/11..15) in the same cell. RES_MK was added to all 7 `metal_resistor*` cells: LEQ, L1 and LSHUNT_OUT (tm11k), LD4 (tm11k + rm4 + rm3 + rm2) and LD2 (rm4). LD2 needs no M5 bridge in this flow.
3. **DEEMB_O / DEEMB_S / DEEMB_R / DEEMB_2R / DEEMB_0P5R: identical feed in all five** (new cell `DEEMB_feed_rm3`).
   The chain is: M1 feed line → via tower M1–V1–M2–V2–M3 (1.62 × 1.62 µm, 3×3 vias) → M3 → **rm3** (W = 1.62 µm, L = 1 µm, 110/13 + 110/5) → M3 pin.
   - The rm1 marker (110/11) of DEEMB_O / DEEMB_S was removed. The Magic tech maps GDS 110/11 to `MET2RES`, so **rm1 is never extracted**. This is a bug in both the extra_be_checks tech and the PDK's magic tech.
   - The pin labels `deemb_*` moved from M1 to the M3 end of the feed (42/10). The old M1 labels were removed, including a stray top-level `deemb_s` label at (19.62, 936.59) that was not on metal.

4. **DRC MT.2b** (space to wide metaltop, 0.6 µm) at (734, 16) and (846, 16). These were already in the original layout. Two PG tiles merge there with the wide M5 of the L1 / LSHUNT_OUT coils, and each tile has a 2 × 2 µm M5 hole. Both holes are empty on M3–M5 and on all via layers, so filling them with M5 leaves the net unchanged.
5. **Two `vss` labels on unconnected metal** were removed (text only): the M4 label at (578.107, 1096.027) and the M1 label at (55, 535). Magic reported them as disconnected nodes `vss_uq19` / `vss_uq31`, and Netgen showed them as extra pins ("port errors").
6. **Magic DRC MIMTM.2** (11 areas): some via4 of the M4-bottom-plate → M5 connections of the MIM caps sat only 0.2–0.3 µm from the bottom plate edge (minimum 0.4 µm). The via4 closer than 0.42 µm to the edge were removed: 208 shapes in 4 via-array cells, 400 vias over all instances. At least 4, and usually several hundred, vias remain per connection.
7. **Magic DRC PRES/LRES/HRES.7** (972 places): Magic wants the poly contact of an unsalicided resistor exactly 0.22 µm from the SAB edge, while the PDK high-Rs pcell has 0.25 µm. The inner poly contacts were moved 0.03 µm towards the SAB edge (14 contacts in 3 resistor cells). This also meets the DRM minimum (HRES.8 ≥ 0.22 µm).

8. **DRC ANT.16** (11 areas): four metal1 rectangles in `lna_core_parts` were removed — two straps
   (3.840 x 35.320 um at 412.760/680.000 and 3.740 x 33.860 um at 601.260/786.140) and two small pieces
   (at 60.000/824.905 and 552.510/812.500). They were a second path from the dummy-transistor guard rings
   to the vss grid, which is tied to vss anyway, so the extracted netlist is unchanged (28 devices / 22 nets
   before and after). Antenna rules are evaluated per metal level on the conductor attached to the gate at
   that step, so this redundant-for-DC metal still counted its full area and broke `ANT.16_i/ii_ANT.2/5/9/10/11/12`.
   Removing it clears all 11. Five unreferenced `PG_PLAIN_*` cells were deleted at the same time; they also
   left the layout with a single top cell (it had four).

9. **COMP + poly2 dummy fill** -> `klayout/lna_core_parts_filled.gds` (the unfilled
   `klayout/lna_core_parts.gds` keeps items 1-8 only). Conformal fill: the region where dummy COMP is legal,
   cut by a grid of 2.8 um streets at 30 um pitch, so islands follow the available space. Dummy poly2 is each
   island grown 0.1 um per side (see the Magic-only poly rules below). The five de-embedding structures
   (`Open`, `Short`, `Load_R`, `Load_2R`, `Load_0p5R`) are excluded: no fill inside their bbox + 5 um, and
   each is marked with NDMY (111/5) so `DCF.1a` does not demand fill in that gap. Verified 0.000 um2 of fill
   inside any of them, and all five carry an identical (empty) interior pattern -- the only pattern legal in
   all five, since the three Load cells leave 13 um2 of legal space.

## Verification results

| | KLayout DRC (`decks=all`) | Magic DRC | LVS |
|---|---|---|---|
| `klayout/lna_core_parts.gds` | 16 violations: `DCF.1a` x14, `DCF.1b`, `PL.8` -- **density only** | 0 | PASS, 28 devices / 22 nets |
| `klayout/lna_core_parts_filled.gds` | **0** | **0** | PASS, 28 devices / 22 nets |

Filled densities: COMP 26.197 % (`DCF.1b` >= 25 %), poly2 18.377 % (`PL.8` >= 14 %), metal 50.8-56.1 %
unchanged -- **no metal fill**. The unfilled file's only failures are the three rules that fill exists to
satisfy; per Chipathon issue #202 density fill may also be left to chip-level integration, so both variants
are kept.

## DRC (results: `lvs/check_results.txt`; KLayout and Magic DRC are both clean)

Both decks run from `klayout/check_lna_core_layouts.py`, selected with `--drc` (default `both`):

```bash
python3 klayout/check_lna_core_layouts.py parts --drc=both --no-lvs
```

| `--drc=` | deck | covers | result on this layout |
|---|---|---|---|
| `klayout` | PDK KLayout deck | FEOL + BEOL + antenna | clean (0 violations over 753 rule categories) |
| `magic` | Magic, PDK `gf180mcuD` tech, `drc style drc(full)` | catches e.g. `PRES/LRES/HRES.7`, `MIMTM.2`; **no** antenna rules | clean (0 errors) |
| `both` | both of the above | — | use this for signoff |

They are not redundant: the two decks do not code the same rules, which is why `MIMTM.2` and `HRES.7` were only
found by Magic (layout changes 6 and 7 above).

### Poly-fill rules exist only in Magic (`DPF.1`, `DPF.2a`)

A third case of the same kind, found when generating the COMP/poly2 dummy fill. Magic codes two poly-fill
rules that the KLayout deck does **not** have at all:

| rule (Magic) | requirement |
|---|---|
| `DPF.1` | poly fill **width** >= 5.6 um |
| `DPF.2a` | poly fill **spacing** >= 2.4 um |

The identifiers collide: the KLayout deck uses `DPF.1` for "dummy poly2 is generated on top of dummy COMP"
and `DPF.2b` for a 1.1 um space, and codes no poly-fill width rule. A fill built against the KLayout deck
alone therefore looks clean while violating the DRM -- the first version here used a 0.3 um poly overhang on
a 2.0 um street, giving 1.4 um poly spacing and islands down to 1.8 um wide: **0 violations in KLayout, 4877
in Magic** (5456 `DPF.2a` edge pairs + 570 `DPF.1`).

What satisfies both decks at once (see the geometry used for `lna_core_parts_filled.gds`):
- poly overhang only **0.1 um** per side, so the street width goes into poly spacing instead of being eaten
  by the overhang: poly space = street - 0.2 um. A 2.8 um street gives 2.6 um.
- poly placed only on islands whose **minimum width is >= 5.6 um everywhere** -- testing "wide somewhere"
  (`sized(-w).is_empty()`) is not enough, an island can pass that and still have a narrow rim. The test that
  works is `opening(shape) == shape`.
- COMP islands are kept even where poly is skipped: dummy COMP has no Magic width rule, so dropping poly on
  a narrow island costs poly density only.

The KLayout side uses the PDK's `run_drc.py` when the PDK ships one, and otherwise drives `gf180mcu.drc`
directly. Note that there is no `-rd feol` / `-rd beol` switch in the deck shipped with the gf180mcuD in
IIC-OSIC-TOOLS: there, `feol` and `beol` are *tags* on the rules (see `drc/options.rb` and the `tags: %w[...]`
lines in `drc/rule_decks/*`), so `-rd decks=all,-density,-dummy_comp` runs every FEOL, BEOL and antenna rule.
Which form is needed depends on the PDK build; the script picks automatically.

Magic reads the coil cells with a few "Unknown layer/datatype" warnings for `151/5` (inductor marker) and
`201/0` + `202/0` (openEMS simulation ports). These are marker layers with no manufacturable geometry, so
nothing that DRC would check is skipped.

## 4. Schematic changes (`xschem/`)

- `lna_core_cg.sch` (C3) and `lna_core_cs.sch` (C_CAS): the symbol rotation from "Updated MiM Caps" was reverted to `2 1`. Netlist: `C3 vss net1`, `C_CAS vss vbias_cas`. This matches the layout, where the M5 top plate is on vss.
- `DEEMB_O.sch`, `DEEMB_S.sch`: rm1 replaced by rm3 (W = 1.62 µm, L = 1 µm).
- `DEEMB_R.sch`, `DEEMB_2R.sch`, `DEEMB_0P5R.sch`: rm3 (W = 1.62 µm, L = 1 µm) inserted between the pin and the structure.

## Notes
- LVS in this flow does not need the patched KLayout deck or the LD2 M5 bridge from the earlier PRs. LD2 is extracted as rm4 from its existing M4 marker, as in the original LD2/LD4 `lvsrm` models.
- `lna_top2.gds` was renamed: `klayout/lna_core_parts.gds` (unfilled) and `klayout/lna_core_parts_filled.gds` (filled). The old standalone `lna_core_parts.gds` was replaced by the first of these.
- The rm1 mapping bug (GDS 110/11 → `MET2RES`) is also in the PDK's own `libs.tech/magic/gf180mcuD.tech`. It would be worth reporting to the organizers or to open_pdks.
