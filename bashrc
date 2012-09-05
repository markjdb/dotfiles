case $(hostname) in
wtl-lview-*|test*|wtllab-test-*)
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
    $(which ssh) $@
    settitle $(hostname -s)
}

ipod_quirk()
{
    case $(uname) in
    FreeBSD)
        usbconfig add_dev_quirk_vplh 0x05ac 0x1261 0 65535 UQ_MSC_NO_SYNC_CACHE
        ;;
    *)
        echo 1>&2 "ipod_quirk: this function only works on FreeBSD"
        return 1
        ;;
    esac
}

PPROC=$(ps -p $PPID -o comm=)

# Make sure our parent process is screen(1) first.
if [ "$(ps -p $PPID -o comm=)" = screen ]; then
    settitle $(hostname -s)
fi

if [ $(uname) = FreeBSD -a $PPROC = sshd ]; then
    PS1='\[\033[01;31m\]$(prompt_prefix)\[\033[00m\]\[\033[01;35m\]\u@\h\[\033[00m\]: '
    PS1="$PS1"'\[\033[01;34m\]\w/\[\033[00m\]\[\033[00m\]$ '
else
    PS1='\[\033[01;34m\]$(prompt_prefix)\[\033[00m\]\[\033[01;32m\]\u@\h\[\033[00m\]: '
    PS1="$PS1"'\[\033[01;31m\]\w/\[\033[00m\]\[\033[00m\]$ '
fi

unset PPROC

set -o vi

export HISTFILESIZE=100000
export HISTSIZE=10000
shopt -s histappend

export PATH=$PATH:${HOME}/bin
export EDITOR=`which vim`
export PAGER='/usr/bin/less -i'
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

alias man="man -P 'less -isR'"

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

cin()
{
    local cmsgfile

    if ! which cleartool >/dev/null 2>&1; then
        echo 1>&2 "cin: can't check in, cleartool isn't present"
        return 1
    fi

    expr $(hostname -s) : wtl-lview-* || return
    cmsgfile=$(mktemp)
    if [ $? -ne 0 ]; then
        cmsgfile=/tmp/commit
        echo "" > $cmsgfile
    fi

    if [ -z "$EDITOR" ]; then
        vim $cmsgfile
    else
        $EDITOR $cmsgfile
    fi

    if [ "$(stat -c '%s' $cmsgfile)" = 0 ]; then
        echo 1>&2 "cin: aborting due to empty commit message"
        rm -f $cmsgfile
        return 1
    fi

    cleartool ci -cfile $cmsgfile $@
    echo 1>&2 "cin: left commit message in $cmsgfile"
}

sview()
{
    if [ $# -ne 1 ]; then
        echo 1>&2 "usage: sview < view >"
        return 1
    elif ! which cleartool >/dev/null 2>&1; then
        echo 1>&2 "sview: can't set view, cleartool isn't present"
        return 1
    fi

    settitle $1
    cleartool setview mjohnston_$1
    settitle $(hostname -s)
}

case $(hostname) in
oddish)
    alias startx='sudo kldload i915kms && startx'
    ;;
test*|wtllab-test-*)
    alias tcl=/m/mjohnston_lab/fwtest/bin/tcl
    alias tpc=/m/mjohnston_lab/fwtest/TLA/bin/tpc
    alias findall=/m/mjohnston_lab/fwtest/tools/bin/findall
    alias showres='tcl reserve res | grep mjohnston'
    ;;
wtl-lview-*)
    alias locatesrc='locate -d ${HOME}/db/srcfiles.db'
    alias updatesrcdb='updatedb -o ${HOME}/db/srcfiles.db -U /view/mjohnston_pts_cd_platform/vobs -l 0'
    alias cout='cleartool co -nc -unr'
    alias unco='cleartool unco -rm'
    ;;
TPC-*)
    alias undecimate='sudo /m/mjohnston_lab/fwtest/TLA/bin/undecimate'
    alias startscdpd='sudo /usr/local/etc/rc.d/0002.serviceLauncher.sh start &&
                      sudo /usr/local/etc/rc.d/svscdpd.sh start'
    alias svlog='cat /var/log/svlog'
    ;;
esac
