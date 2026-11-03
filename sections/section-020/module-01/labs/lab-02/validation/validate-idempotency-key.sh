#!/usr/bin/env bash
# Check: the request carries the idempotency key.
set -uo pipefail

spec="$(kubectl -n starfleet get job process-event -o jsonpath='{.spec.template.spec.containers[0].command} {.spec.template.spec.containers[0].args}' 2>/dev/null || true)"
case "$spec" in
  *"Idempotency-Key: evt-1001"*) echo "PASS: header Idempotency-Key: evt-1001 found" ;;
  *) echo "FAIL: the Job command or args do not contain 'Idempotency-Key: evt-1001'"; exit 1 ;;
esac

