#!/bin/bash

get_cpu_usage() {
	read -r cpu user nice system idle iowait reset < /proc/stat
	total1=$((user + nice + system + idle + iowait))
	idle1=$((idle + iowait))

	sleep 1

	read -r cpu user nice system idle iowait reset < /proc/stat
        total2=$((user + nice + system + idle + iowait))
        idle2=$((idle + iowait))

	total_diff=$((total2 - total1))
	idle_diff=$((idle2 - idle1))

	usage=$((100 * (total_diff-idle_diff)/total_diff))

	echo "$usage"
}

draw_bar() {
    percentage=$1

    filled=$((percentage / 5))
    empty=$((20 - filled))

    printf "["

    for ((i=0; i<filled; i++))
    do
        printf "|"
    done

    for ((i=0; i<empty; i++))
    do
        printf "  "
    done

    printf "] %s%%\n" "$percentage"
}

get_memory_usage(){

	total=$(grep "^MemTotal:" /proc/meminfo | awk '{print $2}')

	available=$(grep '^MemAvailable:' /proc/meminfo |  awk '{print $2}')

	used=$((total - available))

	usage=$((100 * used/total))

	echo "$usage"
}

echo"RAM USAGE"
get_memory_usage

while true
do
	clear
	echo " ------------------  "
	echo "| MY SYSTEM MONITOR |"
	echo " ------------------  "

	echo " ----- "
        echo "| CPU |"
        echo " ----- "

	cpu=$(get_cpu_usage)
	draw_bar "$cpu"

	echo "----"
	echo "TIME"
	echo "----"
	date
	echo
	echo "------"
	echo "MEMORY:"
	echo "------"
	memory=$(get_memory_usage)
	draw_bar "$memory"
	echo
	echo "----"
	echo "DISK:"
	echo "----"
	df -h /

	sleep 5
done
