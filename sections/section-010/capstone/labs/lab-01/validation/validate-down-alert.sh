#!/usr/bin/env bash
# Check: the availability alert.
set -uo pipefail

prom_get() {
  kubectl -n orbit exec deploy/drifter -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}
rule="$(prom_get /api/v1/rules | jq -c '[.data.groups[].rules[] | select(.name == "BeaconDown" and .type == "alerting")][0] // empty' 2>/dev/null || true)"
if [ -z "$rule" ]; then echo "FAIL: no alerting rule named BeaconDown is loaded"; exit 1; fi
query="$(echo "$rule" | jq -r '.query' | tr -d ' ')"
case "$query" in
  'up{job="beacon"}==0') ;;
  *) echo "FAIL: expression is '${query}', expected up{job=\"beacon\"} == 0"; exit 1 ;;
esac
[ "$(echo "$rule" | jq -r '.duration')" = "60" ] || { echo "FAIL: for is not 60 seconds"; exit 1; }
[ "$(echo "$rule" | jq -r '.labels.severity // empty')" = "page" ] || { echo "FAIL: label severity is not page"; exit 1; }
[ -n "$(echo "$rule" | jq -r '.annotations.summary // empty')" ] || { echo "FAIL: annotation summary is missing"; exit 1; }
echo "PASS: BeaconDown is defined"

