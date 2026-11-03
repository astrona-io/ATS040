#!/usr/bin/env bash
# Check: environment. Prometheus is Ready and drifter runs.
set -uo pipefail

prom_get() {
  kubectl -n orbit exec deploy/drifter -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}
ready="$(prom_get /-/ready)"
case "$ready" in
  *Ready*) ;;
  *) echo "FAIL: Prometheus is not Ready: '${ready}'"; exit 1 ;;
esac
available="$(kubectl -n orbit get deploy drifter -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)"
if [ "${available:-0}" -lt 1 ]; then echo "FAIL: deployment drifter has no available replica"; exit 1; fi
echo "PASS: Prometheus is Ready and drifter is running"

