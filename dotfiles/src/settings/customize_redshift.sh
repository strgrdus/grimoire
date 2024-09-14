#!/bin/bash

# Define the configuration directory and file path
CONFIG_DIR="$HOME/.config/redshift"
CONFIG_FILE="$CONFIG_DIR/redshift.conf"

# Create the configuration directory if it doesn't exist
if [ ! -d "$CONFIG_DIR" ]; then
    mkdir -p "$CONFIG_DIR"
    echo "Created directory: $CONFIG_DIR"
fi

# Create the redshift.conf file and add the settings to focus on blue light reduction
cat <<EOL > "$CONFIG_FILE"
[redshift]
temp-day=4500        # Daytime color temperature (in Kelvin, slight reduction in blue light)
temp-night=3000      # Nighttime color temperature (in Kelvin, further reduction in blue light)
transition=1         # Smooth transition between day and night
brightness-day=1.0   # No brightness adjustment during the day
brightness-night=1.0 # No brightness adjustment at night
gamma=1.0:0.9:0.8    # Adjust gamma for R:G:B to reduce blue light

; Use the Geoclue2 provider to automatically determine your location
location-provider=manual

; Manual location settings (Dallas, Texas)
[manual]
lat=32.7767
lon=-96.7970
EOL

echo "Redshift configuration created at: $CONFIG_FILE"
~
