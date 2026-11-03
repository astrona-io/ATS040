#!/usr/bin/env bash
# Starting state for the observability lab. Environment only: Prometheus that
# scrapes itself with an empty rules file, plus scout, probe and shuttle.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"

kubectl -n monitoring rollout status deployment/prometheus --timeout=180s
for name in scout probe shuttle; do
  kubectl -n starfleet rollout status "deployment/$name" --timeout=180s
done
echo "[lab] Ready."
