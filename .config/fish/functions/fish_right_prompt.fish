function fish_right_prompt
    # Skip if not in a git repo
    git rev-parse --is-inside-work-tree &>/dev/null; or return

    set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git describe --tags --exact-match HEAD 2>/dev/null; or git rev-parse --short HEAD 2>/dev/null)
    test -z "$branch"; and return

    set -l info

    set -l ahead (git rev-list --count @{upstream}..HEAD 2>/dev/null)
    set -l behind (git rev-list --count HEAD..@{upstream} 2>/dev/null)
    test "$ahead" -gt 0 2>/dev/null; and set -a info "↑$ahead"
    test "$behind" -gt 0 2>/dev/null; and set -a info "↓$behind"

    set -l staged (git diff --cached --numstat 2>/dev/null)
    set -l modified (git diff --numstat 2>/dev/null)
    set -l untracked (git ls-files --others --exclude-standard 2>/dev/null)
    set -l stashed (git stash list 2>/dev/null)

    test (count $staged) -gt 0; and set -a info "+"(count $staged)
    test (count $modified) -gt 0; and set -a info "~"(count $modified)
    test (count $untracked) -gt 0; and set -a info "?"(count $untracked)
    test (count $stashed) -gt 0; and set -a info "⚑"(count $stashed)

    set -l git_dir (git rev-parse --git-dir 2>/dev/null)
    if test -d "$git_dir/rebase-merge"; or test -d "$git_dir/rebase-apply"
        set -a info rebase
    end
    test -f "$git_dir/MERGE_HEAD"; and set -a info merge
    test -f "$git_dir/CHERRY_PICK_HEAD"; and set -a info cherry-pick

    if test (count $info) -gt 0
        echo -n "$branch "(string join ' ' $info)
    else
        echo -n "$branch"
    end
end
