#!/usr/bin/env bash
# Check: requests and a memory limit.
set -uo pipefail

res="$(kubectl -n orbit get deploy beacon -o jsonpath='{.spec.template.spec.containers[0].resources}' 2>/dev/null || true)"
if [ -z "$res" ]; then echo "FAIL: deployment beacon not found or has no resources"; exit 1; fi
for field in '.requests.cpu' '.requests.memory' '.limits.memory'; do
  value="$(echo "$res" | jq -r "$field // empty")"
  if [ -z "$value" ]; then echo "FAIL: resources${field} is not set"; exit 1; fi
done
echo "PASS: requests and the memory limit are set"

