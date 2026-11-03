#!/usr/bin/env bash
# Check: Recording rule scout:http_requests:rate5m sums rate of http_requests_total over 5m
set -uo pipefail

rules="$(kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 http://prometheus.monitoring.svc.cluster.local:9090/api/v1/rules 2>/dev/null || true)"
[ -n "$rules" ] || { echo "FAIL: Prometheus is not reachable"; exit 1; }
q="$(echo "$rules" | jq -r '.data.groups[]? | select(.name=="scout-latency") | .rules[] | select(.type=="recording" and .name=="scout:http_requests:rate5m") | .query' 2>/dev/null || true)"
[ -n "$q" ] || { echo "FAIL: recording rule scout:http_requests:rate5m is not loaded"; exit 1; }
echo "$q" | grep -q "sum(" || { echo "FAIL: the query does not use sum"; exit 1; }
echo "$q" | grep -q "rate(http_requests_total" || { echo "FAIL: the query does not use rate of http_requests_total"; exit 1; }
echo "$q" | grep -q "\[5m\]" || { echo "FAIL: the window is not 5m"; exit 1; }
echo "PASS: recording rule scout:http_requests:rate5m is correct"
