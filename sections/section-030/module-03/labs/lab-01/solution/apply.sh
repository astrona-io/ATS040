#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VERSION="$(kubectl version -o json | jq -r .serverVersion.gitVersion)"
sed "s/__VERSION__/${VERSION}/" "$DIR/solution.yaml" | kubectl apply -f -
echo "[solution] Applied."
