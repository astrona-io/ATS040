#!/usr/bin/env bash
# Check: the HPA computes its metric. Waits up to 150 seconds.
set -uo pipefail

for attempt in $(seq 1 30); do
  status="$(kubectl -n starfleet get hpa.v2.autoscaling scout -o jsonpath='{.status.conditions[?(@.type=="ScalingActive")].status}' 2>/dev/null || true)"
  if [ "$status" = "True" ]; then echo "PASS: ScalingActive is True"; exit 0; fi
  sleep 5
done
reason="$(kubectl -n starfleet get hpa.v2.autoscaling scout -o jsonpath='{.status.conditions[?(@.type=="ScalingActive")].reason}' 2>/dev/null || true)"
echo "FAIL: ScalingActive is '${status}' (reason: ${reason:-none}). Check requests and Metrics Server."
exit 1

