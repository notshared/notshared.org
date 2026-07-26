#!/usr/bin/env bash

# Fail on error
set -eu

# Source config
SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${0}")")"

# Build and deploy
if [[ -z "${1:-}" || -z "${2:-}" ]]; then
    printf "%s\n" "ERROR: You need to specify a remote as first argument and a port as second argument."
    exit 1
fi
cd "${SCRIPT_DIR}"/..
rm -rf ./public
hugo build --gc --minify
rsync -e "ssh -p ${2}" -r --delay-updates --delete --force -p --chmod=D0755,F0644 ./public/ "${1}"
