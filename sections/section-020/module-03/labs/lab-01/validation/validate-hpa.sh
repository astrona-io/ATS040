#!/usr/bin/env bash
# Check: HPA spec.
set -uo pipefail

json="$(kubectl -n starfleet get hpa.v2.autoscaling scout -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: HPA scout does not exist in starfleet"; exit 1; fi
field() { printf '%s' "$json" | jq -r "$1"; }
[ "$(field .spec.scaleTargetRef.kind)" = "Deployment" ] || { echo "FAIL: target kind is not Deployment"; exit 1; }
[ "$(field .spec.scaleTargetRef.name)" = "scout" ] || { echo "FAIL: target name is not scout"; exit 1; }
[ "$(field .spec.minReplicas)" = "2" ] || { echo "FAIL: minReplicas is not 2"; exit 1; }
[ "$(field .spec.maxReplicas)" = "5" ] || { echo "FAIL: maxReplicas is not 5"; exit 1; }
[ "$(field '.spec.metrics[] | select(.type=="Resource" and .resource.name=="cpu") | .resource.target.averageUtilization')" = "60" ] || { echo "FAIL: no cpu Utilization target of 60 percent"; exit 1; }
echo "PASS: HPA scout targets 60 percent CPU between 2 and 5 replicas"

