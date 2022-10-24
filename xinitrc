xset r rate 160 35
xset m 7 10
xset s blank
xset s 3000
xset dpms 0 3000 3000
xset fp+ /usr/local/share/fonts/terminus-font
xset fp+ /usr/local/share/fonts/webfonts
xset b off

datestr()
{
    date +"%F %R"
}

case $(uname) in
FreeBSD)
    sysctl -q hw.acpi.battery.life && batterystr='sysctl -n hw.acpi.battery.life'
    ;;
Linux)
    batterystr='acpi -b | awk '"'"'gsub(/,*/,"",$4) {print $4}'"'"
    ;;
esac

while true; do
    if [ -z "$batterystr" ]; then
        xsetroot -name "$(datestr)"
    else
        batteryval=$(eval $batterystr)
        if [ $batteryval -ge 0 -a $batteryval -le 3 -a \
	     $(expr "$(sysctl -n hw.acpi.battery.state)" \& 2) -ne 2 ]; then
            wall <<__EOF__
WARNING: Low battery! Value is ${batteryval}.
__EOF__
        fi
        xsetroot -name "$(datestr), Battery: $batteryval"
    fi
    sleep 30
done &

cd ${HOME}
if which nitrogen >/dev/null 2>&1 && [ -d ${HOME}/media/bg ]; then
    # nitrogen is weird and doesn't let me just specify a file on the
    # command line.
    cat <<__EOF__ > ${HOME}/.config/nitrogen/bg-saved.cfg
[:0.0]
file=${HOME}/media/bg/$(ls ${HOME}/media/bg | sort -R | head -n 1)
mode=4
bgcolor=#000000
__EOF__
    nitrogen --restore
fi

xrdb ${HOME}/.Xresources

eval `dbus-launch --sh-syntax --exit-with-session`
fcitx5 &

exec dwm
