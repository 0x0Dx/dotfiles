# dotfiles

> Unix configurations for WSL2 development

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-WSL2-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/wsl)

Personal WSL2 setup featuring Zsh, Tmux, and Catppuccin theming. Focused on a productive terminal workflow.

## What's Included

- **Zsh** with Powerlevel10k (Pure style for minimalism)
- **Tmux** for terminal multiplexing with Vim keybindings
- **Git** configuration with sensible defaults
- **Fastfetch** for system information
- Catppuccin Mocha theme throughout

## Requirements

- Windows 11 with WSL2 enabled
- Ubuntu 22.04+ (likely compatible with other distributions)
- Basic terminal knowledge
- Patience for learning Tmux keybindings

## Installation

### Install Dependencies

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install essentials
sudo apt install -y zsh git curl wget build-essential tmux

# Install Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```

### Setup Dotfiles

```bash
# Clone repository
git clone https://github.com/0x0Dx/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run installation script
chmod +x install.sh
./install.sh

# Change default shell to Zsh
chsh -s $(which zsh)

# Reload shell
exec zsh
```

The Powerlevel10k configuration wizard will run on first launch. Pure style is recommended but customize as preferred.

## Configuration Overview

### .zshrc

Shell configuration including:
- Powerlevel10k theme
- Syntax highlighting
- Autosuggestions
- History optimization
- Useful aliases

### .p10k.zsh

Powerlevel10k configuration using Pure style:
- Minimal prompt design
- Asynchronous Git status updates
- Command execution time display
- Python virtualenv indicator
- Clean aesthetic

### tmux.conf

Tmux setup featuring:
- `Ctrl-a` prefix (Screen-style)
- Vim keybindings for navigation (`hjkl`)
- Mouse support
- Catppuccin theme
- vim-tmux-navigator integration

**Key bindings:**
```
Prefix: Ctrl-a

Pane Navigation:
  h/j/k/l         - Vim-style movement
  Alt+Arrows      - Alternative movement
  |               - Split horizontal
  -               - Split vertical
  f               - Toggle fullscreen

Window Navigation:
  Shift+Left/Right    - Previous/next window
  Alt+Shift+h/l       - Previous/next window (Vim-style)

Copy Mode:
  v               - Begin selection
  y               - Copy selection
```

### Git Configuration

`.gitconfig` includes:
- Compression level 9
- Automatic remote tracking
- Rebase by default on pull
- diff-so-fancy integration
- Branch sorting by commit date
- Shortcuts: `me:repo` → `git@github.com:0x0Dx/repo`

`.gitignore_global` excludes:
- OS artifacts (`.DS_Store`, `Thumbs.db`)
- Editor files (`.vscode/`, `.idea/`, `*.swp`)
- Build artifacts (`node_modules/`, `dist/`, `__pycache__/`)

### Fastfetch

Display includes:
- Ubuntu small logo
- OS and kernel information
- Shell details
- Package count
- System uptime
- Memory usage
- Color palette (Catppuccin colors)

## Directory Structure

```
dotfiles/
├── .config/
│   ├── fastfetch/config.jsonc
│   ├── git/
│   │   ├── .gitconfig
│   │   └── .gitignore_global
│   └── tmux/tmux.conf
├── .zshrc
├── .p10k.zsh
├── install.sh
└── README.md
```

### install.sh

Installation script that copies configurations to appropriate locations. Backs up existing files with `.bak` extension.

## WSL2 Optimization

### Performance Configuration

Add to `/etc/wsl.conf`:
```ini
[wsl2]
memory=8GB
processors=4

[automount]
options="metadata,umask=22,fmask=11"
```

Restart WSL after changes: `wsl --shutdown`

### Windows Integration

Access Windows files:
```bash
cd /mnt/c/Users/YourName
```

Add Windows tools to PATH (in `.zshrc`):
```bash
export PATH="$PATH:/mnt/c/Windows/System32"
```

## Troubleshooting

**Powerlevel10k Not Displaying**

Font issue - ensure a Nerd Font is installed on Windows (JetBrainsMono recommended).

Reconfigure if needed:
```bash
p10k configure
```

**Tmux Plugins Not Working**

Install TPM (Tmux Plugin Manager):
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

In Tmux, press `Prefix + I` (capital I) to install plugins.

**diff-so-fancy Missing**

```bash
sudo npm install -g diff-so-fancy
```

Alternatively, remove from Git config if not needed.

**Zsh Slow Startup**

Disable instant prompt in `.p10k.zsh`:
```bash
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
```

## Customization

### Custom Aliases

Add to `.zshrc`:
```bash
alias update='sudo apt update && sudo apt upgrade -y'
alias zshconfig='nvim ~/.zshrc'
alias tmuxconfig='nvim ~/.tmux.conf'
alias reload='source ~/.zshrc'
```

### Additional Tmux Plugins

Edit `tmux.conf`:
```bash
set -g @plugin 'tmux-plugins/tmux-resurrect'  # Save sessions
set -g @plugin 'tmux-plugins/tmux-continuum'  # Auto-save sessions
```

Reload configuration: `tmux source ~/.tmux.conf`

### Multiple Git Profiles

For separate work and personal accounts, add to `.gitconfig`:
```bash
[includeIf "gitdir:~/work/"]
    path = ~/.gitconfig-work
```

## Maintenance

### Regular Updates

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Update Zsh plugins
cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && git pull
cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && git pull

# Update Powerlevel10k
cd ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k && git pull
```

### Backup

Create dated backup:
```bash
tar -czf ~/dotfiles-backup-$(date +%Y%m%d).tar.gz -C ~ \
  .zshrc .p10k.zsh .tmux.conf .gitconfig

# Store in Windows for safety
cp ~/dotfiles-backup-*.tar.gz /mnt/c/Users/YourName/
```

### Additional Tools

Recommended installations for enhanced workflow:

```bash
sudo apt install -y \
  neovim \
  ripgrep \
  fd-find \
  bat \
  exa \
  htop \
  tree
```

## Roadmap

- [x] Core shell configuration
- [x] Terminal multiplexer setup
- [x] Git workflow optimization
- [ ] Automated backup script
- [ ] Neovim configuration
- [ ] Docker integration guide
- [ ] Development environment templates

## Credits

- [Catppuccin](https://catppuccin.com) - Color scheme
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh prompt
- [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) - Plugin ecosystem
- [diff-so-fancy](https://github.com/so-fancy/diff-so-fancy) - Enhanced diffs

## Contributing

Improvements and suggestions are welcome. Open an issue or pull request for any changes.

## License

MIT License. See [LICENSE](LICENSE) for details.

---

Made by [0x0D](https://github.com/0x0Dx)

*Productive terminal environment for WSL2*