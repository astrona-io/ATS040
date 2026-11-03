#!/usr/bin/env bash
# Check: scout has requests.
set -uo pipefail

res="$(kubectl -n starfleet get deploy scout -o json 2>/dev/null || true)"
if [ -z "$res" ]; then echo "FAIL: Deployment scout does not exist in starfleet"; exit 1; fi
cpu="$(printf '%s' "$res" | jq -r '.spec.template.spec.containers[] | select(.name=="scout") | .resources.requests.cpu // empty')"
mem="$(printf '%s' "$res" | jq -r '.spec.template.spec.containers[] | select(.name=="scout") | .resources.requests.memory // empty')"
if [ "$cpu" != "100m" ]; then echo "FAIL: cpu request is '${cpu}', expected 100m"; exit 1; fi
if [ "$mem" != "32Mi" ]; then echo "FAIL: memory request is '${mem}', expected 32Mi"; exit 1; fi
echo "PASS: scout requests cpu 100m and memory 32Mi"

