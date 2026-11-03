#!/usr/bin/env bash
# Check: the source ConfigMap and scout were not changed.
set -uo pipefail

v="$(kubectl -n starfleet get configmap legacy-manifests -o jsonpath='{.data.pdb\.yaml}' 2>/dev/null || true)"
case "$v" in
  *"policy/v1beta1"*) ;;
  *) echo "FAIL: the ConfigMap legacy-manifests was edited or deleted"; exit 1 ;;
esac
img="$(kubectl -n starfleet get deploy scout -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null || true)"
[ "$img" = "ghcr.io/stefanprodan/podinfo:6.15.0" ] || { echo "FAIL: the scout image was changed"; exit 1; }
cpu="$(kubectl -n starfleet get deploy scout -o jsonpath='{.spec.template.spec.containers[0].resources.requests.cpu}' 2>/dev/null || true)"
[ "$cpu" = "100m" ] || { echo "FAIL: the scout CPU request was changed"; exit 1; }
echo "PASS: legacy-manifests and scout are unchanged"

