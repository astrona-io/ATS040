#!/usr/bin/env bash
# Check: The file /data/entry.txt in the pod contains recorded
set -uo pipefail

content="$(kubectl -n starfleet exec recorder -- cat /data/entry.txt 2>/dev/null || true)"
[ "$content" = "recorded" ] || { echo "FAIL: /data/entry.txt contains '${content}'"; exit 1; }
echo "PASS: /data/entry.txt contains recorded"
