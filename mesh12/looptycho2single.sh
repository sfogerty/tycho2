#!/bin/bash -l
#--File-Name: looptycho2.sh--#

#this script sets up and loops Tycho2 n amount of times where n is represented by $LOOPCOUNT.
#this script also calls another script which tracks memory usage on the entire node while Tycho2 is running.

#---!!CHECK THIS!!----#
#SBATCH --nodes=1
#SBATCH --qos=debug 
#SBATCH -t 00:15:00

#---------------------#
#Allocating cpu architectures on Cori and Darwin requires different syntax. Make sure the correct lines are appropriately commented for each architecture (## for unused and # for used)
#The following line is the correct syntax for allocating a haswell on Cori.
##SBATCH -C haswell

#The following lines are the correct syntax for allocating a haswell with minimum of 32 cpus on Darwin.
#SBATCH -C cpu_family:haswell
#SBATCH --mincpus=32
#----------------------#

#---INPUT PARAMETERS----#
#change the following parameters to match the architecture, the node/memory statistics you want to log, the desired MPI/OMP values, the loop count, and the input mesh file.

#set CLUSTER to 'DARWIN' or 'CORI'.
CLUSTER='DARWIN'
#set MEMUSE to anything other than 'TRUE' and pullmemory.sh will not run.
MEMUSE='TRUE'
#set VERBOSE to anything other than 'TRUE' and node information will not be included.
VERBOSE='TRUE'
#set MEMNAME's first value to the variant type of Tycho2. e.g. 'double', 'single', 'qsingle', or some other term. Set the second value equal to the node count being used.
DATE="$(date +%m%d%H%M%S)"
##MEMNAME=double-1node$DATE.mem
MEMNAME=single.mem
#set RANKS to the amount of MPI processes you want to run, also depends on bindings, usually defaults to per-node, make sure the MPI process count x the OMP thread count are less than or equal to the CPU count allocated.
RANKS=16
#set OMP_NUM_THREADS to the amount of OpenMP threads you want per MPI process, also depends on bindings.
export OMP_NUM_THREADS=1
#set LOOPCOUNT to the amount of loops you want Tycho2 to run through before the job completes.
LOOPCOUNT=1
#set INPUTFILE to the path for your pmesh file. This file needs to be partitioned accordingly for the intended job.
INPUTFILE=util/cube-output12.pmesh
#-----------------------#

if [ $VERBOSE == TRUE ]; then
	
	#---NODE INFORMATION---#
	ARCH="$(lscpu | awk -F " " '/Architecture/{print}')"
	CPU="$(lscpu | awk -F " " '/^CPU\(s\):/{print}')"
	THREADS="$(lscpu | awk -F " " '/Thread\(s\) per core/{print}')"
	CORESperSOCKET="$(lscpu | awk -F " " '/Core\(s\) per socket:/{print}')"
	SOCKETS="$(lscpu | awk -F " " '/Socket/{print}')"
	NUMANODES="$(lscpu | awk -F " " '/NUMA node\(s\):/{print}')"
	CPUMAX="$(lscpu | awk -F " " '/CPU max MHz/{print}')"
	CPUMIN="$(lscpu | awk -F " " '/CPU min MHz/{print}')"
	L1DCACHE="$(lscpu | awk -F " " '/L1d cache:/{print}')"
	L2CACHE="$(lscpu | awk -F " " '/L2 cache:/{print}')"
	L3CACHE="$(lscpu | awk -F " " '/L3 cache:/{print}')"
	#----------------------#
	
	#--PRINT NODE, JOB, AND SBATCH INFO--#
	echo ${ARCH}
	echo ${CPU}
	echo ${THREADS}
	echo ${CORESperSOCKET}
	echo ${SOCKETS}
	echo ${NUMANODES}
	echo ${CPUMAX}
	echo ${CPUMIN}
	echo ${L1DCACHE}
	echo ${L2CACHE}
	echo ${L3CACHE}
	echo "Ranks: "${RANKS}
	echo "OMP_NUM_THREADS: "${OMP_NUM_THREADS}
	echo "Total Loops: "${LOOPCOUNT}
	echo "Input File: "${INPUTFILE}
	
	#------------------------------------#
fi

if [ $MEMUSE == 'TRUE' ]; then
	
	#---MEM USAGE SCRIPT----#
	#the below script, pullmemory.sh, collects data from proc/meminfo about MemTotal, MemFree, and MemAvailable for the entire node.#
	#the script starts if a file titled <endme> does not exist in the same directory, so the following IF statement checks for <endme> and 
	#removes it if it does exist before starting the pullmemory.sh script
	
	if [ -f endme ]; then
		rm endme
	fi
	
	../pullmemory.sh $MEMNAME &
	echo "Mem File: "$MEMNAME
	#-----------------------#
fi

#------TYCHO2 LOOP------#
#The following for loop loops Tycho2 n amount of times, where n is represented by $LOOPCOUNT
for (( i=1 ; i <= $LOOPCOUNT; i++ ))
	do
	echo "*                                                                        *"
	echo "*--------------------------------RUN $i OF $LOOPCOUNT------------------------------*"
	echo "*                                                                        *"
	echo "*                                                                        *"
	
	if [ $CLUSTER == 'CORI' ]; then
		srun -n ${RANKS} --cpu-bind=cores ../sweep.x ${INPUTFILE} ../input.deck
	fi
	if [ $CLUSTER == 'DARWIN' ]; then
		mpirun -n ${RANKS} --bind-to core ../sweep.x ${INPUTFILE} ../input.deck
	fi
done
#-----------------------#

#the following line creates the <endme> file that kills the pullmemory.sh script.

if [ $MEMUSE == 'TRUE' ]; then
	touch endme
fi
#-----END OF FILE-----#
