# Define colors
RESET="%f"
GREEN="%F{green}"
CYAN="%F{cyan}"
RED="%F{red}"

# Function to get Git branch
git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Set the prompt
PROMPT="${GREEN}%n@%m${RESET}:${CYAN}%~${RESET} ${RED}\$(git_branch)${RESET}"$'\n'"└─ %# "

# Set the prompt
setopt PROMPT_SUBST
