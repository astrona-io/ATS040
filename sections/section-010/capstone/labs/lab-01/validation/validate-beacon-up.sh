#!/usr/bin/env bash
# Check: the beacon target is scraped with the label team=orbit.
set -uo pipefail

prom_get() {
  kubectl -n orbit exec deploy/drifter -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}
result="$(prom_get /api/v1/query --data-urlencode 'query=up{job="beacon",team="orbit"}')"
value="$(echo "$result" | jq -r '.data.result[0].value[1] // empty' 2>/dev/null || true)"
if [ -z "$value" ]; then echo "FAIL: up{job=\"beacon\",team=\"orbit\"} returns no series"; exit 1; fi
if [ "$value" != "1" ]; then echo "FAIL: up is ${value}, expected 1"; exit 1; fi
interval="$(prom_get /api/v1/targets | jq -r '[.data.activeTargets[] | select(.labels.job=="beacon")][0].scrapeInterval // empty' 2>/dev/null || true)"
if [ "$interval" != "10s" ]; then echo "FAIL: the scrape interval of beacon is '${interval}', expected 10s"; exit 1; fi
echo "PASS: beacon is up with team=orbit and a 10s interval"

