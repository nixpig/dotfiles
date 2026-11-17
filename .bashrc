# ~/.bashrc — shared by macOS and Debian/Ubuntu/Raspberry Pi OS (managed by yadm).
# Platform differences are handled with existence checks rather than yadm
# alternates, so this one file works everywhere.
#
# Login shells (macOS terminals, ssh) read ~/.bash_profile, which sources this.

# --- Environment (also wanted by non-interactive shells, e.g. `ssh host cmd`) ---

[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Prepend a directory to PATH if it exists and isn't already there.
path_prepend() {
    [ -d "$1" ] || return 0
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}
# Listed lowest-priority first; the last one ends up at the front of PATH.
path_prepend /opt/homebrew/opt/llvm/bin
path_prepend /usr/local/go/bin
path_prepend "$HOME/go/bin"
path_prepend "$HOME/.hunk/bin"
path_prepend "$HOME/.atuin/bin"
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/.opencode/bin"
# mise shims, for non-interactive shells; interactive ones use `mise activate` below
path_prepend "$HOME/.local/share/mise/shims"
export PATH
unset -f path_prepend

export VISUAL="nvim"
export EDITOR="nvim"
export GIT_EDITOR="nvim"
export BAT_THEME="Catppuccin Mocha"
# lazygit's default config dir on macOS is ~/Library/Application Support; point it here on every platform.
export LG_CONFIG_FILE="$HOME/.config/lazygit/config.yml"
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

[ -d "$HOME/projects/cloud/tc/cmd/tc" ] && export TC_PATH="$HOME/projects/cloud/tc/cmd/tc"

# Package cooldowns: don't install packages published in the last 3 days.
export YARN_NPM_MINIMAL_AGE_GATE="4320"

# --- Interactive only below here ---
case $- in
    *i*) ;;
      *) return;;
esac

set -o vi

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
# check the window size after each command and, if necessary, update LINES and COLUMNS.
shopt -s checkwinsize

# Load bash-completion before ble.sh, which clears PS1 during early init
# (bash_completion only loads when PS1 is set).
if ! shopt -oq posix; then
    for f in /opt/homebrew/etc/profile.d/bash_completion.sh \
             /usr/share/bash-completion/bash_completion \
             /etc/bash_completion; do
        [ -r "$f" ] && { . "$f"; break; }
    done
    unset f
fi

[ -r "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh" --noattach

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases"

# mise: dev tools and runtimes from ~/.config/mise/config.toml (replaces nvm)
command -v mise >/dev/null 2>&1 && eval "$(mise activate bash)"

# pip cooldown: pass --uploaded-prior-to (pip >= 26) to install/download/wheel.
pip3() {
    local pip_major cutoff
    pip_major=$(command pip3 --version 2>/dev/null | awk '{ split($2, a, "."); print a[1]; exit }')
    case "$1" in
        install|download|wheel)
            if [[ "${pip_major:-0}" -ge 26 ]]; then
                # GNU date first, then BSD (macOS) date
                cutoff=$(date -u -d '3 days ago' '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -v-3d '+%Y-%m-%dT%H:%M:%SZ')
                command pip3 "$1" --uploaded-prior-to "$cutoff" "${@:2}"
            else
                echo "warning: pip3 ${pip_major:-unknown} does not support --uploaded-prior-to (need >= 26), skipping cooldown" >&2
                command pip3 "$@"
            fi
            ;;
        *)
            command pip3 "$@"
            ;;
    esac
}

bind -x '"\C-f": "bash -c \"herdr-sessionizer\""'
bind -x '"\C-n": "bash -c \"rangerizer\""'

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion bash)
command -v aws_completer >/dev/null 2>&1 && complete -C aws_completer aws
command -v terraform >/dev/null 2>&1 && complete -C "$(command -v terraform)" terraform

command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

if command -v atuin >/dev/null 2>&1; then
    # atuin uses ble.sh's hooks when present; otherwise it needs bash-preexec.
    [[ ! ${BLE_VERSION-} && -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"
    eval "$(atuin init bash --disable-up-arrow)"
fi

# Attach blesh (keep last)
[[ ${BLE_VERSION-} ]] && ble-attach
