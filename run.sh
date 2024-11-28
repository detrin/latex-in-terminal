#!/bin/bash

set -e

VERBOSE=false
FONT_SIZE=18  # Default font size

# Parse command-line arguments
while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do
    case $1 in
        -v)
            VERBOSE=true
            ;;
        -s)
            shift
            FONT_SIZE=$1
            ;;
    esac
    shift
done

if [[ "$1" == '--' ]]; then shift; fi

LATEX_EXPRESSION=$1

if [ -z "$LATEX_EXPRESSION" ]; then
    echo "Usage: $0 [-v] [-s font_size] \"LaTeX expression\""
    exit 1
fi

# Escape LaTeX expression for URL encoding
LATEX_EXPRESSION_ENCODED=$(echo "$LATEX_EXPRESSION" | sed 's/ /+/g' | sed 's/\\/\\\\/g')

# Create a temporary file that will be automatically cleaned up on exit
IMAGE_FILENAME=$(mktemp /tmp/latex_image.XXXXXX)

cleanup() {
    if $VERBOSE; then
        echo "Cleaning up: removing $IMAGE_FILENAME"
    fi
    rm -f "$IMAGE_FILENAME"
}
trap cleanup EXIT

# Construct the POST data
POST_DATA="eq_latex=${LATEX_EXPRESSION}&eq_forecolor=Black&eq_bkcolor=White&eq_font_family=modern&eq_font=${FONT_SIZE}&eq_imformat=JPG"

# Make the POST request
RESPONSE=$(curl -s 'https://www.sciweavers.org/process_form_tex2img' \
  --data-raw "$POST_DATA")

IMAGE_ID=$(echo "$RESPONSE" | awk -F"upload/Tex2Img_" '{print $2}' | awk -F"/" '{print $1}')
IMAGE_ID=$(echo $IMAGE_ID | xargs echo -n)
if [ -z "$IMAGE_ID" ]; then
    echo "Failed to extract the image ID."
    exit 1
fi

IMAGE_URL="https://www.sciweavers.org/upload/Tex2Img_"$IMAGE_ID"/render.png"
curl -sSf -o "$IMAGE_FILENAME" "$IMAGE_URL"

if [ -f "$IMAGE_FILENAME" ]; then
    if $VERBOSE; then
        echo "Image downloaded successfully: $IMAGE_FILENAME"
    fi
    echo "$IMAGE_URL" | pbcopy
    if $VERBOSE; then
        echo "Image URL copied to clipboard: $IMAGE_URL"
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