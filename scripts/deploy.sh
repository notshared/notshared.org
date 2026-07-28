#!/usr/bin/env bash

# Fail on error
set -eu

# Source config
SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${0}")")"

# Build site
if [[ -z "${1:-}" || -z "${2:-}" ]]; then
    printf "%s\n" "ERROR: You need to specify a remote as first argument and a port as second argument."
    exit 1
fi
cd "${SCRIPT_DIR}"/..
rm -rf ./public
hugo build --gc --minify
## Add gzip compressed files for `gzip_static`
find ./public -type f \( \
    -iname '*.html' -o \
    -iname '*.txt' -o \
    -iname '*.css' -o \
    -iname '*.xml' -o \
    -iname '*.js' -o \
    -iname '*.mjs' -o \
    -iname '*.json' -o \
    -iname '*.wasm' -o \
    -iname '*.rss' -o \
    -iname '*.atom' -o \
    -iname '*.eot' -o \
    -iname '*.ttf' -o \
    -iname '*.otf' -o \
    -iname '*.woff' -o \
    -iname '*.woff2' -o \
    -iname '*.svg' -o \
    -iname '*.ico' \
\) -exec gzip -9 -knf {} +;

# Deploy site
rsync -e "ssh -p ${2}" -r --delay-updates --delete --force -p --chmod=D0755,F0644 ./public/ "${1}"
