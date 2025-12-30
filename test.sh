#!/bin/bash
set -euo pipefail

shopt -s globstar nullglob
status=0
declare -a unclean_scripts
for script in scripts/**/*.sh; do
    echo "=> Linting $script through shellcheck"
    if shellcheck "$script"; then
        echo "   Script $script ok"
    else
        status=1
        unclean_scripts+=($script)
        echo "::error file=${script}::Shellcheck error on file ${script}"
    fi
done
if [[ status -eq 1 ]]; then
    echo "The following scripts dont pass shellckeck: ${unclean_scripts[*]}"
    exit 1
fi
