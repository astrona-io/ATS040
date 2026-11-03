#!/usr/bin/env bash
# Check: readiness and liveness probes use the right paths.
set -uo pipefail

ready="$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[0].readinessProbe.httpGet.path}' 2>/dev/null || true)"
live="$(kubectl -n starfleet get deployment scout -o jsonpath='{.spec.template.spec.containers[0].livenessProbe.httpGet.path}' 2>/dev/null || true)"
if [ "$ready" != "/readyz" ]; then echo "FAIL: readinessProbe path is '${ready}', expected /readyz"; exit 1; fi
if [ "$live" != "/healthz" ]; then echo "FAIL: livenessProbe path is '${live}', expected /healthz"; exit 1; fi
echo "PASS: probes are configured"

