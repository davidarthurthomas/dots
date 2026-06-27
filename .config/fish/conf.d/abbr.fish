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
alias config="/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"
