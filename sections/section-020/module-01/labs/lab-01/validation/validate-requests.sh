#!/usr/bin/env bash
# Check: cpu and memory requests exist.
set -uo pipefail

cpu="$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null || true)"
mem="$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[0].resources.requests.memory}' 2>/dev/null || true)"
if [ -z "$cpu" ] || [ -z "$mem" ]; then echo "FAIL: requests cpu='${cpu}' memory='${mem}', both must be set"; exit 1; fi
echo "PASS: requests cpu=${cpu} memory=${mem}"

