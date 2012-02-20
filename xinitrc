xset r rate 160 35
xset m 7 10
while true; do
	xsetroot -name "$(date +"%F %R"), Battery: $(acpi -b | awk 'gsub(/,*/,"",$4) {print $4}')"
	sleep 30
done &

cd ~/
exec dwm
