#!/usr/bin/env bash
# Check: the stored Sensor.
set -uo pipefail

json="$(kubectl -n starfleet get sensors.fleet.example.com scout-sensor -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: Sensor scout-sensor does not exist in starfleet"; exit 1; fi
t="$(printf '%s' "$json" | jq -r '.spec.target')"; i="$(printf '%s' "$json" | jq -r '.spec.intervalSeconds')"
[ "$t" = "scout" ] || { echo "FAIL: target is '${t}', expected scout"; exit 1; }
[ "$i" = "30" ] || { echo "FAIL: intervalSeconds is '${i}', expected 30 (the default)"; exit 1; }
echo "PASS: Sensor scout-sensor targets scout with interval 30"

