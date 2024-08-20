#!/bin/bash 
#SBATCH -J hpl-test
#SBATCH -p gg
#SBATCH -N 1 
#SBATCH --ntasks-per-node=144
#SBATCH -t 24:00:00 

ml nvhpc-hpcx-cuda12/24.7

export OMP_NUM_THREADS=$nomp
MPIRUN="mpirun "

nodeid=$SLURM_NODELIST
outfile=hpl1-${nodeid}.out

echo $nodeid

echo $nodeid > $outfile

#for nmpi in 4 8 16 36 72 144 ; do 
for nmpi in 2 ; do 
  nomp=$((144/nmpi))
  export OMP_NUM_THREADS=$nomp
  input=HPL.dat.$nmpi
  for i in `seq 1 1`
  do
    $MPIRUN -n $nmpi -map-by socket:PE=$OMP_NUM_THREADS ./xhpl $input >> $outfile 2>&1
    sleep 30
  done
  done

echo "jj_success" >> $outfile

