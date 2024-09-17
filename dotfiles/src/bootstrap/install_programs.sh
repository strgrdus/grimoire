# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt-get update && sudo apt-get upgrade -y

# Check if the update and upgrade were successful
if [ $? -eq 0 ]; then
    echo "System update and upgrade completed successfully."
else
    echo "Error: System update and upgrade failed. Please check your internet connection and try again."
    exit 1
fi


# Install jq if not already installed
if ! command -v jq &> /dev/null; then
    echo "Installing jq..."
    sudo apt-get update
    sudo apt-get install -y jq
else
    echo "jq is already installed."
fi
# Install redshift if not already installed
if ! command -v redshift &> /dev/null; then
    echo "Installing redshift..."
    sudo apt-get update
    sudo apt-get install -y redshift
else
    echo "redshift is already installed."
fi

# Install evtest if not already installed
if ! command -v evtest &> /dev/null; then
    echo "Installing evtest..."
    sudo apt-get update
    sudo apt-get install -y evtest
else
    echo "evtest is already installed."
fi

# Install udevmon if not already installed
if ! command -v udevmon &> /dev/null; then
    echo "Installing udevmon..."
    sudo apt-get update
    sudo apt-get install -y interception-tools
    if [ $? -eq 0 ]; then
        echo "udevmon (interception-tools) installed successfully."
    else
        echo "Error: Failed to install udevmon (interception-tools). Please check your internet connection and try again."
        exit 1
    fi
else
    echo "udevmon is already installed."
fi
