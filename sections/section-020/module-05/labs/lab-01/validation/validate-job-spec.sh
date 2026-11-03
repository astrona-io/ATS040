#!/usr/bin/env bash
# Check: Job beacon sets backoffLimit 2, activeDeadlineSeconds 120, ttl 3600 and restartPolicy Never
set -uo pipefail

j="$(kubectl -n starfleet get job beacon -o json 2>/dev/null || true)"
[ -n "$j" ] || { echo "FAIL: Job beacon does not exist in starfleet"; exit 1; }
[ "$(echo "$j" | jq -r .spec.backoffLimit)" = "2" ] || { echo "FAIL: backoffLimit is not 2"; exit 1; }
[ "$(echo "$j" | jq -r .spec.activeDeadlineSeconds)" = "120" ] || { echo "FAIL: activeDeadlineSeconds is not 120"; exit 1; }
[ "$(echo "$j" | jq -r .spec.ttlSecondsAfterFinished)" = "3600" ] || { echo "FAIL: ttlSecondsAfterFinished is not 3600"; exit 1; }
[ "$(echo "$j" | jq -r .spec.template.spec.restartPolicy)" = "Never" ] || { echo "FAIL: restartPolicy is not Never"; exit 1; }
echo "PASS: Job beacon sets the required limits"
