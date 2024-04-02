#!/bin/bash

# Ensure the script is executed with superuser privileges on Debian-based systems
if [ "$(id -u)" -ne 0 ] && [ -f /etc/debian_version ]; then
  echo "This script must be run as root on Debian-based systems" 1>&2
  exit 1
fi

# Function to install Node.js and npm on Debian-based systems
install_node_debian() {
    curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
    apt-get install -y nodejs
}

# Function to install Node.js and npm on macOS
install_node_mac() {
    brew install node
}

# Check if Node.js and npm are installed, install them if not
if ! command -v node > /dev/null 2>&1 || ! command -v npm > /dev/null 2>&1; then
    echo "Node.js or npm not found, installing..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        . /etc/os-release
        if [[ "$ID" == "debian" || "$ID_LIKE" == "debian" ]]; then
            install_node_debian
        else
            echo "Unsupported Linux distribution for this script."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        install_node_mac
    else
        echo "Unsupported operating system."
        exit 1
    fi
fi
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

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    echo "Backing up existing .zshrc to .zshrc.backup"
    mv "$HOME/.zshrc" "$HOME/.zshrc.backup"
fi

# Symlink the _zshrc file
ln -s "$(pwd)/zsh/_zshrc" "$HOME/.zshrc"

# Define Neovim CoC extensions to be installed
COC_EXTENSIONS="coc-css coc-eslint coc-html coc-json coc-sh coc-sql coc-tsserver coc-yaml coc-pyright"

# Function to install Neovim on Debian-based systems from source
install_neovim_debian() {
    mkdir -p /root/TMP
    cd /root/TMP && git clone https://github.com/neovim/neovim
    cd /root/TMP/neovim && git checkout stable && make -j4 && make install
    rm -rf /root/TMP
}

# Function to install Neovim on macOS with Homebrew
install_neovim_mac() {
    brew install neovim
}

# Check if Neovim is installed, install if not
if ! command -v nvim > /dev/null 2>&1; then
    echo "Neovim not found, installing..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        . /etc/os-release
        if [[ "$ID" == "debian" || "$ID_LIKE" == "debian" ]]; then
            install_neovim_debian
        else
            echo "Unsupported Linux distribution for Neovim installation from this script."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        install_neovim_mac
    else
        echo "Unsupported operating system."
        exit 1
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
    cp -rf "$HOME/.config" "$HOME/.config_back"
    rm -rf "$HOME/.config"
fi


# Create .config directory if it doesn't exist after backup
mkdir -p "$HOME/.config"

# Symlink contents of config folder to ~/.config
# Note: Adjust this if there are nested directories within config
for config in ./config/*; do
    config_name=$(basename "$config")
    ln -s "$(pwd)/config/$config_name" "$HOME/.config/$config_name"
done

echo "Installation and configuration complete."
