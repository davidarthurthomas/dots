set -g fish_greeting

mise activate fish | source
abbr -a m "mise"
abbr -a mi "mise install"
abbr -a mr "mise run"
abbr -a mt "mise task"

fzf --fish | source
zoxide init fish --cmd cd | source

fish_add_path $HOME/.local/bin
fish_add_path /usr/local/bin
fish_add_path /opt/homebrew/bin

set -gx PNPM_HOME /Users/davidthomas/Library/pnpm
fish_add_path $PNPM_HOME

set -gx EDITOR "zed --wait"
set -gx VISUAL "zed --wait"

fish_add_path /Applications/Obsidian.app/Contents/MacOS

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :
