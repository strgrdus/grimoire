#!/bin/bash

exec > >(tee -a "/tmp/remap-truly-ergonomic.log") 2>&1
echo "Script started at $(date)"

set -euo pipefail

AUTOSTART_FILE="$HOME/.config/autostart/remap-truly-ergonomic.desktop"

# Function to create or update remap script
update_remap_script() {
    local REMAP_SCRIPT="$HOME/.local/bin/remap-truly-ergonomic.sh"
    mkdir -p "$(dirname "$REMAP_SCRIPT")"
    
    local content="#!/bin/bash

set -x

echo 'Listing all input devices:'
xinput list

# Look for the Truly Ergonomic CLEAVE Keyboard
KEYBOARD_ID=\$(xinput list | grep -i 'TrulyErgonomic.com Truly Ergonomic CLEAVE Keyboard' | grep -v 'Mouse' | grep -v 'Consumer Control' | grep -v 'System Control' | grep -oP 'id=\K\d+' | head -n 1)

echo \"Debug: KEYBOARD_ID=\$KEYBOARD_ID\"

if [ -n \"\$KEYBOARD_ID\" ]; then
    echo \"Found Truly Ergonomic keyboard with ID: \$KEYBOARD_ID\"
    setxkbmap -device \$KEYBOARD_ID -option super_l:escape,end:super_l
    echo \"Key remapping applied for Truly Ergonomic keyboard\"
else
    echo \"Truly Ergonomic keyboard not found. Available devices:\"
    xinput list
    echo \"Attempting to find alternative keyboard...\"
    KEYBOARD_ID=\$(xinput list | grep -i 'keyboard' | grep -v 'Virtual' | grep -v 'Consumer Control' | grep -v 'System Control' | grep -oP 'id=\K\d+' | head -n 1)
    if [ -n \"\$KEYBOARD_ID\" ]; then
        echo \"Found alternative keyboard with ID: \$KEYBOARD_ID\"
        setxkbmap -device \$KEYBOARD_ID -option super_l:escape,end:super_l
        echo \"Key remapping applied for alternative keyboard\"
    else
        echo \"No suitable keyboard found. Skipping remapping.\"
    fi
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
