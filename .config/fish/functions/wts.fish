function wts
    set -l selected (git worktree list | fzf --height=~50% | awk '{print $1}')
    test -n "$selected"; and cd $selected
end
