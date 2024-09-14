#!/bin/bash

# Function to remap Caps Lock to Escape
remap_caps_to_escape() {
    # Check if xmodmap is installed
    if ! command -v xmodmap &> /dev/null; then
        echo "xmodmap is not installed. Please install it first."
        exit 1
    fi

    # Remap Caps Lock to Escape
    xmodmap -e "clear lock"
    xmodmap -e "keycode 66 = Escape"

    echo "Caps Lock has been remapped to Escape."
}

# Function to make the change permanent
make_permanent() {
    # Create a new Xmodmap file in the user's home directory
    echo "clear lock" > ~/.Xmodmap
    echo "keycode 66 = Escape" >> ~/.Xmodmap

    # Add the xmodmap command to .xinitrc to load on X server startup
    if [ -f ~/.xinitrc ]; then
        if ! grep -q "xmodmap ~/.Xmodmap" ~/.xinitrc; then
            echo "xmodmap ~/.Xmodmap" >> ~/.xinitrc
        fi
    else
        echo "xmodmap ~/.Xmodmap" > ~/.xinitrc
    fi

    # Add the xmodmap command to .xprofile for display managers
    if [ -f ~/.xprofile ]; then
        if ! grep -q "xmodmap ~/.Xmodmap" ~/.xprofile; then
            echo "xmodmap ~/.Xmodmap" >> ~/.xprofile
        fi
    else
        echo "xmodmap ~/.Xmodmap" > ~/.xprofile
    fi

    echo "The Caps Lock to Escape remapping has been made permanent."
}

# Perform the remapping
remap_caps_to_escape

# Make the change permanent
make_permanent

echo "Caps Lock has been permanently remapped to Escape. The change will take effect on the next login or when X server is restarted."

