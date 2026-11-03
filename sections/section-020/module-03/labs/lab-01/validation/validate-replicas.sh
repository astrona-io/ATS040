#!/usr/bin/env bash
# Check: replicas follow minReplicas. Waits up to 150 seconds.
set -uo pipefail

for attempt in $(seq 1 30); do
  ready="$(kubectl -n starfleet get deploy scout -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
  if [ "${ready:-0}" -ge 2 ]; then echo "PASS: scout has ${ready} ready replicas"; exit 0; fi
  sleep 5
done
echo "FAIL: scout has '${ready:-0}' ready replicas, expected at least 2"
exit 1

