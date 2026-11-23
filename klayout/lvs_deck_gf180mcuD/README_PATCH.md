# Locally patched gf180mcuD KLayout LVS deck

Copy of `/foss/pdks/gf180mcuD/libs.tech/klayout/tech/lvs` (IIC-OSIC-TOOLS 2026.04), used by
`klayout/check_lna_core_layouts.py`.

The only change is in `rule_decks/general_connections.lvs`, between the `LOCAL PATCH` markers.

**Why the patch is needed.** The top-metal resistor devices (`tm11k`) take their terminals from the layer `top_metal_con`. That layer is only connected to `top_via`. All other Metal5 shapes are on `metal5_con`, which is connected through `via4_n_cap`. Nothing connects the two layers, so in the official deck every `tm11k` terminal is a floating net, even when real vias land on it. The patch connects `top_metal_con` to `metal5_con`. Both are the same drawn metal.

**Also note:** at 5 metal levels the deck has no `rm4` device. A `metal4_res` marker (110/14) only cuts Metal4. So use `rm2`, `rm3` or `tm11k` for coil stand-ins, not `rm4`.
