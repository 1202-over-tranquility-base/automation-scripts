#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Function to display usage instructions
usage() {
    echo "Usage: $0 <app_name> <path/to/app.AppImage> <path/to/logo.png|jpg>"
    exit 1
}

# Prevent the script from being run with sudo
if [ "$EUID" -eq 0 ]; then
    echo "Error: Do not run this script with sudo."
    echo "Please run it as a regular user."
    exit 1
fi

# Check if exactly three arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Error: Incorrect number of arguments."
    usage
fi

# Assign arguments to variables
APP_NAME="$1"
APP_IMAGE_PATH="$2"
LOGO_PATH="$3"

# Define target directories
PROGRAM_FILES_DIR="$HOME/program-files/$APP_NAME"
DESKTOP_DIR="$HOME/.local/share/applications"

# Function to check file existence in both original and target directories
check_file() {
    local file_path="$1"
    local target_dir="$2"
    local file_name
    file_name=$(basename "$file_path")

    if [ -f "$file_path" ]; then
        echo "$file_path"
    elif [ -f "$target_dir/$file_name" ]; then
        echo "$target_dir/$file_name"
    else
        echo ""
    fi
}

# Check AppImage
APP_IMAGE_FULL_PATH=$(check_file "$APP_IMAGE_PATH" "$PROGRAM_FILES_DIR")
if [ -z "$APP_IMAGE_FULL_PATH" ]; then
    echo "Error: AppImage file '$APP_IMAGE_PATH' does not exist in the original or target directory."
    exit 1
fi

# Check Logo
LOGO_FULL_PATH=$(check_file "$LOGO_PATH" "$PROGRAM_FILES_DIR")
if [ -z "$LOGO_FULL_PATH" ]; then
    echo "Error: Logo file '$LOGO_PATH' does not exist in the original or target directory."
    exit 1
fi

# Extract logo extension and ensure it's png or jpg/jpeg
LOGO_EXTENSION="${LOGO_PATH##*.}"
LOGO_EXTENSION_LOWER=$(echo "$LOGO_EXTENSION" | tr '[:upper:]' '[:lower:]')

if [[ "$LOGO_EXTENSION_LOWER" != "png" && "$LOGO_EXTENSION_LOWER" != "jpg" && "$LOGO_EXTENSION_LOWER" != "jpeg" ]]; then
    echo "Error: Logo file must be a .png or .jpg/.jpeg"
    exit 1
fi

# Create necessary directories
mkdir -p "$PROGRAM_FILES_DIR"
mkdir -p "$DESKTOP_DIR"

# Move AppImage to program-files directory if it's not already there
if [ "$(dirname "$APP_IMAGE_FULL_PATH")" != "$PROGRAM_FILES_DIR" ]; then
    mv "$APP_IMAGE_PATH" "$PROGRAM_FILES_DIR/"
    APP_IMAGE_FULL_PATH="$PROGRAM_FILES_DIR/$(basename "$APP_IMAGE_PATH")"
    echo "Moved AppImage to $PROGRAM_FILES_DIR/"
fi

# Move the logo if it's not already in the target directory
if [ "$(dirname "$LOGO_FULL_PATH")" != "$PROGRAM_FILES_DIR" ]; then
    mv "$LOGO_PATH" "$PROGRAM_FILES_DIR/"
    LOGO_FULL_PATH="$PROGRAM_FILES_DIR/$(basename "$LOGO_PATH")"
    echo "Moved logo to $LOGO_FULL_PATH"
fi

# Make the AppImage executable
chmod +x "$APP_IMAGE_FULL_PATH"

# Define Exec and Icon paths for desktop entry
EXEC_PATH="$APP_IMAGE_FULL_PATH"
ICON_PATH="$LOGO_FULL_PATH"

# **New Addition: Check Write Permission to DESKTOP_DIR**
if [ ! -w "$DESKTOP_DIR" ]; then
    echo "Error: Cannot write to '$DESKTOP_DIR'."
    echo "Please ensure you have the correct permissions by running:"
    echo "  sudo chown -R \"$USER\":\"$USER\" \"$DESKTOP_DIR\""
    exit 1
fi

# Create the desktop entry
DESKTOP_FILE="$DESKTOP_DIR/${APP_NAME}.desktop"

# Check if desktop file already exists
if [ -f "$DESKTOP_FILE" ]; then
    echo "Desktop entry '$DESKTOP_FILE' already exists. Overwriting..."
fi

# Attempt to create the desktop entry
if ! cat > "$DESKTOP_FILE" << EOL
[Desktop Entry]
Encoding=UTF-8
Version=1.0
Type=Application
Name=$APP_NAME
Comment=$APP_NAME Application
Exec="$EXEC_PATH" %U
Icon="$ICON_PATH"
Terminal=false
Categories=Utility;Application;
EOL
then
    echo "Error: Failed to create desktop entry at '$DESKTOP_FILE'."
    echo "You might not have the necessary permissions."
    echo "Please ensure you have write access to '$DESKTOP_DIR' by running:"
    echo "  sudo chown -R \"$USER\":\"$USER\" \"$DESKTOP_DIR\""
    exit 1
fi

# Make the desktop entry executable
chmod +x "$DESKTOP_FILE"

echo "Setup completed successfully for '$APP_NAME'."
echo "Desktop entry created at '$DESKTOP_FILE'."
