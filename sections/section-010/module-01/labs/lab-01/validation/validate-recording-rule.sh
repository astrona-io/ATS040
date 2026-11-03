#!/usr/bin/env bash
# Check: the recording rule is loaded, is a recording rule (not an alert), is
# built on http_requests_total, and returns a plausible 5xx ratio (about 0.1).
set -uo pipefail

prom_get() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}

rules="$(prom_get /api/v1/rules)"
rule="$(echo "$rules" | jq -c '[.data.groups[].rules[] | select(.name == "scout:http_error_ratio:rate5m" and .type == "recording")][0] // empty' 2>/dev/null || true)"
if [ -z "$rule" ]; then
  echo "FAIL: no recording rule named scout:http_error_ratio:rate5m is loaded"
  exit 1
fi

query="$(echo "$rule" | jq -r '.query')"
case "$query" in
  *http_requests_total*) ;;
  *) echo "FAIL: the rule expression does not use http_requests_total: ${query}"; exit 1 ;;
esac

result="$(prom_get /api/v1/query --data-urlencode 'query=scout:http_error_ratio:rate5m')"
value="$(echo "$result" | jq -r '.data.result[0].value[1] // empty' 2>/dev/null || true)"
if [ -z "$value" ]; then
  echo "FAIL: the recorded series has no value yet, wait for one evaluation interval and check the expression"
  exit 1
fi
if ! awk -v v="$value" 'BEGIN { exit !(v >= 0.03 && v <= 0.3) }'; then
  echo "FAIL: the recorded ratio is ${value}, expected about 0.1 (5xx rate divided by total rate)"
  exit 1
fi

echo "PASS: scout:http_error_ratio:rate5m is recorded (${value})"
