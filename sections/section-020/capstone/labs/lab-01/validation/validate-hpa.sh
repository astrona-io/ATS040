#!/usr/bin/env bash
# Check: the autoscaler.
set -uo pipefail

hpa="$(kubectl -n orbit get hpa.v2.autoscaling -o json 2>/dev/null | jq -c '[.items[] | select(.spec.scaleTargetRef.kind == "Deployment" and .spec.scaleTargetRef.name == "beacon")][0] // empty' 2>/dev/null || true)"
if [ -z "$hpa" ]; then echo "FAIL: no HorizontalPodAutoscaler targets Deployment beacon in orbit"; exit 1; fi
[ "$(echo "$hpa" | jq -r '.spec.minReplicas')" = "3" ] || { echo "FAIL: minReplicas is not 3"; exit 1; }
[ "$(echo "$hpa" | jq -r '.spec.maxReplicas')" = "6" ] || { echo "FAIL: maxReplicas is not 6"; exit 1; }
target="$(echo "$hpa" | jq -r '[.spec.metrics[] | select(.type == "Resource" and .resource.name == "cpu")][0].resource.target.averageUtilization // empty')"
if [ "$target" != "70" ]; then echo "FAIL: CPU utilization target is '${target}', expected 70"; exit 1; fi
echo "PASS: the autoscaler scales beacon between 3 and 6 on 70 percent CPU"

