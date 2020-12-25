#!/bin/bash
#######################################################################
# Toggle touchpad
#
#######################################################################

NAME="$(xinput list --name-only|grep  '^SYNA.*Touchpad$')"
#get status
ENABLED=$(xinput list-props "$NAME"|awk -F':' '/Device Enabled/{print $2}')

if [ $ENABLED -eq 1 ]; then
	INFO="Touchpad Disabled"
	xinput disable "$NAME"
	echo "Touchpad Disabled"
	notify-send "$INFO" "OFF -> $NAME" -i input-touchpad -t 4000 >/dev/null 2>&1
else
	INFO="Touchpad Enabled"
	xinput enable "$NAME"
	echo "Touchpad Enabled"
	notify-send "$INFO" "ON -> $NAME" -i input-touchpad -t 4000 >/dev/null 2>&1
fi
