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

### Help

- `just` or `just --list` shows the available commands.

## Notes

- The install/uninstall pattern keeps setup and teardown easy to reason about.
- `PS1.sh` expects a hostname argument, but it defaults to `UNKNOWN` if one is not provided.
