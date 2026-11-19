# Default recipe to show available commands
default:
    @just --list

# Installs the custom Git prompt into ~/.bashrc using PS1.sh
# Usage: just install <hostname> (e.g., just install ACER)
install-promt hostname="UNKNOWN":
    @# Ensure the script is marked as executable before calling it
    @./PS1.sh {{hostname}}

# Uninstalls the custom Git prompt completely from ~/.bashrc
uninstall-promt:
    @echo "Removing custom prompt configuration from ~/.bashrc..."
    @if [ -f "$HOME/.bashrc" ]; then \
        sed -i '/# --- CUSTOM GIT PROMPT CONFIG ---/,/# --- END CUSTOM GIT PROMPT ---/d' "$HOME/.bashrc"; \
    fi
    @echo "Success! Config block removed."
    @echo "Run 'source ~/.bashrc' to completely revert the PS1"

# Installs Rust using rustup and sets the default toolchain.
install-rust:
    @echo "Installing Rust toolchain..."
    @if ! command -v rustc >/dev/null 2>&1; then \
        curl https://sh.rustup.rs -sSf | sh -s -- -y; \
        . "$HOME/.cargo/env"; \
    fi
    @rustup default stable
    @rustc --version
    @cargo --version

# Uninstalls the Rust toolchain from this machine.
uninstall-rust:
    @echo "Removing Rust toolchain..."
    @if command -v rustup >/dev/null 2>&1; then \
        rustup self uninstall -y; \
    fi
    @echo "Rust has been uninstalled."

# Installs Yazi for the current user into ~/.local.
install-yazi: install-rust
    @echo "Installing Yazi for $USER..."
    @cargo install --force --root "$HOME/.local" yazi-build
    @echo "Yazi installed in $HOME/.local."

# Uninstalls Yazi from the current user's ~/.local installation.
uninstall-yazi:
    @echo "Removing Yazi for $USER..."
    @cargo uninstall --root "$HOME/.local" yazi-build
    @echo "Yazi has been uninstalled from $HOME/.local."
