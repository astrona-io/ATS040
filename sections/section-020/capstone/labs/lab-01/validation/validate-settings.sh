#!/usr/bin/env bash
# Check: configuration comes from the ConfigMap.
set -uo pipefail

ref="$(kubectl -n orbit get deploy beacon -o jsonpath='{.spec.template.spec.containers[0].envFrom[*].configMapRef.name}' 2>/dev/null || true)"
case " $ref " in
  *" beacon-settings "*) ;;
  *) echo "FAIL: container does not use envFrom with ConfigMap beacon-settings"; exit 1 ;;
esac
pod="$(kubectl -n orbit get pods -l app=beacon -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
if [ -z "$pod" ]; then echo "FAIL: no beacon pod found"; exit 1; fi
value="$(kubectl -n orbit get pod "$pod" -o json | jq -r '.spec.containers[0].envFrom[0].configMapRef.name // empty')"
if [ -z "$value" ]; then echo "FAIL: the running pod does not carry envFrom yet; wait for the rollout"; exit 1; fi
echo "PASS: beacon reads beacon-settings through envFrom"

