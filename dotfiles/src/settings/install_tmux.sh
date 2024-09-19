#!/bin/bash

# Define the source and destination paths
SRC_DIR="$(dirname "$(readlink -f "$0")")"
TMUX_CONF="$SRC_DIR/tmux.conf"
DEST_DIR="$HOME"

# Check if the source tmux.conf file exists
if [ ! -f "$TMUX_CONF" ]; then
    echo "Error: tmux.conf not found in $SRC_DIR"
    exit 1
fi

# Create a backup of the existing .tmux.conf if it exists
if [ -f "$DEST_DIR/.tmux.conf" ]; then
    echo "Backing up existing .tmux.conf"
    mv "$DEST_DIR/.tmux.conf" "$DEST_DIR/.tmux.conf.bak"
fi

# Copy the tmux.conf to the user's home directory
echo "Installing tmux.conf to $DEST_DIR/.tmux.conf"
cp "$TMUX_CONF" "$DEST_DIR/.tmux.conf"

# Check if the copy was successful
if [ $? -eq 0 ]; then
    echo "tmux.conf has been successfully installed"
else
    echo "Error: Failed to install tmux.conf"
    exit 1
fi

# Optionally, source the new .tmux.conf if tmux is running
if tmux info &> /dev/null; then
    echo "Reloading tmux configuration"
    tmux source-file "$DEST_DIR/.tmux.conf"
fi

echo "Installation complete"
