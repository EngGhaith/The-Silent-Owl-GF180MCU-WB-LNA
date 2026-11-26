#!/usr/bin/env bash
# LVS of the main_Chipalooza lna_core_parts layout against the Chipalooza schematic.
#
# Self-contained in this branch: the toolchain (lvs/extra_be_checks), the helper scripts and
# the config all live here, and UPRJ_ROOT points at this worktree. Nothing is read from or
# written to the main_pex_layout_refloor checkout.
#
# usage:  lvs/run_lvs.sh              netlist the schematic, extract, compare
#         lvs/run_lvs.sh --nonet      reuse xschem/lna_core_parts_lvs.spice as is
#         lvs/run_lvs.sh --noextract  re-run netgen only on the previous extraction (fast)
#         lvs/run_lvs.sh --layout F   extract F instead of the LAYOUT_FILE in lvs_config.json
#
# The sign-off files are the ones lvs_config.json names, same convention as the Chipathon
# branch -- klayout/lna_core_parts_filled.gds and xschem/lna_core_parts_lvs.spice. Earlier
# revisions of this script copied the layout into lvs/work and repaired it there, which meant
# LVS silently tested geometry that the committed GDS did not have (that is how 246 via4 kept
# violating Magic's MIMTM.2 unnoticed). The repairs now live in the GDS itself, and the files
# are written without KLayout PCell context information so they cannot be regenerated:
# run lvs/repair_pcell_regression.py on the source after any KLayout edit, before signing off.
#
# result: lvs/work/lna_core_parts/lvs.report, lvs/work/run.log
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export UPRJ_ROOT="$ROOT"
export LVS_ROOT="$ROOT/lvs/extra_be_checks"
export PDK_ROOT="${PDK_ROOT:-/foss/pdks}"
export PDK=gf180mcuD
WORK="$ROOT/lvs/work"
mkdir -p "$WORK"

NETLIST=yes; EXTRACT=""; GDS=""
while [ $# -gt 0 ]; do
    case "$1" in
        --nonet) NETLIST=no ;;
        --noextract) NETLIST=no; EXTRACT="--noextract" ;;
        --layout) shift; GDS="$1" ;;
        *) echo "unknown option $1"; exit 2 ;;
    esac
    shift
done

if [ $NETLIST = yes ]; then
    echo "netlisting xschem/lna_core_parts.sch ..."
    # xschem exits 10 from this batch invocation even when it netlists fine, so the
    # output file is the success test, not the exit code.
    rm -f "$WORK/lna_core_parts_xschem.spice"
    (cd "$ROOT/xschem" && xschem -q -x -n -s -o "$WORK" \
        --netlist_filename lna_core_parts_xschem.spice lna_core_parts.sch \
        >"$WORK/xschem.log" 2>&1) || true
    [ -s "$WORK/lna_core_parts_xschem.spice" ] || {
        echo "xschem netlisting produced nothing (see $WORK/xschem.log)"; exit 2; }
    python3 "$ROOT/lvs/make_lvs_netlist.py" "$WORK/lna_core_parts_xschem.spice" \
        "$ROOT/xschem/lna_core_parts_lvs.spice" || exit 2
    echo "wrote xschem/lna_core_parts_lvs.spice"
fi

CONFIG="$ROOT/lvs_config.json"
if [ -n "$GDS" ]; then
    # same config, different LAYOUT_FILE -- so the sign-off config is never edited in place
    CONFIG="$WORK/lvs_config_override.json"
    python3 - "$ROOT/lvs_config.json" "$GDS" "$CONFIG" <<'PY' || exit 2
import json, os, sys
cfg = json.load(open(sys.argv[1]))
cfg["LAYOUT_FILE"] = os.path.abspath(sys.argv[2])
json.dump(cfg, open(sys.argv[3], "w"), indent=2)
PY
    echo "layout override: $GDS"
fi

cd "$WORK" || exit 2
echo "running run_full_lvs (log: $WORK/run.log) ..."
"$LVS_ROOT/run_full_lvs" $EXTRACT "$CONFIG" > run.log 2>&1
grep -E "^Final result|Number of devices|Number of nets" lna_core_parts/lvs.report | tail -3
if grep -q "^Final result: Circuits match uniquely\.$" lna_core_parts/lvs.report 2>/dev/null \
   && ! grep -q "Error: LVS mismatch" run.log; then
    echo "RESULT: PASS"
else
    echo "RESULT: FAIL  (details: $WORK/lna_core_parts/lvs.report)"
    exit 1
fi
