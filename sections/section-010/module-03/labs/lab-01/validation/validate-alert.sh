#!/usr/bin/env bash
# Check: Alert ScoutSlow fires above 0.5 for 5 minutes with label severity=ticket and a summary annotation
set -uo pipefail

rules="$(kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 http://prometheus.monitoring.svc.cluster.local:9090/api/v1/rules 2>/dev/null || true)"
[ -n "$rules" ] || { echo "FAIL: Prometheus is not reachable"; exit 1; }
a="$(echo "$rules" | jq -c '.data.groups[]? | select(.name=="scout-latency") | .rules[] | select(.type=="alerting" and .name=="ScoutSlow")' 2>/dev/null || true)"
[ -n "$a" ] || { echo "FAIL: alerting rule ScoutSlow is not loaded"; exit 1; }
[ "$(echo "$a" | jq -r .duration)" = "300" ] || { echo "FAIL: the for duration is not 5m"; exit 1; }
echo "$a" | jq -r .query | grep -q "scout:http_request_duration_seconds:p95_5m > 0.5" || { echo "FAIL: the expression is not the recorded p95 > 0.5"; exit 1; }
[ "$(echo "$a" | jq -r .labels.severity)" = "ticket" ] || { echo "FAIL: label severity is not ticket"; exit 1; }
[ "$(echo "$a" | jq -r '.annotations.summary // empty')" != "" ] || { echo "FAIL: annotation summary is missing"; exit 1; }
echo "PASS: alert ScoutSlow is correct"
