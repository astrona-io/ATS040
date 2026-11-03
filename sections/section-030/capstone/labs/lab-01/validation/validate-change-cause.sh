#!/usr/bin/env bash
# Check: the change is explained and has a new revision.
set -uo pipefail

json="$(kubectl -n orbit get deploy beacon -o json 2>/dev/null || true)"
if [ -z "$json" ]; then echo "FAIL: deployment beacon not found in orbit"; exit 1; fi
cause="$(echo "$json" | jq -r '.metadata.annotations["kubernetes.io/change-cause"] // empty')"
revision="$(echo "$json" | jq -r '.metadata.annotations["deployment.kubernetes.io/revision"] // "0"')"
if [ "${#cause}" -lt 10 ]; then echo "FAIL: annotation kubernetes.io/change-cause is missing or shorter than 10 characters"; exit 1; fi
if [ "$revision" -lt 2 ]; then echo "FAIL: deployment is still on revision ${revision}; the fix must roll out a new revision"; exit 1; fi
echo "PASS: change-cause is set and the revision is ${revision}"

