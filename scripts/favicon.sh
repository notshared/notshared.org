#!/usr/bin/env bash

# Fail on error
set -e

# Source config
SCRIPT_DIR="$(dirname -- "$(readlink -f -- "${0}")")"

# Define variables
INPUT="${SCRIPT_DIR}"/../static/images/logo.svg
if [[ ! -f "${INPUT}" ]]; then
    printf "%s\n" "ERROR: '${INPUT}' does not exist."
    exit 1
fi
OUTPUT_DIR="${SCRIPT_DIR}"/../static
## These will be exported as png
SIZES=(180 192 512)
## These will be included in .ico
SIZES_ICO="16,32,48"

# Fill FILES variable to match filenames
mkdir -p "${OUTPUT_DIR}"
for size in "${SIZES[@]}"; do
    if [[ "${size}" -eq 512 ]] || [[ "${size}" -eq 192 ]]; then
        FILES+=("${OUTPUT_DIR}"/icon-"${size}".png)
        continue
    fi
    if [[ "${size}" -eq 180 ]]; then
        FILES+=("${OUTPUT_DIR}"/apple-touch-icon.png)
        continue
    fi
done

# Convert images with inkscape and compress
SIZES_LENGTH="${#SIZES[@]}"
for ((i = 0; i < SIZES_LENGTH; i++)); do
    size="${SIZES[${i}]}"
    output="${FILES[${i}]}"
    inkscape "${INPUT}" -h "${size}" -w "${size}" -o "${output}"
    if [[ "${size}" -eq 180 ]]; then
        magick "${output}" -background white -gravity center -resize "160x160" -extent "${size}x${size}" "${output}"
    fi
    if [[ "${size}" -eq 512 ]]; then
        output_maskable="${OUTPUT_DIR}"/icon-"${size}"-maskable.png
        magick "${output}" -background none -gravity center -resize "409x409" -extent "${size}x${size}" "${output_maskable}"
        oxipng -a -s -o 4 "${output_maskable}"
    fi
    oxipng -a -s -o 4 "${output}"
done

# Create favicon.ico
magick -background none "${INPUT}" -define icon:auto-resize="${SIZES_ICO}" "${OUTPUT_DIR}"/favicon.ico

# Copy icon.svg
cp "${INPUT}" "${OUTPUT_DIR}"/favicon.svg
