#!/usr/bin/env bash
# Check: the disruption budget.
set -uo pipefail

pdb="$(kubectl -n orbit get pdb -o json 2>/dev/null | jq -c '[.items[] | select(.spec.selector.matchLabels.app == "beacon")][0] // empty' 2>/dev/null || true)"
if [ -z "$pdb" ]; then echo "FAIL: no PodDisruptionBudget selects app=beacon in orbit"; exit 1; fi
min="$(echo "$pdb" | jq -r '.spec.minAvailable // empty')"
max="$(echo "$pdb" | jq -r '.spec.maxUnavailable // empty')"
if [ "$min" != "2" ] && [ "$max" != "1" ]; then echo "FAIL: budget must keep 2 pods available (minAvailable 2 or maxUnavailable 1)"; exit 1; fi
expected="$(echo "$pdb" | jq -r '.status.expectedPods // 0')"
if [ "$expected" -lt 3 ]; then echo "FAIL: the budget matches ${expected} pods, expected at least 3"; exit 1; fi
echo "PASS: the budget keeps 2 beacon pods available"

