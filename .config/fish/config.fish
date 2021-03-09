# Nix

set NIX_LINK $HOME/.nix-profile
set -x NIX_PATH $HOME/.nix-defexpr/channels
set -x NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
set -x NIX_PROFILES /nix/var/nix/profiles/default $HOME/.nix-profile
set -x MANPATH $NIX_LINK/share/man:$MANPATH

# PATH

set -x PATH $NIX_LINK/bin $HOME/.cargo/bin $HOME/.local/bin $PATH

# Others

set -U EDITOR nvim
set -U TERMINAL alacritty
set -U VISUAL codium
set -U BROWSER firefox

# Aliases

alias ls="exa"
alias bat="bat --theme=TwoDark"
alias cat="bat -pp"
alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias copy="xclip -sel clipboard"

# Starship

starship init fish | source
