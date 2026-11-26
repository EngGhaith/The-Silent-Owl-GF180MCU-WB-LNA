# The-Silent-Owl-GF180MCU-WB-LNA
The Silent Owl is an open-source LNA designed in GF180MCU for Chipathon 2026

Branch: `main_Chipalooza` — the Chipalooza variant of the layout.


# Sign-off files

| | path | notes |
|---|---|---|
| **Sign-off GDS (filled)** | [`klayout/lna_core_parts_filled.gds`](klayout/lna_core_parts_filled.gds) | top cell `lna_core_parts`, 1109 × 1080 µm. COMP + poly2 dummy fill, **no metal fill**. This is the file to hand to integration. |
| GDS (unfilled) | [`klayout/lna_core_parts.gds`](klayout/lna_core_parts.gds) | same layout without the dummy fill |
| **Sign-off schematic (LVS top)** | [`xschem/lna_core_parts.sch`](xschem/lna_core_parts.sch) | top cell `lna_core_parts`; hierarchy: `lna_core_input_match`, `lna_core_cg`, `lna_core_cs`, `lna_core_output_match` |
| LVS reference netlist | [`xschem/lna_core_parts_lvs.spice`](xschem/lna_core_parts_lvs.spice) | generated from the schematic above by `lvs/make_lvs_netlist.py` (called by `lvs/run_lvs.sh`); regenerate it after any schematic change |
| LVS configuration | [`lvs_config.json`](lvs_config.json) | `TOP_SOURCE`/`TOP_LAYOUT` = `lna_core_parts`, `LAYOUT_FILE` = the filled GDS, `LVS_SPICE_FILES` = the netlist above — same convention as the Chipathon branch |

What the layout carries, beyond the Chipathon branch:

* bias resistors R1/R2 are `ppolyf_u_1k_6p0` (6 V), marked with DUALGATE inside `lna_core_cg__R3`/`R4`
* the substrate tie is **Fix A**: one existing p-tap (COMP + pplus + 64 contacts + M1) duplicated into the
  `lna_core_parts` cell itself at the same coordinates, so Magic exports the substrate node as `vss`
  instead of an unnamed `VSUBS`. It is pure geometry duplication — no device, and the schematic needs no
  counterpart. Rendered by `lvs/render_fix.py A`.
* coils enter LVS as PDK metal resistors through the `lvsrm` sections of `xschem/*_model.lib`

Verification status of both GDS variants:

| | KLayout DRC | Magic DRC | LVS |
|---|---|---|---|
| `klayout/lna_core_parts_filled.gds` | 0 violations | 0 violations | match uniquely — 21 devices / 13 nets |
| `klayout/lna_core_parts.gds` | 0 violations | 0 violations | match uniquely — 21 devices / 13 nets |

Both GDS files are written **without KLayout PCell/library context information** (`Store PCell and library
context information` off, i.e. `SaveLayoutOptions.write_context_info = False`). Every cell is a static cell,
so reopening the file with the PDK libraries loaded can no longer regenerate the pcells and silently revert
the layout fixes that `lvs/repair_pcell_regression.py` exists to restore (RES_MK on the coil markers, the
stray rm1 marker, the MIMTM.2 via4 trim). The consequence is that those cells have no pcell parameter
dialog any more — edit a pre-freeze copy if a pcell parameter has to change.


# Papers about LNA

