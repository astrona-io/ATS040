#!/usr/bin/env bash
# Check: Container scout requests 100m CPU and 64Mi memory and has a memory limit of 128Mi
set -uo pipefail

r() { kubectl -n starfleet get deployment scout -o jsonpath="{.spec.template.spec.containers[?(@.name==\"scout\")]$1}" 2>/dev/null; }
[ "$(r '.resources.requests.cpu')" = "100m" ] || { echo "FAIL: CPU request is not 100m"; exit 1; }
[ "$(r '.resources.requests.memory')" = "64Mi" ] || { echo "FAIL: memory request is not 64Mi"; exit 1; }
[ "$(r '.resources.limits.memory')" = "128Mi" ] || { echo "FAIL: memory limit is not 128Mi"; exit 1; }
echo "PASS: scout is right-sized"
