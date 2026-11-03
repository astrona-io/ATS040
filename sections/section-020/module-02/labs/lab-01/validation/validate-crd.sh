#!/usr/bin/env bash
# Check: CRD identity and versions.
set -uo pipefail

json="$(kubectl get crd sensors.fleet.example.com -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: CRD sensors.fleet.example.com does not exist"; exit 1; fi
field() { printf '%s' "$json" | jq -r "$1"; }
[ "$(field .spec.group)" = "fleet.example.com" ] || { echo "FAIL: group is not fleet.example.com"; exit 1; }
[ "$(field .spec.scope)" = "Namespaced" ] || { echo "FAIL: scope is not Namespaced"; exit 1; }
[ "$(field .spec.names.kind)" = "Sensor" ] || { echo "FAIL: kind is not Sensor"; exit 1; }
[ "$(field .spec.names.plural)" = "sensors" ] || { echo "FAIL: plural is not sensors"; exit 1; }
[ "$(field '.spec.versions[] | select(.name=="v1") | .served')" = "true" ] || { echo "FAIL: v1 is not served"; exit 1; }
[ "$(field '.spec.versions[] | select(.name=="v1") | .storage')" = "true" ] || { echo "FAIL: v1 is not the storage version"; exit 1; }
est="$(field '.status.conditions[]? | select(.type=="Established") | .status')"
[ "$est" = "True" ] || { echo "FAIL: the CRD is not Established"; exit 1; }
echo "PASS: CRD sensors.fleet.example.com is defined and established"

