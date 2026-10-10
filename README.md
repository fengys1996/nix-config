# nix-config

Personal NixOS configuration with the flake configuration name `desktop` and
hostname `nixos`.

## Layout

- `flake.nix`: flake entrypoint and NixOS system definition
- `configuration.nix`: system-level NixOS configuration
- `home.nix`: Home Manager user configuration
- `hardware-configuration.nix`: generated hardware configuration
- `modules/`: Home Manager modules for Plannotator and Lark CLI
- `pkgs/`: custom Nix packages
- `scripts/`: maintenance scripts
- `services/`: Home Manager user service definitions
- `dot/`: managed dotfiles and desktop assets

## Usage

Build and switch to this configuration:

```sh
sudo nixos-rebuild switch --flake .#desktop
```

Update flake inputs:

```sh
nix flake update
```

Check the configuration without switching:

```sh
nix flake check
```

## Configuration initialization

Some configurations, such as Neovim and Alacritty, need to stay writable for
local adjustments or files written by plugins. Home Manager initializes them
only when absent, preserving existing configurations on subsequent rebuilds.

## Garbage collection

Automatic garbage collection runs weekly with `--delete-older-than 14d`
to remove old generations and collect unreferenced store paths.

Manually remove store paths that are no longer referenced by any GC root:

```sh
nix-collect-garbage
```
