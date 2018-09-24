#!/bin/sh
make
##for VAR in 12 208 1374 4128 
##for VAR in 10717 10992 67249 85736 571760 
for VAR in 12_half 208_half 1374_half 4128_half 10717_half 67249_half 571760_half
do
cd mesh$VAR
sbatch -o half.log looptycho2half.sh
cd ..
done

##sleep 3600
##for VAR in 10717 10992 67249 85736 571760 
##do
##cd mesh$VAR
##sbatch -o single.log looptycho2single.sh
##cd ..
##done
