#!/usr/bin/env bash
# Check: HPA behavior.
set -uo pipefail

json="$(kubectl -n starfleet get hpa.v2.autoscaling scout -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: HPA scout does not exist in starfleet"; exit 1; fi
field() { printf '%s' "$json" | jq -r "$1"; }
[ "$(field .spec.behavior.scaleDown.stabilizationWindowSeconds)" = "120" ] || { echo "FAIL: scaleDown stabilizationWindowSeconds is not 120"; exit 1; }
[ "$(field '.spec.behavior.scaleUp.policies[]? | select(.type=="Pods") | .value')" = "2" ] || { echo "FAIL: no scaleUp Pods policy with value 2"; exit 1; }
[ "$(field '.spec.behavior.scaleUp.policies[]? | select(.type=="Pods") | .periodSeconds')" = "30" ] || { echo "FAIL: the scaleUp Pods policy period is not 30 seconds"; exit 1; }
echo "PASS: scale-down window 120 seconds, scale-up 2 pods per 30 seconds"

