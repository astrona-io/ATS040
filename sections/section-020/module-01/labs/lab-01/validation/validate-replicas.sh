#!/usr/bin/env bash
# Check: three replicas, all available.
set -uo pipefail

spec="$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.replicas}' 2>/dev/null || true)"
avail="$(kubectl -n starfleet get deployment scout -o jsonpath='{.status.availableReplicas}' 2>/dev/null || true)"
if [ "$spec" != "3" ]; then echo "FAIL: spec.replicas is '${spec}', expected 3"; exit 1; fi
if [ "${avail:-0}" != "3" ]; then echo "FAIL: availableReplicas is '${avail:-0}', expected 3"; exit 1; fi
echo "PASS: scout has 3 available replicas"

