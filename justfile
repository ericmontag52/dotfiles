# Default recipe to show available commands
default:
    @just --list

# Installs the custom Git prompt into ~/.bashrc using PS1.sh
# Usage: just install <hostname> (e.g., just install ACER)
install PS1 hostname="UNKNOWN":
    @# Ensure the script is marked as executable before calling it
    @./PS1.sh {{hostname}}

# Uninstalls the custom Git prompt completely from ~/.bashrc
uninstall PS1:
    @echo "Removing custom prompt configuration from ~/.bashrc..."
    @if [ -f "$HOME/.bashrc" ]; then \
        sed -i '/# --- CUSTOM GIT PROMPT CONFIG ---/,/# --- END CUSTOM GIT PROMPT ---/d' "$HOME/.bashrc"; \
    fi
    @echo "Success! Config block removed."
    @echo "Run 'source ~/.bashrc' to completely revert the PS1"
