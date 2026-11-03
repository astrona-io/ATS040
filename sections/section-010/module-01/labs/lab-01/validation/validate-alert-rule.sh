#!/usr/bin/env bash
# Check: the alerting rule exists with the right threshold, for, label and
# annotation. The threshold is 14.4 * 0.001 = 0.0144, not 0.001 or 14.4.
set -uo pipefail

prom_get() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}

rules="$(prom_get /api/v1/rules)"
rule="$(echo "$rules" | jq -c '[.data.groups[].rules[] | select(.name == "ScoutErrorBudgetBurn" and .type == "alerting")][0] // empty' 2>/dev/null || true)"
if [ -z "$rule" ]; then
  echo "FAIL: no alerting rule named ScoutErrorBudgetBurn is loaded"
  exit 1
fi

query="$(echo "$rule" | jq -r '.query' | tr -d ' ()')"
case "$query" in
  *scout:http_error_ratio:rate5m\>0.0144|*scout:http_error_ratio:rate5m\>14.4\*0.001|*scout:http_error_ratio:rate5m\>0.001\*14.4) ;;
  *) echo "FAIL: expression is '${query}', expected scout:http_error_ratio:rate5m greater than 14.4 * 0.001"; exit 1 ;;
esac

duration="$(echo "$rule" | jq -r '.duration')"
if [ "$duration" != "120" ]; then
  echo "FAIL: for is ${duration} seconds, expected 120 (2m)"
  exit 1
fi

severity="$(echo "$rule" | jq -r '.labels.severity // empty')"
if [ "$severity" != "page" ]; then
  echo "FAIL: label severity is '${severity}', expected 'page'"
  exit 1
fi

summary="$(echo "$rule" | jq -r '.annotations.summary // empty')"
if [ -z "$summary" ]; then
  echo "FAIL: annotation summary is missing"
  exit 1
fi

echo "PASS: ScoutErrorBudgetBurn uses threshold 14.4 * 0.001, for 2m, severity=page and a summary"
