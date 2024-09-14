#!/bin/bash

# Function to enable natural scrolling for all touchpad devices
enable_natural_scrolling() {
    echo "Enabling natural scrolling..."
    for id in $(xinput list | grep -i touchpad | grep -o 'id=[0-9]*' | cut -d= -f2); do
        echo "Setting natural scrolling for device $id"
        xinput set-prop "$id" "libinput Natural Scrolling Enabled" 1
        echo "Current setting for device $id:"
        xinput list-props "$id" | grep "Natural Scrolling Enabled"
    done
}

# Enable natural scrolling immediately
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

echo "Natural scrolling has been enabled and set to start automatically."
echo "Autostart file contents:"
cat "$autostart_file"
