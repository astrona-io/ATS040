#!/usr/bin/env bash
# Check: the burn-rate alert. Threshold is 14.4 * 0.005 = 0.072.
set -uo pipefail

prom_get() {
  kubectl -n orbit exec deploy/drifter -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}
rule="$(prom_get /api/v1/rules | jq -c '[.data.groups[].rules[] | select(.name == "BeaconErrorBudgetBurn" and .type == "alerting")][0] // empty' 2>/dev/null || true)"
if [ -z "$rule" ]; then echo "FAIL: no alerting rule named BeaconErrorBudgetBurn is loaded"; exit 1; fi
query="$(echo "$rule" | jq -r '.query' | tr -d ' ()')"
case "$query" in
  *beacon:http_error_ratio:rate5m\>0.072|*beacon:http_error_ratio:rate5m\>14.4\*0.005|*beacon:http_error_ratio:rate5m\>0.005\*14.4) ;;
  *) echo "FAIL: expression is '${query}', expected beacon:http_error_ratio:rate5m greater than 14.4 * 0.005"; exit 1 ;;
esac
[ "$(echo "$rule" | jq -r '.duration')" = "120" ] || { echo "FAIL: for is not 120 seconds"; exit 1; }
[ "$(echo "$rule" | jq -r '.labels.severity // empty')" = "page" ] || { echo "FAIL: label severity is not page"; exit 1; }
echo "PASS: BeaconErrorBudgetBurn uses 14.4 * 0.005, for 2m, severity=page"

