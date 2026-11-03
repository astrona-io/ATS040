#!/usr/bin/env bash
# Check: the recorded reason.
set -uo pipefail

v="$(kubectl -n starfleet get deploy scout -o jsonpath='{.metadata.annotations.kubernetes\.io/change-cause}' 2>/dev/null || true)"
case "$v" in
  *readiness*|*Readiness*) echo "PASS: change-cause is '${v}'" ;;
  *) echo "FAIL: annotation kubernetes.io/change-cause is '${v}', expected a text that mentions readiness"; exit 1 ;;
esac

