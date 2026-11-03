#!/usr/bin/env bash
# Check: the Job finished successfully.
set -uo pipefail

ok="$(kubectl -n starfleet get job process-event -o jsonpath='{.status.succeeded}' 2>/dev/null || true)"
if [ "$ok" != "1" ]; then echo "FAIL: status.succeeded is '${ok}', expected 1"; exit 1; fi
echo "PASS: Job process-event completed"

