# old_tries — archived LNA design variants

This branch is a consolidated archive of ~31 abandoned/superseded design-variant
branches from this project's history. Each variant's full `xschem/` design lives in
its own `xschem_<branch_name>/` folder (instead of the usual shared `xschem/`, since
this one branch holds all of them side by side), and `docs/doc_<branch_name>.html`
describes its topology and real, freshly re-simulated performance.

All of these were re-simulated fresh against the idealized PDK pad model (not the
PEX-extracted netlist used by the current `main`) to get real S11/S21/S22/NF/Icc numbers —
none of this is estimated or copied from old, unverified notes.

The currently active designs (`main`, `dev_ilir_pexmatched`,
`main_lowtailnoise_pexmatched_*`) are NOT archived here — see the main branch.

## dev_ghaith

| Variant | Band | S11 | S21 | S22 | NF | Icc | Status |
|---|---|---|---|---|---|---|---|
| [`dev_ghaith`](docs/doc_dev_ghaith.html) | 2.4 GHz ISM | -22.04 dB | 18.89 dB | -15.94 dB | 2.99 dB | 14.97 mA | ✅ Functional |
| [`dev_ghaith_gnssl1`](docs/doc_dev_ghaith_gnssl1.html) | GNSS L1 | -15.55 dB | 10.72 dB | -8.15 dB | 4.16 dB | 14.97 mA | ⚠️ Marginal |
| [`dev_ghaith_gnssl2`](docs/doc_dev_ghaith_gnssl2.html) | GNSS L2 | -22.28 dB | 7.86 dB | -24.88 dB | 5.04 dB | 14.97 mA | ✅ Functional |
| [`dev_ghaith_loraeu868`](docs/doc_dev_ghaith_loraeu868.html) | LoRa EU868 | -37.28 dB | 2.77 dB | -13.36 dB | 6.77 dB | 14.97 mA | ✅ Functional |
| [`dev_ghaith_lowtailnoise`](docs/doc_dev_ghaith_lowtailnoise.html) | 2.4 GHz ISM | -17.58 dB | 19.02 dB | -15.94 dB | 2.56 dB | 14.97 mA | ✅ Functional |
| [`dev_ghaith_lowtailnoise_gnssl1`](docs/doc_dev_ghaith_lowtailnoise_gnssl1.html) | GNSS L1 | -11.74 dB | 26.15 dB | -17.54 dB | 1.47 dB | 14.97 mA | ✅ Functional |
| [`dev_ghaith_lowtailnoise_gnssl2`](docs/doc_dev_ghaith_lowtailnoise_gnssl2.html) | GNSS L2 | -22.08 dB | 20.18 dB | -22.49 dB | 1.70 dB | 14.97 mA | ✅ Functional |
| [`dev_ghaith_lowtailnoise_loraeu433`](docs/doc_dev_ghaith_lowtailnoise_loraeu433.html) | LoRa EU433 | -0.73 dB | -0.61 dB | -4.19 dB | 12.36 dB | 14.97 mA | ❌ Structural failure |
| [`dev_ghaith_lowtailnoise_loraeu868`](docs/doc_dev_ghaith_lowtailnoise_loraeu868.html) | LoRa EU868 | -7.84 dB | 15.97 dB | -13.28 dB | 2.22 dB | 14.97 mA | ⚠️ Marginal |
| [`dev_ghaith_passive_output`](docs/doc_dev_ghaith_passive_output.html) | 2.4 GHz ISM | -21.97 dB | 22.82 dB | -31.54 dB | 2.97 dB | 16.15 mA | ✅ Functional |
| [`dev_ghaith_passive_output_gnssl1`](docs/doc_dev_ghaith_passive_output_gnssl1.html) | GNSS L1 | -26.25 dB | 23.67 dB | -22.68 dB | 2.48 dB | 16.15 mA | ✅ Functional |
| [`dev_ghaith_passive_output_gnssl2`](docs/doc_dev_ghaith_passive_output_gnssl2.html) | GNSS L2 | -30.22 dB | 19.16 dB | -19.35 dB | 2.94 dB | 16.15 mA | ✅ Functional |
| [`dev_ghaith_passive_output_loraeu433`](docs/doc_dev_ghaith_passive_output_loraeu433.html) | LoRa EU433 | -1.35 dB | -7.58 dB | -0.23 dB | 8.26 dB | 16.15 mA | ❌ Structural failure |
| [`dev_ghaith_passive_output_loraeu868`](docs/doc_dev_ghaith_passive_output_loraeu868.html) | LoRa EU868 | -26.93 dB | 12.86 dB | -12.60 dB | 3.96 dB | 16.12 mA | ✅ Functional |

## dev_ilir

