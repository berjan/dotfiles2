#!/bin/bash

# Remove symlinks from ~/.config and restore backup if available
if [ -d "$HOME/.config_back" ]; then
    echo "Restoring .config from backup..."
    # Remove the symlinked .config directory
    rm -rf "$HOME/.config"
    # Restore the original .config directory
    mv "$HOME/.config_back" "$HOME/.config"
else
    echo "No .config backup found. Removing symlinks only..."
    # Assuming all items in .config are symlinks from the script
    find "$HOME/.config" -type l -exec rm {} +
fi

# Restore .zshrc from backup if it exists
if [ -f "$HOME/.zshrc.backup" ]; then
    echo "Restoring .zshrc from backup..."
    rm "$HOME/.zshrc" # Remove the symlink
    mv "$HOME/.zshrc.backup" "$HOME/.zshrc"
else
    echo "No .zshrc backup found. Removing symlink if it exists..."
    [ -L "$HOME/.zshrc" ] && rm "$HOME/.zshrc" # Remove if symlink
fi

echo "Uninstallation complete."

