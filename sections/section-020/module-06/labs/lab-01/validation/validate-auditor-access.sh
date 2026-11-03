#!/usr/bin/env bash
# Check: data can read Pods and Deployments but cannot change them or read Secrets
set -uo pipefail

r="$(kubectl auth can-i get pods --as data -n starfleet 2>/dev/null || true)"
[ "$r" = "yes" ] || { echo "FAIL: data get pods should be yes but is '$r'"; exit 1; }
r="$(kubectl auth can-i list deployments --as data -n starfleet 2>/dev/null || true)"
[ "$r" = "yes" ] || { echo "FAIL: data list deployments should be yes but is '$r'"; exit 1; }
r="$(kubectl auth can-i create deployments --as data -n starfleet 2>/dev/null || true)"
[ "$r" = "no" ] || { echo "FAIL: data create deployments should be no but is '$r'"; exit 1; }
r="$(kubectl auth can-i get secrets --as data -n starfleet 2>/dev/null || true)"
[ "$r" = "no" ] || { echo "FAIL: data get secrets should be no but is '$r'"; exit 1; }
echo "PASS: data can read Pods and Deployments but cannot change them or read Secrets"
