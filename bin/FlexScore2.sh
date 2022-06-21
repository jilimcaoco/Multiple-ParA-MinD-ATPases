#!/bin/bash
#
#
#SBATCH --job-name=MinD/MinE_score
#SBATCH --account=ave0
#SBATCH --partition=standard
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=1000m
#SBATCH --time=0-00:30:00
#SBATCH --array=1
#SBATCH --output=Flex_Score.log
#SBATCH --mail-user=limcaoco@med.umich.edu
#SBATCH --mail-type=END,FAIL
set -euo pipefail
module load gcc/4.8.5
JOB_ID=${SLURM_JOB_ID}
TASK_ID="1"
PATH_TO_ROSETTA=/home/limcaoco/rosetta/rosetta3.12
PATH_TO_PROJ=/home/limcaoco/ATPase_project
PEPTIDE_ID="MGILD"
ATPASE_ID='divisome'
DATE='05_18_2022'
SCRATCH_DIR=/scratch/ave_root/ave0/limcaoco/flex_dock_${PEPTIDE_ID}_${ATPASE_ID}_${DATE}
#run relax; be sure to change the -in:file:silent directory and options directory
${PATH_TO_ROSETTA}/main/source/bin/rosetta_scripts.default.linuxgccrelease \
    -database ${PATH_TO_ROSETTA}/main/database \
    @ ${PATH_TO_PROJ}/input_files/options/FlexScore.options 
    -in:file:fullatom ${PEPTIDE_ID}_pep_${ATPASE_ID}_selected.pdb\
    -run:jran ${JOB_ID} \
    -out:suffix _${TASK_ID}_${JOB_ID} \
    -out:nstruct 1 \
    -out:file:scorefile ${SCRATCH_DIR}/out_files/${ATPASE_ID}_flex_dock_${JOB_ID}_${TASK_ID}.sc\
    -out:file:silent ${SCRATCH_DIR}/out_files/${ATPASE_ID}_flex_dock_${JOB_ID}_${TASK_ID}.out \
    > ${SCRATCH_DIR}/${ATPASE_ID}_flex_dock_${JOB_ID}_${TASK_ID}.log
##
## creating .err file from STDERR
##
command 2> ${SCRATCH_DIR}/flex_dock_${JOB_ID}.err
command 1> ${SCRATCH_DIR}/flex_dock_${JOB_ID}.txt
