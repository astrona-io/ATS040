#!/usr/bin/env bash
# Check: behaviour. The scout target is reachable and the last scrape worked.
set -uo pipefail

prom_get() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}

result="$(prom_get /api/v1/query --data-urlencode 'query=up{job="scout"}')"
value="$(echo "$result" | jq -r '.data.result[0].value[1] // empty' 2>/dev/null || true)"
if [ -z "$value" ]; then
  echo "FAIL: up{job=\"scout\"} returns no series, Prometheus has not loaded the scout job"
  exit 1
fi
if [ "$value" != "1" ]; then
  echo "FAIL: up{job=\"scout\"} is ${value}, expected 1"
  exit 1
fi

echo "PASS: up{job=\"scout\"} is 1"
