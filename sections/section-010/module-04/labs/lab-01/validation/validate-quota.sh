#!/usr/bin/env bash
# Check: ResourceQuota compute-budget allows 2 CPU and 2Gi memory of requests, 4Gi of memory limits and 10 pods
set -uo pipefail

q() { kubectl -n starfleet get resourcequota compute-budget -o jsonpath="{.spec.hard.$1}" 2>/dev/null; }
[ "$(q 'requests\.cpu')" = "2" ] || { echo "FAIL: requests.cpu is not 2"; exit 1; }
[ "$(q 'requests\.memory')" = "2Gi" ] || { echo "FAIL: requests.memory is not 2Gi"; exit 1; }
[ "$(q 'limits\.memory')" = "4Gi" ] || { echo "FAIL: limits.memory is not 4Gi"; exit 1; }
[ "$(q pods)" = "10" ] || { echo "FAIL: pods is not 10"; exit 1; }
echo "PASS: ResourceQuota compute-budget is correct"
