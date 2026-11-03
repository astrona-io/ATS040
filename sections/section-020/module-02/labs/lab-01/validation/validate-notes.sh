#!/usr/bin/env bash
# Check: platform job map.
set -uo pipefail

get() { kubectl -n starfleet get configmap ecosystem-notes -o jsonpath="{.data.$1}" 2>/dev/null || true; }
if ! kubectl -n starfleet get configmap ecosystem-notes >/dev/null 2>&1; then echo "FAIL: ConfigMap ecosystem-notes does not exist in starfleet"; exit 1; fi
expect() { v="$(get "$1")"; if [ "$v" != "$2" ]; then echo "FAIL: key $1 is '${v}', expected '$2'"; exit 1; fi; }
expect metrics observability
expect gitops continuous-delivery
expect runtime container-runtime
expect mesh service-mesh
echo "PASS: ecosystem-notes maps all four jobs"

