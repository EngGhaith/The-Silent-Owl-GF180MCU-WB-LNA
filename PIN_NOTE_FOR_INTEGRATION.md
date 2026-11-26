# Note for integration (Mitch Bailey): please keep pin names and pin structure

Project: A38 The Silent Owl, GF180MCU Wide-Band LNA
Layout: `klayout/lna_core_parts_filled.gds`, top cell `lna_core_parts` (1110 x 1110 um)
LVS: `lvs_config.json` (Magic + Netgen `run_full_lvs`): circuits match uniquely, 28 devices / 22 nets

## Request

Please keep the **pin names exactly as they are** and keep the **order and arrangement of the pins along
the edges**. The arrangement is intentional:

- RF input, RF output and the five de-embedding structures sit in **GSG groups**
  (ground - signal - ground, about 100 um pitch) for RF probing and for symmetric pad connection.
- The ground pins between the signals are part of these GSG groups. Please do not merge, drop or
  reorder them.
- Please do not rename nets (for example `vss` to `VSS` or `gnd`). The net names in the layout
  (`vss`, `vdd`, ...) have to match the schematic netlist `xschem/lna_core_parts_lvs.spice`.
- The pad names in `info.yaml` name the individual pads of these nets: `vss_l_1..6`, `vss_t_1..3`
  are the 9 pads of net `vss`, `vdd_t_1..3` the 3 pads of net `vdd`. All other pads have the same
  name as their net (see the tables below).

## Pin arrangement (label positions in the top cell, um)

West edge, bottom to top (x about 4-12):

| y | net (layout label) | info.yaml pad | role |
|---:|---|---|---|
| 23 | vss | `vss_l_1` | G |
| 130 | deemb_2r | `deemb_2r` | S (de-embedding, load 2R) |
| 223 | vss | `vss_l_2` | G |
| 330 | deemb_r | `deemb_r` | S (de-embedding, load R) |
| 423 | vss | `vss_l_3` | G |
| 530 | deemb_0p5r | `deemb_0p5r` | S (de-embedding, load 0.5R) |
| 623 | vss | `vss_l_4` | G |
| 730 | **rf_in_pad** | `rf_in_pad` | S (RF input) |
| 823 | vss | `vss_l_5` | G |
| 930 | deemb_s | `deemb_s` | S (de-embedding, short) |
| 1023 | vss | `vss_l_6` | G |

North edge, left to right (y about 1095-1107):

| x | net (layout label) | info.yaml pad | role |
|---:|---|---|---|
| 62 | vbias_cg | `vbias_cg` | bias |
| 180 | vdd | `vdd_t_1` | supply |
| 272 | vbias_cs | `vbias_cs` | bias |
| 379 | vdd | `vdd_t_2` | supply |
| 477 | vbias_cas | `vbias_cas` | bias |
| 578 | vss | `vss_t_1` | G |
| 678 | **rf_out_pad** | `rf_out_pad` | S (RF output) |
| 778 | vss | `vss_t_2` | G (shared by rf_out_pad and deemb_o) |
| 880 | deemb_o | `deemb_o` | S (de-embedding, open) |
| 978 | vss | `vss_t_3` | G |
| 1079 | vdd | `vdd_t_3` | supply |

South and east edges carry only `vdd` and `vss` supply connections (corners, x = 575, y = 535); they are
not pad positions and have no `info.yaml` entry.

## Pad types (`info.yaml`)

| pin | io_type |
|---|---|
| vss_l_1..6, vss_t_1..3 (net vss) | ground (DVSS) |
| vdd_t_1..3 (net vdd) | power (DVDD) |
| rf_in_pad, rf_out_pad | analog (ASIG5V) |
| vbias_cg, vbias_cs, vbias_cas | analog |
| deemb_o, deemb_s, deemb_r, deemb_2r, deemb_0p5r | analog: each de-embedding structure has its own pad |

## Notes

- `open_dummy_lvs` is an LVS-only label on the open end of the open de-embedding structure
  (Metal1, near x = 880, y = 1088). It must **not** get a pad, otherwise the open structure is no
  longer open. That is why it is not in `info.yaml`.
- `vss` is one net, but it has 9 ground pads (the G of each GSG group: 6 west, 3 north). `vdd` has
  3 pads on the north edge. In `info.yaml` they are listed as `vss_l_1..6` (west edge, bottom to
  top), `vss_t_1..3` and `vdd_t_1..3` (north edge, left to right). In the layout and in the LVS
  netlist all of them are still labelled `vss` / `vdd`. Please tell us whether the pad names in
  `info.yaml` have to match the layout labels, or how multiple pads of one net should be declared.
- Many DVSS cells sit between the ASIG5V pads. Please let us know if that is a problem for the
  padring rails ("subsequent power/ground cells cause a break in the I/O power rails").

Thank you!
