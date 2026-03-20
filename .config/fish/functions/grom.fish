function grom
    if test -z "$argv[1]"
        echo "Usage: grom <base-branch>"
        return 1
    end
    git rebase --update-refs $argv[1]
end