| Title | Technology | Architecture | Gain | NF | BW | IIP3 | Power | Supply | Area | Reference | Notes | S11 | S22 |
|---|---|---|---:|---:|---:|---:|---:|---:|---:|---|---|---|---|
| An Ultra-Wide-Band 0.4–10-GHz LNA in 0.18 µm CMOS | 180 nm CMOS | 3 stages: CG with degeneration + cascoded CS + buffer | 12.4 dB | 4.4–6.5 dB | 0.4–10 GHz | −6.0 dBm | 12.00 mW | 1.8 V | 0.42 mm² | [IEEE](https://ieeexplore.ieee.org/document/4132952) | Inductive degeneration cancels the parasitics in M1. The input impedance is approximately 1/gm and becomes less dependent on parasitics, supporting wideband input matching. | S11 > −10 dB from 0–2 GHz; S11 < −10 dB above 2 GHz. | S22 < −10 dB over the full band. |
| A 180 nm CMOS dual-mode LNA with current reuse and double-resonance load for 2.4 GHz and 3.1–10.6 GHz wireless communication | 180 nm CMOS | Single-stage inductively degenerated CS | 17.9 dB | 3.8 dB | 2.4 GHz narrowband | −18.3 dBm | 25.41 mW | 1.8 V | 0.71 mm² | [ResearchGate](https://www.researchgate.net/publication/390026477_A_180_nm_CMOS_dual-mode_LNA_with_current_reuse_and_double-resonance_load_for_24_GHz_and_31-106_GHz_wireless_communication) | The narrowband LNA employs a single-stage inductively degenerated CS configuration with current reuse. | S11: −16.8 to −15.8 dB. | S22: −15.9 to −14.9 dB. |
| A 180 nm CMOS dual-mode LNA with current reuse and double-resonance load for 2.4 GHz and 3.1–10.6 GHz wireless communication | 180 nm CMOS | Two-stage architecture: CG + CS | 17.5 dB | 5.9 dB | 3.1–10.6 GHz UWB | −14.9 dBm | 14.79 mW | 1.8 V | 0.71 mm² | [ResearchGate](https://www.researchgate.net/publication/390026477_A_180_nm_CMOS_dual-mode_LNA_with_current_reuse_and_double-resonance_load_for_24_GHz_and_31-106_GHz_wireless_communication) | The UWB LNA uses a two-stage architecture with a double-resonance load network and resistive shunt feedback to ensure wide bandwidth and flat gain. | S11: −19 to −14 dB. | S22: −14 to −11 dB. |
| An Ultra-Wideband Resistive-Feedback LNA with Noise Cancellation in 0.18 µm Digital CMOS | 180 nm CMOS | 1st stage resistive-feedback LNA + 2nd stage M3 source follower + M4 CS | 12.5 dB | 3.5–4.2 dB | 0.7–6.5 GHz | −5.0 dBm @ 5 GHz | 11.10 mW | 1.8 V | 0.78 mm × 0.68 mm = 0.53 mm² | [IEEE](https://ieeexplore.ieee.org/document/4446295?arnumber=4446295) | M4 is connected to M1 for noise cancellation. | S11 < −11 dB. | S22 mostly < −10 dB, but degrades near the band edges. |
| Design and analysis of a UWB LNA in the 0.18 µm CMOS process | 180 nm CMOS | CG + cascoded CS + buffer | 12.4–14.5 dB | 4.2–5.4 dB | 3.1–10.6 GHz | −7.2 dBm @ 6 GHz | 9.00 mW | 1.8 V | 0.88 mm² | [IEEE](https://ieeexplore.ieee.org/document/1606978) | A 2nd-order Chebyshev filter is chosen for input matching. LG2 and Cg couple the output of the first stage to the second stage. | S11 < −9.4 dB. | S22 < −12 dB. |
| An Inductor-less LNA for high gain and low noise figure dedicated for future wireless application | 180 nm CMOS | CG + CS | 18.1 dB | 1.01 dB | 3.0–13.0 GHz | −9.3 dBm | 3.5 mW | 1.8 V | — | [IEEE](https://ieeexplore.ieee.org/document/10931979/) | CS and CG stages are used with noise cancellation. | S11 < −15 dB. | S22 < −5 dB overall; S22 < −10 dB from 4.5–12.5 GHz. |

# Papers about ESD

| Title | Reference | Notes |
|---|---|---|
| Design and theoretical comparison of input ESD devices in 180 nm CMOS with focus on low capacitance | [ResearchGate](https://www.researchgate.net/publication/322363855_Design_and_theoretical_comparison_of_input_ESD_devices_in_180_nm_CMOS_with_focus_on_low_capacitance) |
| Design of an ESD Protected Ultra-Wideband LNA in Nanoscale CMOS for Full Band Mobile TV Tuners | [IEEE](https://ieeexplore.ieee.org/document/4783014) |
| ESD Protection circuits for advanced CMOS Technologies | [IEEE](https://ieeexplore.ieee.org/document/11408826) |
| Low Capacitance SCR with Waffle Layout Structure for On-Chip ESD Protection in RFICs | [IEEE](https://ieeexplore.ieee.org/document/4266539) |
