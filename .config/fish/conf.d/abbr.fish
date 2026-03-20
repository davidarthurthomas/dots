# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Modern CLI tools (aliases to shadow builtins)
alias ls='eza --icons=always'
alias ll='eza -la --icons=always'
alias lt='eza --tree --icons=always'
alias grep=rg

# Misc
alias python=python3
alias mkdir='mkdir -p'
alias tailscale=/Applications/Tailscale.app/Contents/MacOS/Tailscale
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

# Git (abbreviations -- expand inline when you press space/enter)
abbr -a g git
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit'
abbr -a gp 'git push'
abbr -a gr 'git pull'
abbr -a gl 'git log'
abbr -a gd 'git diff'
abbr -a gco 'git checkout'
abbr -a gb 'git branch'
abbr -a gst 'git stash'
abbr -a gsp 'git stash pop'
abbr -a grs 'git rebase --update-refs'
abbr -a grsi 'git rebase --update-refs -i'
abbr -a grc 'git rebase --continue'
abbr -a gra 'git rebase --abort'
abbr -a gpf 'git push --force-with-lease'
