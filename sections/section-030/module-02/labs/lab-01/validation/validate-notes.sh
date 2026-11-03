#!/usr/bin/env bash
# Check: migration notes.
set -uo pipefail

if ! kubectl -n starfleet get configmap migration-notes >/dev/null 2>&1; then echo "FAIL: ConfigMap migration-notes does not exist in starfleet"; exit 1; fi
get() { kubectl -n starfleet get configmap migration-notes -o jsonpath="{.data.$1}" 2>/dev/null || true; }
[ "$(get cronjob)" = "batch/v1" ] || { echo "FAIL: key cronjob is not batch/v1"; exit 1; }
[ "$(get hpa)" = "autoscaling/v2" ] || { echo "FAIL: key hpa is not autoscaling/v2"; exit 1; }
[ "$(get pdb)" = "policy/v1" ] || { echo "FAIL: key pdb is not policy/v1"; exit 1; }
echo "PASS: migration-notes lists the current versions"

