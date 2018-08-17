#!/bin/bash
#--File-Name: pullmemory.sh--#

#While this script is running the memory usage of the node is being collected. MemTotal, MemFree, and MemAvailable from /proc/meminfo are piped into a column format of the same order. This produces a rough estimate for the memory usage of Tycho2 as it runs. pullmemory.sh is passed a filename as an argument from looptycho2.sh. The filename of the matching <.mem> file for every <.log> file is printed at the top of the <.log> file. 

#DATE="$(date +%m%d%H%M%S)"
#OUTPUT=$1-1node$DATE.mem

while [ ! -f endme ]; do
#The following command prints the three memory values (MemTotal, MemFree, and MemAvailable) in a column format of the same order.
	awk -F " " '/Mem/{print $2}' /proc/meminfo | column -s "\n">>"$1"

#The following command subtracts MemAvailable (column 3) from MemTotal (Column 1), printing a general memory usage statistic for the timeframe that pullmemory.sh is running.
	#awk -F " " '/Mem/{print $2}' /proc/meminfo | column -s "\n" | awk -F " " '{print $1-$3}'>>${OUTPUT}

	sleep .5
	done

rm endme
