#!/usr/bin/env bash
# Check: riker can create Deployments and read logs but cannot delete them or read Secrets
set -uo pipefail

r="$(kubectl auth can-i create deployments --as riker -n starfleet 2>/dev/null || true)"
[ "$r" = "yes" ] || { echo "FAIL: riker create deployments should be yes but is '$r'"; exit 1; }
r="$(kubectl auth can-i get pods/log --as riker -n starfleet 2>/dev/null || true)"
[ "$r" = "yes" ] || { echo "FAIL: riker get pods/log should be yes but is '$r'"; exit 1; }
r="$(kubectl auth can-i delete deployments --as riker -n starfleet 2>/dev/null || true)"
[ "$r" = "no" ] || { echo "FAIL: riker delete deployments should be no but is '$r'"; exit 1; }
r="$(kubectl auth can-i get secrets --as riker -n starfleet 2>/dev/null || true)"
[ "$r" = "no" ] || { echo "FAIL: riker get secrets should be no but is '$r'"; exit 1; }
echo "PASS: riker can create Deployments and read logs but cannot delete them or read Secrets"
