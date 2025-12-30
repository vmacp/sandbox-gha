#!/bin/bash
set -euo pipefail

while IFS= read -r script; do
    echo "Linting $script through shellcheck"
    shellcheck "$script"
    echo "Script $script ok"
done < <(find scripts -name '*.sh')
