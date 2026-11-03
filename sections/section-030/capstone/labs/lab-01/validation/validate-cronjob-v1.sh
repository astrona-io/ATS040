#!/usr/bin/env bash
# Check: the CronJob exists through batch/v1.
set -uo pipefail

json="$(kubectl -n orbit get cronjob.v1.batch beacon-sweep -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: CronJob beacon-sweep does not exist in orbit through batch/v1"; exit 1; fi
[ "$(echo "$json" | jq -r '.spec.schedule')" = "*/30 * * * *" ] || { echo "FAIL: schedule is not */30 * * * *"; exit 1; }
[ "$(echo "$json" | jq -r '.spec.concurrencyPolicy')" = "Forbid" ] || { echo "FAIL: concurrencyPolicy is not Forbid"; exit 1; }
[ "$(echo "$json" | jq -r '.spec.jobTemplate.spec.template.spec.containers[0].image')" = "curlimages/curl:8.22.0" ] || { echo "FAIL: container image changed"; exit 1; }
[ "$(echo "$json" | jq -r '.spec.suspend // false')" = "false" ] || { echo "FAIL: CronJob is suspended"; exit 1; }
echo "PASS: beacon-sweep exists through batch/v1 with the legacy schedule and policy"

