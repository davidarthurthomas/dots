function gbs
    if test -z "$argv[1]"
        echo "Usage: gbs <base-branch>"
        return 1
    end
    git log --oneline --decorate "$argv[1]"..HEAD
end
