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

if ! command -v direnv &> /dev/null; then
    echo "Installing direnv..."
    curl -sfL https://direnv.net/install.sh | bash
    if [ $? -eq 0 ]; then
        echo "direnv installed successfully."
    else
        echo "Error: Failed to install direnv. Please check your internet connection and try again."
        exit 1
    fi
else
    echo "direnv is already installed."
fi

# Install Rust if not already installed
if ! command -v rustc &> /dev/null; then
    echo "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    if [ $? -eq 0 ]; then
        echo "Rust installed successfully."
        # Add Rust to the PATH for the current session
        export PATH="$HOME/.cargo/bin:$PATH"
        source "$HOME/.cargo/env"
    else
        echo "Error: Failed to install Rust. Please check your internet connection and try again."
        exit 1
    fi
else
    echo "Rust is already installed."
fi

# Ensure Cargo is available
if ! command -v cargo &> /dev/null; then
    echo "Cargo not found. Attempting to set up Rust environment..."
    export PATH="$HOME/.cargo/bin:$PATH"
    source "$HOME/.cargo/env"
    if ! command -v cargo &> /dev/null; then
        echo "Error: Cargo still not available. Please restart your shell or run 'source $HOME/.cargo/env' manually."
        exit 1
    fi
fi

echo "Rust and Cargo are now available."

