#!/usr/bin/env bash
# Check: nothing else changed.
set -uo pipefail

json="$(kubectl -n starfleet get deploy scout -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: Deployment scout does not exist"; exit 1; fi
c='.spec.template.spec.containers[0]'
field() { printf '%s' "$json" | jq -r "$1"; }
[ "$(field "$c.livenessProbe.httpGet.path")" = "/healthz" ] || { echo "FAIL: the liveness path was changed"; exit 1; }
[ "$(field "$c.name")" = "scout" ] || { echo "FAIL: the container name was changed"; exit 1; }
[ "$(field "$c.image")" = "ghcr.io/stefanprodan/podinfo:6.15.0" ] || { echo "FAIL: the image was changed"; exit 1; }
[ "$(field "$c.ports[0].containerPort")" = "9898" ] || { echo "FAIL: the container port was changed"; exit 1; }
[ "$(field .spec.replicas)" = "1" ] || { echo "FAIL: replicas was changed"; exit 1; }
echo "PASS: only the readiness probe changed"

