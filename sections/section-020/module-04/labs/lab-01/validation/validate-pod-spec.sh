#!/usr/bin/env bash
# Check: Pod recorder uses RuntimeClass standard-runc and mounts logbook at /data
set -uo pipefail

j="$(kubectl -n starfleet get pod recorder -o json 2>/dev/null || true)"
[ -n "$j" ] || { echo "FAIL: pod recorder does not exist in starfleet"; exit 1; }
[ "$(echo "$j" | jq -r .spec.runtimeClassName)" = "standard-runc" ] || { echo "FAIL: runtimeClassName is not standard-runc"; exit 1; }
[ "$(echo "$j" | jq -r '[.spec.volumes[]? | select(.persistentVolumeClaim.claimName=="logbook")] | length')" = "1" ] || { echo "FAIL: the pod does not use the claim logbook"; exit 1; }
[ "$(echo "$j" | jq -r '[.spec.containers[0].volumeMounts[]? | select(.mountPath=="/data")] | length')" = "1" ] || { echo "FAIL: nothing is mounted at /data"; exit 1; }
echo "PASS: pod recorder is defined correctly"
