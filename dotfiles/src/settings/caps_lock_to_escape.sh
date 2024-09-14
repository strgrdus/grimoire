#!/bin/bash

# Function to remap Caps Lock to Escape
remap_caps_to_escape() {
    if ! command -v xmodmap &> /dev/null; then
        echo "xmodmap is not installed. Please install it first."
        exit 1
    fi

    xmodmap -e 'clear Lock' -e 'keycode 66 = Escape'

    # Verify the mapping
    if xmodmap -pke | grep -q 'keycode *66 = Escape'; then
        echo "Caps Lock has been successfully remapped to Escape."
    else
        echo "Failed to remap Caps Lock to Escape. Please check your system configuration."
        exit 1
    fi
}

# Function to make the change permanent
make_permanent() {
    local config_files=("$HOME/.xinitrc" "$HOME/.xprofile")
    local xmodmap_file="$HOME/.Xmodmap"

    # Create or update .Xmodmap file
    echo "clear Lock" > "$xmodmap_file"
    echo "keycode 66 = Escape" >> "$xmodmap_file"
    echo "Created/Updated $xmodmap_file"

    # Add xmodmap command to startup files
    for file in "${config_files[@]}"; do
        if [ -f "$file" ]; then
            if ! grep -q "xmodmap.*\.Xmodmap" "$file"; then
                echo "xmodmap $HOME/.Xmodmap" >> "$file"
                echo "Added xmodmap command to $file"
            else
                echo "xmodmap command already exists in $file"
            fi
        else
            echo "xmodmap $HOME/.Xmodmap" > "$file"
            echo "Created $file with xmodmap command"
        fi
    done

    echo "The Caps Lock to Escape remapping has been made permanent."
}

# Perform the remapping
remap_caps_to_escape

# Make the change permanent
make_permanent

echo "Caps Lock has been permanently remapped to Escape. The change will take effect on the next login or when X server is restarted."

# Apply the change immediately
xmodmap "$HOME/.Xmodmap"
echo "Remapping applied to current session."

