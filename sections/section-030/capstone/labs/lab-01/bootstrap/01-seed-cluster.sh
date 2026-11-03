#!/usr/bin/env bash
# Starting state for the community and API capstone. The beacon pods stay not ready until the learner fixes the probe.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n orbit wait --for=condition=Available deployment/beacon --timeout=5s >/dev/null 2>&1 || true
echo "[lab] Ready."

