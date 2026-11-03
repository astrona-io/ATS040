#!/usr/bin/env bash
# Check: enough ready replicas.
set -uo pipefail

ready="$(kubectl -n orbit get deploy beacon -o jsonpath='{.status.readyReplicas}' 2>/dev/null || true)"
desired="$(kubectl -n orbit get deploy beacon -o jsonpath='{.spec.replicas}' 2>/dev/null || true)"
if [ -z "$desired" ]; then echo "FAIL: deployment beacon not found in orbit"; exit 1; fi
if [ "$desired" -lt 3 ]; then echo "FAIL: spec.replicas is ${desired}, expected at least 3"; exit 1; fi
if [ "${ready:-0}" -lt 3 ]; then echo "FAIL: ${ready:-0} replicas are ready, expected at least 3"; exit 1; fi
echo "PASS: ${ready} of ${desired} replicas are ready"

