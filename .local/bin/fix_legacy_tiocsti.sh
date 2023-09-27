#!/usr/bin/env bash

if [[ $(sysctl -n dev.tty.legacy_tiocsti) == 0 ]]; then
	read -n 1 -p "Enable legacy_tiocsti? [y/N]: " answer
	case ${answer:0:1} in
		y|Y )
			sudo sysctl -w dev.tty.legacy_tiocsti=1 &1>/dev/null
		;;
		* )
			echo "\nExiting"
			exit 0
		;;
	esac
fi
