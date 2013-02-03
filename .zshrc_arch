# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="blinks"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
#gpg-agent 
plugins=(git archlinux command-not-found encode64 git-extras git-flow lein mercurial mvn screen svn systemd urltools)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/home/adam/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl:usr/bin/site_perl/:$PATH


eval "$(fasd --init auto)"

export EDITOR="vim"

alias ls='ls --color'

alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

alias llx='ll -X'
alias lx='ls -X'
alias lla='ls -lA'

alias du='du -h'
alias df='df -h'
alias kk='exit'
alias hkk='history -c;exit'

alias gitk='gitk --all'

alias re='re.pl'

alias -g xzo='-print0|xargs -0'
alias -g xzoo='-print0|xargs -0 -I{}'
alias -g G='| grep'
alias -g Gi='| grep -i'
alias -g L='| less'
alias -g Li='| wc -l'


# Who doesn't want home and end to work?
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

bindkey '\e[A' up-line-or-history
bindkey '\e[B' down-line-or-history

bindkey '\eOA' up-line-or-history
bindkey '\eOB' down-line-or-history

bindkey '\e[C' forward-char
bindkey '\e[D' backward-char

bindkey '\eOC' forward-char
bindkey '\eOD' backward-char
