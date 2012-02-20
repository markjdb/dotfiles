prompt_prefix()
{
    git branch > /dev/null 2>&1 && echo "git " && return
    stat CVS > /dev/null 2>&1 && echo "CVS " && return
    stat .svn > /dev/null 2>&1 && echo "svn " && return
}

PS1='\[\033[01;34m\]$(prompt_prefix)\[\033[00m\]\[\033[01;32m\]\u\[\033[00m\]: \[\033[01;31m\]\w/\[\033[00m\]\[\033[01;33m\]\[\033[00m\]$ '

set -o vi

export CVSROOT=m6johnst@linux.student.cs.uwaterloo.ca:/u/m6johnston/cvsroot
export CVS_RSH=ssh
export EDITOR=`which vim`
export BUG_PROJECT=/home/mark/src/bugs

source ~/bin/set_csdb

# Aliases
alias mocp='mocp -T nightly_theme'

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

alias sshwat='ssh -Y m6johnst@linux.student.cs.uwaterloo.ca'

case $(uname) in
Linux)
    alias ls='ls --color=auto'
    ;;
FreeBSD)
    alias ls='ls -G'
    ;;
esac

alias lss='ls'
alias lls='ls'
alias sl='ls'
alias grep='grep --color=auto'

alias gitco='git checkout'
alias gita='git add'
alias gitb='git branch'
alias gitc='git commit'
alias gitl='git log'
alias gits='git status'
alias gitd='git diff'

alias myip='curl whatismyip.org && echo'
alias gdb='gdb -q' # Supress banner
