case $(hostname) in
wtl-lview-*|test*|wtllab-test-*)
    . ${HOME}/.bash_sv
    ;;
esac

prompt_prefix()
{
    git branch >/dev/null 2>&1 && \
        echo "git ("$(git branch 2> /dev/null | awk '/\*/ {print $2}')") " && \
        return
    stat CVS >/dev/null 2>&1 && echo "CVS " && return
    ( svn info >/dev/null 2>&1 || \
        svn info 2>&1 | grep -q 'Previous operation has not finished' ) && \
        echo "svn " && return
}

mkdircd()
{
    mkdir -p "$1" && cd "$1"
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
    if [ -n "$TMUX" ]; then
        echo -n -e "\033k$1\033\\"
    fi
}

ssh()
{
    settitle "${@: -1}"
    $(which ssh) $@
    settitle $(hostname -s)
}

svnclean()
{
    svn status --no-ignore | awk '{if ($1 == "I" || $1 == "?") print $2}' | xargs rm -rf
}

PPROC=$(ps -p $PPID -o comm=)

# Make sure our parent process is screen(1) first.
if [ "$(ps -p $PPID -o comm=)" = screen ]; then
    settitle $(hostname -s)
fi

if [ $(uname) = FreeBSD -a $PPROC = sshd ]; then
    PS1='\[\033[01;31m\]$(prompt_prefix)\[\033[00m\]\[\033[01;35m\]\u\[\033[00m\]@\[\033[01;35m\]\h\[\033[00m\]: '
    PS1="$PS1"'\[\033[01;34m\]\w\[\033[00m\]\[\033[00m\] $ '
else
    PS1='\[\033[01;34m\]$(prompt_prefix)\[\033[00m\]\[\033[01;32m\]\u\[\033[01;31m\]@\[\033[01;32m\]\h\[\033[00m\]: '
    PS1="$PS1"'\[\033[01;31m\]\w\[\033[00m\]\[\033[00m\] $ '
fi

unset PPROC

export HISTFILESIZE=100000
export HISTSIZE=10000
shopt -s histappend
set -o vi

PATH=${PATH}:${HOME}/bin:${HOME}/bin/scripts:${HOME}/bin/scripts/dtrace
PATH=${PATH}:${HOME}/bin/scripts/contrib
PATH=${PATH}:${HOME}/bin/arm/bin

if which vim >/dev/null 2>&1; then
    export EDITOR=$(which vim)
elif which vi >/dev/null 2>&1; then
    export EDITOR=$(which vi)
fi

export PAGER='/usr/bin/less -i'
export BUG_PROJECT=/home/mark/src/bugs
[ $USER != mjohnston ] && export LC_CTYPE=en_US.UTF-8
export CVS_RSH=ssh

# For u-boot builds.
export CROSS_COMPILE=arm-elf-

case $(uname) in
FreeBSD)
    export GOOS=freebsd
    export GOROOT=/usr/local/go
    ;;
esac

export DIFF_TOOL="diff -u"

if [ -f $HOME/bin/scripts/cscope.sh ]; then
    source $HOME/bin/scripts/cscope.sh
fi
if [ -f $HOME/bin/scripts/goto.sh ]; then
    source $HOME/bin/scripts/goto.sh
fi

if [ -f /usr/local/share/bash-completion/bash_completion.sh ]; then
    source /usr/local/share/bash-completion/bash_completion.sh
elif [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
fi

if [ -f /usr/local/share/git-core/contrib/completion/git-completion.bash ]; then
    source /usr/local/share/git-core/contrib/completion/git-completion.bash
fi

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

    git checkout master && git pull origin master && git pull && \
                           git push origin && git checkout "$curr"
    git fetch upstream refs/notes/*:refs/notes/*
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

startvbox()
{
    sudo kldload vboxdrv vboxnetadp
}

findf()
{
    find . -name "$1" -type f
}

findd()
{
    find . -name "$1" -type d
}

ssh-setup()
{
    eval $(ssh-agent)
    ssh-add
}

mount-ipod()
{
    local dev

    dev=$(sudo camcontrol devlist | grep 'Apple iPod' | \
          sed 's/^.*\(da[0-9][0-9]*\).*$/\1/')
    if [ -z "$dev" ]; then
        echo "mount-ipod: couldn't find iPod device" >&2
        return 1
    fi

    sudo service devfs restart
    mount -t msdosfs -o large /dev/$dev ${HOME}/mnt/ipod
}

unmount-ipod()
{
    umount ${HOME}/mnt/ipod
}

source ${HOME}/.bash_aliases
