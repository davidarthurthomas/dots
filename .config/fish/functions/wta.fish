function wta
    if test -z "$argv[1]"
        echo "Usage: wta <branch-name>"
        return 1
    end

    set -l branch $argv[1]
    set -l base (basename (git rev-parse --show-toplevel))
    set -l safe_name (string replace -a '/' '-' $branch)
    set -l wt_path "../$base--$safe_name"

    git worktree add -b $branch $wt_path; or return 1
    _wt_copy_env $wt_path
    cd $wt_path
end
