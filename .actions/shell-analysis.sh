#!/bin/bash
set -euo pipefail
shopt -s globstar nullglob

rootdir="$1"

unclean_scripts=()

for script in "$rootdir"/**/*.sh; do
    echo "::notice file=${script}::Parsing $script through shellcheck"
    if shellcheck "$script"; then
        echo "::notice file=${script}::shellcheck - $script ok"
    else
        unclean_scripts+=("$script")
        shellcheck_data="$(shellcheck -f json1 "$script" || true)"
        exp='.comments[] | "file=\(.file),line=\(.line),endLine=\(.endLine)col=\(.column),endColumn=\(.endColumn)::\(.message)"' 
        jq -r "$exp" <<< "$shellcheck_data" | while IFS= read -r log; do
            echo "::error $log"
        done
    fi
done

if [[ ${#unclean_scripts[@]} -gt 0 ]]; then
    echo "::error::The following scripts dont pass shellckeck: ${unclean_scripts[*]}"
    exit 1
fi
