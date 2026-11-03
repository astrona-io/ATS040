#!/usr/bin/env bash
# Check: PersistentVolumeClaim logbook requests 100Mi, ReadWriteOnce, StorageClass standard
set -uo pipefail

j="$(kubectl -n starfleet get pvc logbook -o json 2>/dev/null || true)"
[ -n "$j" ] || { echo "FAIL: PVC logbook does not exist in starfleet"; exit 1; }
[ "$(echo "$j" | jq -r .spec.resources.requests.storage)" = "100Mi" ] || { echo "FAIL: the request is not 100Mi"; exit 1; }
[ "$(echo "$j" | jq -r '.spec.accessModes[0]')" = "ReadWriteOnce" ] || { echo "FAIL: the access mode is not ReadWriteOnce"; exit 1; }
[ "$(echo "$j" | jq -r .spec.storageClassName)" = "standard" ] || { echo "FAIL: the StorageClass is not standard"; exit 1; }
echo "PASS: PVC logbook is defined correctly"
