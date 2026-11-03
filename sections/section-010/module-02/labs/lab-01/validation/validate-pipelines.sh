#!/usr/bin/env bash
# Check: Pipelines traces and metrics use otlp, then memory_limiter and batch in order, then debug
set -uo pipefail

cfg="$(kubectl -n starfleet get configmap collector-config -o jsonpath='{.data.config\.yaml}' 2>/dev/null || true)"
for signal in traces metrics; do
  block="$(printf '%s\n' "$cfg" | awk -v s="$signal" '$1==s":"{f=1;next} f&&/^ *[a-z]+:$/&&$1!="receivers:"&&$1!="processors:"&&$1!="exporters:"{f=0} f{print}')"
  [ -n "$block" ] || { echo "FAIL: pipeline $signal is not defined"; exit 1; }
  printf '%s' "$block" | grep -q "receivers: \[otlp\]" || { echo "FAIL: $signal receivers are not [otlp]"; exit 1; }
  printf '%s' "$block" | grep -q "processors: \[memory_limiter, batch\]" || { echo "FAIL: $signal processors are not [memory_limiter, batch]"; exit 1; }
  printf '%s' "$block" | grep -q "exporters: \[debug\]" || { echo "FAIL: $signal exporters are not [debug]"; exit 1; }
done
echo "PASS: traces and metrics pipelines are wired in order"
