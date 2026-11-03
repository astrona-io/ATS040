#!/usr/bin/env bash
# Check: RuntimeClass standard-runc has the handler runc
set -uo pipefail

[ "$(kubectl get runtimeclass standard-runc -o jsonpath='{.handler}' 2>/dev/null)" = "runc" ] || { echo "FAIL: RuntimeClass standard-runc with handler runc does not exist"; exit 1; }
echo "PASS: RuntimeClass standard-runc uses handler runc"
