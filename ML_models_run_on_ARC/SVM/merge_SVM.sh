#!/bin/bash
  
#SBATCH --job-name=JobScript_merge_SVM_results
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --output=ArrayJobScript_SVM_%J.out
#SBATCH --mem=16GB

# Print some job information

echo
echo "My hostname is: $(hostname -s)"
echo

# run the python program 



echo starting main program python code for merging SVM results

echo python merge_SVM.py 
python merge_SVM.py  

echo ending slurm script to do merging SVM results                                                    