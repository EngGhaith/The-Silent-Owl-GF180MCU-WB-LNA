#!/usr/bin/env bash
# DRC + LVS of the LNA core layout (klayout/lna_top2.gds, top cell lna_core_parts) in one go.
#
# Usage (from anywhere, inside the IIC-OSIC-TOOLS / Chipathon container):
#   klayout/run_lna_core_parts_checks.sh            # DRC + LVS
#   klayout/run_lna_core_parts_checks.sh --no-drc   # LVS only (faster)
#   klayout/run_lna_core_parts_checks.sh --stock    # LVS with the unpatched PDK deck instead (reports in
#                                                   #   klayout/reports/lna_core_parts_stock/); expected: only the
#                                                   #   5 tm11k coil stand-ins + their nets mismatch
#
# Results:
#   klayout/reports/lna_core_parts/summary.txt           -- one-line verdict per check + run log
#   klayout/reports/lna_core_parts/drc_lna_core_parts/   -- DRC report (*.lyrdb, open in KLayout: Tools > Marker Browser)
#   klayout/reports/lna_core_parts/lvs_lna_core_parts/   -- LVS report (lna_core_parts.lvsdb, open in KLayout:
#                                                           Tools > Netlist Browser), extracted + reference netlists
#   klayout/lvs/lna_core_parts_lvs.{gds,spice}           -- layout copy as checked + reference netlist
#
# Uses the patched LVS deck in klayout/lvs_deck_gf180mcuD (see README_PATCH.md there: the official deck leaves
# every tm11k terminal floating). Expected result: "DRC clean" and "LVS match". Exit code 0 only if both pass.
set -u
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$HERE/reports/lna_core_parts"
ARGS=()
DECK="patched (klayout/lvs_deck_gf180mcuD)"
for a in "$@"; do
    if [ "$a" = "--stock" ]; then
        export LVS_DECK="${PDK_ROOT:-/foss/pdks}/gf180mcuD/libs.tech/klayout/tech/lvs/gf180mcu.lvs"
        DECK="stock ($LVS_DECK)"
        OUT="$HERE/reports/lna_core_parts_stock"
    else
        ARGS+=("$a")
    fi
done
mkdir -p "$OUT"
cd "$HERE" || exit 2

echo "layout:  $HERE/lna_top2.gds (git $(git -C "$HERE" rev-parse --short HEAD 2>/dev/null || echo '?'))"
echo "LVS deck: $DECK"
echo "reports: $OUT"
echo

python3 check_lna_core_layouts.py parts --run_dir "$OUT" ${ARGS[@]+"${ARGS[@]}"} 2>&1 | tee "$OUT/summary.txt"

echo
if grep -q "DRC VIOLATIONS\|LVS MISMATCH\|Traceback" "$OUT/summary.txt"; then
    echo "RESULT: FAIL  (details: $OUT/summary.txt)"
    exit 1
fi
echo "RESULT: PASS"
