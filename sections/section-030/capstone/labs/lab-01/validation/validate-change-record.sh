#!/usr/bin/env bash
# Check: the change record.
set -uo pipefail

if ! kubectl -n orbit get configmap change-record >/dev/null 2>&1; then echo "FAIL: ConfigMap change-record does not exist in orbit"; exit 1; fi
get() { kubectl -n orbit get configmap change-record -o jsonpath="{.data.$1}" 2>/dev/null || true; }
[ "$(get replaced-api)" = "batch/v1beta1" ] || { echo "FAIL: replaced-api is not batch/v1beta1"; exit 1; }
[ "$(get replacement-api)" = "batch/v1" ] || { echo "FAIL: replacement-api is not batch/v1"; exit 1; }
[ "$(get replaced-maturity)" = "beta" ] || { echo "FAIL: replaced-maturity is not beta"; exit 1; }
[ "$(get beta-support-months)" = "9" ] || { echo "FAIL: beta-support-months is not 9"; exit 1; }
[ "$(get beta-support-releases)" = "3" ] || { echo "FAIL: beta-support-releases is not 3"; exit 1; }
echo "PASS: change-record is complete"

