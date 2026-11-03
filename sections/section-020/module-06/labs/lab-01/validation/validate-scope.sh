#!/usr/bin/env bash
# Check: Neither user has access in the namespace default
set -uo pipefail

r="$(kubectl auth can-i get pods --as riker -n default 2>/dev/null || true)"
[ "$r" = "no" ] || { echo "FAIL: riker get pods should be no but is '$r'"; exit 1; }
r="$(kubectl auth can-i get pods --as data -n default 2>/dev/null || true)"
[ "$r" = "no" ] || { echo "FAIL: data get pods should be no but is '$r'"; exit 1; }
echo "PASS: Neither user has access in the namespace default"
