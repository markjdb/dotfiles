xset r rate 160 35
xset m 7 10

datestr='date +"%F %R"'
case $(uname) in
FreeBSD)
	sysctl -q hw.dri.debug && sudo sysctl hw.dri.debug=0
	sysctl -q hw.acpi.battery.life && batterystr='sysctl -n hw.acpi.battery.life'
	;;
Linux)
	batterystr='acpi -b | awk '"'"'gsub(/,*/,"",$4) {print $4}'"'"
	;;
esac

while true; do
	if [ -z "$batterystr" ]; then
		xsetroot -name "$(eval $datestr)"
	else
		xsetroot -name "$(eval $datestr), Battery: $(eval $batterystr)"
	fi
	sleep 30
done &

cd ~/
exec dwm
