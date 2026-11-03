#!/usr/bin/env bash
# Check: CronJob settings.
set -uo pipefail

json="$(kubectl -n starfleet get cronjob nightly-report -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: CronJob nightly-report does not exist in starfleet"; exit 1; fi
field() { printf '%s' "$json" | jq -r "$1"; }
[ "$(field .spec.schedule)" = "0 2 * * *" ] || { echo "FAIL: schedule is not '0 2 * * *'"; exit 1; }
[ "$(field .spec.concurrencyPolicy)" = "Forbid" ] || { echo "FAIL: concurrencyPolicy is not Forbid"; exit 1; }
[ "$(field .spec.startingDeadlineSeconds)" = "300" ] || { echo "FAIL: startingDeadlineSeconds is not 300"; exit 1; }
[ "$(field .spec.successfulJobsHistoryLimit)" = "2" ] || { echo "FAIL: successfulJobsHistoryLimit is not 2"; exit 1; }
[ "$(field .spec.failedJobsHistoryLimit)" = "2" ] || { echo "FAIL: failedJobsHistoryLimit is not 2"; exit 1; }
[ "$(field .spec.suspend)" = "true" ] || { echo "FAIL: the CronJob is not suspended"; exit 1; }
echo "PASS: CronJob nightly-report is configured"

