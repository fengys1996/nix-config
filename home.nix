{ config, pkgs, lib, inputs, ... }:

{
  home.username = "fys";
  home.homeDirectory = "/home/fys";

  home.stateVersion = "25.05";

  home.activation.bootstrapNvimConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    set -e

    nvim_dir="${config.home.homeDirectory}/.config/nvim"

    if [ ! -e "$nvim_dir" ] && [ ! -L "$nvim_dir" ]; then
      mkdir -p "$(dirname "$nvim_dir")"
      ${pkgs.git}/bin/git clone https://github.com/fengys1996/nvim-config.git "$nvim_dir"
    else
      echo "Neovim config already exists, skipping bootstrap: $nvim_dir"
    fi
  '';

  wayland.windowManager.sway.enable = true;
  xdg.configFile."sway".source = ./dot/sway;
  
  xdg.configFile."./xkb/symbols/us_minila_r".source = ./dot/xkb/us_minila_r;

  programs.fish.enable = true;
  xdg.configFile."fish".source = ./dot/fish;

  programs.alacritty.enable = true;
  xdg.configFile."alacritty".source = ./dot/alacritty;

  xdg.configFile."wofi".source = ./dot/wofi;

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "fys";
        email = "fengys1996@gmail.com";
      };
    };
  };
  
  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
  
  home.packages = with pkgs; [
    neovim
    mold
    clang
    protobuf
    taplo
    curl
    ripgrep
    fd
    bat
    eza
    jq
    tree
    htop
    btop
    wofi
    codex
    unzip
    yazi
  ];
}
