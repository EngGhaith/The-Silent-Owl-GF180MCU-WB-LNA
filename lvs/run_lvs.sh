#!/usr/bin/env bash
# LVS of lna_core_parts (klayout/lna_top2.gds) with the same flow the Chipathon integration uses:
# Magic extraction + Netgen via run_full_lvs from d-m-bailey/extra_be_checks (copy in lvs/extra_be_checks),
# configured by lvs_config.json in the repo root. See lvs/README.md.
#
# usage:  lvs/run_lvs.sh            regenerate xschem/lna_core_parts_lvs.spice from the schematic, then LVS
#         lvs/run_lvs.sh --nonet    LVS only, use the committed xschem/lna_core_parts_lvs.spice as is
#         lvs/run_lvs.sh --noextract  re-run netgen only on the previous extraction (fast)
#
# result: lvs/work/lna_core_parts/lvs.report (netgen report), lvs/work/run.log; prints RESULT: PASS / FAIL
# runtime: ~25 min (most of it is the Magic extraction of the coils)
set -u
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export UPRJ_ROOT="$ROOT"
export LVS_ROOT="$ROOT/lvs/extra_be_checks"
export PDK_ROOT="${PDK_ROOT:-/foss/pdks}"
export PDK=gf180mcuD
WORK="$ROOT/lvs/work"
mkdir -p "$WORK"

NETLIST=yes; EXTRACT=""
for a in "$@"; do
    case "$a" in
        --nonet) NETLIST=no ;;
        --noextract) NETLIST=no; EXTRACT="--noextract" ;;
        *) echo "unknown option $a"; exit 2 ;;
    esac
done

if [ $NETLIST = yes ]; then
    echo "netlisting xschem/lna_core_parts.sch ..."
    (cd "$ROOT/xschem" && xschem -q -x -n -s -o "$WORK" --netlist_filename lna_core_parts_xschem.spice lna_core_parts.sch \
        >/dev/null 2>&1) || { echo "xschem netlisting failed"; exit 2; }
    python3 "$ROOT/lvs/make_lvs_netlist.py" "$WORK/lna_core_parts_xschem.spice" "$ROOT/xschem/lna_core_parts_lvs.spice" || exit 2
fi

cd "$WORK" || exit 2
echo "running run_full_lvs (log: $WORK/run.log) ..."
"$LVS_ROOT/run_full_lvs" $EXTRACT "$ROOT/lvs_config.json" > run.log 2>&1
grep -E "^Final result|Number of devices|Number of nets" lna_core_parts/lvs.report | tail -3
if grep -q "^Final result: Circuits match uniquely\.$" lna_core_parts/lvs.report && ! grep -q "Error: LVS mismatch" run.log; then
    echo "RESULT: PASS"
else
    echo "RESULT: FAIL  (details: $WORK/lna_core_parts/lvs.report)"
    exit 1
fi
