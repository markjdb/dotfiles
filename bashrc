case $(hostname) in
wtl-lview-*|test*|wtllab-test-*)
    . ${HOME}/.bash_sv
    ;;
esac

prompt_prefix()
{
    git branch > /dev/null 2>&1 && \
        echo "git ("$(git branch 2> /dev/null | awk '/\*/ {print $2}')") " && \
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
    settitle "${@: -1}"
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
    PS1="$PS1"'\[\033[01;34m\]\w\[\033[00m\]\[\033[00m\]$ '
else
    PS1='\[\033[01;34m\]$(prompt_prefix)\[\033[00m\]\[\033[01;32m\]\u@\h\[\033[00m\]: '
    PS1="$PS1"'\[\033[01;31m\]\w\[\033[00m\]\[\033[00m\]$ '
fi

unset PPROC

export HISTFILESIZE=100000
export HISTSIZE=10000
shopt -s histappend
set -o vi

export PATH=$PATH:${HOME}/bin:${HOME}/bin/scripts:${HOME}/bin/arm/bin
export EDITOR=`which vim`
export PAGER='/usr/bin/less -i'
export BUG_PROJECT=/home/mark/src/bugs
export LC_CTYPE=en_US.UTF-8
export CVS_RSH=ssh

# For u-boot builds.
export CROSS_COMPILE=arm-elf-
alias ts7800='gmake distclean && gmake ts7800_config && gmake -j8 ts7800'

case $(uname) in
FreeBSD)
    export GOOS=freebsd
    export GOROOT=/usr/local/go
    ;;
esac

[ -f $HOME/bin/scripts/set_csdb ] && source $HOME/bin/scripts/set_csdb
if [ -f /usr/local/share/bash-completion/bash_completion.sh ]; then
    source /usr/local/share/bash-completion/bash_completion.sh
elif [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
fi

# Aliases
alias mocp='mocp -T nightly_theme'
alias grep='grep --color=auto --exclude="*\.git*"'

alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

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
alias ll='ls -lAh'

alias gitco='git checkout'
alias gita='git add'
alias gitb='git branch'
alias gitd='git diff'
alias gitc='git commit'
alias gitl='git log'
alias gitp='git pull'
alias gits='git status'

alias svna='svn add'
alias svnc='svn commit'
alias svnd='svn diff'
alias svnl='svn log | less'
alias svns='svn status'
alias svnu='svn update'

alias sshff='ssh markj@freefall.freebsd.org'
alias sshhub='ssh markj@hub.freebsd.org'
alias sshwat='ssh m6johnst@linux.student.cs.uwaterloo.ca'

alias gdb='gdb -q' # Supress banner
alias mytree="find . -type d | sed -e 1d -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|-/'"
alias startx='exec startx'
alias mounts='mount | column -t'
alias unsrc='tar -C ~/src -xvf'
alias df='df -h'
alias mutt='settitle mail && mutt && settitle $(hostname -s)'
alias ripcd='settitle CDs && cdparanoia -B && sleep 2 && camcontrol eject cd0'
alias wav2flac_dir='for file in *.wav ; do flac $file ; done'
alias ts7800conn='sudo cu -s 115200 -l /dev/cuaU0'

aiff2mp3()
{
    if [ $# -ne 1 ]; then
        echo "aiff2mp3: no input file specified"
        return 1
    fi

    ffmpeg -i "$1" -f mp3 -acodec libmp3lame -ab 320000 -ar 44100 "${1%.aiff}.mp3"
}

godoc()
{
    $(which godoc) $@ | less
}

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

update-master()
{
    local curr

    curr=$(git branch | awk '/^\*/{print $2}')
    if [ -z "$curr" ]; then
        echo "update-master: couldn't determine current branch"
        return 1
    fi

    git checkout master && git pull && git push origin && git checkout "$curr"
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
