xset r rate 160 35
xset m 7 10
xset s blank
xset s 3000
xset dpms 0 3000 3000

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

cd ~/
exec dwm
