#!/usr/bin/env bash
# Check: serverVersion matches the version of the cluster
set -uo pipefail

live="$(kubectl version -o json 2>/dev/null | jq -r .serverVersion.gitVersion)"
got="$(kubectl -n starfleet get configmap release-facts -o jsonpath='{.data.serverVersion}' 2>/dev/null || true)"
[ -n "$live" ] || { echo "FAIL: cannot read the server version"; exit 1; }
[ "$got" = "$live" ] || { echo "FAIL: serverVersion is '$got' but the cluster runs '$live'"; exit 1; }
echo "PASS: serverVersion matches the cluster"
