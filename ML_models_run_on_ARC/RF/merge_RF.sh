#!/bin/bash
  
#SBATCH --job-name=JobScript_merge_RF_results
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --output=ArrayJobScript_RF_%J.out
#SBATCH --mem=16GB

# Print some job information

echo
echo "My hostname is: $(hostname -s)"
echo

# run the python program 



echo starting main program python code for merging Random Forest results

echo python merge_RF.py 
python merge_RF.py  

echo ending slurm script to do merging Random Forest results                                                    