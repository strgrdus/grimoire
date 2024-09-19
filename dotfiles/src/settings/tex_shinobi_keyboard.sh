#!/bin/bash

exec > >(tee -a "/tmp/remap-truly-ergonomic.log") 2>&1
echo "Script started at $(date)"

set -euo pipefail

AUTOSTART_FILE="$HOME/.config/autostart/remap-tex-shinobi.desktop"

# Function to create or update remap script
update_remap_script() {
    local REMAP_SCRIPT="$HOME/.local/bin/remap-tex-shinobi.sh"
    mkdir -p "$(dirname "$REMAP_SCRIPT")"
    
    local content="#!/bin/bash

set -x

echo 'Listing all input devices:'
xinput list

KEYBOARD_ID=20

echo \"Debug: KEYBOARD_ID=\$KEYBOARD_ID\"

# Check if the keyboard is found in xinput list and is a keyboard
if xinput list | grep -q "id=$KEYBOARD_ID.*keyboard"; then
    echo "Found TEX Shinobi keyboard with ID: $KEYBOARD_ID"
    setxkbmap -device $KEYBOARD_ID -option caps:escape
    echo "Key remapping applied for TEX Shinobi keyboard"
else
    echo "TEX Shinobi keyboard not found or not recognized as a keyboard"
    echo "Available devices:"
    xinput list
    echo \"Device not found\"
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
Name=Remap Truly Ergonomic Keyboard
Exec=$HOME/.local/bin/remap-tex-shinobi.sh
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

echo "Key remapping configuration is complete"
