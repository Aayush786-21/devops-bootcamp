#!/bin/bash

# Exit if any command fails
set -e

# Usage: ./package-app.sh [app_name] [version] [source_directory]
# Defaults: app_name from package.json, version from package.json, source_directory=./

# Extract app name and version from package.json if available
if [ -f "package.json" ]; then
    APP_NAME_DEFAULT=$(grep -oP '"name":\s*"\K[^"]+' package.json 2>/dev/null | head -1 | sed 's/@.*\///' || echo "app")
    VERSION_DEFAULT=$(grep -oP '"version":\s*"\K[^"]+' package.json 2>/dev/null | head -1 | sed 's/^/v/' || echo "v1.0.0")
else
    APP_NAME_DEFAULT="app"
    VERSION_DEFAULT="v1.0.0"
fi

APP_NAME=${1:-$APP_NAME_DEFAULT}
VERSION=${2:-$VERSION_DEFAULT}
SOURCE_DIR=${3:-./}

# Normalize source directory path
SOURCE_DIR=$(realpath "${SOURCE_DIR}")

PACKAGE_NAME="${APP_NAME}-${VERSION}.tar.gz"
CHECKSUM_FILE="CHECKSUM.sha256"

# Required files or directories to validate
REQUIRED_FILES=("package.json" "src" "README.md")

# Directories to exclude (exact matches)
EXCLUDE_DIRS=(".git" "node_modules" ".nyc_output" "coverage" "lib" ".cache" ".eslintcache" ".vscode-test" ".idea" "temp" "dist")

# File patterns to exclude
EXCLUDE_PATTERNS=("*.log" "*.tgz" "*.tar.gz" "CHECKSUM.sha256" "package-app.sh")

# Validate required files or directory
for item in "${REQUIRED_FILES[@]}"
do
    if [[ ! -e "${SOURCE_DIR}/${item}" ]]; then
        echo "Error: required file/directory '${item}' missing!"
        exit 1
    fi
done

# Creating exclude flags for tar command
exclude=""
for item in "${EXCLUDE_DIRS[@]}"
do
    exclude+="--exclude=${item} "
done
for pattern in "${EXCLUDE_PATTERNS[@]}"
do
    exclude+="--exclude=${pattern} "
done

# Save current directory (where we want the package to be created)
OUTPUT_DIR=$(pwd)

# Create temporary package file outside source directory
TEMP_PACKAGE=$(mktemp --suffix=".tar.gz" --tmpdir="${OUTPUT_DIR}")

# Change to source directory and create package
cd "${SOURCE_DIR}"

# Creating package with tar (create in temp location first)
# Note: tar may warn about files changing, but this is usually safe to ignore
if ! tar -czf "${TEMP_PACKAGE}" ${exclude} . 2>/dev/null; then
    rm -f "${TEMP_PACKAGE}"
    echo "Error: failed to create package!"
    exit 1
fi

# Move temp package to final location
mv "${TEMP_PACKAGE}" "${OUTPUT_DIR}/${PACKAGE_NAME}"

# Return to output directory
cd "${OUTPUT_DIR}"

# Generate checksum
sha256sum "${PACKAGE_NAME}" >> "${CHECKSUM_FILE}"

if [[ $? -ne 0 ]]
then
    echo "Error: failed to create checksum!"
    exit 1
fi

# Print package path on success
PACKAGE_PATH=$(realpath "${PACKAGE_NAME}")
CHECKSUM_PATH=$(realpath "${CHECKSUM_FILE}")
echo "Package created at: ${PACKAGE_PATH}"
echo "Checksum file: ${CHECKSUM_PATH}"
