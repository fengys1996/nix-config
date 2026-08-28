{ config, pkgs, lib, inputs, ... }:

let
  feishuFontconfig = pkgs.writeText "feishu-fonts.conf" (
    builtins.readFile ./dot/linuxfont/feishu-fonts.conf
  );
in {
  imports = [
    # TODO: auto install rad
    # TODO: add rad.toml config
    ./services/rad.nix
  ];

  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  
    gtk.enable = true;
    x11.enable = true;
  };
  
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

  home.activation.bootstrapAlacrittyConfig = lib.hm.dag.entryAfter ["linkGeneration"] ''
    set -e
    alacritty_dir="${config.xdg.configHome}/alacritty"
    if [ ! -e "$alacritty_dir" ] && [ ! -L "$alacritty_dir" ]; then
      mkdir -p "$(dirname "$alacritty_dir")"
      cp -R ${./dot/alacritty} "$alacritty_dir"
      chmod -R u+w "$alacritty_dir"
    else
      echo "Alacritty config already exists, skipping bootstrap: $alacritty_dir"
    fi
  '';

  home.file.".config/bg/nixos-wallpapers.png".source = ./dot/bg/nixos-wallpapers.png;

  home.file.".pi/agent/settings.json" = {
    source = ./dot/pi/settings.json;
    force = true;
  };

  wayland.windowManager.sway.enable = true;
  xdg.configFile."sway".source = ./dot/sway;
  xdg.configFile."waybar".source = ./dot/waybar;

  xdg.configFile."fontconfig/fonts.conf".source = ./dot/linuxfont/fonts.conf;

  xdg.configFile."fcitx5/conf/classicui.conf".text = ''
    Font="LXGW WenKai Mono 14"
  '';
  
  xdg.configFile."./xkb/symbols/us_minila_r".source = ./dot/xkb/us_minila_r;
  xdg.configFile."xkb/symbols/swap_esc_tilde".source = ./dot/xkb/symbols/swap_esc_tilde;
  xdg.configFile."xkb/symbols/esdf_arrows".source = ./dot/xkb/symbols/esdf_arrows;
  xdg.configFile."xkb/rules/evdev".source = ./dot/xkb/rules/evdev;

  home.file.".cargo/config.toml".text = ''
    [target.x86_64-unknown-linux-gnu]
    linker = "clang"
    rustflags = [
        "-C", "link-arg=-fuse-ld=mold",
        "-C", "link-arg=-Wl,--no-rosegment",
    ]
  '';
  
  xdg.configFile."rad".source = ./dot/rad;

  programs.fish = {
    enable = true;
    interactiveShellInit = builtins.readFile ./dot/fish/config.fish;
  };

  programs.tmux = {
    enable = true;
    shell = "${pkgs.fish}/bin/fish";
    extraConfig = builtins.readFile ./dot/tmux/.tmux.conf;
  };

  programs.zellij.enable = true;
  xdg.configFile."zellij".source = ./dot/zellij;

  programs.alacritty.enable = true;

  home.file.".codex/AGENTS.md".source = ./dot/agents/AGENTS.md;
  home.file.".pi/agent/AGENTS.md".source = ./dot/agents/AGENTS.md;

  programs.firefox = {
    enable = true;
    configPath = ".mozilla/firefox";

    profiles.default = {
      id = 0;
      isDefault = true;

      settings = {
        "browser.display.use_document_fonts" = 0;
        "font.language.group" = "x-western";
        "layout.css.devPixelsPerPx" = "-1.0";
        "font.name.monospace.x-western" = "MonaspiceKr Nerd Font Mono";
        "font.name.monospace.zh-CN" = "LXGW WenKai Mono";
        "font.name.sans-serif.x-western" = "MonaspiceKr Nerd Font";
        "font.name.sans-serif.zh-CN" = "LXGW WenKai Mono";
        "font.name.serif.x-western" = "MonaspiceKr Nerd Font";
        "font.name.serif.zh-CN" = "LXGW WenKai Mono";
      };
    };
  };

  xdg.configFile."wofi".source = ./dot/wofi;

  xdg.configFile."foot".source = ./dot/foot;

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    theme.flavor = {
      dark = "catppuccin-mocha";
      light = "catppuccin-latte";
    };

    flavors = {
      catppuccin-mocha = "${inputs.yazi-flavors}/catppuccin-mocha.yazi";
      catppuccin-latte = "${inputs.yazi-flavors}/catppuccin-latte.yazi";
    };

    plugins.git = {
      package = pkgs.yaziPlugins.git;
      setup = true;
      settings.order = 1500;
    };

    settings.plugin.prepend_fetchers = [
      {
        url = "*";
        run = "git";
        group = "git";
      }
      {
        url = "*/";
        run = "git";
        group = "git";
      }
    ];
  };
  
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
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
  
  home.packages = with pkgs; [
    gnumake
    file
    rustup
    neovim
    mold
    clang
    protobuf
    taplo
    curl
    wget
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
    unzip
    zoxide
    grim
    slurp
    swappy
    wl-clipboard
    nerd-fonts.monaspace
    nerd-fonts.intone-mono
    lxgw-wenkai
    docker-compose
    mariadb.client
    bcc
    delta
    lazygit
    gh
    bluez
    bluez-tools
    bluetui
    pavucontrol
    bibata-cursors
    p7zip
    cargo-ndk
    python3
    typos
    bottom
    rtk
    ((feishu.override {
      commandLineArgs = "--ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3";
    }).overrideAttrs (oldAttrs: {
      postFixup = (oldAttrs.postFixup or "") + ''
        for executable in $out/opt/bytedance/feishu/{feishu,vulcan/vulcan}; do
          wrapProgram "$executable" \
            --set FONTCONFIG_FILE ${feishuFontconfig}
        done
      '';
    }))
    feishu-cli
    codex
    opencode
    pi-coding-agent
    fastfetch
    obsidian
    vscode
    go
    waybar
    perf
    cargo-flamegraph
    mold
  ];
}
