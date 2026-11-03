#!/usr/bin/env bash
# Check: separate readiness and liveness probes.
set -uo pipefail

deploy="$(kubectl -n orbit get deploy beacon -o json 2>/dev/null || true)"
if [ -z "$deploy" ]; then echo "FAIL: deployment beacon not found in orbit"; exit 1; fi
ready_path="$(echo "$deploy" | jq -r '.spec.template.spec.containers[0].readinessProbe.httpGet.path // empty')"
live_path="$(echo "$deploy" | jq -r '.spec.template.spec.containers[0].livenessProbe.httpGet.path // empty')"
startup="$(echo "$deploy" | jq -r '.spec.template.spec.containers[0].startupProbe // empty')"
if [ "$ready_path" != "/readyz" ]; then echo "FAIL: readiness probe path is '${ready_path}', expected /readyz"; exit 1; fi
if [ "$live_path" != "/healthz" ]; then echo "FAIL: liveness probe path is '${live_path}', expected /healthz"; exit 1; fi
echo "PASS: readiness uses /readyz and liveness uses /healthz"

