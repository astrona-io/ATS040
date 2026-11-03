#!/usr/bin/env bash
# Check: releasesPerYear is 3
set -uo pipefail

got="$(kubectl -n starfleet get configmap release-facts -o jsonpath='{.data.releasesPerYear}' 2>/dev/null || true)"
[ "$got" = "3" ] || { echo "FAIL: releasesPerYear is '$got'"; exit 1; }
echo "PASS: releasesPerYear is 3"
