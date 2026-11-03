#!/usr/bin/env bash
# Check: The annotation owner-sig is sig-release
set -uo pipefail

got="$(kubectl -n starfleet get configmap release-facts -o jsonpath='{.metadata.annotations.owner-sig}' 2>/dev/null || true)"
[ "$got" = "sig-release" ] || { echo "FAIL: owner-sig is '$got'"; exit 1; }
echo "PASS: owner-sig is sig-release"
