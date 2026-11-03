#!/usr/bin/env bash
# Check: RoleBindings bind developer to riker and auditor to data
set -uo pipefail

a="$(kubectl -n starfleet get rolebinding developer-riker -o jsonpath='{.roleRef.name}/{.subjects[0].kind}/{.subjects[0].name}' 2>/dev/null || true)"
[ "$a" = "developer/User/riker" ] || { echo "FAIL: developer-riker is '$a'"; exit 1; }
b="$(kubectl -n starfleet get rolebinding auditor-data -o jsonpath='{.roleRef.name}/{.subjects[0].kind}/{.subjects[0].name}' 2>/dev/null || true)"
[ "$b" = "auditor/User/data" ] || { echo "FAIL: auditor-data is '$b'"; exit 1; }
echo "PASS: RoleBindings bind developer to riker and auditor to data"
