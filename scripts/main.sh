#!/bin/bash
set -euo pipefail

var='something with spaces'
echo "$var"

ls "$var"

other_var=ok
