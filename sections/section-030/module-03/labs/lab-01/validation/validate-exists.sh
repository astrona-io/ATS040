#!/usr/bin/env bash
# Check: ConfigMap release-facts exists in starfleet
set -uo pipefail

kubectl -n starfleet get configmap release-facts >/dev/null 2>&1 || { echo "FAIL: ConfigMap release-facts does not exist"; exit 1; }
echo "PASS: ConfigMap release-facts exists"
