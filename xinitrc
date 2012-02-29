xset r rate 160 35
xset m 7 10

datestr='date +"%F %R"'
case $(uname) in
FreeBSD)
	batterystr='sysctl -n hw.acpi.battery.life'
	;;
Linux)
	batterystr='acpi -b | awk '"'"'gsub(/,*/,"",$4) {print $4}'"'"
	;;
esac

while true; do
	xsetroot -name "$(eval $datestr), Battery: $(eval $batterystr)"
	sleep 30
done &

cd ~/
exec dwm
