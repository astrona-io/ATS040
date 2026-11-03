#!/usr/bin/env bash
# Check: supportedMinorVersions is 3
set -uo pipefail

got="$(kubectl -n starfleet get configmap release-facts -o jsonpath='{.data.supportedMinorVersions}' 2>/dev/null || true)"
[ "$got" = "3" ] || { echo "FAIL: supportedMinorVersions is '$got'"; exit 1; }
echo "PASS: supportedMinorVersions is 3"
