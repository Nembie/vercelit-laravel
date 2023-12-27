#!/bin/bash

INSTALL_DIR="/usr/local/bin"
SCRIPT_NAME="vercelize-laravel.sh"
SCRIPT_PATH="$INSTALL_DIR/$SCRIPT_NAME"

# Help function
show_help() {
    echo -e '🚀 Vercelize Laravel Installer 🚀\n'
    echo -e "Usage: $0 [-h] [-u] [-r]\n"
    echo "Options:"
    echo "  -h, --help       Show this help message"
    echo "  -u, --uninstall  Uninstall the Vercelize Laravel setup"
    echo "  -r, --reinstall  Reinstall, overwriting necessary files"
    exit 0
}

# Install function
install() {
    echo "🌟 Installing Vercelize Laravel script..."

    # Check if the script already exists
    if [ -e "$SCRIPT_PATH" ]; then
        echo "❌ Error: The script is already installed. Use -r or --reinstall to overwrite."
        exit 1
    fi

    # Copy the script to the installation directory
    cp vercelize-laravel.sh "$INSTALL_DIR"

    # Create a symbolic link for global access
    ln -s "$INSTALL_DIR/$SCRIPT_NAME" "$INSTALL_DIR/vercelize-laravel"

    echo "✅ Vercelize Laravel script has been installed successfully."
}

# Uninstall function
uninstall() {
    echo "🗑️ Uninstalling Vercelize Laravel script..."

    # Remove the script and symbolic link
    rm -f "$SCRIPT_PATH"
    rm -f "$INSTALL_DIR/vercelize-laravel"

    echo "✅ Vercelize Laravel script has been uninstalled successfully."
}

# Check for options
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) show_help ;;
        -u|--uninstall) uninstall; exit 0 ;;
        -r|--reinstall) reinstall=true ;;
        *) echo "❌ Unknown parameter: $1" >&2; exit 1 ;;
    esac
    shift
done

# Install or reinstall based on the option provided
if [ "$reinstall" = true ]; then
    uninstall
fi

install
