#!/bin/bash

# Function to enable natural scrolling for touchpads and reverse scrolling for mice
enable_natural_scrolling() {
    echo "Configuring scrolling..."
    for id in $(xinput list | grep -E 'touchpad|mouse' | grep -o 'id=[0-9]*' | cut -d= -f2); do
        device_name=$(xinput list --name-only $id)
        echo "Configuring device: $device_name (ID: $id)"
        
        if echo "$device_name" | grep -qi "touchpad"; then
            xinput set-prop "$id" "libinput Natural Scrolling Enabled" 1
            echo "Enabled natural scrolling for touchpad: $device_name"
        elif echo "$device_name" | grep -qi "mouse"; then
            xinput set-button-map "$id" 1 2 3 5 4 6 7 8 9 10 11 12
            echo "Reversed scroll wheel for mouse: $device_name"
        fi
        
        echo "---"
    done
}

# Apply settings immediately
enable_natural_scrolling

# Make changes persistent
autostart_dir="$HOME/.config/autostart"
autostart_file="$autostart_dir/natural_scroll.desktop"

mkdir -p "$autostart_dir"

cat << EOF > "$autostart_file"
[Desktop Entry]
Type=Application
Name=Natural Scrolling
Exec=bash -c '$(declare -f enable_natural_scrolling); enable_natural_scrolling'
Hidden=false
X-GNOME-Autostart-enabled=true
EOF

echo "Scrolling configuration has been set and will start automatically."
echo "Autostart file contents:"
cat "$autostart_file"
