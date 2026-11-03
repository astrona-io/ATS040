#!/usr/bin/env bash
# Check: the issue report.
set -uo pipefail

if ! kubectl -n orbit get configmap issue-report >/dev/null 2>&1; then echo "FAIL: ConfigMap issue-report does not exist in orbit"; exit 1; fi
get() { kubectl -n orbit get configmap issue-report -o jsonpath="{.data.$1}" 2>/dev/null || true; }
title="$(get title)"
if [ "${#title}" -lt 10 ]; then echo "FAIL: key title is missing or shorter than 10 characters"; exit 1; fi
[ "$(get kind)" = "bug" ] || { echo "FAIL: key kind is not bug"; exit 1; }
[ "$(get sig)" = "sig-apps" ] || { echo "FAIL: key sig is not sig-apps"; exit 1; }
echo "PASS: issue-report names the bug and sig-apps"

