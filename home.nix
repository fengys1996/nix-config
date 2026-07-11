{ pkgs, ... }:

{
  home.username = "fys";
  home.homeDirectory = "/home/fys";

  home.stateVersion = "25.05";

  programs.neovim.enable = true;
  programs.neovim.withRuby = false;
  programs.neovim.withPython3 = false;
  
  xdg.configFile."nvim".source = ./dot/nvim-config;

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
  ];
}
