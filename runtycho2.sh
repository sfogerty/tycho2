#!/bin/sh
cd util
make PartitionColumns
./PartitionColumns.x 16 1 cube-33024.smesh cube-output.pmesh
cd ..
sbatch -o plotresultsattempt_double.log looptycho2.sh
