icon_play=''
icon_pause=''

if [ $(playerctl status) == 'Paused' ]; then
	echo " $icon_play"
else
	echo " $icon_pause"
fi
