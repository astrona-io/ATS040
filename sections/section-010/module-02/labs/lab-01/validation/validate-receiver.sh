#!/usr/bin/env bash
# Check: ConfigMap collector-config defines an otlp HTTP receiver on 0.0.0.0:4318 and the processors memory_limiter and batch
set -uo pipefail

cfg="$(kubectl -n starfleet get configmap collector-config -o jsonpath='{.data.config\.yaml}' 2>/dev/null || true)"
[ -n "$cfg" ] || { echo "FAIL: ConfigMap collector-config has no key config.yaml"; exit 1; }
printf '%s' "$cfg" | grep -q "0.0.0.0:4318" || { echo "FAIL: no endpoint 0.0.0.0:4318"; exit 1; }
printf '%s' "$cfg" | grep -qE "^ *memory_limiter:" || { echo "FAIL: processor memory_limiter is not defined"; exit 1; }
printf '%s' "$cfg" | grep -qE "^ *batch:" || { echo "FAIL: processor batch is not defined"; exit 1; }
printf '%s' "$cfg" | grep -qE "^ *debug:" || { echo "FAIL: exporter debug is not defined"; exit 1; }
echo "PASS: receiver, processors and exporter are defined"
