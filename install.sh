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

# Symlink the _zshrc file
ln -s "$(pwd)/zsh/_zshrc" "$HOME/.zshrc"

# Check if ~/.config exists and back it up
if [ -d "$HOME/.config" ]; then
    echo "Existing .config folder found, backing up..."
    cp -rf "$HOME/.config" "$HOME/.config_back"
    rm -rf "$HOME/.config"
fi


# Define which Neovim CoC extensions should be installed
COC_EXTENSIONS="coc-css coc-eslint coc-html coc-json coc-sh coc-sql coc-tsserver coc-yaml coc-pyright"

# Cooperate Node.js with Neovim
npm install -g neovim

# Create directory for Neovim spell check dictionaries
# mkdir -p $HOME/.local/share/nvim/site/spell

# Copy Neovim dictionaries
# Adjust the source path according to where you keep your spell files
# cp -r ./spell/* $HOME/.local/share/nvim/site/spell/

# Install Vim Plug
curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim



# Additional setup for Neovim or other tools can go here
# For example, setting up Python debugger for Neovim
# Ensure you have the required setup or script for installing Python debuggers or other tools

# Create .config directory if it doesn't exist after backup
mkdir -p "$HOME/.config/nvim"

# Symlink contents of config folder to ~/.config
# Note: Adjust this if there are nested directories within config
for config in ./config/*; do
    config_name=$(basename "$config")
    ln -sf "$(pwd)/config/$config_name" "$HOME/.config/nvim/$config_name"
done

# Install Neovim extensions
nvim --headless +PlugInstall +qall

# Prepare for COC extensions installation
mkdir -p $HOME/.config/coc/extensions && \
echo '{"dependencies":{}}' > $HOME/.config/coc/extensions/package.json

# Install COC extensions
cd $HOME/.config/coc/extensions && npm install $COC_EXTENSIONS --global-style --only=prod

cd $HOME/.config/nvim/plugins/vimspector && python3 install_gadget.py --enable-python
echo "Neovim and CoC extensions setup complete."


echo "Neovim and CoC extensions setup complete."

echo "Installation and configuration complete."

