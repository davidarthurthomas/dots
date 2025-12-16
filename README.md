# Dotfiles

My personal dotfiles, managed using a bare Git repository.

## How It Works

This setup uses a **bare Git repository** stored in `~/.cfg` with the working tree set to `$HOME`. This allows tracking dotfiles directly in the home directory without symlinking or additional tools.

The key is a `config` alias that wraps git commands:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

This lets you run git commands like `config status`, `config add`, `config commit`, etc. to manage your dotfiles.

## What's Tracked

- `.zshrc` - Zsh configuration (aliases, prompt, plugins, etc.)
- `.config/` - Application configurations
- `Library/` - macOS application settings

## Setting Up on a New Machine

### 1. Clone the Repository

```bash
git clone --bare git@github.com-davidarthurthomas:davidarthurthomas/dots.git $HOME/.cfg
```

### 2. Define the Alias

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

### 3. Checkout the Files

```bash
config checkout
```

If you get errors about existing files that would be overwritten:

```bash
# Back up conflicting files
mkdir -p .config-backup
config checkout 2>&1 | grep -E "^\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}

# Then retry checkout
config checkout
```

### 4. Configure the Repository

Hide untracked files (so `config status` only shows tracked files):

```bash
config config --local status.showUntrackedFiles no
```

### 5. Add the Alias Permanently

Add this line to your `~/.zshrc` or `~/.bashrc`:

```bash
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
```

## Usage

Once set up, use the `config` alias just like `git`:

```bash
# Check status
config status

# Add a file
config add .vimrc

# Commit changes
config commit -m "Add vimrc"

# Push to remote
config push

# Pull updates
config pull
```

## Adding New Dotfiles

```bash
config add ~/.some-config-file
config commit -m "Add some-config-file"
config push
```

## References

- [Atlassian: How to Store Dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
