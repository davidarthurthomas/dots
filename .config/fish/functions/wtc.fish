function wtc
    if test -z "$argv[1]"
        echo "Usage: wtc <existing-branch>"
        return 1
    end

    set -l branch $argv[1]
    set -l base (basename (git rev-parse --show-toplevel))
    set -l safe_name (string replace -a '/' '-' $branch)
    set -l wt_path "../$base--$safe_name"

    git worktree add $wt_path $branch; or return 1
    _wt_copy_env $wt_path
    cd $wt_path
end
