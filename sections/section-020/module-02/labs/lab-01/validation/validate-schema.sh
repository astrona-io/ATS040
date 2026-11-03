#!/usr/bin/env bash
# Check: schema fields.
set -uo pipefail

json="$(kubectl get crd sensors.fleet.example.com -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: CRD sensors.fleet.example.com does not exist"; exit 1; fi
s='.spec.versions[] | select(.name=="v1") | .schema.openAPIV3Schema.properties.spec'
field() { printf '%s' "$json" | jq -r "$1"; }
[ "$(field "$s.required | index(\"target\") != null")" = "true" ] || { echo "FAIL: target is not required"; exit 1; }
[ "$(field "$s.properties.target.type")" = "string" ] || { echo "FAIL: target is not a string"; exit 1; }
[ "$(field "$s.properties.intervalSeconds.type")" = "integer" ] || { echo "FAIL: intervalSeconds is not an integer"; exit 1; }
[ "$(field "$s.properties.intervalSeconds.minimum")" = "1" ] || { echo "FAIL: intervalSeconds minimum is not 1"; exit 1; }
[ "$(field "$s.properties.intervalSeconds.default")" = "30" ] || { echo "FAIL: intervalSeconds default is not 30"; exit 1; }
echo "PASS: schema requires target and bounds intervalSeconds"

