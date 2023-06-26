#!/usr/bin/env python3

from i3ipc import Connection, Event

i3 = Connection()

workspace_apps = [
    { "name": "", "command": "i3-sensible-terminal -x tmux" },
    { "name": "", "command": "" },
    { "name": "", "command": "" },
    { "name": "", "command": "dbeaver" },
    { "name": "", "command": "" },
    { "name": "", "command": "i3-sensible-terminal -x lazydocker"},
    { "name": "", "command": "google-chrome-stable" },
    { "name": "obs", "command": "obs" },
    { "name": "gimp", "command": "gimp" },
    { "name": "", "command": "" }
]

def on_workspace_focus(i3, e):
    workspace_number = int(e.current.name.split(':')[0]) -1
    focused_workspace = i3.get_tree().find_focused().workspace()
    app_name = workspace_apps[workspace_number]["name"]
    app_command = workspace_apps[workspace_number]["command"]
    if not focused_workspace.find_named(app_name):
        i3.command("exec %s" %(app_command))

i3.on(Event.WORKSPACE_FOCUS, on_workspace_focus)

i3.main()
