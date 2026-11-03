#!/usr/bin/env bash
# Check: Jobs of patrol stop after 60 seconds and do not restart in place
set -uo pipefail

j="$(kubectl -n starfleet get cronjob patrol -o json 2>/dev/null || true)"
[ -n "$j" ] || { echo "FAIL: CronJob patrol does not exist"; exit 1; }
[ "$(echo "$j" | jq -r .spec.jobTemplate.spec.activeDeadlineSeconds)" = "60" ] || { echo "FAIL: activeDeadlineSeconds is not 60"; exit 1; }
[ "$(echo "$j" | jq -r .spec.jobTemplate.spec.template.spec.restartPolicy)" = "Never" ] || { echo "FAIL: restartPolicy is not Never"; exit 1; }
echo "PASS: patrol job template is correct"
