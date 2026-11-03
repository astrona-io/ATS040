#!/usr/bin/env bash
# Check: the API server enforces the schema.
set -uo pipefail

try() {
  kubectl -n starfleet create --dry-run=server -f - >/dev/null 2>&1 <<Y
apiVersion: fleet.example.com/v1
kind: Sensor
metadata:
  name: probe-check
$1
Y
}
if try "spec:
  target: scout
  intervalSeconds: 0"; then echo "FAIL: the API server accepted intervalSeconds 0"; exit 1; fi
if try "spec:
  intervalSeconds: 10"; then echo "FAIL: the API server accepted a Sensor without target"; exit 1; fi
if ! try "spec:
  target: scout
  intervalSeconds: 10"; then echo "FAIL: the API server rejected a valid Sensor"; exit 1; fi
echo "PASS: invalid Sensors are rejected and a valid one is accepted"

