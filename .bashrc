# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source blesh
[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --attach=non-text

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Alias thefuck
eval $(thefuck --alias)

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ -f "/etc/arch-release" ]; then
    source /usr/share/git/completion/git-prompt.sh
elif [ -f "/etc/debian_version" ]; then
    source /usr/lib/git-core/git-sh-prompt
else
    export ANDROID_HOME="/usr/lib/android-sdk"
fi

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim=nvr -cc split --remote-wait +'set bufhidden=wipe'
fi

# Make sure we export the correct Android path - apt and pacman install to different locations
if [ -f "/etc/arch-release" ]; then
    export ANDROID_HOME="$HOME/android-sdk-linux"
elif [ -f "/etc/debian_version" ]; then
    export ANDROID_HOME="/usr/lib/android-sdk"
else
    # Always default to Ubuntu
    export ANDROID_HOME="/usr/lib/android-sdk"
fi

export ANDROID_SDK_ROOT=$ANDROID_HOME


export GIT_PS1_SHOWDIRTYSTATE=1
# export N_PREFIX="$HOME/.local/n"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$ANDROID_HOME:$ANDROID_HOME/tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/build-tools/debian:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$HOME/.config/lsp/lua-language-server/bin:$PATH:$HOME/go/bin"

export BAT_THEME="Catppuccin-mocha"

# Set the default editors
if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL="nvim"
    export EDITOR="nvim"
fi

export GIT_EDITOR="nvim"

export VAGRANT_HOME=/mnt/efe8b538-025d-4e8c-befc-fe22dcec7f15/Vagrant

# Set up mcfly options
export MCFLY_KEY_SCHEME=vim
export MCFLY_FUZZY=2
export MCFLY_RESULTS=25
export MCFLY_DISABLE_MENU=TRUE
export MCFLY_INTERFACE_VIEW=TOP
export MCFLY_PROMPT=󰍉

# Set up fzf options
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Start mcfly
eval "$(mcfly init bash)"

# Open tmux-sessionizer
bind -x '"\C-f": "bash -c \"tmux-sessionizer\""'
bind -x '"\C-n": "bash -c \"rangerizer\""'

# Check/Fix legacy_tiocsti and open mcfly
bind -x '"\C-r": "bash -c \"mcfly_fix.sh\""'


# Initialise starship
eval "$(starship init bash)"

# Attach blesh
[[ ${BLE_VERSION-} ]] && ble-attach

source ${HOME}/.config/broot/launcher/bash/br

# Initialise the keychain
eval $(keychain --eval --quiet id_rsa)


# >>>> Vagrant command completion (start)
. /opt/vagrant/embedded/gems/gems/vagrant-2.3.7/contrib/bash/completion.sh
# <<<<  Vagrant command completion (end)
