# exports

export PS1="\[$(tput setaf 6)\]\u \W$\[$(tput sgr0)\] "

export EDITOR=mcedit
export GIT_EDITOR=mcedit

export LESS_TERMCAP_mb=$'\E[01;33m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;42;30m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
export LESS_TERMCAP_ue=$'\E[0m'

export USE_LOCAL_PODS=yes
export LOCAL_PODS_FOLDER=~/Projects/
export LANG=en_US.UTF-8


if [ -e ~/.privatevars ]; then
	. ~/.privatevars
fi

# aliases

alias psg="ps -A | grep"
alias lsa="ls -a"
alias init-ssh="exec ssh-agent bash && ssh-add && security unlock-keychain"
alias brewup="brew update && brew upgrade && brew upgrade --cask && brew cleanup"
alias ql="qlmanage -p 2>/dev/null"

# output

date

export PATH="/opt/iOSOpenDev/bin:$PATH"
export PATH="$HOME/.fastlane/bin:$PATH"

eval "$(rbenv init -)"

