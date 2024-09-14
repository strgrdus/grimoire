#!/bin/bash

# Define the path to the VSCode settings file
VSCODE_SETTINGS_FILE="$HOME/.config/Code/User/settings.json"

# Ensure the directory exists
mkdir -p "$(dirname "$VSCODE_SETTINGS_FILE")"

# If the file doesn't exist, create it with an empty JSON object
[ ! -f "$VSCODE_SETTINGS_FILE" ] && echo '{}' > "$VSCODE_SETTINGS_FILE"

# Use jq to update or add the keyboard.dispatch setting
if command -v jq &> /dev/null; then
    jq '. + {"keyboard.dispatch": "keyCode"}' "$VSCODE_SETTINGS_FILE" > "$VSCODE_SETTINGS_FILE.tmp" && mv "$VSCODE_SETTINGS_FILE.tmp" "$VSCODE_SETTINGS_FILE"
    echo "VSCode settings updated successfully using jq."
else
    # Fallback method if jq is not available
    if grep -q "keyboard.dispatch" "$VSCODE_SETTINGS_FILE"; then
        sed -i 's/"keyboard.dispatch":.*/"keyboard.dispatch": "keyCode",/' "$VSCODE_SETTINGS_FILE"
    else
        sed -i '1s/^/{\n  "keyboard.dispatch": "keyCode",\n/' "$VSCODE_SETTINGS_FILE"
        echo '}' >> "$VSCODE_SETTINGS_FILE"
    fi
    echo "VSCode settings updated successfully using sed."
fi
