# ~/.bash_profile — read by bash login shells (macOS terminals, ssh) instead of ~/.profile.
[ -r "$HOME/.profile" ] && . "$HOME/.profile"
[ -r "$HOME/.bashrc" ] && . "$HOME/.bashrc"
