#!/bin/sh
cd util
make PartitionColumns
./PartitionColumns.x 16 1 cube-67249.smesh cube-outputsingle.pmesh
cd ..
sbatch -o plotresultsattempt_single.log looptycho2single.sh
python grabdata.py plotresultsattempt_single.log single-67249.log.sum
