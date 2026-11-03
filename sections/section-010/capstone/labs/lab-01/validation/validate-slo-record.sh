#!/usr/bin/env bash
# Check: the recorded objective.
set -uo pipefail

if ! kubectl -n orbit get configmap beacon-slo >/dev/null 2>&1; then echo "FAIL: ConfigMap beacon-slo does not exist in orbit"; exit 1; fi
get() { kubectl -n orbit get configmap beacon-slo -o jsonpath="{.data.$1}" 2>/dev/null || true; }
[ "$(get objective)" = "99.5" ] || { echo "FAIL: objective is not 99.5"; exit 1; }
[ "$(get allowed-error-ratio)" = "0.005" ] || { echo "FAIL: allowed-error-ratio is not 0.005"; exit 1; }
[ "$(get error-budget-minutes-30d)" = "216" ] || { echo "FAIL: error-budget-minutes-30d is not 216"; exit 1; }
echo "PASS: beacon-slo records the objective, the ratio and the budget"

