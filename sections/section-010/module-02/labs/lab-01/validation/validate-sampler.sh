#!/usr/bin/env bash
# Check: The sampler is parentbased_traceidratio with argument 0.25
set -uo pipefail

[ "$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[?(@.name=="scout")].env[?(@.name=="OTEL_TRACES_SAMPLER")].value}' 2>/dev/null)" = "parentbased_traceidratio" ] || { echo "FAIL: OTEL_TRACES_SAMPLER is not parentbased_traceidratio"; exit 1; }
[ "$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[?(@.name=="scout")].env[?(@.name=="OTEL_TRACES_SAMPLER_ARG")].value}' 2>/dev/null)" = "0.25" ] || { echo "FAIL: OTEL_TRACES_SAMPLER_ARG is not 0.25"; exit 1; }
echo "PASS: sampler is set"
