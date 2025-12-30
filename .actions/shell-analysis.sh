#!/bin/bash
set -euo pipefail
shopt -s globstar nullglob

rootdir="$1"

unclean_scripts=()

gha_error_params='file=\(.file),line=\(.line),endLine=\(.endLine)col=\(.column),endColumn=\(.endColumn)'
gha_error_msg='\(.level)[\(.code)]: \(.message)'
jq_exp=".comments[] | \"${gha_error_params}::${gha_error_msg}\""

for script in "$rootdir"/**/*.sh; do
    echo "::notice file=${script}::Parsing $script through shellcheck"
    if shellcheck "$script"; then
        echo "::notice file=${script}::shellcheck - $script ok"
    else
        unclean_scripts+=("$script")
        shellcheck_data="$(shellcheck -f json1 "$script" || true)"
        jq -r "$jq_exp" <<< "$shellcheck_data" | while IFS= read -r log; do
            echo "::error $log"
        done
    fi
done

if [[ ${#unclean_scripts[@]} -gt 0 ]]; then
    echo "::error::The following scripts dont pass shellckeck: ${unclean_scripts[*]}"
    exit 1
fi
