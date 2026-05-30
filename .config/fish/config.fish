set -gx EDITOR "zed --wait"
set -gx VISUAL "zed --wait"
set -gx PNPM_HOME /Users/davidthomas/Library/pnpm
set -gx BUN_INSTALL $HOME/.bun

fish_add_path $PNPM_HOME
fish_add_path $BUN_INSTALL/bin
fish_add_path $HOME/.opencode/bin
fish_add_path $HOME/.npm-global/bin
fish_add_path $HOME/.rvm/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.local/bin
fish_add_path /usr/local/bin
fish_add_path /opt/homebrew/bin
fish_add_path /Applications/Obsidian.app/Contents/MacOS

mise activate fish | source
fzf --fish | source
zoxide init fish --cmd cd | source

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
