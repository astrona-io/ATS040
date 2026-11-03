#!/usr/bin/env bash
# Check: migrated PodDisruptionBudget.
set -uo pipefail

json="$(kubectl get --raw /apis/policy/v1/namespaces/starfleet/poddisruptionbudgets/scout-pdb 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: PodDisruptionBudget scout-pdb is not served at policy/v1 in starfleet"; exit 1; fi
field() { printf '%s' "$json" | jq -r "$1"; }
[ "$(field .spec.minAvailable)" = "1" ] || { echo "FAIL: minAvailable is not 1"; exit 1; }
[ "$(field .spec.selector.matchLabels.app)" = "scout" ] || { echo "FAIL: the selector does not match app=scout"; exit 1; }
echo "PASS: PodDisruptionBudget scout-pdb is served at policy/v1"

