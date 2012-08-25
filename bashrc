case $(hostname) in
wtl-lview-*|test*)
    . ${HOME}/.bash_sv
    ;;
esac

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
        [ -f "${file%.orig}" -a -f "${file%.rej}" ] && rm -f "$file"
    done
}

settitle()
{
    echo -n -e "\033k$1\033\\"
}

ssh()
{
    settitle $1
    /usr/bin/ssh $@
    settitle $(hostname -s)
}

PS1='\[\033[01;34m\]$(prompt_prefix)\[\033[00m\]\[\033[01;32m\]\u@\h\[\033[00m\]: \[\033[01;31m\]\w/\[\033[00m\]\[\033[01;33m\]\[\033[00m\]$ '

set -o vi

export HISTFILESIZE=5000

export PATH=$PATH:${HOME}/bin
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

alias grep='grep --color=auto --exclude="*\.git*"'
case $(uname) in
Linux)
    alias ls='ls --color=auto'
    alias gmake='make'
    ;;
FreeBSD)
    alias ls='ls -G'
    alias makeport='sudo make config-recursive install clean'
    which -s ascii || alias ascii='cat /usr/share/misc/ascii'
    ;;
esac

alias man='man -P less'

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
alias startx='exec startx'
alias mounts='mount | column -t'
alias unsrc='tar -C ~/src -xvf'
alias df='df -h'

case $(hostname) in
test*)
    alias tcl=/m/mjohnston_lab/fwtest/bin/tcl
    alias tpc=/m/mjohnston_lab/fwtest/TLA/bin/tpc
    alias findall=/m/mjohnston_lab/fwtest/tools/bin/findall
    alias showres='tcl reserve res | grep mjohnston'
    ;;
wtl-lview-*)
    alias locatesrc='locate -d ${HOME}/db/srcfiles.db'
    alias updatesrcdb='updatedb -o ${HOME}/db/srcfiles.db -U /vobs'
    ;;
TPC-*)
    alias undecimate=/m/mjohnston_lab/fwtest/TLA/bin/undecimate
    ;;
oddish)
    alias startx='sudo kldload i915kms && startx'
    ;;
esac
