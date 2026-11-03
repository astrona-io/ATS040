#!/usr/bin/env bash
# Check: OTEL_SERVICE_NAME is scout
set -uo pipefail

[ "$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[?(@.name=="scout")].env[?(@.name=="OTEL_SERVICE_NAME")].value}' 2>/dev/null)" = "scout" ] || { echo "FAIL: OTEL_SERVICE_NAME is not scout"; exit 1; }
echo "PASS: OTEL_SERVICE_NAME is scout"
