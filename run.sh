#!/bin/bash

set -e

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [-v] \"LaTeX expression\""
    exit 1
fi

VERBOSE=false

if [ "$1" == "-v" ]; then
    VERBOSE=true
    shift  # Shift the arguments to process the LaTeX expression next
fi

LATEX_EXPRESSION=$1

# Create a temporary file that will be automatically cleaned up on exit
IMAGE_FILENAME=$(mktemp /tmp/latex_image.XXXXXX)

cleanup() {
    if $VERBOSE; then
        echo "Cleaning up: removing $IMAGE_FILENAME"
    fi
    rm -f "$IMAGE_FILENAME"
}
trap cleanup EXIT

PAYLOAD=$(jq -n --arg latex "$LATEX_EXPRESSION" \
    '{
        "auth": {"user": "guest", "password": "guest"},
        "latex": $latex,
        "resolution": 600,
        "color": "000000"
    }')

RESPONSE=$(curl -sSf 'http://latex2png.com/api/convert' \
  --header "Content-Type: application/json" \
  --data-binary "$PAYLOAD")

IMAGE_PATH=$(echo $RESPONSE | jq -r '.url')
FULL_URL="http://latex2png.com$IMAGE_PATH"

curl -sSf -o $IMAGE_FILENAME $FULL_URL

if [ -f "$IMAGE_FILENAME" ]; then
    if $VERBOSE; then
        echo "Image downloaded successfully: $IMAGE_FILENAME"
    fi
    echo $FULL_URL | pbcopy
    if $VERBOSE; then
        echo "Image URL copied to clipboard: $FULL_URL"
    fi
    
    osascript_output=$(osascript -e 'set the clipboard to (read (POSIX file "'$IMAGE_FILENAME'") as JPEG picture)' 2>&1)

    if $VERBOSE; then
        if [ -n "$osascript_output" ]; then
            echo "osascript Error Output: $osascript_output"
        fi
    fi
else
    if $VERBOSE; then
        echo "Failed to download the image."
    fi
    exit 1
fi