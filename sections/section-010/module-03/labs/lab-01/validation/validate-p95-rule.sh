#!/usr/bin/env bash
# Check: Recording rule scout:http_request_duration_seconds:p95_5m uses histogram_quantile 0.95 over summed bucket rates by le
set -uo pipefail

rules="$(kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 http://prometheus.monitoring.svc.cluster.local:9090/api/v1/rules 2>/dev/null || true)"
[ -n "$rules" ] || { echo "FAIL: Prometheus is not reachable"; exit 1; }
q="$(echo "$rules" | jq -r '.data.groups[]? | select(.name=="scout-latency") | .rules[] | select(.type=="recording" and .name=="scout:http_request_duration_seconds:p95_5m") | .query' 2>/dev/null || true)"
[ -n "$q" ] || { echo "FAIL: recording rule scout:http_request_duration_seconds:p95_5m is not loaded"; exit 1; }
echo "$q" | grep -q "histogram_quantile(0.95" || { echo "FAIL: the query does not use histogram_quantile(0.95"; exit 1; }
echo "$q" | grep -q "http_request_duration_seconds_bucket" || { echo "FAIL: the query does not use the _bucket series"; exit 1; }
echo "$q" | grep -qE "by \(le\)" || { echo "FAIL: the query does not keep the le label"; exit 1; }
echo "$q" | grep -q "\[5m\]" || { echo "FAIL: the window is not 5m"; exit 1; }
echo "PASS: the p95 recording rule is correct"
