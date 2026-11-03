#!/usr/bin/env bash
# Check: CronJob patrol keeps one successful and one failed Job
set -uo pipefail

j="$(kubectl -n starfleet get cronjob patrol -o json 2>/dev/null || true)"
[ -n "$j" ] || { echo "FAIL: CronJob patrol does not exist"; exit 1; }
[ "$(echo "$j" | jq -r .spec.successfulJobsHistoryLimit)" = "1" ] || { echo "FAIL: successfulJobsHistoryLimit is not 1"; exit 1; }
[ "$(echo "$j" | jq -r .spec.failedJobsHistoryLimit)" = "1" ] || { echo "FAIL: failedJobsHistoryLimit is not 1"; exit 1; }
echo "PASS: history limits are 1"
