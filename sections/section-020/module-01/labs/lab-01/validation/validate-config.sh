#!/usr/bin/env bash
# Check: the message comes from the ConfigMap, not from an inline value.
set -uo pipefail

if ! kubectl -n starfleet get configmap scout-config >/dev/null 2>&1; then echo "FAIL: ConfigMap scout-config does not exist"; exit 1; fi
tpl="$(kubectl -n starfleet get deployment scout -o json 2>/dev/null || true)"
inline="$(printf '%s' "$tpl" | jq -r '[.spec.template.spec.containers[0].env[]? | select(.name=="PODINFO_UI_MESSAGE") | .value // empty] | length')"
if [ "$inline" != "0" ]; then echo "FAIL: PODINFO_UI_MESSAGE is still set with an inline value"; exit 1; fi
from_env="$(printf '%s' "$tpl" | jq -r '[.spec.template.spec.containers[0].envFrom[]? | select(.configMapRef.name=="scout-config")] | length')"
from_key="$(printf '%s' "$tpl" | jq -r '[.spec.template.spec.containers[0].env[]? | select(.valueFrom.configMapKeyRef.name=="scout-config")] | length')"
if [ "$from_env" = "0" ] && [ "$from_key" = "0" ]; then echo "FAIL: the Deployment does not read the ConfigMap scout-config"; exit 1; fi
echo "PASS: scout reads its message from scout-config"

