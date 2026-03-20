function _wt_copy_env
    set -l dest $argv[1]
    for f in .env*
        if test -f "$f"
            cp "$f" "$dest/"
        end
    end
end
