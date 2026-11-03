#!/usr/bin/env bash
# Check: LimitRange container-defaults sets a default request of 50m CPU and 64Mi memory and a default memory limit of 128Mi
set -uo pipefail

j="$(kubectl -n starfleet get limitrange container-defaults -o json 2>/dev/null || true)"
[ -n "$j" ] || { echo "FAIL: LimitRange container-defaults does not exist"; exit 1; }
f() { echo "$j" | jq -r "$1"; }
[ "$(f '.spec.limits[] | select(.type=="Container") | .defaultRequest.cpu')" = "50m" ] || { echo "FAIL: default request cpu is not 50m"; exit 1; }
[ "$(f '.spec.limits[] | select(.type=="Container") | .defaultRequest.memory')" = "64Mi" ] || { echo "FAIL: default request memory is not 64Mi"; exit 1; }
[ "$(f '.spec.limits[] | select(.type=="Container") | .default.memory')" = "128Mi" ] || { echo "FAIL: default memory limit is not 128Mi"; exit 1; }
echo "PASS: LimitRange container-defaults is correct"
