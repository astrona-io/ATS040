#!/usr/bin/env bash
# Check: readiness probe path.
set -uo pipefail

path="$(kubectl -n orbit get deploy beacon -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null || true)"
if [ -z "$path" ]; then echo "FAIL: deployment beacon has no readiness probe path"; exit 1; fi
if [ "$path" != "/readyz" ]; then echo "FAIL: readiness probe path is '${path}', expected /readyz"; exit 1; fi
echo "PASS: readiness probe uses /readyz"

