#!/usr/bin/env bash
# Check: The exporter endpoint is http://collector.starfleet:4318 with protocol http/protobuf
set -uo pipefail

[ "$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[?(@.name=="scout")].env[?(@.name=="OTEL_EXPORTER_OTLP_ENDPOINT")].value}' 2>/dev/null)" = "http://collector.starfleet:4318" ] || { echo "FAIL: OTEL_EXPORTER_OTLP_ENDPOINT is not http://collector.starfleet:4318"; exit 1; }
[ "$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[?(@.name=="scout")].env[?(@.name=="OTEL_EXPORTER_OTLP_PROTOCOL")].value}' 2>/dev/null)" = "http/protobuf" ] || { echo "FAIL: OTEL_EXPORTER_OTLP_PROTOCOL is not http/protobuf"; exit 1; }
echo "PASS: exporter endpoint and protocol are set"
