#!/usr/bin/env bash
# Check: migrated CronJob.
set -uo pipefail

json="$(kubectl get --raw /apis/batch/v1/namespaces/starfleet/cronjobs/report-sweep 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: CronJob report-sweep is not served at batch/v1 in starfleet"; exit 1; fi
field() { printf '%s' "$json" | jq -r "$1"; }
[ "$(field .spec.schedule)" = "*/30 * * * *" ] || { echo "FAIL: schedule is not '*/30 * * * *'"; exit 1; }
[ "$(field .spec.concurrencyPolicy)" = "Forbid" ] || { echo "FAIL: concurrencyPolicy is not Forbid"; exit 1; }
[ "$(field .spec.jobTemplate.spec.template.spec.containers[0].image)" = "curlimages/curl:8.22.0" ] || { echo "FAIL: the image is not curlimages/curl:8.22.0"; exit 1; }
echo "PASS: CronJob report-sweep is served at batch/v1"

