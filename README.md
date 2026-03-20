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

- `.config/fish/` - Fish shell configuration (env, aliases, prompt, functions)
- `.config/` - Application configurations
- `Library/` - macOS application settings
- `Brewfile` - Homebrew packages and applications

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

Add this line to your `~/.config/fish/conf.d/abbr.fish`:

```fish
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
```

### 6. Install Homebrew Packages

```bash
brew bundle --file=~/Brewfile
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

## Globally Installed Tools

### qmd

[qmd](https://github.com/tobi/qmd) is an on-device search engine for markdown notes, documentation, and knowledge bases. It combines BM25 full-text search, vector semantic search, and LLM re-ranking, all running locally via node-llama-cpp with GGUF models.

Installed globally via npm:

```bash
npm install -g @tobilu/qmd
```

Basic usage:

```bash
# Add a collection of markdown files
qmd collection add ~/path/to/docs --name docs

# Generate embeddings
qmd embed

# Search
qmd search "query"           # Keyword search (BM25)
qmd vsearch "query"          # Semantic search (vector)
qmd query "query"            # Hybrid search with reranking
```

It also supports MCP for agent integration (`qmd mcp`).

## References

- [Atlassian: How to Store Dotfiles](https://www.atlassian.com/git/tutorials/dotfiles)
