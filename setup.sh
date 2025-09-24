#!/bin/zsh

set -e  # Exit immediately if a command exits with a non-zero status.

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
GRAY='\033[0;90m'
NC='\033[0m' # No Color


# Function to execute step and print result
execute_step() {
    local description="$1"
    local command="$3"
    local check_command="${4:-true}"

    if eval "$check_command" > /dev/null 2>&1; then

        if eval "$command" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ $description${NC}"
        else
            echo -e "${RED}✗ $description${NC}"
            return 1
        fi
    else
        echo -e "${GRAY}- $description (Skipped)${NC}"
    fi
}

setup_git() {
    echo "Setup git"
    git config --global --unset-all push.autoSetupRemote
    git config --global push.autoSetupRemote true
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}
write_fnm_to_shell() {
    cat << 'EOT' >> ~/.zshrc

    eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell zsh)"
EOT
    cat << 'EOT2' >> ~/.zshrc

    eval "$(fnm env --use-on-cd --version-file-strategy=recursive --shell bash)"
EOT2
}

# Main execution
echo "Starting setup"
echo

echo "Setup Brew"
if ! command_exists brew; then
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update

echo "Setup nfm"
if ! command_exists fnm; then
    brew install fnm
#    curl -fsSL https://fnm.vercel.app/install | bash
    write_fnm_to_shell
fi

echo "Setup node"
fnm install --arch=arm64 22.18.0
fnm default 22.18.0

source "${HOME}/.zshrc"
echo "Resetting node modules"
sudo rm -rf ./node_modules
npm install
setup_git
echo "Installing github cli"
brew install gh
echo "Setup git hooks"
npm run prepare
npm run setup:env

echo "\n${GREEN}Setup complete!${NC}"

node_version=$(node -v)
npm_version=$(npm -v)
nvm_version=$(fnm --version)

echo -e "Node.js version: ${GREEN}$node_version${NC}"
echo -e "npm version: ${GREEN}$npm_version${NC}"
echo -e "fnm version: ${GREEN}$nvm_version${NC}"
# Verify installations
echo -e "\nVerifying installations:"
echo "Please refresh your shell (source ) or reopen in order to see updates"
