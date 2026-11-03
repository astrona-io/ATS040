#!/usr/bin/env bash
# Check: CronJob patrol runs every five minutes with concurrencyPolicy Forbid
set -uo pipefail

j="$(kubectl -n starfleet get cronjob patrol -o json 2>/dev/null || true)"
[ -n "$j" ] || { echo "FAIL: CronJob patrol does not exist in starfleet"; exit 1; }
[ "$(echo "$j" | jq -r .spec.schedule)" = "*/5 * * * *" ] || { echo "FAIL: schedule is not */5 * * * *"; exit 1; }
[ "$(echo "$j" | jq -r .spec.concurrencyPolicy)" = "Forbid" ] || { echo "FAIL: concurrencyPolicy is not Forbid"; exit 1; }
echo "PASS: CronJob patrol schedule and policy are correct"
