#!/bin/sh
make
##for VAR in 12 208 1374 4128 
##for VAR in 10717 10992 67249 85736 571760 
for VAR in 12 208 1374 4128 10717 67249 571760
do
cd mesh$VAR
sbatch -o double.log looptycho2double.sh
cd ..
done

##sleep 3600
##for VAR in 10717 10992 67249 85736 571760 
##do
##cd mesh$VAR
##sbatch -o single.log looptycho2single.sh
##cd ..
##done
