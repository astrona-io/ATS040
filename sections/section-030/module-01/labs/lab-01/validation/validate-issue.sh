#!/usr/bin/env bash
# Check: the issue report.
set -uo pipefail

if ! kubectl -n starfleet get configmap issue-report >/dev/null 2>&1; then echo "FAIL: ConfigMap issue-report does not exist in starfleet"; exit 1; fi
get() { kubectl -n starfleet get configmap issue-report -o jsonpath="{.data.$1}" 2>/dev/null || true; }
[ "$(get component)" = "scout" ] || { echo "FAIL: key component is not 'scout'"; exit 1; }
[ -n "$(get observed)" ] || { echo "FAIL: key observed is missing or empty"; exit 1; }
case "$(get expected)" in
  */readyz*) ;;
  *) echo "FAIL: key expected does not mention /readyz"; exit 1 ;;
esac
echo "PASS: issue-report names scout and the expected path"

