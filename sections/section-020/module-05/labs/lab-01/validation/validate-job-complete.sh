#!/usr/bin/env bash
# Check: Job beacon is complete
set -uo pipefail

for attempt in $(seq 1 24); do
  ok="$(kubectl -n starfleet get job beacon -o jsonpath='{.status.succeeded}' 2>/dev/null || true)"
  if [ "$ok" = "1" ]; then echo "PASS: Job beacon succeeded"; exit 0; fi
  sleep 5
done
echo "FAIL: Job beacon has not succeeded"; exit 1
