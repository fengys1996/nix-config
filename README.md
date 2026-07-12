# nix-config

Personal NixOS configuration for the `desktop` host.

## Layout

- `flake.nix`: flake entrypoint and NixOS system definition
- `configuration.nix`: system-level NixOS configuration
- `home.nix`: Home Manager user configuration
- `hardware-configuration.nix`: generated hardware configuration
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
