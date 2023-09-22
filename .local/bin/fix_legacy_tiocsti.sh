#!/usr/bin/env bash
if [[ $(sysctl -n dev.tty.legacy_tiocsti) == 0 ]]; then
	sysctl -w dev.tty.legacy_tiocsti=1 &1>/dev/null
	exit 0
fi
