#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
kubectl apply -f "$DIR/solution.yaml"
kubectl wait --for=condition=Established crd/sensors.fleet.example.com --timeout=60s
# The API server needs a moment to serve the new kind.
for i in $(seq 1 30); do
  kubectl -n starfleet apply -f "$DIR/sensor.yaml" && break
  sleep 2
done
echo "[solution] Applied."

