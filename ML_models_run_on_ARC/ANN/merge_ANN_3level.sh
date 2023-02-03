#!/bin/bash
  
#SBATCH --job-name=JobScript_merge_ANN_3level_results
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --output=ArrayJobScript_ANN_3level%J.out
#SBATCH --mem=16GB

# Print some job information

echo
echo "My hostname is: $(hostname -s)"
echo

# run the python program 



echo starting main program python code for merging ANN_3level results

echo python merge_ANN_3level.py 
python merge_ANN_3level.py  

echo ending slurm script to do merging ANN_3level results                                                    