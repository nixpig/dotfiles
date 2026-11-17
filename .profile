# ~/.profile — POSIX login environment for non-bash login shells (sh, display managers).
# Bash login shells source this from ~/.bash_profile; interactive config lives in ~/.bashrc.
# Installers (rustup, atuin) like to append here; their env scripts are guarded and idempotent.
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) [ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH" ;; esac
[ -d "$HOME/.local/share/mise/shims" ] && PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH
