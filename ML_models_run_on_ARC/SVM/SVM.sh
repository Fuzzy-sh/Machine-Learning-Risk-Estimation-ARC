#!/bin/bash
  
#SBATCH --job-name=ArrayJobScript_SVM
#SBATCH --time=2:00:00
#SBATCH --nodes=1
#SBATCH --output=ArrayJobScript_SVM_%A.out
#SBATCH --mem=16GB

# Print some job information

echo
echo "SVM file with task Id: $SLURM_ARRAY_TASK_ID"
echo "My hostname is: $(hostname -s)"
echo

# run the python program 

index=0
while read line ; do
        LINEARRAY[$index]="$line"
        index=$(($index+1))
done < params_SVM.txt

echo $((${SLURM_ARRAY_TASK_ID}))
echo ${LINEARRAY[$((${SLURM_ARRAY_TASK_ID}))]}

echo starting main program python code for SVM

echo python SVM.py ${LINEARRAY[$((${SLURM_ARRAY_TASK_ID}))]} 
python SVM.py  ${LINEARRAY[$((${SLURM_ARRAY_TASK_ID}))]}

echo ending slurm script to do training for SVM                                                     