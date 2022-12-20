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

alias gita='git add'
alias gitb='git branch'
alias gitd='git diff'
alias gitc='git commit'
alias gitl='git log'
alias gitp='git pull'
alias gits='git status'

alias svna='svn add'
alias svnc='svn commit'
alias svnd='svn diff | less'
alias svnl='svn log | less'
alias svns='svn status'
alias svnu='svn update'

alias vim='nvim'

alias gdb='gdb -q' # Supress banner
alias startx='exec startx'
alias mounts='mount | column -t'
alias unsrc='tar -C ~/src -xvf'
alias df='df -h'
alias mutt='settitle mail && mutt && settitle $(hostname -s)'
alias ripcd='settitle CDs && cdparanoia -B && sleep 2 && camcontrol eject cd0'
alias wav2flac_dir='rm -f track00.cdda.wav && for file in *.wav ; do flac "$file"; done'
alias battery='sysctl -n hw.acpi.battery.life'
alias webserver='python -m http.server 8000'

if [ $(uname) = FreeBSD ]; then
    alias mkkernncnd="make -s -j $(sysctl -n hw.ncpu) -DNO_KERNELCLEAN -DNO_KERNELDEPEND buildkernel"
    alias mkkernnc="make -s -j $(sysctl -n hw.ncpu) -DNO_KERNELCLEAN buildkernel"
    #alias mkkern="make -s -j $(sysctl -n hw.ncpu) buildkernel"
fi

alias tmux="TERM=screen-256color tmux"

alias masmi="make && sudo make install"
alias mami="make && make install"
alias mcam="make clean && make"

alias i3lock="i3lock -c 000000"

alias mytop="top -SHza -s 1"

alias bootfile="sysctl -n kern.bootfile"

alias cdpwd='cd $(pwd)'
alias cdobj='cd $(make -V.OBJDIR)'
