# Git abbreviations -- expand inline on space/enter, so the full command is
# visible before it runs. Naming follows the Oh My Zsh git plugin (consensus).

# Core
abbr -a g    git
abbr -a gst  'git status'
abbr -a gss  'git status --short'

# Stage & commit
abbr -a ga    'git add'
abbr -a gaa   'git add --all'
abbr -a gc    'git commit --verbose'
abbr -a gcmsg 'git commit --message'
abbr -a 'gc!'  'git commit --verbose --amend'
abbr -a 'gcn!' 'git commit --verbose --amend --no-edit'

# Branch & switch
abbr -a gco  'git checkout'
abbr -a gcb  'git checkout -b'
abbr -a gsw  'git switch'
abbr -a gswc 'git switch -c'
abbr -a gb   'git branch'
abbr -a gbd  'git branch --delete'

# Diff & log
abbr -a gd   'git diff'
abbr -a gdca 'git diff --cached'
abbr -a glo  'git log --oneline --decorate'
abbr -a glog 'git log --oneline --decorate --graph'

# Sync
abbr -a gp    'git push'
abbr -a gpf   'git push --force-with-lease'
abbr -a gpsup 'git push --set-upstream origin (git branch --show-current)'
abbr -a gl    'git pull'
abbr -a gf    'git fetch'
abbr -a gfa   'git fetch --all --prune'
abbr -a gr    'git remote'

# Rebase (--update-refs default keeps stacked branches in sync)
abbr -a grb  'git rebase --update-refs'
abbr -a grbi 'git rebase --update-refs --interactive'
abbr -a grbc 'git rebase --continue'
abbr -a grba 'git rebase --abort'

# Merge & cherry-pick
abbr -a gm   'git merge'
abbr -a gcp  'git cherry-pick'

# Stash
abbr -a gsta 'git stash push'
abbr -a gstp 'git stash pop'

# Restore & reset
abbr -a grs  'git restore'
abbr -a grh  'git reset'
abbr -a grhh 'git reset --hard'
