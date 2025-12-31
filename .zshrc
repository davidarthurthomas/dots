# =============================================================================
# Environment Variables
# =============================================================================
export EDITOR="zed --wait"
export VISUAL="zed --wait"
export PNPM_HOME="/Users/davidthomas/Library/pnpm"
export BUN_INSTALL="$HOME/.bun"

# =============================================================================
# PATH Configuration
# =============================================================================
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.rvm/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"

# pnpm (conditional add)
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# =============================================================================
# History Configuration
# =============================================================================
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history

# =============================================================================
# Shell Options
# =============================================================================
setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt prompt_subst

# =============================================================================
# Key Bindings
# =============================================================================
# Completion using arrow keys (based on history)
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# =============================================================================
# Completion System
# =============================================================================
autoload -Uz compinit && compinit

# =============================================================================
# Aliases - Navigation
# =============================================================================
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# =============================================================================
# Aliases - Modern CLI Tools
# =============================================================================
# eza (better ls)
alias ls="eza --icons=always"
alias ll="eza -la --icons=always"
alias lt="eza --tree --icons=always"

# zoxide (better cd)
eval "$(zoxide init zsh)"
alias cd="z"
alias zi="z -i"

# ripgrep (better grep)
alias grep="rg"

# =============================================================================
# Aliases - Git
# =============================================================================
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gr='git pull'
alias gl='git log'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gst='git stash'
alias gsp='git stash pop'
alias grs='git rebase --update-refs'
alias grsi='git rebase --update-refs -i'
alias grc='git rebase --continue'
alias gra='git rebase --abort'
alias gpf='git push --force-with-lease'

# Stacked PR helpers
grom() {
  if [[ -z "$1" ]]; then
    echo "Usage: grom <base-branch>"
    return 1
  fi
  git rebase --update-refs "$1"
}

gbs() {
  if [[ -z "$1" ]]; then
    echo "Usage: gbs <base-branch>"
    return 1
  fi
  git log --oneline --decorate "$1"..HEAD
}

gps() {
  if [[ -z "$1" ]]; then
    echo "Usage: gps <base-branch>"
    return 1
  fi
  git log --format='%(decorate:prefix=,suffix=,pointer=%n,separator=%n)' "$1"..HEAD \
    | grep -v '^$' | grep -v '^HEAD$' | grep -v '^origin/' | sort -u \
    | xargs -r git push --force-with-lease origin
}

# =============================================================================
# Aliases - Misc
# =============================================================================
alias python="python3"
alias mkdir="mkdir -p"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# =============================================================================
# Functions
# =============================================================================
# Create directory and cd into it
take() { mkdir -p "$1" && cd "$1" }

# =============================================================================
# Tool Initialization
# =============================================================================
# fnm (Fast Node Manager) - replaces nvm
eval "$(fnm env --use-on-cd)"

# fzf - fuzzy finder (Ctrl+R for history, Ctrl+T for files, Alt+C for cd)
source <(fzf --zsh)

# Bun completions
[ -s "/Users/davidthomas/.bun/_bun" ] && source "/Users/davidthomas/.bun/_bun"

# =============================================================================
# Prompt
# =============================================================================
PROMPT='%n@%m %1~ %# '

# =============================================================================
# Git Status Display (RPROMPT) - Async
# =============================================================================
# Shows: branch, sync status (↑N/↓N), staged (+N), modified (~N),
# untracked (?N), stashed (⚑N), and special states (merge/rebase/cherry-pick)
# Example: "main ↑2↓1 +3 ~2 ?1 ⚑1"

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats '%b'
zstyle ':vcs_info:*' actionformats '%b|%a'

_git_status_async_callback() {
    local fd=$1
    RPROMPT="$(<&$fd)"
    zle reset-prompt
    exec {fd}<&-
}

_git_status_worker() {
    vcs_info
    [[ -z ${vcs_info_msg_0_} ]] && return

    local branch=${vcs_info_msg_0_//[\[\]]/}
    local ahead behind staged modified untracked stashed
    local -a info

    ahead=$(git rev-list --count @{upstream}..HEAD 2>/dev/null)
    behind=$(git rev-list --count HEAD..@{upstream} 2>/dev/null)
    [[ "$ahead" -gt 0 ]] && info+=("↑$ahead")
    [[ "$behind" -gt 0 ]] && info+=("↓$behind")

    staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
    stashed=$(git stash list 2>/dev/null | wc -l | tr -d ' ')

    [[ "$staged" -gt 0 ]] && info+=("+$staged")
    [[ "$modified" -gt 0 ]] && info+=("~$modified")
    [[ "$untracked" -gt 0 ]] && info+=("?$untracked")
    [[ "$stashed" -gt 0 ]] && info+=("⚑$stashed")

    local git_dir=$(git rev-parse --git-dir 2>/dev/null)
    [[ -d "$git_dir/rebase-merge" || -d "$git_dir/rebase-apply" ]] && info+=("rebase")
    [[ -f "$git_dir/MERGE_HEAD" ]] && info+=("merge")
    [[ -f "$git_dir/CHERRY_PICK_HEAD" ]] && info+=("cherry-pick")

    echo "$branch${info:+ ${(j: :)info}}"
}

precmd_vcs_info() {
    RPROMPT=""

    # Skip if not in a git repo
    git rev-parse --is-inside-work-tree &>/dev/null || return

    local fd
    exec {fd}< <(_git_status_worker)
    zle -F $fd _git_status_async_callback
}

precmd_functions=(${precmd_functions:#precmd_vcs_info})
precmd_functions+=(precmd_vcs_info)

# =============================================================================
# Sourced Scripts
# =============================================================================
source ~/.zsh/worktrees.zsh

# =============================================================================
# Plugins
# =============================================================================
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-you-should-use/you-should-use.plugin.zsh
