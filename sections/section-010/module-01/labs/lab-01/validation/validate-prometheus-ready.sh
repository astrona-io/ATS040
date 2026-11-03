#!/usr/bin/env bash
# Check: environment. Prometheus is Ready (valid configuration and rules) and
# shuttle is still running. Passes on the starting state.
set -uo pipefail

prom_get() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}

ready="$(prom_get /-/ready)"
case "$ready" in
  *Ready*) ;;
  *) echo "FAIL: Prometheus is not Ready: '${ready}'"; exit 1 ;;
esac

available="$(kubectl -n starfleet get deploy shuttle -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)"
if [ "${available:-0}" -lt 1 ]; then
  echo "FAIL: deployment shuttle has no available replica"
  exit 1
fi

echo "PASS: Prometheus is Ready and shuttle is running"
