function gps
    if test -z "$argv[1]"
        echo "Usage: gps <base-branch>"
        return 1
    end
    set -l branches (git log --format='%(decorate:prefix=,suffix=,pointer=%n,separator=%n)' "$argv[1]"..HEAD \
        | string match -rv '^$' | string match -rv '^HEAD$' | string match -rv '^origin/' | sort -u)
    if test (count $branches) -gt 0
        git push --force-with-lease origin $branches
    else
        echo "No local branches found to push"
    end
end
