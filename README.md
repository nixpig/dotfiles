[![bootstrap](https://github.com/nixpig/dotfiles/actions/workflows/bootstrap.yml/badge.svg)](https://github.com/nixpig/dotfiles/actions/workflows/bootstrap.yml)

# dotfiles

My dotfiles and system setup, managed with [mise](https://mise.jdx.dev).

## What's new?

**2026-11-18:** After many years of using Arch Linux as my daily driver,
I'm now using macOS on my main machine and some Ubuntu or Debian derivative on all VMs, SBCs.
This has enabled migration from the complex yadm + Ansible setup I was previously using,
to a much simpler setup with mise.

## New machine

```sh
curl -fsSL https://mise.run | sh
~/.local/bin/mise bootstrap --from 'https://github.com/nixpig/dotfiles.git' \
  --from-dir ~/.dotfiles --config-dir mise --force-dotfiles
```

`--from` clones this repo to `~/.dotfiles` (installing git if needed), links
`~/.config/mise` to `~/.dotfiles/mise`, and runs the bootstrap from there.
`--force-dotfiles` replaces files that are already in the way, such as the
distro's default `~/.bashrc`.

### Additional

Installing Operator Mono font requires GitHub login because it's in a private repo.
After running the bootstrap script, run
`gh auth login` then `mise run bootstrap -- operator-mono`.

#### macOS

Install [Xcode Command Line Tools](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools#Install-the-Command-Line-Tools-package-in-Terminal)
(git, clang, make, etc.) before running the bootstrap script.
After running the bootstrap script, sign in to the App Store,
then run `mise bootstrap` again to install the App Store apps
(it needs `mas`, which the first run installs).
Then, open a new terminal, and do anything listed under "To do by hand" at the end.

Finally, open Docker Desktop, InstantSpaceSwitcher, UnnaturalScrollWheels and
Logi Tune once to grant their permissions.

#### Linux

After running the bootstrap script, run `newgrp docker` to apply the `docker` group
to the current shell or log out and back in for it to be applied globally.

### Work machines

Add `-E work` to the `mise bootstrap --from` command, then make it permanent for that machine:

```sh
echo 'env = ["work"]' > ~/.config/mise/miserc.local.toml
```

That file is git-ignored, so it stays on the machine.
The `work` environment loads `mise/config.work.toml`, which links `work/` into `~`.
Without the file, later runs would switch it back.

### Switching a machine from yadm

Run these before the commands above. They move yadm and the old
`~/.config/mise` out of the way, because mise needs that path for its link:

```sh
mv ~/.local/share/yadm ~/.local/share/yadm.old
mv ~/.config/mise ~/.config/mise.old
```

`--force-dotfiles` then replaces yadm's checked-out files with links. Afterwards:

- Remove yadm's leftovers: `rm -rf ~/.config/yadm ~/.github ~/.local/share/yadm.old ~/.config/mise.old ~/.local/state/bootstrap`,
  and anything `find ~ -name '*##*' -not -path '*/.dotfiles/*'` lists.
- Remove tools that mise now installs, so they don't shadow its versions. Check
  each one with `type -a <tool>`: the mise one is under `~/.local/share/mise`.
  - Old installers: `~/.atuin`, `~/.hunk`, `~/.nvm`, `/usr/local/go`,
    `/opt/nvim-*`, and on Linux the `bat`, `fzf`, `jq`, `ripgrep`, `hyperfine`,
    `mkcert`, `lazygit`, `starship` and `gh` apt packages.
  - herdr's installer: `rm ~/.local/bin/herdr`, then `herdr server stop` and
    start herdr again so the server runs mise's copy.
  - Claude Code's installer: `rm -rf ~/.local/bin/claude ~/.local/share/claude`.
    Keep `~/.claude` and `~/.claude.json`, which hold its settings and login.
  - The gh-dash extension (now a mise tool): `gh extension remove dash`.
  - On macOS, Homebrew formulae that are now mise tools, or no longer needed:
    `brew uninstall mise yadm mas neovim bat fzf jq ripgrep hyperfine mkcert
    awscli gh lazygit starship` (only the ones you have).
- Keep `~/.cargo` and `~/.rustup`: mise's Rust uses them too. Keep
  `~/.local/share/blesh` and `/opt/homebrew` as well, which the new setup reuses.

## Day to day

Every file under `~/.dotfiles/home` is **linked** into `~` at the same path.
So editing `~/.bashrc` edits `~/.dotfiles/home/.bashrc`;
commit and push from `~/.dotfiles` as normal.

| To | Run |
|---|---|
| Start managing a new file | `mise dot add ~/.config/foo/config.toml` (moves it into `~/.dotfiles/home` and links it back), then commit |
| Pull changes and apply them | `mise bootstrap --update` |
| See what's out of sync | `mise bootstrap status`, or `mise run check` |
| Upgrade tools pinned to `latest` | `mise upgrade` |
| Upgrade system packages | `mise bootstrap packages upgrade` |
| Preview a run | `mise bootstrap --dry-run` |
| Run some parts only | `mise bootstrap --only packages,dotfiles` (parts are listed in `mise bootstrap --help`) |

If an app saves its config by replacing the file rather than writing into it,
the link becomes a plain file and `mise bootstrap status` shows it.
Run `mise dot add <file>` to copy the app's version into the repo and link it again.

## Layout

```text
~/.dotfiles/
├── home/                     linked into ~ on every machine
├── work/                     linked into ~ on work machines
└── mise/                     ~/.config/mise (a link to here)
    ├── config.toml           tools, dotfiles, git repos (every machine)
    ├── config.linux.toml     apt packages and apt repos
    ├── config.macos.toml     Homebrew formulae, casks, App Store apps
    ├── config.work.toml      links work/ (work machines)
    ├── miserc.toml           turns on auto_env, so the platform files load
    ├── miserc.local.toml     (untracked) env = ["work"] on work machines
    ├── files/                apt signing keys
    └── tasks/
        ├── bootstrap         steps mise can't declare (run last by mise bootstrap)
        └── check             checks the machine matches the config (used by CI)
```

## Adding something

| What | Where |
|---|---|
| A CLI tool or runtime | `mise use -g <tool>@latest`, which writes `mise/config.toml`. `mise registry <name>` shows if mise has it. |
| A system package or library | `mise/config.linux.toml` (`"apt:<name>"`) and/or `mise/config.macos.toml` (`"brew:<name>"`). |
| A macOS app or font | `"brew-cask:<name>"` in `mise/config.macos.toml` (search at [formulae.brew.sh](https://formulae.brew.sh)). |
| A git checkout | `[bootstrap.repos]` in `mise/config.toml`. |
| Anything else | A `step_<name>` function in `mise/tasks/bootstrap`, added to `STEPS`. |

Use `mise use -g` rather than apt or Homebrew when mise has the tool.
That way it's one entry for both platforms, and the same version on each.

### Platform-specific files

Most differences live inside shared files, using existence checks. For example,
`~/.bashrc` only adds `/opt/homebrew/bin` to PATH if it exists, and looks for
bash-completion in both Homebrew's and Debian's locations.

Whole files that only belong on work machines go in `work/`.

When only some lines differ, the file is a Tera template.
It's named `<file>.tera`, add has an entry like the git config's in
`[dotfile_groups.home.entries]`.
It uses conditionals in the template like `{% if os() == "macos" %}` or
`{% if mise_env is defined and "work" in mise_env %}`.

