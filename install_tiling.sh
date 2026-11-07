#!/usr/bin/env bash

# Exit immediately if any command fails
set -e

CHOICE="${1:-regolith}"

echo "=========================================="
echo " Starting Tiling Window Manager Installer"
echo " Target: $CHOICE"
echo "=========================================="

# Update system repositories
sudo apt update

case "$CHOICE" in
    "i3")
        echo "Installing core i3wm ecosystem..."
        # Install i3, rofi (menu), feh (wallpaper), and i3status (bottom bar)
        sudo apt install -y i3 rofi feh i3status xclip
        
        # Create default config directory path if it doesn't exist
        mkdir -p "$HOME/.config/i3"
        echo "Success! i3wm installed."
        ;;
        
    "regolith")
        echo "Registering Regolith PPA..."
        # Regolith requires adding their official package repository
        sudo add-apt-repository -y ppa:regolith-linux/release
        sudo apt update
        
        echo "Installing Regolith desktop environment..."
        sudo apt install -y regolith-desktop regolith-session-flashback
        echo "Success! Regolith installed."
        ;;
        
    *)
        echo "Error: Invalid selection. Use 'i3' or 'regolith'."
        exit 1
        ;;
esac

echo "------------------------------------------"
echo "Installation complete!"
echo "👉 Action Required: Log out of Ubuntu."
echo "👉 On the login screen, click your name, then click the gear icon"
echo "   in the bottom right corner to switch your session to $CHOICE."
echo "=========================================="
