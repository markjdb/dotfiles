prompt_prefix()
{
    git branch > /dev/null 2>&1 && \
        echo "git ("$(git branch 2> /dev/null | grep '*' | awk '{print $2}')") " && \
        return
    stat CVS > /dev/null 2>&1 && echo "CVS " && return
    stat .svn > /dev/null 2>&1 && echo "svn " && return
}

mkdircd()
{
    mkdir -p $1 && cd $1
}

cleanpatch()
{
    for file in $(find . -name '*.orig' -o -name '*.rej'); do
        echo $file
        [ -f "${file%.orig}" -o -f "${file%.rej}" ] && rm -f "$file"
    done
}

update-repos()
{
    pushd .
    cd $HOME/bin && git pull && git push
    if [ -z "$DOTFILESDIR" ]; then
        cd $HOME/dotfiles
    else
        cd $DOTFILESDIR
    fi
    git pull && git push
    popd
}

PS1='\[\033[01;34m\]$(prompt_prefix)\[\033[00m\]\[\033[01;32m\]\u\[\033[00m\]: \[\033[01;31m\]\w/\[\033[00m\]\[\033[01;33m\]\[\033[00m\]$ '

set -o vi

export HISTFILESIZE=5000

export PATH=$PATH:$HOME/bin:$HOME/bin/gnu-arm/bin:/usr/local/9/bin
export CVSROOT=m6johnst@linux.student.cs.uwaterloo.ca:/u/m6johnston/cvsroot
export CVS_RSH=ssh
export EDITOR=`which vim`
export BUG_PROJECT=/home/mark/src/bugs

case $(uname) in
FreeBSD)
    export GOOS=freebsd
    export GOROOT=/usr/local/go
    ;;
esac

[ -f $HOME/bin/set_csdb ] && source $HOME/bin/set_csdb
[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion

# Aliases
alias mocp='mocp -T nightly_theme'

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

alias grep='grep --color=auto'
case $(uname) in
Linux)
    alias ls='ls --color=auto'
    alias gmake='make'
    ;;
FreeBSD)
    alias ls='ls -G'
    alias makeport='sudo make config-recursive install clean'
    ;;
esac

alias gitco='git checkout'
alias gita='git add'
alias gitb='git branch'
alias gitc='git commit'
alias gitl='git log'
alias gits='git status'
alias gitd='git diff'
alias gitp='git pull'

alias sshwat='ssh -Y m6johnst@linux.student.cs.uwaterloo.ca'
alias ll='ls -lAh'

alias gdb='gdb -q' # Supress banner
alias mytree="find . -type d | sed -e 1d -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|-/'"
