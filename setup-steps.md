# Setup steps


herdr + config

## Basics

```
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

```
sudo apt update && sudo apt install -y curl ca-certificates build-essential
```

## Tools

```
# misc.
sudo apt install bat btop eza fzf gawk jq lazygit ranger ripgrep starship yadm

# atuin
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# hunk
curl -fsSL https://hunk.dev/install.sh | sh

# gh
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
  && sudo mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && sudo mkdir -p -m 755 /etc/apt/sources.list.d \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && sudo apt update \
  && sudo apt install gh -y

# gh-dash
gh extension install dlvhdr/gh-dash

# ranger devicons
git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons \
  && echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf

# ble.sh
git clone --recursive https://github.com/akinomyoga/ble.sh.git \
  && cd ble.sh \
  && make install

# bat
mkdir -p "$(batcat --config-dir)/themes" \
  && wget -P "$(batcat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme \
  && batcat cache --build

```

## Neovim

```
sudo apt remove -y neovim
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
sudo rm -rf /opt/nvim-linux-arm64
sudo tar -C /opt -xzf nvim-linux-arm64.tar.gz
rm nvim-linux-arm64.tar.gz
echo 'export PATH=/opt/nvim-linux-arm64/bin:$PATH' >> ~/.profile
source ~/.profile
nvim --version    # NVIM v0.12.6
```

```
mkdir -p ~/.local/bin
curl -L https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-arm64.gz | gunzip > ~/.local/bin/tree-sitter
chmod +x ~/.local/bin/tree-sitter
source ~/.profile
```

## tmux

```
sudo apt update && sudo apt install -y tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## herdr

```


herdr plugin install aimdevlee/herdr-nvim-nav
herdr plugin install makyinmars/herdr-context.nvim
herdr plugin install jeffarese/herdr-bar
```

## Claude

```
curl -fsSL https://claude.ai/install.sh | bash
```

## Go

```
GO_VER=$(curl -s 'https://go.dev/dl/?mode=json' | python3 -c 'import json,sys;print(json.load(sys.stdin)[0]["version"])')
curl -LO "https://go.dev/dl/${GO_VER}.linux-arm64.tar.gz"
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "${GO_VER}.linux-arm64.tar.gz"
rm "${GO_VER}.linux-arm64.tar.gz"
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> ~/.profile
source ~/.profile
go version
```

## Node

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.41.0/install.sh | bash
source ~/.bashrc
nvm install 26
nvm alias default 26
node --version
npm --version
```

## Rust

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup update
rustup --version
```

## Docker

```
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER
newgrp docker
docker run --rm hello-world
```



