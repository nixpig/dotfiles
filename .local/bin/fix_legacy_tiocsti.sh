#!/usr/bin/env bash
if [[ $(sysctl -n dev.tty.legacy_tiocsti) == 0 ]]; then
	sudo sysctl -w dev.tty.legacy_tiocsti=1
	exit 0
fi
