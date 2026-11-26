chafa_version := "1.18.3" # TODO add as part of just recipe
tmux_version := "3.5a" # TODO add as part of just recipe
fzf_version := "0.67.0"

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

# Installs tmux for the current user into ~/.local by compiling from source.
install-tmux:
    @echo "Installing tmux {{tmux_version}} for $USER..."
    @set -euo pipefail; \
    tmp_dir=$(mktemp -d); \
    trap 'rm -rf "$tmp_dir"' EXIT; \
    curl -fsSL "https://github.com/tmux/tmux/releases/download/{{tmux_version}}/tmux-{{tmux_version}}.tar.gz" -o "$tmp_dir/tmux.tar.gz"; \
    tar -xzf "$tmp_dir/tmux.tar.gz" -C "$tmp_dir"; \
    cd "$tmp_dir/tmux-{{tmux_version}}"; \
    ./configure --prefix="$HOME/.local"; \
    make -j"$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)"; \
    make install; \
    echo "tmux {{tmux_version}} installed in $HOME/.local/bin."

# Uninstalls tmux from the current user's ~/.local installation.
uninstall-tmux:
    @echo "Removing tmux for $USER..."
    @set -e; \
    rm -f "$$HOME/.local/bin/tmux"; \
    rm -f "$$HOME/.local/share/man/man1/tmux.1"; \
    rm -f "$$HOME/.local/share/bash-completion/completions/tmux"; \
    echo "tmux has been uninstalled from $$HOME/.local."

# Installs ueberzugpp for the current user into ~/.local by compiling from source.
install-ueberzugpp:
    @echo "Installing ueberzugpp for $USER..."
    @set -euo pipefail; \
    tmp_dir=$(mktemp -d); \
    trap 'rm -rf "$tmp_dir"' EXIT; \
    git clone --depth=1 https://github.com/jstkdng/ueberzugpp.git "$tmp_dir/ueberzugpp"; \
    cmake -S "$tmp_dir/ueberzugpp" -B "$tmp_dir/ueberzugpp/build" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_INSTALL_PREFIX="$HOME/.local"; \
    cmake --build "$tmp_dir/ueberzugpp/build" -j"$(nproc 2>/dev/null || echo 2)"; \
    cmake --install "$tmp_dir/ueberzugpp/build"; \
    echo "ueberzugpp installed in $HOME/.local/bin."

# Removes ueberzugpp from the user's ~/.local installation.
uninstall-ueberzugpp:
    @echo "Uninstalling ueberzugpp for $USER..."
    @rm -f "$HOME/.local/bin/ueberzugpp" "$HOME/.local/bin/ueberzug"
    @echo "ueberzugpp removed from $HOME/.local/bin."

# Installs chafa for the current user into ~/.local by compiling from source.
install-chafa:
    @echo "Installing chafa {{chafa_version}} for $USER..."
    @set -euo pipefail; \
    tmp_dir=$(mktemp -d); \
    trap 'rm -rf "$tmp_dir"' EXIT; \
    curl -fsSL "https://github.com/hpjansson/chafa/releases/download/{{chafa_version}}/chafa-{{chafa_version}}.tar.xz" -o "$tmp_dir/chafa.tar.xz"; \
    tar -xf "$tmp_dir/chafa.tar.xz" -C "$tmp_dir"; \
    cd "$tmp_dir/chafa-{{chafa_version}}"; \
    ./configure --prefix="$HOME/.local"; \
    make -j"$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 2)"; \
    make install; \
    echo "chafa {{chafa_version}} installed in $HOME/.local/bin."

# Removes chafa from the user's ~/.local installation.
uninstall-chafa:
    @echo "Uninstalling chafa for $USER..."
    @rm -f "$HOME/.local/bin/chafa" "$HOME/.local/lib/libchafa"*
    @rm -rf "$HOME/.local/include/chafa" "$HOME/.local/lib/pkgconfig/chafa.pc"
    @echo "chafa removed from $HOME/.local."

# Installs fzf for the current user into ~/.local/bin from official releases.
install-fzf:
    @echo "Installing fzf {{fzf_version}} for $USER..."
    @set -euo pipefail; \
    tmp_dir=$(mktemp -d); \
    trap 'rm -rf "$tmp_dir"' EXIT; \
    arch=$(uname -m); \
    case "$arch" in \
      x86_64) fzf_arch="linux_amd64" ;; \
      aarch64|arm64) fzf_arch="linux_arm64" ;; \
      *) echo "Unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    mkdir -p "$HOME/.local/bin"; \
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v{{fzf_version}}/fzf-{{fzf_version}}-${fzf_arch}.tar.gz" -o "$tmp_dir/fzf.tar.gz"; \
    tar -xzf "$tmp_dir/fzf.tar.gz" -C "$HOME/.local/bin" fzf; \
    chmod +x "$HOME/.local/bin/fzf"; \
    echo "fzf {{fzf_version}} installed in $HOME/.local/bin."

# Removes fzf from the user's ~/.local/bin installation.
uninstall-fzf:
    @echo "Uninstalling fzf for $USER..."
    @rm -f "$HOME/.local/bin/fzf"
    @echo "fzf removed from $HOME/.local/bin."

# Installs the resvg SVG renderer CLI for the current user via Cargo (~/.cargo/bin).
install-resvg:
    @echo "Installing resvg for $USER..."
    @cargo install --locked resvg
    @echo "resvg installed in $HOME/.cargo/bin."

# Removes resvg from the user's ~/.cargo/bin installation.
uninstall-resvg:
    @echo "Uninstalling resvg for $USER..."
    @cargo uninstall resvg || rm -f "$HOME/.cargo/bin/resvg"
    @echo "resvg removed from $HOME/.cargo/bin."

zoxide_version := "0.9.9"

# Installs zoxide for the current user into ~/.local/bin from official releases.
install-zoxide:
    @echo "Installing zoxide {{zoxide_version}} for $USER..."
    @set -euo pipefail; \
    tmp_dir=$(mktemp -d); \
    trap 'rm -rf "$tmp_dir"' EXIT; \
    arch=$(uname -m); \
    case "$arch" in \
      x86_64) zox_arch="x86_64-unknown-linux-musl" ;; \
      aarch64|arm64) zox_arch="aarch64-unknown-linux-musl" ;; \
      *) echo "Unsupported architecture: $arch" >&2; exit 1 ;; \
    esac; \
    mkdir -p "$HOME/.local/bin"; \
    curl -fsSL "https://github.com/ajeetdsouza/zoxide/releases/download/v{{zoxide_version}}/zoxide-{{zoxide_version}}-${zox_arch}.tar.gz" -o "$tmp_dir/zoxide.tar.gz"; \
    tar -xzf "$tmp_dir/zoxide.tar.gz" -C "$tmp_dir" zoxide; \
    install -m 0755 "$tmp_dir/zoxide" "$HOME/.local/bin/zoxide"; \
    echo "zoxide {{zoxide_version}} installed in $HOME/.local/bin."

# Removes zoxide from the user's ~/.local/bin installation.
uninstall-zoxide:
    @echo "Uninstalling zoxide for $USER..."
    @rm -f "$HOME/.local/bin/zoxide"
    @echo "zoxide removed from $HOME/.local/bin."