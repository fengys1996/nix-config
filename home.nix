{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    # TODO: auto install rad
    # TODO: add rad.toml config
    ./services/rad.nix
  ];
  
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

  home.file.".config/bg/nixos-wallpapers.png".source = ./dot/bg/nixos-wallpapers.png;

  wayland.windowManager.sway.enable = true;
  xdg.configFile."sway".source = ./dot/sway;

  xdg.configFile."fontconfig/fonts.conf".source = ./dot/linuxfont/font.conf;
  
  xdg.configFile."./xkb/symbols/us_minila_r".source = ./dot/xkb/us_minila_r;

  xdg.configFile."fish/config.fish".source = ./dot/fish/config.fish;

  programs.alacritty.enable = true;
  xdg.configFile."alacritty".source = ./dot/alacritty;

  xdg.configFile."wofi".source = ./dot/wofi;
  
  home.file.".local/share/nvim/site/parser/rust.so".source =
    "${pkgs.tree-sitter-grammars.tree-sitter-rust}/parser";

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
    gnumake
    file
    fish
    rustup
    neovim
    mold
    clang
    protobuf
    taplo
    curl
    ripgrep
    fzf
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
    zoxide
    tree-sitter
    tree-sitter-grammars.tree-sitter-rust
    grim
    slurp
    swappy
  ];
}
