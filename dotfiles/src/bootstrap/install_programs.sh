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
