#!/usr/bin/env bash
# Check: behaviour. With about 10% errors the burn alert must be firing.
set -uo pipefail

prom_get() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}

result="$(prom_get /api/v1/query --data-urlencode 'query=ALERTS{alertname="ScoutErrorBudgetBurn",alertstate="firing"}')"
count="$(echo "$result" | jq -r '.data.result | length' 2>/dev/null || echo 0)"
if [ "$count" = "0" ]; then
  echo "FAIL: ScoutErrorBudgetBurn is not firing (wait about 3 minutes after the rules load, then check the rule)"
  exit 1
fi

echo "PASS: ScoutErrorBudgetBurn is firing"
