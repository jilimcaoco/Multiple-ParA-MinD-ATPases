#!/bin/bash
#
#
#SBATCH --job-name=MTDAF_abinitio
#SBATCH --account=ave0
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=5000m
#SBATCH --time=00-4:00:00
#SBATCH --array=1-10
#SBATCH --output=FastRelax.log
#SBATCH --mail-user=limcaoco@med.umich.edu
#SBATCH --mail-type=END,FAIL
set -euo pipefail
module load gcc/4.8.5
JOB_ID=$SLURM_JOB_ID
TASK_ID=$SLURM_ARRAY_TASK_ID
PATH_TO_ROSETTA=/home/limcaoco/rosetta/rosetta3.12
PATH_TO_PROJ=/home/limcaoco/ATPase_project
ATPASE_ID='MTDAF'
DATE='03_22_2022'
SCRATCH_DIR=/scratch/ave_root/ave0/limcaoco/abinit_${ATPASE_ID}_${DATE}
#run relax; be sure to change the -in:file:silent directory and options directory
${PATH_TO_ROSETTA}/main/source/bin/rosetta_scripts.default.linuxgccrelease \
    -database ${PATH_TO_ROSETTA}/main/database \
    @ ${PATH_TO_PROJ}/input_files/options/MTDAF_abinito.options \
    -in:file:fasta MTDAF_pep.fasta\
    -run:jran ${JOB_ID} \
    -out:suffix _${TASK_ID}_${JOB_ID} \
    -out:nstruct 10 \
    -out:file:silent ${SCRATCH_DIR}/out_files/${ATPASE_ID}_abinit_${JOB_ID}_${TASK_ID}.out \
    > ${SCRATCH_DIR}/${ATPASE_ID}_abinit_${JOB_ID}_${TASK_ID}.log
##
## creating .err file from STDERR
##
command 2> ${SCRATCH_DIR}/relax_${JOB_ID}.err
command 1> ${SCRATCH_DIR}/relax_${JOB_ID}.txt
