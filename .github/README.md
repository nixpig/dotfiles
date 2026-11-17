# dotfiles

My dotfiles for **macOS** and **Debian / Ubuntu / Raspberry Pi OS**, managed with
[yadm](https://yadm.io), plus a bootstrap script that sets up a new machine from scratch.

There's one branch for every platform. Most files are shared; the few real platform
differences are handled with existence checks in the shell config, or yadm
[alternate files](#platform-specific-files) where a whole file only makes sense on
one platform.

[![bootstrap](https://github.com/nixpig/dotfiles/actions/workflows/bootstrap.yml/badge.svg)](https://github.com/nixpig/dotfiles/actions/workflows/bootstrap.yml)

## New machine

### macOS

You need yadm before you can clone, and it's a single script. Running `git` for the
first time will prompt you to install the Xcode Command Line Tools.

```sh
curl -fLo /tmp/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod +x /tmp/yadm
/tmp/yadm clone --bootstrap https://github.com/nixpig/dotfiles.git
```

### Debian / Ubuntu / Raspberry Pi OS

```sh
sudo apt update && sudo apt install -y yadm git curl
yadm clone --bootstrap https://github.com/nixpig/dotfiles.git
```

### If the machine already has dotfiles

`yadm clone` won't overwrite existing files (such as a distro's default `~/.bashrc`);
it leaves them and tells you. To use the versions from this repo instead:

```sh
yadm checkout -- ~/.bashrc ~/.profile    # or whichever files it listed
yadm alt                                 # link the platform-specific files
```

Then open a new terminal so the shell config takes effect.

## Bootstrap

`yadm bootstrap` (run automatically by `yadm clone --bootstrap`) installs everything
for the current OS. It's safe to run again at any time: each step skips work that's
already done.

```sh
yadm bootstrap                               # run every step
~/.config/yadm/bootstrap --list              # list the steps for this OS
~/.config/yadm/bootstrap --only gh-dash,tpm  # run particular steps
BOOTSTRAP_ONLY=gh-dash yadm bootstrap        # same; yadm doesn't pass arguments through
```

**Failures.** Prerequisites stop the run if they fail, because everything after them
depends on them. Every other step carries on after a failure. At the end you get a
summary showing each step as `ok`, `skip`, `manual` or `FAIL`, a list of manual
follow-ups, the command to retry whatever failed, and the path to the full log
(`~/.local/state/bootstrap/`).

**Installers that edit shell files.** Some installers (atuin's, for example) append to
`~/.bashrc` or `~/.profile`. The bootstrap reverts those edits afterwards, because the
dotfiles already set up PATH and shell integration.

### Steps

| Step | macOS | Linux | What it does |
|---|---|---|---|
| `network`, `sudo` | ✓ | ✓ | Prerequisites: GitHub is reachable, sudo works (kept alive for the run) |
| `xcode-clt` | ✓ | | Prerequisite: Xcode Command Line Tools (opens Apple's installer, then waits) |
| `homebrew` | ✓ | | Prerequisite: Homebrew |
| `apt-packages` | | ✓ | Prerequisite: everything in [`packages.apt`](../.config/yadm/packages.apt) |
| `mise` | ✓ | ✓ | Prerequisite: [mise](https://mise.jdx.dev) |
| `brew-bundle` | ✓ | | Everything in the [`Brewfile`](../.config/yadm/Brewfile): CLI tools, apps, fonts |
| `mise-tools` | ✓ | ✓ | Everything in [`mise/config.toml`](../.config/mise/config.toml): language runtimes and dev tools |
| `rust` | ✓ | ✓ | rustup |
| `atuin`, `hunk`, `claude`, `herdr` | ✓ | ✓ | Each tool's official installer |
| `herdr-plugins` | ✓ | ✓ | herdr plugins (macOS also gets herdr-stay-awake) |
| `blesh`, `tpm`, `ranger-devicons` | ✓ | ✓ | ble.sh, the tmux plugin manager, ranger icons |
| `bat-cache` | ✓ | ✓ | Builds bat's theme cache so the tracked Catppuccin theme works |
| `gh-dash` | ✓ | ✓ | The gh-dash extension (needs `gh auth login` first) |
| `operator-mono` | ✓ | | Patched Operator Mono from a private repo (needs `gh auth login` first) |
| `docker` | | ✓ | Docker Engine from Docker's apt repo, and adds you to the `docker` group |
| `azure-cli` | | ✓ | Microsoft's repo on Ubuntu, Debian's own package on Debian 13 |
| `aws-cli` | | ✓ | apt where packaged; AWS's official installer otherwise (Ubuntu 24.04) |

On macOS, Docker Desktop, the Azure CLI and the AWS CLI come from the Brewfile.

### Manual follow-ups

The summary lists whatever applies. These need a person:

- **`gh auth login`**, then `~/.config/yadm/bootstrap --only gh-dash` (and
  `operator-mono` on macOS).
- **Linux:** log out and back in so the `docker` group applies.
- **macOS:** open Docker Desktop, InstantSpaceSwitcher, UnnaturalScrollWheels and
  Logi Tune once, and grant any permissions they ask for.
- **macOS:** Amphetamine comes from the App Store, so you need to be signed in. If its
  install fails, "Get" it once in the App Store app, then run
  `~/.config/yadm/bootstrap --only brew-bundle`.

### Where things are installed from

| Source | File | Used for |
|---|---|---|
| Homebrew (macOS) | `~/.config/yadm/Brewfile` | CLI tools, GUI apps, the Nerd Fonts symbols font |
| apt (Linux) | `~/.config/yadm/packages.apt` | CLI tools, compilers, system packages |
| mise (both) | `~/.config/mise/config.toml` | Go, Node, Neovim, gh, lazygit, starship, kubectl, helm, minikube, terraform, yq, protoc and its Go plugins, grpcurl, goreleaser, benchstat |
| Official installers | `step_*` functions in the bootstrap | rustup, atuin, hunk, Claude Code, herdr, Docker Engine, and so on |

mise gives both platforms the same, current versions of tools that Debian and Ubuntu
package old or not at all. Notably, Debian's `yq` package is a different tool from
mikefarah's yq.

## Adding something

- **A package on both platforms:** add it to the `Brewfile` and to `packages.apt`.
  apt installs the whole list in one go, so one wrong name fails all of it: check the
  name exists on both Debian (`apt-cache policy <name>`) and Ubuntu
  (packages.ubuntu.com) first.
- **A dev tool or runtime:** `mise use -g <tool>@latest` adds it to
  `~/.config/mise/config.toml`. Check it's in the registry with `mise registry`.
- **A macOS app:** `cask "<name>"` in the `Brewfile` (search with `brew search --cask`).
  For App Store apps, use `mas "<Name>", id: <id>`.
- **Anything with its own installer:** add a `step_<name>` function to
  `~/.config/yadm/bootstrap` and register it with `add_step`. Make it start by
  calling `skip` when the work is already done, so re-runs stay cheap.

Then commit, and the [CI workflow](#ci) checks it on fresh machines.

## Platform-specific files

Most differences live inside shared files, using existence checks. For example,
`~/.bashrc` only runs `brew shellenv` if Homebrew is there, and looks for
bash-completion in both Homebrew's and Debian's locations. The PATH list includes every
platform's directories; ones that don't exist are skipped.

Where a whole file only makes sense on one platform, yadm
[alternates](https://yadm.io/docs/alternates) pick the right version by filename suffix.
`yadm alt` creates the symlinks (it runs automatically after clone, checkout and pull):

| File | Used on | Why |
|---|---|---|
| `.config/git/config##os.Darwin` | macOS | Work git identity, and the `osxkeychain` credential helper |
| `.config/git/config##default` | everything else | Personal git identity |
| `.terraformrc##os.Darwin` | macOS | Terraform dev overrides for local builds |
| `.local/bin/{tsh,tctl,teleport,tbot,fdpass-teleport}##os.Darwin` | macOS | Symlinks to local Teleport builds |

Git reads `~/.config/git/config` as well as `~/.gitconfig`, so the shared
`.gitconfig` holds everything else.

Other conditions are available if needed: `##os.Linux`, `##distro.ubuntu`,
`##distro_family.debian`, `##hostname.<name>`, and `##class.<name>`, where you
set a machine's class with `yadm config local.class <name>`.

## Conventions

- **Use `$HOME`, never `/home/nixpig` or `/Users/...`.** The username differs between
  machines, so absolute home paths make otherwise-shared files platform-specific.
- **Don't track generated state.** For example atuin's install receipt, herdr's
  plugin registry and `gh/hosts.yml` (which can hold a token on machines without a
  keychain). The bootstrap recreates them.
- **Config locations that differ on macOS** are pointed at `~/.config` explicitly:
  - lazygit uses `LG_CONFIG_FILE` (set in `.bashrc`); its macOS default is
    `~/Library/Application Support`.
  - Ghostty reads `~/.config/ghostty/config`, but also loads
    `~/Library/Application Support/com.mitchellh.ghostty/config`, and that file wins.
    Don't keep one there.

## CI

[`.github/workflows/bootstrap.yml`](workflows/bootstrap.yml) runs on every push and pull
request:

- **Linux:** fresh Debian trixie and Ubuntu 24.04 containers, each on x64 and arm64.
- **macOS:** the latest macOS runner. Amphetamine is skipped there, because the App
  Store needs an interactive sign-in.

Each job clones the commit with yadm as a normal user and runs `yadm bootstrap`. It
then runs [`ci-check-tools`](../.config/yadm/ci-check-tools), which checks every tool
is on PATH in a login shell. You can also run that by hand on any machine:

```sh
bash -l ~/.config/yadm/ci-check-tools
```

To test the Linux bootstrap locally in Docker without touching your machine:

```sh
docker run --rm -it -e HOST_UID="$(id -u)" \
  -v ~/.local/share/yadm/repo.git:/dotfiles.git:ro debian:trixie bash -c '
  apt-get update -qq && apt-get install -y -qq sudo git yadm curl ca-certificates >/dev/null
  userdel -r ubuntu 2>/dev/null   # Ubuntu images already use UID 1000
  useradd -m -u "$HOST_UID" -s /bin/bash tester
  echo "tester ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/tester
  rm -f /home/tester/.bashrc /home/tester/.profile
  su - tester -c "yadm clone --no-bootstrap -b unified /dotfiles.git && yadm bootstrap"'
```

Swap in `ubuntu:24.04` to test Ubuntu. The test user gets your UID because only you
can read the yadm repo that's mounted in.

## Branches

- **`unified`:** everything above.
- **`archive/arch`:** the old Arch Linux desktop setup (i3, polybar and friends), kept
  for reference. It was set up with Ansible rather than this bootstrap.

## Troubleshooting

- **Shell changes not showing up:** open a new terminal, or run `exec bash`.
- **bat isn't using the Catppuccin theme:** run `bat cache --build` (`batcat` on
  Debian/Ubuntu), and check `bat --config-dir` is `~/.config/bat`.
- **A tool is missing:** run `bash -l ~/.config/yadm/ci-check-tools` to see what's not
  on PATH, then re-run the relevant bootstrap step with `--only`.
- **A step failed:** the end of the bootstrap output names the step, gives the retry
  command, and points to the full log in `~/.local/state/bootstrap/`.
