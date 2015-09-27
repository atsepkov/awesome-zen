#!/bin/bash
# Copyright 2015 Alexander Tsepkov


#SINK_NAME="alsa_output.pci-0000_00_1b.0.analog-stereo"
#SINK_NAME="alsa_output.pci-0000_00_1b.0.hdmi-stereo"
SOUND_DEVICE=`pacmd dump | grep -P "^set-card-profile" | grep stereo | cut -d: -f2 | cut -d+ -f1`
SINK_NAME="alsa_output.pci-0000_00_1b.0.$SOUND_DEVICE"
VOL_STEP="0x01000"

MUTE_STATE=`pacmd dump | grep -P "^set-sink-mute $SINK_NAME\s+" | perl -p -i -e 's/.+\s(yes|no)$/$1/'`
VOL_NOW=`pacmd dump | grep -P "^set-sink-volume $SINK_NAME\s+" | perl -p -i -e 's/.+\s(.x.+)$/$1/'`
VOL_MAX=$((0x10000))

case "$1" in
	plus)
	if [ $MUTE_STATE = yes ]; then
		echo "Muted"
	else
		VOL_NEW=$((VOL_NOW + VOL_STEP))
		if [ $VOL_NEW -gt $VOL_MAX ]
		then
			VOL_NEW=$VOL_MAX
		fi
		pactl set-sink-volume $SINK_NAME `printf "0x%X" $VOL_NEW`
		echo "$((100*VOL_NEW / VOL_MAX))%"
	fi

	;;
	minus)
	if [ $MUTE_STATE = yes ]; then
		echo "Muted"
	else
		VOL_NEW=$((VOL_NOW - VOL_STEP))
		if [ $(($VOL_NEW)) -lt $((0x00000)) ]
		then
			VOL_NEW=$((0x00000))
		fi
		pactl set-sink-volume $SINK_NAME `printf "0x%X" $VOL_NEW`
		echo "$((100*VOL_NEW / VOL_MAX))%"
	fi

	;;
	mute)
	if [ $MUTE_STATE = no ]; then
		pactl set-sink-mute $SINK_NAME 1
		echo "Muted"
	elif [ $MUTE_STATE = yes ]; then
		pactl set-sink-mute $SINK_NAME 0
		echo "$((100*VOL_NOW / VOL_MAX))%"
	fi
esac
