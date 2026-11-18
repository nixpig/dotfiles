[![bootstrap](https://github.com/nixpig/dotfiles/actions/workflows/bootstrap.yml/badge.svg)](https://github.com/nixpig/dotfiles/actions/workflows/bootstrap.yml)

# dotfiles

My dotfiles and machine setup, managed with [mise](https://mise.jdx.dev):
one tool for the dotfiles, system packages, apps, and dev tools.

## Recent changes

### No more Arch

After many years of running Arch as my daily driver, I'm no longer doing so.

My main machine is now macOS and all VMs, containers, SBCs, etc. are running some
Debian/Ubuntu derivative.

### No more Ansible (or yadm)

No longer using Arch means setting up a new machine is simpler than ever,
and my previous [Ansible playbook](https://github.com/nixpig/playbook)
is far too heavyweight. `mise bootstrap` now does the lot, from config in this repo.

## New machine

### macOS

1. `xcode-select --install` and wait for it to finish (git, clang, make).
1. Run:

   ```sh
   curl -fsSL https://mise.run | sh
   ~/.local/bin/mise bootstrap --from 'https://github.com/nixpig/dotfiles.git?ref=mise' \
     --from-dir ~/.dotfiles --config-dir mise --force-dotfiles
   ```

1. Sign in to the App Store, then run `mise bootstrap` again to install the App
   Store apps (it needs `mas`, which the first run installs).
1. Open a new terminal, and do anything listed under "To do by hand" at the end.

### Debian / Ubuntu / Raspberry Pi OS

```sh
sudo apt update && sudo apt install -y curl
curl -fsSL https://mise.run | sh
~/.local/bin/mise bootstrap --from 'https://github.com/nixpig/dotfiles.git?ref=mise' \
  --from-dir ~/.dotfiles --config-dir mise --force-dotfiles
```

`--from` clones this repo to `~/.dotfiles` (installing git if needed), links
`~/.config/mise` to `~/.dotfiles/mise`, and runs the bootstrap from there.
`--force-dotfiles` replaces files that are already in the way, such as the
distro's default `~/.bashrc`. Leave it off to have mise stop and list them instead.

Once this branch is merged into the default branch, drop `?ref=mise`.

### Work machines

Add `-E work` to the `mise bootstrap --from` command, then make it permanent for
that machine:

```sh
echo 'env = ["work"]' > ~/.config/mise/miserc.local.toml
```

That file is git-ignored, so it stays on the machine. The `work` environment
loads `mise/config.work.toml`, which links `work/` into `~` (the Teleport
links in `.local/bin`), and the templates use it to switch the git identity
and add the Teleport provider override to `.terraformrc`.
Without the file, later runs would switch it back.

### Switching a machine from yadm

Run these before the commands above. They move yadm and the old
`~/.config/mise` out of the way, because mise needs that path for its link:

```sh
mv ~/.local/share/yadm ~/.local/share/yadm.old
mv ~/.config/mise ~/.config/mise.old
```

`--force-dotfiles` then replaces yadm's checked-out files with links. Afterwards:

- Remove yadm's leftovers: `rm -rf ~/.config/yadm ~/.local/share/yadm.old ~/.config/mise.old`,
  and anything `find ~ -name '*##*' -not -path '*/.dotfiles/*'` lists.
- Remove tools that mise now installs, so they don't shadow its versions. Check
  each one with `type -a <tool>`: the mise one is under `~/.local/share/mise`.
  - Old installers: `~/.atuin`, `~/.hunk`, `~/.nvm`, `/usr/local/go`,
    `/opt/nvim-*`, and on Linux the `bat`, `fzf`, `jq`, `ripgrep`, `hyperfine`,
    `mkcert`, `lazygit`, `starship` and `gh` apt packages.
  - On macOS, Homebrew formulae that are now mise tools: `brew uninstall mise
    neovim bat fzf jq ripgrep hyperfine mkcert awscli gh lazygit starship`
    (only the ones you have).

## Day to day

Every file under `~/.dotfiles/home` is **linked** into `~` at the same path. So
editing `~/.bashrc` edits `~/.dotfiles/home/.bashrc`; commit and push from
`~/.dotfiles` as normal.

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
the link becomes a plain file and `mise bootstrap status` shows it. Run
`mise dot add <file>` to copy the app's version into the repo and link it again.

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

## What the bootstrap does

`mise bootstrap` works through the config in this order, skipping anything already
in the right state, so it's safe to run any time:

1. **apt sources** (Linux): Docker's repo, and Microsoft's for the Azure CLI on
   Ubuntu (Debian has its own `azure-cli` package and Microsoft has no repo for
   Debian 13). The repo URL depends on the distro, so these are templates in
   `config.linux.toml`; their keys are in `mise/files`.
1. **Packages**: apt on Linux. On macOS, Homebrew formulae and casks, which
   mise installs itself into `/opt/homebrew` (the `brew` command isn't needed),
   and App Store apps via `mas`.
1. **Git repos**: tpm, ranger_devicons and ble.sh's source.
1. **Dotfiles**: links `home/` (and `work/` on work machines) into `~`, and
   renders the templates: `~/.config/git/config`, which holds the git identity
   (work or personal) and, on macOS, the keychain credential helper; and
   `~/.terraformrc`.
1. **Tools**: everything in `[tools]`: languages, Neovim, gh, atuin, herdr, Claude
   Code, and so on.
1. **The `bootstrap` task** (`mise/tasks/bootstrap`):
   - builds ble.sh;
   - installs the herdr plugins;
   - rebuilds bat's theme cache;
   - on Linux, adds you to the `docker` group;
   - on macOS, installs Operator Mono.

   A failed step doesn't stop the others, and a summary at the end lists anything
   that failed or needs doing by hand. Re-run single steps with
   `mise run bootstrap -- bat-cache`.

A failure in any of the steps before the task stops the run. Fix it and run
`mise bootstrap` again.

### To do by hand

The bootstrap lists these when they apply:

- `gh auth login`. On macOS, then `mise run bootstrap -- operator-mono`, which
  needs gh because the font repo is private.
- Linux: log out and back in for the `docker` group.
- macOS: sign in to the App Store and run `mise bootstrap` again. Then open Docker
  Desktop, InstantSpaceSwitcher, UnnaturalScrollWheels and Logi Tune once to grant
  their permissions.

## Adding something

| What | Where |
|---|---|
| A CLI tool or runtime (prefer this) | `mise use -g <tool>@latest`, which writes `mise/config.toml`. `mise registry <name>` shows if mise has it. |
| A system package or library | `mise/config.linux.toml` (`"apt:<name>"`) and/or `mise/config.macos.toml` (`"brew:<name>"`). |
| A macOS app or font | `"brew-cask:<name>"` in `mise/config.macos.toml` (search at [formulae.brew.sh](https://formulae.brew.sh)). |
| A git checkout | `[bootstrap.repos]` in `mise/config.toml`. |
| Anything else | A `step_<name>` function in `mise/tasks/bootstrap`, added to `STEPS`. |

Use `mise use -g` rather than apt or Homebrew when mise has the tool. That way
it's one entry for both platforms, and the same version on each.

## Platform-specific files

Most differences live inside shared files, using existence checks. For example,
`~/.bashrc` only adds `/opt/homebrew/bin` to PATH if it exists, and looks for
bash-completion in both Homebrew's and Debian's locations.

Whole files that only belong on work machines go in `work/`. For example, the
Teleport links in `work/.local/bin` are relative links to `~/projects/.../build`.
They resolve through `~/.dotfiles/work/.local/bin`, so they rely on the repo
being at `~/.dotfiles`, and dangle until something is built.

When only some lines differ, the file becomes a Tera template: name it
`<file>.tera`, add an entry like the git config's in `[dotfile_groups.home.entries]`,
and use `{% if os() == "macos" %}`, or
`{% if mise_env is defined and "work" in mise_env %}` for work machines.

## Conventions

- **Use `$HOME`, never `/home/nixpig` or `/Users/...`.** The username differs between
  machines. In a file that can't expand `$HOME`, make it a template and use
  `{{ env.HOME }}`; in a link, use a relative path.
- **Don't commit generated state.** For example atuin's install receipt, herdr's
  plugin registry, or `gh/hosts.yml`, which can hold a token on machines without
  a keychain. Only committed files are linked, so untracked files in
  `~/.dotfiles/home` are ignored.
- **Config locations that differ on macOS** are pointed at `~/.config` explicitly:
  - lazygit uses `LG_CONFIG_FILE`, set in `.bashrc`. Its macOS default is
    `~/Library/Application Support`.
  - Ghostty reads `~/.config/ghostty/config`, but also loads
    `~/Library/Application Support/com.mitchellh.ghostty/config`, and that file
    wins. Don't keep one there.

## CI

[`.github/workflows/bootstrap.yml`](.github/workflows/bootstrap.yml) runs on
every push. It covers Debian 13 and Ubuntu 24.04 (each on x64 and arm64) and
macOS. Each job:
1. follows the new-machine steps above, as a normal user with sudo;
2. runs `mise bootstrap` a second time, to check it's repeatable;
3. runs `mise run check` in a login shell.

`check` uses `mise bootstrap status --missing`, so it compares against the
config itself rather than a separate list. It also checks that commands from
each source are on PATH.

macOS CI skips App Store apps, because it can't sign in.

To try a change locally in a container, first commit it. Then, from `~/.dotfiles`:

```sh
docker run --rm -it -e HOST_UID="$(id -u)" -e BRANCH="$(git branch --show-current)" \
  -v "$PWD/.git:/dotfiles.git:ro" debian:trixie bash -c '
  apt-get update -qq && apt-get install -y -qq sudo curl ca-certificates >/dev/null
  userdel -r ubuntu 2>/dev/null   # Ubuntu images already use UID 1000
  useradd -m -u "$HOST_UID" -s /bin/bash tester
  echo "tester ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/tester
  su - tester -c "curl -fsSL https://mise.run | sh && ~/.local/bin/mise bootstrap --yes --force-dotfiles \
    --from \"file:///dotfiles.git?ref=$BRANCH\" --from-dir ~/.dotfiles --config-dir mise"'
```

## Branches

- `mise`: this setup.
- `unified`: the previous yadm setup, with the same dotfiles, using yadm alternates and a bootstrap script.
- `deb`, `macos`, `main`: the old per-platform yadm branches, before they
  were merged. `main` is the old Arch setup (archived).

## Troubleshooting

- **`mise bootstrap` stops on a dotfile conflict**: a real file is where a link
  should go. Keep the repo's version with `--force-dotfiles`, or keep yours with
  `mise dot add <file>`.
- **A tool runs an old version**: something earlier on PATH shadows mise's.
  Run `type -a <tool>` and remove the old one.
- **`--config-dir` refuses to run**: `~/.config/mise` already exists. Move it
  aside (see [Switching a machine from yadm](#switching-a-machine-from-yadm)).
- **bat lost its theme**: `mise run bootstrap -- bat-cache`.
