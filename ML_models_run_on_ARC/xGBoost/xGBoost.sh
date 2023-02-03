#!/bin/bash
  
#SBATCH --job-name=ArrayJobScript_xGBoost
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --output=ArrayJobScript_xGBoost_%A.out
#SBATCH --mem=16GB

# Print some job information

echo
echo "xGBoost file with task Id: $SLURM_ARRAY_TASK_ID"
echo "My hostname is: $(hostname -s)"
echo

# run the python program 

index=0
while read line ; do
        LINEARRAY[$index]="$line"
        index=$(($index+1))
done < params_xGBoost.txt

echo $((${SLURM_ARRAY_TASK_ID}))
echo ${LINEARRAY[$((${SLURM_ARRAY_TASK_ID}))]}

echo starting main program python code for xGBoost

echo python xGBoost.py ${LINEARRAY[$((${SLURM_ARRAY_TASK_ID}))]} 
python xGBoost.py  ${LINEARRAY[$((${SLURM_ARRAY_TASK_ID}))]}

echo ending slurm script to do training for xGBoost                                                     