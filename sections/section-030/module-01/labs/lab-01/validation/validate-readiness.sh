#!/usr/bin/env bash
# Check: the readiness path.
set -uo pipefail

p="$(kubectl -n starfleet get deploy scout -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null || true)"
if [ "$p" != "/readyz" ]; then echo "FAIL: readiness path is '${p}', expected /readyz"; exit 1; fi
echo "PASS: readiness probe calls /readyz"