| Variant | Band | S11 | S21 | S22 | NF | Icc | Status |
|---|---|---|---|---|---|---|---|
| [`dev_ilir`](docs/doc_dev_ilir.html) | 2.4 GHz baseline | -17.70 dB | 19.70 dB | -16.14 dB | 2.00 dB | 22.18 mA | ✅ Functional |
| [`dev_ilir_gnssl1`](docs/doc_dev_ilir_gnssl1.html) | GNSS L1 | -9.28 dB | 10.14 dB | -7.76 dB | 4.48 dB | 22.18 mA | ⚠️ Marginal |
| [`dev_ilir_gnssl2`](docs/doc_dev_ilir_gnssl2.html) | GNSS L2 | -9.21 dB | 8.37 dB | -24.78 dB | 5.17 dB | 22.18 mA | ✅ Functional |
| [`dev_ilir_inductive_degen`](docs/doc_dev_ilir_inductive_degen.html) | 2.4 GHz baseline | -35.28 dB | 22.81 dB | -39.23 dB | 2.35 dB | 17.49 mA | ✅ Functional |
| [`dev_ilir_inductive_degen_gnssl1`](docs/doc_dev_ilir_inductive_degen_gnssl1.html) | GNSS L1 | -14.97 dB | 29.49 dB | -32.97 dB | 1.28 dB | 17.55 mA | ✅ Functional |
| [`dev_ilir_inductive_degen_gnssl2`](docs/doc_dev_ilir_inductive_degen_gnssl2.html) | GNSS L2 | -8.14 dB | 26.71 dB | -30.94 dB | 1.40 dB | 17.55 mA | ✅ Functional |
| [`dev_ilir_inductive_degen_loraeu433`](docs/doc_dev_ilir_inductive_degen_loraeu433.html) | LoRa EU433 | -0.41 dB | -7.42 dB | -0.23 dB | 9.72 dB | 17.56 mA | ❌ Structural failure |
| [`dev_ilir_inductive_degen_loraeu868`](docs/doc_dev_ilir_inductive_degen_loraeu868.html) | LoRa EU868 | -20.24 dB | 23.24 dB | -16.74 dB | 1.75 dB | 17.53 mA | ✅ Functional |
| [`dev_ilir_loraeu868`](docs/doc_dev_ilir_loraeu868.html) | LoRa EU868 | -5.21 dB | 2.93 dB | -13.34 dB | 7.38 dB | 22.18 mA | ⚠️ Marginal |

## pre-PEX main

| Variant | Band | S11 | S21 | S22 | NF | Icc | Status |
|---|---|---|---|---|---|---|---|
| [`main_gnssl1`](docs/doc_main_gnssl1.html) | GNSS L1 | -19.54 dB | 8.02 dB | -16.97 dB | 4.41 dB | 15.13 mA | ✅ Functional |
| [`main_gnssl2`](docs/doc_main_gnssl2.html) | GNSS L2 | -10.80 dB | 6.17 dB | -9.55 dB | 5.42 dB | 15.13 mA | ⚠️ Marginal |
| [`main_loraeu433`](docs/doc_main_loraeu433.html) | LoRa EU433 | -21.61 dB | 12.49 dB | -25.25 dB | 2.25 dB | 22.73 mA | ✅ Functional |
| [`main_loraeu868`](docs/doc_main_loraeu868.html) | LoRa EU868 | -24.13 dB | 15.12 dB | -38.21 dB | 2.19 dB | 22.73 mA | ✅ Functional |
| [`main_lowtailnoise_gnssl1`](docs/doc_main_lowtailnoise_gnssl1.html) | GNSS L1 | -14.18 dB | 17.22 dB | -12.11 dB | 1.33 dB | 22.10 mA | ✅ Functional |
| [`main_lowtailnoise_gnssl2`](docs/doc_main_lowtailnoise_gnssl2.html) | GNSS L2 | -12.94 dB | 17.04 dB | -12.40 dB | 1.36 dB | 22.10 mA | ✅ Functional |
| [`main_lowtailnoise_loraeu433`](docs/doc_main_lowtailnoise_loraeu433.html) | LoRa EU433 | -5.00 dB | -0.53 dB | -3.34 dB | 4.66 dB | 22.10 mA | ❌ Structural failure |
| [`main_lowtailnoise_loraeu868`](docs/doc_main_lowtailnoise_loraeu868.html) | LoRa EU868 | -11.45 dB | 15.03 dB | -8.40 dB | 1.58 dB | 22.10 mA | ✅ Functional |

## Legacy comparison report

`docs/legacy_comparison/lna_configurability_comparison.html` is the most complete
version of a cross-variant comparison report authored earlier in the project (from the
now-deleted `docs-new-ghaith-ilir-variants` branch), comparing dev_ghaith/dev_ilir/main
variants against each other. Kept here for reference since it predates and does not
describe any of the currently-active designs.
