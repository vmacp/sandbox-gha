#!/bin/bash
set -euo pipefail

shellcheck_data="$(shellcheck -f json1 scripts/main.sh || true)"
echo "$shellcheck_data"

jq -r '.comments[] | "file=\(.file),line\(.line),endLine=\(.endLine)col=\(.column),endColumn=\(.endColumn)"' <<< "$shellcheck_data"
