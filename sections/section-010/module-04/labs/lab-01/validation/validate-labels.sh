#!/usr/bin/env bash
# Check: Namespace starfleet has labels team=bridge and cost-center=exploration
set -uo pipefail

[ "$(kubectl get namespace starfleet -o jsonpath='{.metadata.labels.team}' 2>/dev/null)" = "bridge" ] || { echo "FAIL: label team is not bridge"; exit 1; }
[ "$(kubectl get namespace starfleet -o jsonpath='{.metadata.labels.cost-center}' 2>/dev/null)" = "exploration" ] || { echo "FAIL: label cost-center is not exploration"; exit 1; }
echo "PASS: namespace labels are set"
