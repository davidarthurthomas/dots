# =============================================================================
# Git Worktrees
# =============================================================================
# Create new worktree + branch (handles slashes in branch names)
wta() {
  if [[ -z "$1" ]]; then
    echo "Usage: wta <branch-name>"
    return 1
  fi

  local branch="$1"
  local base="$(basename $(git rev-parse --show-toplevel))"
  local safe_name="${branch//\//-}"
  local wt_path="../${base}--${safe_name}"

  git worktree add -b "$branch" "$wt_path"
  cd "$wt_path"
}

# Checkout existing branch as worktree
wtc() {
  if [[ -z "$1" ]]; then
    echo "Usage: wtc <existing-branch>"
    return 1
  fi

  local branch="$1"
  local base="$(basename $(git rev-parse --show-toplevel))"
  local safe_name="${branch//\//-}"
  local wt_path="../${base}--${safe_name}"

  git worktree add "$wt_path" "$branch"
  cd "$wt_path"
}

# List worktrees
wtl() {
  git worktree list
}

# Switch worktree (fzf)
wts() {
  local selected=$(git worktree list | fzf --height=~50% | awk '{print $1}')
  [[ -n "$selected" ]] && cd "$selected"
}

# Delete current worktree + branch
wtd() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  local worktree=$(pwd)
  local main=$(git worktree list | head -1 | awk '{print $1}')

  if [[ "$worktree" == "$main" ]]; then
    echo "Can't delete main worktree"
    return 1
  fi

  echo "Delete worktree: $worktree"
  echo "Delete branch:   $branch"
  read -q "?Continue? (y/n) " && echo

  [[ "$REPLY" == "y" ]] || return 0

  cd "$main"
  git worktree remove "$worktree" --force
  git branch -D "$branch"
}

# Prune stale worktrees
wtp() {
  git worktree prune -v
}
