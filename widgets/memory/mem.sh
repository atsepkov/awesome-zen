#!/bin/bash
# Copyright 2015 Alexander Tsepkov

#

case "$1" in
	simple)
		free | grep Mem | awk '{printf("%.1f\n", $3/$2 * 100)}'
	;;
	summary)
		free -h
		echo ''
		ps -eo pid,pmem,rss,comm --sort -rss | head -n 20
	;;
esac
