# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
RESET='\033[0m'

# ASCII art with tribal designs
echo -e "${RED}"
echo "  /\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\/\\"
echo " <><><><><><><><><><><><><><><><><><><><><><><><><>"
echo -e "${CYAN}"
echo "  ___       _ _   _       _ _     _             "
echo " |_ _|_ __ (_) |_(_) __ _| (_)___(_)_ __   __ _ "
echo "  | || '_ \| | __| |/ _\` | | |_  / | '_ \ / _\` |"
echo "  | || | | | | |_| | (_| | | |/ /| | | | | (_| |"
echo " |___|_| |_|_|\__|_|\__,_|_|_/___|_|_| |_|\__, |"
echo "  ____  _              ____                     _ "
echo " / ___|| |_ __ _ _ __ / ___|_   _  __ _ _ __ __| |"
echo " \___ \| __/ _\` | '__| |  _| | | |/ _\` | '__/ _\` |"
echo "  ___) | || (_| | |  | |_| | |_| | (_| | | | (_| |"
echo " |____/ \__\__,_|_|   \____|\__,_|\__,_|_|  \__,_|"
echo "                                                  "
echo " |  _ \  ___ | |_ / _(_) | ___  ___ "
echo " | | | |/ _ \| __| |_| | |/ _ \/ __|"
echo " | |_| | (_) | |_|  _| | |  __/\__ \\"
echo " |____/ \___/ \__|_| |_|_|\___||___/"
echo -e "${YELLOW}"
echo " <><><><><><><><><><><><><><><><><><><><><><><><><>"
echo "  \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/"
echo -e "${RESET}"

# Run all bootstrap scripts
echo -e "${BLUE}Running bootstrap scripts...${RESET}"
for bootstrap_script in ./src/bootstrap/*.sh; do
    if [ -f "$bootstrap_script" ] && [ -x "$bootstrap_script" ]; then
        echo -e "${CYAN}Executing $bootstrap_script${RESET}"
        bash "$bootstrap_script"
    else
        echo -e "${YELLOW}Skipping $bootstrap_script (not executable or not a file)${RESET}"
    fi
done
echo -e "${GREEN}Bootstrap scripts completed${RESET}"
echo -e "${GREEN}Initializing dotfiles...${RESET}"
# Function to concatenate files
concatenate_files() {
    local shell_rc="$1"
    local file_updated=false
    
    if [ -s "$shell_rc" ]; then
        echo -e "${YELLOW}The file $shell_rc already contains content.${RESET}"
        read -p "Do you want to overwrite it? (y/n): " overwrite
        if [[ $overwrite != [Yy]* ]]; then
            echo -e "${RED}Skipping $shell_rc${RESET}"
            return
        fi
        file_updated=true
    fi
    
    echo "# Star Guard's dotfiles" > "$shell_rc"
    echo "# WARNING: This is a generated file. Do not edit directly." >> "$shell_rc"
    echo "# Make changes in the individual files in ./src/rc/ instead." >> "$shell_rc"
    for file in ./src/rc/*; do
        if [ -f "$file" ]; then
            echo "" >> "$shell_rc"
            echo "## Contents of $file" >> "$shell_rc"
            cat "$file" >> "$shell_rc"
        fi
    done
    echo -e "${CYAN}Concatenated files into $shell_rc${RESET}"
    file_updated=true

    if [ "$file_updated" = true ]; then
        read -p "Do you want to reload the updated $shell_rc? (y/n): " reload
        if [[ $reload == [Yy]* ]]; then
            echo -e "${GREEN}Reloading $shell_rc${RESET}"
            source "$shell_rc"
        else
            echo -e "${YELLOW}Skipping reload of $shell_rc${RESET}"
        fi
    fi
}

# Detect and update Bash configuration
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        concatenate_files "$HOME/.bashrc"
    elif [ -f "$HOME/.bash_profile" ]; then
        concatenate_files "$HOME/.bash_profile"
    else
        concatenate_files "$HOME/.bashrc"
    fi
fi

# Detect and update Zsh configuration
if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    concatenate_files "$HOME/.zshrc"
fi

# If neither Bash nor Zsh is detected, inform the user
if [ -z "$BASH_VERSION" ] && [ -z "$ZSH_VERSION" ] && [ ! -f "$HOME/.zshrc" ]; then
    echo -e "${RED}Neither Bash nor Zsh detected. Please run this script in Bash or Zsh.${RESET}"
fi

echo -e "${YELLOW}Loading configurations...${RESET}"
# Run all scripts in src/settings directory
if [ -d "./src/settings" ]; then
    for script in ./src/settings/*.sh; do
        if [ -f "$script" ] && [ -x "$script" ]; then
            echo -e "${CYAN}Running $script...${RESET}"
            bash "$script"
            echo -e "${GREEN}Finished running $script${RESET}"
        else
            echo -e "${YELLOW}Skipping $script (not executable or not a file)${RESET}"
        fi
    done
else
    echo -e "${YELLOW}The ./src/settings directory does not exist. Skipping configuration scripts.${RESET}"
fi

echo -e "${MAGENTA}Applying settings...${RESET}"
sleep 1
echo -e "${BLUE}Star Guard's dotfiles are ready!${RESET}"



echo -e "${MAGENTA}"
echo "    /\\\\\\//\\\\\\//\\\\\\//\\\\\\//\\\\\\//\\\\\\//\\\\"
echo "   //\\\\\\//\\\\\\//\\\\\\//\\\\\\//\\\\\\//\\\\\\//\\\\"
echo -e "${RESET}"

