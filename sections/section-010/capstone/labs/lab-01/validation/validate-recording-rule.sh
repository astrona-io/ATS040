#!/usr/bin/env bash
# Check: the recorded error ratio.
set -uo pipefail

prom_get() {
  kubectl -n orbit exec deploy/drifter -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}
rules="$(prom_get /api/v1/rules)"
rule="$(echo "$rules" | jq -c '[.data.groups[].rules[] | select(.name == "beacon:http_error_ratio:rate5m" and .type == "recording")][0] // empty' 2>/dev/null || true)"
if [ -z "$rule" ]; then echo "FAIL: no recording rule named beacon:http_error_ratio:rate5m is loaded"; exit 1; fi
case "$(echo "$rule" | jq -r '.query')" in
  *http_requests_total*) ;;
  *) echo "FAIL: the rule expression does not use http_requests_total"; exit 1 ;;
esac
value="$(prom_get /api/v1/query --data-urlencode 'query=beacon:http_error_ratio:rate5m' | jq -r '.data.result[0].value[1] // empty' 2>/dev/null || true)"
if [ -z "$value" ]; then echo "FAIL: the recorded series has no value yet"; exit 1; fi
if ! awk -v v="$value" 'BEGIN { exit !(v >= 0.03 && v <= 0.3) }'; then echo "FAIL: the recorded ratio is ${value}, expected about 0.1"; exit 1; fi
echo "PASS: beacon:http_error_ratio:rate5m is recorded (${value})"

