eval "$(/opt/homebrew/bin/brew shellenv)"

set -o vi

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Load bash-completion before ble.sh, which clears PS1 during early init
# (bash_completion.sh only loads when PS1 is set)
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

export VISUAL="nvim"
export EDITOR="nvim"
export GIT_EDITOR="nvim"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export BAT_THEME="Catppuccin Mocha"

export TC_PATH=/Users/jacobward/projects/cloud/tc/cmd/tc

export PATH="$HOME/.opencode/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/go/bin:/usr/local/go/bin:/opt/homebrew/opt/llvm/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

bind -x '"\C-f": "bash -c \"herdr-sessionizer\""'
bind -x '"\C-n": "bash -c \"rangerizer\""'

source <(kubectl completion bash)
complete -C aws_completer aws
complete -C /opt/homebrew/bin/terraform terraform

eval "$(starship init bash)"

. "$HOME/.atuin/bin/env"
eval "$(atuin init bash --disable-up-arrow)"

# Attach blesh
[[ ${BLE_VERSION-} ]] && ble-attach

complete -C /opt/homebrew/bin/terraform terraform
