#!/usr/bin/env bash
# Check: the rollout finished. Waits up to 120 seconds.
set -uo pipefail

if ! kubectl -n starfleet rollout status deployment/scout --timeout=120s >/dev/null 2>&1; then echo "FAIL: the rollout of scout did not finish"; exit 1; fi
ready="$(kubectl -n starfleet get deploy scout -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
if [ "${ready:-0}" != "1" ]; then echo "FAIL: readyReplicas is '${ready:-0}', expected 1"; exit 1; fi
echo "PASS: scout rolled out with one ready replica"

