#!/usr/bin/env bash
# Check: Roles developer and auditor exist in starfleet
set -uo pipefail

kubectl -n starfleet get role developer >/dev/null 2>&1 || { echo "FAIL: Role developer does not exist"; exit 1; }
kubectl -n starfleet get role auditor >/dev/null 2>&1 || { echo "FAIL: Role auditor does not exist"; exit 1; }
echo "PASS: Roles developer and auditor exist in starfleet"
