#!/bin/sh
cd util
make PartitionColumns
./PartitionColumns.x 16 1 cube-33024.smesh cube-output.pmesh
cd ..
make
sbatch -o plotresultsattempt_double.log looptycho2double.sh
python grabdata.py plotresultsattempt_double.log double-33024.log.sum
