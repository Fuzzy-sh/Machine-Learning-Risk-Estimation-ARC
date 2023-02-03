#!/bin/bash
  
#SBATCH --job-name=JobScript_merge_ANN_1level_results
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --output=ArrayJobScript_ANN_1level%J.out
#SBATCH --mem=16GB

# Print some job information

echo
echo "My hostname is: $(hostname -s)"
echo

# run the python program 



echo starting main program python code for merging ANN_1level results

echo python merge_ANN_1level.py 
python merge_ANN_1level.py  

echo ending slurm script to do merging ANN_1level results                                                    