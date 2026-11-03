#!/usr/bin/env bash
# Check: bounded retries, deadline and cleanup.
set -uo pipefail

get() { kubectl -n starfleet get job process-event -o jsonpath="$1" 2>/dev/null || true; }
bo="$(get '{.spec.backoffLimit}')"; dl="$(get '{.spec.activeDeadlineSeconds}')"; ttl="$(get '{.spec.ttlSecondsAfterFinished}')"
if [ -z "$bo" ] && [ -z "$dl" ]; then echo "FAIL: Job process-event does not exist in starfleet"; exit 1; fi
if [ "$bo" != "4" ]; then echo "FAIL: backoffLimit is '${bo}', expected 4"; exit 1; fi
if [ "$dl" != "120" ]; then echo "FAIL: activeDeadlineSeconds is '${dl}', expected 120"; exit 1; fi
if [ -z "$ttl" ]; then echo "FAIL: ttlSecondsAfterFinished is not set"; exit 1; fi
echo "PASS: backoffLimit 4, deadline 120, ttl ${ttl}"

