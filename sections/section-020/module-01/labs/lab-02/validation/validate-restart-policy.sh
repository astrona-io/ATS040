#!/usr/bin/env bash
# Check: restartPolicy is valid for a Job.
set -uo pipefail

rp="$(kubectl -n starfleet get job process-event -o jsonpath='{.spec.template.spec.restartPolicy}' 2>/dev/null || true)"
if [ "$rp" != "Never" ] && [ "$rp" != "OnFailure" ]; then echo "FAIL: restartPolicy is '${rp}', expected Never or OnFailure"; exit 1; fi
echo "PASS: restartPolicy ${rp}"

