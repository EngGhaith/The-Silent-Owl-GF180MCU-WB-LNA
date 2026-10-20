#!/bin/bash
# Switch every swept inductor (LEQ/LSHUNT_OUT/L1/LD2/LD4, whichever of these a
# given lna-core_tb.sch actually selects) to one of the three model variants
# encoded in the *_model.lib files living alongside this script's testbench:
#   ideal  - single ideal inductor (L only)
#   rl     - EM-derived series L + equivalent series R
#   snp2le - snp2le broadband vector-fitted macromodel (passive, DC-pinned,
#            thermal-noise-synthesized), same EM data as "rl"
#
# Usage (run from the xschem/ directory containing lna-core_tb.sch):
#   ./set_inductor_model.sh ideal
#   ./set_inductor_model.sh rl
#   ./set_inductor_model.sh snp2le
set -euo pipefail

MODEL="${1:-}"
case "$MODEL" in
  ideal|rl|snp2le) ;;
  *)
    echo "usage: $0 {ideal|rl|snp2le}" >&2
    exit 1
    ;;
esac

TB="lna-core_tb.sch"
if [ ! -f "$TB" ]; then
  echo "error: $TB not found in $(pwd) -- run this from the xschem/ directory" >&2
  exit 1
fi

sed -i -E 's/(\.lib \$::env\(PWD\)\/[A-Za-z0-9_]+_model\.lib )[a-z0-9]+/\1'"$MODEL"'/' "$TB"

echo "Inductor model config set to: $MODEL"
grep -n '_model\.lib' "$TB"
