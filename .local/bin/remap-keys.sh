#!/bin/sh

# Remap Caps Lock to Escape and Control
setxkbmap -option 'caps:ctrl_modifier';xcape -e 'Caps_Lock=Escape' &

