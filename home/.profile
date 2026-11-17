# ~/.profile — POSIX login environment for non-bash login shells (sh, display managers).
# Bash login shells source this from ~/.bash_profile; interactive config lives in ~/.bashrc.
[ -d "$HOME/.cargo/bin" ] && PATH="$HOME/.cargo/bin:$PATH"
case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *) [ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH" ;; esac
[ -d "$HOME/.local/share/mise/shims" ] && PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH
