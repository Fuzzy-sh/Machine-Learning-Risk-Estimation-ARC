#!/bin/bash
  
#SBATCH --job-name=ArrayJobScript_ANN1level
#SBATCH --time=5:00:00
#SBATCH --nodes=1
#SBATCH --output=ArrayJobScript_ANN_1level_%A.out
#SBATCH --mem=16GB

# Print some job information

echo
echo "ANN_1level file with task Id: $SLURM_ARRAY_TASK_ID"
echo "My hostname is: $(hostname -s)"
echo

# run the python program 

index=0
while read line ; do
        LINEARRAY[$index]="$line"
        index=$(($index+1))
done < params_ANN_1level.txt

echo $((${SLURM_ARRAY_TASK_ID}))
echo ${LINEARRAY[$((${SLURM_ARRAY_TASK_ID}))]}

echo starting main program python code for ANN_1level

echo python ANN_1level.py ${LINEARRAY[$((${SLURM_ARRAY_TASK_ID}))]} 
python ANN_1level.py  ${LINEARRAY[$((${SLURM_ARRAY_TASK_ID}))]}

echo ending slurm script to do training for ANN_1level                                                    