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

PS1='$(prompt_prefix)\u@\h> '

unset PPROC

export HISTFILESIZE=10000000
export HISTSIZE=100000
shopt -s histappend
set -o vi

PATH=${PATH}:${HOME}/bin:${HOME}/bin/scripts:${HOME}/bin/scripts/dtrace:${HOME}/bin/sb-tools:${HOME}/src/bricoler
PATH=${PATH}:${HOME}/bin/scripts/contrib
PATH=${PATH}:${HOME}/go/bin
if [ -n "${SB_PATH}" ]; then
    PATH=${PATH}:${SB_PATH}
fi

if which nvim >/dev/null 2>&1; then
    export EDITOR=$(which nvim)
elif which vim >/dev/null 2>&1; then
    export EDITOR=$(which vim)
elif which vi >/dev/null 2>&1; then
    export EDITOR=$(which vi)
fi

export PAGER='/usr/bin/less -i'
export BUG_PROJECT=/home/mark/src/bugs
export LC_CTYPE=en_US.UTF-8
export CVS_RSH=ssh

export DIFF_TOOL="diff -u"

[ -f $HOME/bin/scripts/cscope.sh ] && source $HOME/bin/scripts/cscope.sh
[ -f $HOME/bin/scripts/goto.sh ] && source $HOME/bin/scripts/goto.sh

if [ -f /usr/local/share/bash-completion/bash_completion.sh ]; then
    source /usr/local/share/bash-completion/bash_completion.sh
elif [ -f /usr/local/etc/bash_completion ]; then
    source /usr/local/etc/bash_completion
fi

[ -f /usr/local/share/git-core/contrib/completion/git-completion.bash ] && \
    source /usr/local/share/git-core/contrib/completion/git-completion.bash

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
    sudo mount -t msdosfs /dev/$dev ${HOME}/mnt/ipod
}

unmount-ipod()
{
    sudo umount ${HOME}/mnt/ipod
}

. ${HOME}/.bash_aliases
[ -f ${HOME}/.bash_local ] && . ${HOME}/.bash_local

# Run something, muting output or redirecting it to the debug stream
# depending on the value of _ARC_DEBUG.
# If ARGCOMPLETE_USE_TEMPFILES is set, use tempfiles for IPC.
__python_argcomplete_run() {
    if [[ -z "${ARGCOMPLETE_USE_TEMPFILES-}" ]]; then
        __python_argcomplete_run_inner "$@"
        return
    fi
    local tmpfile="$(mktemp)"
    _ARGCOMPLETE_STDOUT_FILENAME="$tmpfile" __python_argcomplete_run_inner "$@"
    local code=$?
    cat "$tmpfile"
    rm "$tmpfile"
    return $code
}

__python_argcomplete_run_inner() {
    if [[ -z "${_ARC_DEBUG-}" ]]; then
        "$@" 8>&1 9>&2 1>/dev/null 2>&1
    else
        "$@" 8>&1 9>&2 1>&9 2>&1
    fi
}

_python_argcomplete() {
    local IFS=$'\013'
    local SUPPRESS_SPACE=0
    if compopt +o nospace 2> /dev/null; then
        SUPPRESS_SPACE=1
    fi
    COMPREPLY=( $(IFS="$IFS" \
                  COMP_LINE="$COMP_LINE" \
                  COMP_POINT="$COMP_POINT" \
                  COMP_TYPE="$COMP_TYPE" \
                  _ARGCOMPLETE_COMP_WORDBREAKS="$COMP_WORDBREAKS" \
                  _ARGCOMPLETE=1 \
                  _ARGCOMPLETE_SUPPRESS_SPACE=$SUPPRESS_SPACE \
                  __python_argcomplete_run "$1") )
    if [[ $? != 0 ]]; then
        unset COMPREPLY
    elif [[ $SUPPRESS_SPACE == 1 ]] && [[ "${COMPREPLY-}" =~ [=/:]$ ]]; then
        compopt -o nospace
    fi
}
complete -o nospace -o default -o bashdefault -F _python_argcomplete ./cheribuild.py

backup()
{
    local file

    if [ $# -ne 1 ]; then
        echo "backup: no file specified" >&2
        return 1
    fi

    file="$1"
    if [ ! -f "$file" ]; then
        echo "backup: $file doesn't exist" >&2
        return 1
    fi

    cp -p "$file" "$file.orig"
}
