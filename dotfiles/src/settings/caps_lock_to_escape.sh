#!/bin/bash

exec > >(tee -a "/tmp/remap-laptop-keyboard.log") 2>&1
echo "Script started at $(date)"

set -euo pipefail

KEYBOARD_NAME="AT Translated Set 2 keyboard"
AUTOSTART_FILE="$HOME/.config/autostart/remap-laptop-keyboard.desktop"

# Function to create or update remap script
update_remap_script() {
    local REMAP_SCRIPT="$HOME/.local/bin/remap-laptop-keyboard.sh"
    mkdir -p "$(dirname "$REMAP_SCRIPT")"
    
    local content="#!/bin/bash

set -x

# Get the id of the keyboard
KEYBOARD_ID=\$(xinput list --id-only \"$KEYBOARD_NAME\")

if [ -n \"\$KEYBOARD_ID\" ]; then
    # Remap Caps Lock to Escape for the specific keyboard
    setxkbmap -device \$KEYBOARD_ID -option caps:escape

    echo \"Caps Lock remapped to Escape for $KEYBOARD_NAME (ID: \$KEYBOARD_ID)\"
else
    echo \"Keyboard '$KEYBOARD_NAME' not found\"
fi
"

    echo "$content" > "$REMAP_SCRIPT"
    chmod +x "$REMAP_SCRIPT"
    echo "Updated $REMAP_SCRIPT"
    
    # Execute the new script immediately
    echo "Executing the updated script..."
    bash "$REMAP_SCRIPT"
}

# Function to create or update autostart entry
update_autostart() {
    local content="[Desktop Entry]
Type=Application
Name=Remap Laptop Keyboard Caps Lock to Escape
Exec=$HOME/.local/bin/remap-laptop-keyboard.sh
StartupNotify=false
Terminal=false"

    mkdir -p "$(dirname "$AUTOSTART_FILE")"
    
    if [[ ! -f "$AUTOSTART_FILE" ]] || [[ "$(cat "$AUTOSTART_FILE")" != "$content" ]]; then
        echo "$content" > "$AUTOSTART_FILE"
        chmod +x "$AUTOSTART_FILE"
        echo "Updated $AUTOSTART_FILE"
    else
        echo "$AUTOSTART_FILE is already up to date"
    fi
}

# Main execution
update_remap_script
update_autostart

echo "Caps Lock to Escape remapping configuration is complete for $KEYBOARD_NAME"

