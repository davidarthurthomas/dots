function wtd
    if test -z "$argv[1]"
        echo "Usage: wtd <branch-name>"
        return 1
    end

    set -l branch $argv[1]
    set -l worktree (git worktree list --porcelain | grep -B 2 "branch refs/heads/$branch" | head -1 | awk '{print $2}')

    if test -z "$worktree"
        echo "No worktree found for branch: $branch"
        return 1
    end

    # Check if it's the main worktree
    if test -d "$worktree/.git"
        echo "Can't delete main worktree"
        return 1
    end

    echo "Delete worktree: $worktree"
    read -P 'Continue? (y/n) ' confirm
    test "$confirm" = y; or return 0

    git worktree remove $worktree --force
end
