#!/usr/bin/env bash
# Check: Prometheus has an active scout target with the requested address,
# interval and env label. Rejects a job with the wrong name, port, interval or label.
set -uo pipefail

prom_get() {
  kubectl -n starfleet exec deploy/shuttle -- curl -s -m 10 -G "http://prometheus.monitoring.svc.cluster.local:9090$1" "${@:2}" 2>/dev/null
}

targets="$(prom_get /api/v1/targets --data-urlencode state=active)"
if [ -z "$targets" ]; then
  echo "FAIL: could not read the Prometheus targets API"
  exit 1
fi

match="$(echo "$targets" | jq -r '[.data.activeTargets[] | select(.labels.job == "scout")] | length' 2>/dev/null || echo 0)"
if [ "$match" = "0" ]; then
  echo "FAIL: no active target in job 'scout'"
  exit 1
fi

url="$(echo "$targets" | jq -r '[.data.activeTargets[] | select(.labels.job == "scout")][0].scrapeUrl')"
case "$url" in
  http://scout.starfleet.svc.cluster.local:9898/*) ;;
  *) echo "FAIL: scout target scrapes '${url}', expected http://scout.starfleet.svc.cluster.local:9898/metrics"; exit 1 ;;
esac

interval="$(echo "$targets" | jq -r '[.data.activeTargets[] | select(.labels.job == "scout")][0].scrapeInterval')"
if [ "$interval" != "10s" ]; then
  echo "FAIL: scout scrape interval is '${interval}', expected 10s"
  exit 1
fi

env_label="$(echo "$targets" | jq -r '[.data.activeTargets[] | select(.labels.job == "scout")][0].labels.env')"
if [ "$env_label" != "lab" ]; then
  echo "FAIL: scout target label env is '${env_label}', expected 'lab'"
  exit 1
fi

echo "PASS: job scout scrapes ${url} every 10s with env=lab"
