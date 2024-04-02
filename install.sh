#!/bin/bash

# Function to install zsh on Debian-based systems
install_zsh_debian() {
    sudo apt update && sudo apt install zsh -y
}

# Function to install zsh on macOS
install_zsh_mac() {
    brew install zsh
}

# Check for zsh and install if not present
if ! command -v zsh &> /dev/null; then
    echo "zsh could not be found, installing..."
    # Detect OS and install zsh accordingly
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        . /etc/os-release
        if [[ "$ID" == "debian" || "$ID_LIKE" == "debian" ]]; then
            install_zsh_debian
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        install_zsh_mac
    fi
fi

# Check for Oh My Zsh and install if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Oh My Zsh not found, installing..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Check if ~/.config exists and back it up
if [ -d "$HOME/.config" ]; then
    echo "Existing .config folder found, backing up..."
    mv "$HOME/.config" "$HOME/.config_back"
fi

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    echo "Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Symlink the _zshrc file
ln -s "$(pwd)/zsh/_zshrc" "$HOME/.zshrc"

# Create .config directory if it doesn't exist after backup
mkdir -p "$HOME/.config"

# Symlink contents of config folder to ~/.config
# Note: Adjust this if there are nested directories within config
for config in ./config/*; do
    config_name=$(basename "$config")
    ln -s "$(pwd)/config/$config_name" "$HOME/.config/$config_name"
done

echo "Installation and configuration complete."
