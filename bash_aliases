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

alias sshwat='ssh m6johnst@linux.student.cs.uwaterloo.ca'
alias sshftp='ssh mjohnston@wtllab-ftp-1'
alias sshtest='ssh mjohnston@test'
alias sshconserver='ssh mjohnston@wtllab-conserver-1'
alias sshtinderbox='ssh mjohnston@wtllab-tinderbox-1'

alias gdb='gdb -q' # Supress banner
alias mytree="find . -type d | sed -e 1d -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|-/'"
alias startx='exec startx'
alias mounts='mount | column -t'
alias unsrc='tar -C ~/src -xvf'
alias df='df -h'
alias mutt='settitle mail && mutt && settitle $(hostname -s)'
alias ripcd='settitle CDs && cdparanoia -B && sleep 2 && camcontrol eject cd0'
alias wav2flac_dir='rm -f track00.cdda.wav && for file in *.wav ; do flac "$file"; done'
alias ts7800conn='sudo cu -s 115200 -l /dev/cuaU0'
alias please=sudo
alias battery='sysctl -n hw.acpi.battery.life'

case $(hostname) in
test*|wtllab-test-*)
    alias tcl=/m/mjohnston_lab/fwtest/bin/tcl
    alias tpc=/m/mjohnston_lab/fwtest/TLA/bin/tpc
    alias findall=/m/mjohnston_lab/fwtest/tools/bin/findall
    alias showres='tcl reserve res | grep mjohnston'
    ;;
wtl-lview-*)
    alias locatesrc='locate -d ${HOME}/db/srcfiles.db'
    alias updatesrcdb='mkdir -p ${HOME}/db && updatedb -o ${HOME}/db/srcfiles.db -U /view/mjohnston_pts_sn_platform2/vobs -l 0'
    alias cout='cleartool co -nc -unr'
    alias unco='cleartool unco -rm'
    ;;
TPC-*)
    alias undecimate='sudo /m/mjohnston_lab/fwtest/TLA/bin/undecimate'
    alias startscdpd='sudo /usr/local/etc/rc.d/0002.serviceLauncher.sh start &&
                      sudo /usr/local/etc/rc.d/svscdpd.sh start'
    alias stopscdpd='sudo /usr/local/etc/rc.d/svscdpd.sh stop &&
                     sudo /usr/local/etc/rc.d/0002.serviceLauncher.sh stop'
    alias restartscdpd='sudo /usr/local/etc/rc.d/svscdpd.sh restart'
    alias startsfcd='sudo /usr/local/etc/rc.d/0004.svsfcd.sh start'
    alias restartsfcd='sudo /usr/local/etc/rc.d/0004.svsfcd.sh restart'
    alias stopsfcd='sudo /usr/local/etc/rc.d/0004.svsfcd.sh stop'
    alias svlog='cat /var/log/svlog'
    alias lsibbustatus='sudo MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL'
    alias lsibbuprops='sudo MegaCli64 -AdpBbuCmd -GetBbuProperties -aALL'
    alias lsibbumodes='sudo MegaCli64 -AdpBbuCmd -GetBbuModes -aALL'
    alias lsibbudinfo='sudo MegaCli64 -AdpBbuCmd -GetBbuDesignInfo -aALL'
    alias lsibbucinfo='sudo MegaCli64 -AdpBbuCmd -GetBbuCapacityInfo -aALL'
    alias lsildinfo='sudo MegaCli64 -LDInfo -Lall -aALL'
    ;;
esac

if [ $(uname) = FreeBSD ]; then
    alias mkkernncnd="make -s -j $(sysctl -n hw.ncpu) -DNO_KERNELCLEAN -DNO_KERNELDEPEND buildkernel"
    alias mkkernnc="make -s -j $(sysctl -n hw.ncpu) -DNO_KERNELCLEAN buildkernel"
    alias mkkern="make -s -j $(sysctl -n hw.ncpu) buildkernel"
fi

alias tmux="TERM=screen-256color tmux"

alias masmi="make && sudo make install"
alias mami="make && make install"
alias mcam="make clean && make"

alias i3lock="i3lock -c 000000"

alias mytop="top -SHza -s 1"

alias bootfile="sysctl -n kern.bootfile"
