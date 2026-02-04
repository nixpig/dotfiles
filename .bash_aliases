# Alias sudo for shell expansion
# alias sudo='${HOME}/.local/bin/sudo.sh '

alias y='yes| '

# General
alias ~='cd ~'
alias x='exit'
alias mv='mv -iv'
alias cp='cp -iv'
alias mkdir='mkdir -pv'
alias less='less -FSRXc'
alias wget='wget -c'
alias c='clear' 
alias path='echo -e ${PATH//:/\\n' 
alias src='source ~/.bashrc && stty sane'
alias apt='sudo apt'
alias pacman='sudo pacman'
alias update-alternatives='sudo update-alternatives'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias mount='mount | column -t'
alias reboot='sudo reboot'
alias ping='ping -c 5'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

# vim
alias vim="nvim"
alias vrc='cd ~/.config/nvim && vim init.lua'

# tmux
alias t='[[ -z "$TMUX" ]] && tmux || tmux new-session'
alias tma='tmux attach -t "$(tmux ls | fzf | cut -d: -f1)"'
alias tmk='tmux kill-session -t "$(tmux ls | fzf | cut -d: -f1)"'
alias tml='tmux ls'
alias tmn='tmux-sessionizer'
alias tmo='tmux new-session'
alias tmr='tmux rename-session -t "$(tmux ls | fzf | cut -d: -f1)"'
alias tmw='tmux new-window'
alias tms='tmux switch-client -t "$(tmux ls | fzf | cut -d: -f1)"'
alias tmrc='cd ~ && vim .tmux.conf'

# git
alias g='git'
alias gd='git diff'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gc='git commit'
alias gcm='git commit -m'
alias grc='cd ~ && vim .gitconfig'

# alias czsp="cd $(chezmoi source-path)"

# Remap utilities
## cat aliases
alias cat='bat'
alias make='colormake'

## exa and ls aliases
alias ls='exa --icons'
alias ll='exa --long --header --icons'
alias la='exa --long --header --icons --all'
alias llg='exa --long --header --icons --git'
alias lag='exa --long --header --icons --all --git'
alias llr='exa --long --header --icons --tree'
alias lar='exa --long --header --icons --all --tree'
alias lss='exa --long --header --icons --all --sort=size --reverse'
alias lsd='exa --long --header --icons --all --sort=mod --reverse'
alias lsa='exa --long --header --icons --all --sort=acc --reverse'

# Fuzzy-finders
## Fuzzy-find a directory and go there
alias d='cd $(find . -type d -print | fzf --preview "exa --long --header --icons --all {}" --preview-window=down)'

## Fuzzy-find a file and preview out contents
alias f='bat $(find . -type f -print | fzf --preview "bat --color=always --line-range=:500 {}" --preview-window=down)'

## Fuzzy-find a directory and open in vim
alias vd='nvim $(find . -type d -print | fzf --preview "exa --long --header --icons --all {}" --preview-window=down)'

## Fuzzy-find a file and open in vim
alias vf='nvim $(find . -type f -print | fzf --preview "bat --color=always --line-range=:500 {}" --preview-window=down)'

## Fuzzy find a directory and create a new tmux session
alias td='tmux-sessionizer'

# Git aliases
alias g='git'
alias gb='git branch'
alias gbl='git branch --list'
alias gba='git branch -a'
alias gst='git status'
alias glg='git log --graph --oneline --decorate --all'
alias gco='git checkout $(git branch | fzf | sed "s/^[ *]*//g")'
alias gcb='git checkout -b'
alias gbd='git branch -d $(git branch | fzf | sed "s/^[ *]*//g")'
alias gbr='git branch -r'
alias gps='git push'
alias gpl='git pull'
alias gpf='git push --force-with-lease'
alias gpr='git pull --rebase'
alias gpom='git pull origin master'
alias gpob='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias gpu='git push -u origin $(git branch | fzf | sed "s/^[ *]*//g")'
alias gra='git remote add'
alias grr='git remote rm'
alias gcl='git clone'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcz='git-cz'
alias gss='git stash'
alias gsp='git stash pop'
alias gsa='git stash apply'

alias tf='terraform'
alias kc='kubectl'
alias r='ranger'

alias tctl='$HOME/projects/teleport/build/tctl'

alias fdpass-teleport='$HOME/projects/teleport/build/fdpass'
alias tbot='$HOME/projects/teleport/build/tbot'
alias tctl='$HOME/projects/teleport/build/tctl'
alias teleport='$HOME/projects/teleport/build/teleport'
alias teleport-update='$HOME/projects/teleport/build/teleport'
alias tsh='$HOME/projects/teleport/build/tsh'
