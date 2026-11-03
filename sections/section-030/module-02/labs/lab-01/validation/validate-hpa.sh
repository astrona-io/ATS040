#!/usr/bin/env bash
# Check: migrated HPA.
set -uo pipefail

json="$(kubectl get --raw /apis/autoscaling/v2/namespaces/starfleet/horizontalpodautoscalers/scout 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: HPA scout is not served at autoscaling/v2 in starfleet"; exit 1; fi
field() { printf '%s' "$json" | jq -r "$1"; }
[ "$(field .spec.minReplicas)" = "1" ] || { echo "FAIL: minReplicas is not 1"; exit 1; }
[ "$(field .spec.maxReplicas)" = "3" ] || { echo "FAIL: maxReplicas is not 3"; exit 1; }
[ "$(field '.spec.metrics[] | select(.type=="Resource" and .resource.name=="cpu") | .resource.target.averageUtilization')" = "70" ] || { echo "FAIL: no cpu Utilization target of 70 percent"; exit 1; }
[ "$(field .spec.scaleTargetRef.name)" = "scout" ] || { echo "FAIL: the HPA does not target scout"; exit 1; }
echo "PASS: HPA scout is served at autoscaling/v2"

