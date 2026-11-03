#!/usr/bin/env bash
# Check: Rule group scout-latency is loaded and every rule is healthy
set -uo pipefail

rules="$(kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 http://prometheus.monitoring.svc.cluster.local:9090/api/v1/rules 2>/dev/null || true)"
[ -n "$rules" ] || { echo "FAIL: Prometheus is not reachable"; exit 1; }
group="$(echo "$rules" | jq -c '.data.groups[]? | select(.name=="scout-latency")' 2>/dev/null || true)"
[ -n "$group" ] || { echo "FAIL: rule group scout-latency is not loaded"; exit 1; }
for attempt in $(seq 1 12); do
  bad="$(echo "$rules" | jq '[.data.groups[] | select(.name=="scout-latency") | .rules[] | select(.health!="ok")] | length')"
  [ "$bad" = "0" ] && { echo "PASS: group scout-latency is loaded and healthy"; exit 0; }
  sleep 5
  rules="$(kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 http://prometheus.monitoring.svc.cluster.local:9090/api/v1/rules 2>/dev/null || true)"
done
echo "FAIL: a rule in scout-latency is not healthy"; exit 1
