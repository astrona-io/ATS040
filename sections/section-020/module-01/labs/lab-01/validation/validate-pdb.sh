#!/usr/bin/env bash
# Check: a PodDisruptionBudget keeps two pods.
set -uo pipefail

found="$(kubectl -n starfleet get pdb -o json 2>/dev/null | jq -r '[.items[] | select(.spec.minAvailable==2) | select(.spec.selector.matchLabels.app=="scout")] | length')"
if [ "${found:-0}" -lt 1 ]; then echo "FAIL: no PodDisruptionBudget with minAvailable 2 and selector app=scout"; exit 1; fi
echo "PASS: PodDisruptionBudget found"

