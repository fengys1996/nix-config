if status is-interactive
    set -x RUSTUP_DIST_SERVER "https://rsproxy.cn"
    set -x RUSTUP_UPDATE_ROOT "https://rsproxy.cn/rustup"
    
    set -x QT_SCALE_FACTOR 1

    abbr -a ze zellij
    abbr -a nv nvim
    abbr -a vi nvim
    abbr -a open "xdg-open"
    
    abbr -a code "code --ozone-platform=wayland"

    fish_vi_key_bindings
    
    if type -q zoxide
    	zoxide init fish --cmd cd | source
    end
end
