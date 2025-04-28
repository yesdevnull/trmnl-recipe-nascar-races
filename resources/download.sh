#!/usr/bin/env bash
#
# download - Simple downloader that always constructs the filename from the URL
# Source: https://github.com/simonw/git-scraper-template/blob/main/download.sh

set -e

URL="https://www.nascar.com/nascar-cup-series/2025/schedule/"

# Create temporary file
TEMP_FILE=$(mktemp)

USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3 Safari/605.1.15"

# Download the file
echo "Downloading $URL"
curl -A "${USER_AGENT}" -s -L "$URL" -o "$TEMP_FILE" || {
  echo "Error: Failed to download $URL"
  rm -f "$TEMP_FILE"
  exit 1
}

# Add extension to the filename
FILENAME="source_2025_schedule.json"

# Get the current directory to ensure we save to this location
CURRENT_DIR="$(pwd)"
FULL_PATH="${CURRENT_DIR}/resources/${FILENAME}"

sed -nE 's/var scheduledData = (.+);/\1/p' "${TEMP_FILE}" | jq ".response" > "${FULL_PATH}"
