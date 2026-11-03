#!/usr/bin/env bash
# Check: Deployment scout is available with its new pod
set -uo pipefail

for attempt in $(seq 1 24); do
  ready="$(kubectl -n starfleet get deployment scout -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
  updated="$(kubectl -n starfleet get deployment scout -o jsonpath='{.status.updatedReplicas}' 2>/dev/null || true)"
  if [ "${ready:-0}" -ge 1 ] && [ "${updated:-0}" -ge 1 ]; then echo "PASS: scout is available"; exit 0; fi
  sleep 5
done
echo "FAIL: scout has no ready updated replica"; exit 1
