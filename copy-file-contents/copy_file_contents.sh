#!/bin/bash

# copy-file-contents.sh
# Copies the contents of specified files to the clipboard in a formatted manner.
# Usage: ./copy-file-contents.sh file1.py file2.cpp file3.txt

# Function to display usage information
usage() {
    echo "Usage: $0 file1 [file2 ...]"
    exit 1
}

# Check if at least one argument is provided
if [ $# -eq 0 ]; then
    usage
fi

# Function to detect available clipboard command
get_clipboard_cmd() {
    if command -v wl-copy >/dev/null 2>&1; then
        echo "wl-copy"
    elif command -v xclip >/dev/null 2>&1; then
        echo "xclip -selection clipboard"
    elif command -v xsel >/dev/null 2>&1; then
        echo "xsel --clipboard --input"
    else
        echo ""
    fi
}

# Retrieve the clipboard command
CLIP_CMD=$(get_clipboard_cmd)

# If no clipboard utility is found, prompt the user to install one
if [ -z "$CLIP_CMD" ]; then
    echo "Error: No clipboard utility found. Please install one of the following:"
    echo "  - wl-clipboard (wl-copy)"
    echo "  - xclip"
    echo "  - xsel"
    exit 1
fi

# Initialize a flag to track if any files are successfully processed
success=false

# Generate the formatted output and pipe it to the clipboard command
{
    for file in "$@"; do
        if [ ! -f "$file" ]; then
            echo "Warning: File not found or is not a regular file: $file" >&2
            continue
        fi
        echo "---"
        echo "$file:"
        echo '```'
        cat "$file"
        echo '```'
        success=true
    done
} | $CLIP_CMD

# Notify the user of the result
if $success; then
    echo "File contents have been copied to the clipboard."
else
    echo "No valid files were processed. Clipboard not updated." >&2
    exit 1
fi