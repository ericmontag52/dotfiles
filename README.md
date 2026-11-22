# dotfiles

Personal Environment Setup

## Dependencies

This repository is dependent on having `just` installed. The following commands will install `just`.

```
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to "$HOME/.local/bin"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Available commands

This repository uses `just` to manage a few setup tasks.

### Prompt installation

- `just install-promt hostname="ACER"` installs the custom Git prompt into `~/.bashrc` using `PS1.sh`.
- `just uninstall-promt` removes the custom prompt block from `~/.bashrc`.

### Rust toolchain

- `just install-rust` installs Rust with `rustup` and sets the default toolchain to `stable`.
- `just uninstall-rust` removes the Rust toolchain from the machine.

### Yazi file manager

- `just install-yazi` installs Yazi for the current user under `~/.local` (via Cargo).
- `just uninstall-yazi` removes Yazi from the user's `~/.local` installation.
- Yazi is recommended to be used with **ueberzugpp** for image previews in supported terminals.

### ueberzugpp image previews

- `just install-ueberzugpp` builds ueberzugpp from source and installs it for the current user under `~/.local`.
- `just uninstall-ueberzugpp` removes ueberzugpp binaries from `~/.local/bin`.

Installing from source requires Git, CMake, and the build dependencies for ueberzugpp. For example, on Debian/Ubuntu:

```bash
sudo apt-get update && sudo apt-get install -y \
  build-essential \
  cmake \
  extra-cmake-modules \
  pkg-config \
  git \
  libtbb-dev \
  libssl-dev \
  libopencv-dev \
  libvips-dev \
  libsixel-dev \
  libchafa-dev \
  libxcb-image0-dev \
  libxcb-res0-dev \
  libx11-dev \
  libwayland-dev \
  wayland-protocols
```


### tmux terminal multiplexer

- `just install-tmux` builds tmux from source and installs it for the current user under `~/.local`.
- `just uninstall-tmux` removes the tmux binary and documented completion/manpage files from `~/.local`.

Building from source requires the following `apt` packages on Debian/Ubuntu:

```bash
sudo apt-get update && sudo apt-get install -y \
  build-essential \
  bison \
  pkg-config \
  libevent-dev \
  libncurses-dev \
  autoconf \
  automake \
  git
```

### Chafa terminal graphics

- `just install-chafa` builds Chafa from source and installs it for the current user under `~/.local`.
- `just uninstall-chafa` removes Chafa from `~/.local`.

Building Chafa from source requires the following `apt` packages on Debian/Ubuntu:

```bash
sudo apt-get update && sudo apt-get install -y \
  build-essential \
  pkg-config \
  git \
  libglib2.0-dev \
  libjpeg-dev \
  libpng-dev \
  libtiff-dev \
  libwebp-dev \
  librsvg2-dev
```

Optional image format and development support can be added with:

```bash
sudo apt-get install -y \
  libavif-dev \
  libmagickwand-dev
```

### Help

- `just` or `just --list` shows the available commands.

## Notes

- The install/uninstall pattern keeps setup and teardown easy to reason about.
- `PS1.sh` expects a hostname argument, but it defaults to `UNKNOWN` if one is not provided.
