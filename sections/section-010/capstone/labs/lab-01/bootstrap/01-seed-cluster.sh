#!/usr/bin/env bash
# Starting state for the observability capstone.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n monitoring rollout status deployment/prometheus --timeout=180s
for name in beacon drifter; do
  kubectl -n orbit rollout status "deployment/$name" --timeout=180s
done
echo "[lab] Ready."

