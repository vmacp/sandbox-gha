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
        echo "::error file=${script},line=9::Shellcheck error on file ${script}"
    fi
done

if [[ ${#unclean_scripts[@]} -gt 0 ]]; then
    echo "::error::The following scripts dont pass shellckeck: ${unclean_scripts[*]}"
    exit 1
fi
