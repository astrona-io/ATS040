#!/usr/bin/env bash
# Check: the rollout finished with 2 available replicas.
set -uo pipefail

json="$(kubectl -n orbit get deploy beacon -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: deployment beacon not found in orbit"; exit 1; fi
available="$(echo "$json" | jq -r '.status.availableReplicas // 0')"
updated="$(echo "$json" | jq -r '.status.updatedReplicas // 0')"
replicas="$(echo "$json" | jq -r '.status.replicas // 0')"
if [ "$available" -lt 2 ]; then echo "FAIL: ${available} replicas are available, expected 2"; exit 1; fi
if [ "$updated" != "$replicas" ]; then echo "FAIL: rollout is not finished (${updated} of ${replicas} updated)"; exit 1; fi
echo "PASS: ${available} replicas are available and the rollout is complete"

