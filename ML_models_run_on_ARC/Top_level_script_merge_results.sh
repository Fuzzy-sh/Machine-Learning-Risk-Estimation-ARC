#!/bin/bash



echo Start merging files gained from top level script for training
echo Today is 
date
echo ---------------------------------------------------

echo Merge the xGBoost results to a one csv file

jobID1=$(sbatch merge_xGBoost.sh)

echo end of the merge job for xGBoost in top level script

echo ---------------------------------------------------------------------------

###########################################################################################

echo Merge the Random Forest results to a one csv file

jobID2=$(sbatch merge_RF.sh)

echo End of the merge job for Random Forest in top level script

echo ---------------------------------------------------------------------------

###########################################################################################

echo Merge the SVM results to a one csv file

jobID3=$(sbatch merge_SVM.sh)

echo End of the merge job for SVM in top level script

echo ---------------------------------------------------------------------------
 
###########################################################################################

echo Merge the ANN_1level results to a one csv file

jobID4=$(sbatch merge_ANN_1level.sh)

echo end of the merge job for ANN_1level in top level script

echo ---------------------------------------------------------------------------

###########################################################################################

echo Merge the ANN_2level results to a one csv file

jobID5=$(sbatch merge_ANN_2level.sh)

echo end of the merge job for ANN_2level in top level script

echo ---------------------------------------------------------------------------

###########################################################################################

echo Merge the ANN_3level results to a one csv file

jobID6=$(sbatch merge_ANN_3level.sh)

echo end of the merge job for ANN_3level in top level script

echo ---------------------------------------------------------------------------

###########################################################################################
 
 