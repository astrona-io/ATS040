#!/usr/bin/env bash
# Check: The claim is Bound and the pod is Running
set -uo pipefail

for attempt in $(seq 1 36); do
  phase="$(kubectl -n starfleet get pvc logbook -o jsonpath='{.status.phase}' 2>/dev/null || true)"
  pod="$(kubectl -n starfleet get pod recorder -o jsonpath='{.status.phase}' 2>/dev/null || true)"
  if [ "$phase" = "Bound" ] && [ "$pod" = "Running" ]; then echo "PASS: claim is Bound and pod is Running"; exit 0; fi
  sleep 5
done
echo "FAIL: claim is '${phase:-none}' and pod is '${pod:-none}'"; exit 1
