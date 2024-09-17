#!/bin/bash

exec > >(tee -a "/tmp/remap-truly-ergonomic.log") 2>&1
echo "Script started at $(date)"

set -euo pipefail

KEYBOARD_NAME="TrulyErgonomic.com Truly Ergonomic CLEAVE Keyboard"
AUTOSTART_FILE="$HOME/.config/autostart/remap-truly-ergonomic.desktop"

# Function to create or update remap script
update_remap_script() {
    local REMAP_SCRIPT="$HOME/.local/bin/remap-truly-ergonomic.sh"
    mkdir -p "$(dirname "$REMAP_SCRIPT")"
    
    local content="#!/bin/bash

set -x

echo 'Listing all input devices:'
xinput list

KEYBOARD_ID=\$(xinput list | grep -i 'TrulyErgonomic' | grep -oP 'id=\K\d+')

if [ -n \"\$KEYBOARD_ID\" ]; then
    echo \"Found Truly Ergonomic keyboard with ID: \$KEYBOARD_ID\"
    setxkbmap -device \$KEYBOARD_ID -option caps:end,super:escape
    echo \"Key remapping applied for Truly Ergonomic keyboard\"
else
    echo \"Truly Ergonomic keyboard not found. Available devices:\"
    xinput list
    echo \"Skipping remapping.\"
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
Exec=$HOME/.local/bin/remap-truly-ergonomic.sh
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
