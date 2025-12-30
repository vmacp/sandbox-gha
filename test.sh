#!/bin/bash
set -euo pipefail

shopt -s globstar nullglob
for script in scripts/**/*.sh; do
    echo "=> Linting $script through shellcheck"
    shellcheck "$script"
    echo "   Script $script ok"
done
