#!/bin/bash



echo Starting Preprocessing from top level Fuzzy script
echo Today is 
date
echo ---------------------------------------------------

#############################################################################
# send the parameters and write them down to the params_xGBoost.txt file
# We send the parameters from the top level part of the program to know the number of the job array counter 

echo Creating the params for xGBoost

max_depth=( 3 5 6 10 15 20 )
learning_rate=( 0.01 0.1 0.2 0.3 0.4)
subsample=( 0.7 0.8 0.9 )
colsample_bytree=( 0.4 0.5 0.6 0.7 0.8 0.9 )
colsample_bylevel=( 0.4 0.5 0.6 0.7 0.8 0.9 )
n_estimators=( 100 500 1000 )

echo "max_depth parameters are: $max_depth"
echo "learning_rate parameters are: $learning_rate"
echo "subsample parameters are: $subsample"
echo "colsample_bytree parameters are: $colsample_bytree"
echo "colsample_bylevel parameters are: $colsample_bylevel"
echo "n_estimators parameters are: $n_estimators"
echo ---------------------------------------------------
##################################################################################
job1Counter=0
echo "startig point for the jobcouneter for xGBoost is: $job1Counter"

rm params_xGBoost.txt

for max_depth in "${max_depth[@]}" ; do
for learning_rate in "${learning_rate[@]}" ; do
for subsample in "${subsample[@]}" ; do 
for colsample_bytree in "${colsample_bytree[@]}" ; do
for colsample_bylevel in "${colsample_bylevel[@]}" ; do
for n_estimators in "${n_estimators[@]}" ; do
	echo ${max_depth} ${learning_rate} ${subsample} ${colsample_bytree} ${colsample_bylevel} ${n_estimators} ${job1Counter} >> params_xGBoost.txt
	job1Counter=$((job1Counter+1))
done
done
done
done
done
done

echo "Number of the parameters created in params_xGBoost.txt are: $job1Counter"
echo ------------------------------------------------------------------------
########################################################################################
# the max of submitting job arrays is 3999, so at each step, we will sumbit only 3999 jobs 
# then sleep for about one hour till all the jobs are finished

step=3999
start=0
echo "The step for submitting the jobs is: $step"
echo "Job counter at the start of: $start"

declare -a jobID1
for (( COUNTER=$start; COUNTER<=$job1Counter; COUNTER+=3999 )); do
    
    end=$((COUNTER+step))
    
    jobID1[$COUNTER]=$(sbatch --array=$COUNTER-$end  xGBoost.sh)

    echo "Job counter at the end of $end"
    echo "submitted by job id number: ${jobID1[COUNTER]}"
    
    C=$((COUNTER))
    sleep 3600
done

echo "Last Job counter at the start: $C" 
end=$((job1Counter+1))
# jobID1_last=$(sbatch --array=$C-$end  xGBoost.sh)   
echo "Last Job counter at the end $job1Counter"
echo "submitted by job id number: ${jobID1[C]}"
echo ---------------------------------------------------------------------------
echo "End of training xGboost"
echo ---------------------------------------------------------------------------
###########################################################################################



echo Creating the params for Random Forest


bootstrap=( 'True' 'False' )
max_depth=( 10 20 30 40 50 60 70 80 90 100 )
max_features=( 'auto' 'sqrt' 'log2')
min_samples_leaf=( 1 2 4 8 )
min_samples_split=( 2 5 10 )
n_estimators=( 400 600 800 1000 1200 1400 1600 1800 2000 )
criterion=( 'gini' 'entropy')


echo "bootstrap parameters are: $bootstrap"
echo "max_depth parameters are: $max_depth"
echo "max_features parameters are: $max_features"
echo "min_samples_leaf parameters are: $min_samples_leaf"
echo "min_samples_split parameters are: $min_samples_split"
echo "n_estimators parameters are: $n_estimators"
echo "criterion parameters are: $criterion"

echo ---------------------------------------------------
##################################################################################
job2Counter=0
echo "startig point for the jobcouneter for Random Forest is: $job2Counter"

rm params_RF.txt

for bootstrap in "${bootstrap[@]}" ; do
for max_depth in "${max_depth[@]}" ; do
for max_features in "${max_features[@]}" ; do 
for min_samples_leaf in "${min_samples_leaf[@]}" ; do
for min_samples_split in "${min_samples_split[@]}" ; do
for n_estimators in "${n_estimators[@]}" ; do
for criterion in "${criterion[@]}" ; do
	echo ${bootstrap} ${max_depth} ${max_features} ${min_samples_leaf} ${min_samples_split} ${n_estimators} ${criterion} ${job2Counter} >> params_RF.txt
	job2Counter=$((job2Counter+1))

done
done
done
done
done
done
done

echo "Number of the parameters created in params_RF.txt are: $job2Counter"
echo ------------------------------------------------------------------------
#######################################################################################

step=3999
start=0

echo "The step for submitting the jobs is: $step"
echo "Job counter at the start of: $start"

declare -a jobID2

for (( COUNTER=$start; COUNTER<=$job2Counter; COUNTER+=3999 )); do
    
    end=$((COUNTER+step))
    
    jobID2[$COUNTER]=$(sbatch --array=$COUNTER-$end  RF.sh)

    echo "Job counter at the end of $end"
    echo "submitted by job id number: ${jobID2[COUNTER]}"
    
    C=$((COUNTER))
    sleep 3600
done

echo "Last Job counter at the start: $C" 
end=$((job2Counter+1))
jobID2_last=$(sbatch --array=$C-$end  RF.sh)   
echo "Last Job counter at the end $job2Counter"
echo "submitted by job id number: ${jobID2[C]}"
echo ---------------------------------------------------------------------------
echo "End of RF"
echo ---------------------------------------------------------------------------
###########################################################################################
 
C=( 0.1 1. 10. 100. 1000. 1200. 1300. 1400. 1500. 2000. 3000 )
gamma=( 0.000001 0.00001 0.0001 0.001 0.01 0.1 1.0 10.0 100.0 'scale' 'auto' )
kernel=( 'rbf' 'poly' 'sigmoid' )

echo Creating the params for SVM

echo "bootstrap parameters are: $C"
echo "max_depth parameters are: $gamma"
echo "max_features parameters are: $kernel"


echo ---------------------------------------------------
##############################################################################################
job3Counter=0
echo "startig point for the jobcouneter for SVM is: $job3Counter"

rm params_SVM.txt

for C in "${C[@]}" ; do
for gamma in "${gamma[@]}" ; do
for kernel in "${kernel[@]}" ; do 

	echo ${C} ${gamma} ${kernel} ${job3Counter} >> params_SVM.txt
	job3Counter=$((job3Counter+1))

done
done
done


echo "Number of the parameters created in params_RF.txt are: $job3Counter"
echo ------------------------------------------------------------------------
# #######################################################################################
echo "Job counter at the end $job3Counter"

jobID3=$(sbatch --array=0-$job3Counter  SVM.sh)


echo "submitted by job id number: $jobID3"
echo ---------------------------------------------------------------------------
echo "End of SVM"
echo ---------------------------------------------------------------------------
 
#############################################################################################
 
echo Creating the params for ANN_1level

hidden_layer_sizes=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 )
max_iter=( 50 100 150 1000 10000 )
activation=( 'tanh' 'relu' 'logistic' )
solver=( 'sgd' 'adam' 'lbfgs' )
alpha=( 1e-5 0.00001 0.0001 0.001 0.01 0.05 )
learning_rate=( 'constant' 'adaptive' )

echo "hidden_layer_sizes parameters are: $hidden_layer_sizes"
echo "max_iter parameters are: $max_iter"
echo "activation parameters are: $activation"
echo "solver parameters are: $solver"
echo "alpha parameters are: $alpha"
echo "learning_rate parameters are: $learning_rate"
echo ---------------------------------------------------
# ##################################################################################
job4Counter=0
echo "startig point for the jobcouneter for ANN_1level is: $job4Counter"

rm params_ANN_1level.txt

for hidden_layer_sizes in "${hidden_layer_sizes[@]}" ; do
for max_iter in "${max_iter[@]}" ; do
for activation in "${activation[@]}" ; do 
for solver in "${solver[@]}" ; do
for alpha in "${alpha[@]}" ; do
for learning_rate in "${learning_rate[@]}" ; do
	echo ${hidden_layer_sizes} ${max_iter} ${activation} ${solver} ${alpha} ${learning_rate} ${job4Counter} >> params_ANN_1level.txt
	job4Counter=$((job4Counter+1))
done
done
done
done
done
done

echo "Number of the parameters created in params_ANN_1level.txt are: $job4Counter"
echo ------------------------------------------------------------------------
# ########################################################################################

step=3999
start=0
echo "The step for submitting the jobs is: $step"
echo "Job counter at the start of: $start"

declare -a jobID4
for (( COUNTER=$start; COUNTER<=$job4Counter; COUNTER+=3999 )); do
    
    end=$((COUNTER+step))
    
    jobID4[$COUNTER]=$(sbatch --array=$COUNTER-$end  ANN_1level.sh)

    echo "Job counter at the end of $end"
    echo "submitted by job id number: ${jobID4[COUNTER]}"
    
    C=$((COUNTER))
    sleep 3600
done

echo "Last Job counter at the start: $C" 
end=$((job4Counter+1))
jobID4_last=$(sbatch --array=$C-$end  ANN_1level.sh)   
echo "Last Job counter at the end $job4Counter"
echo "submitted by job id number: ${jobID4[C]}"
echo ---------------------------------------------------------------------------
echo "End of ANN with one layer"
echo ---------------------------------------------------------------------------
###########################################################################################


echo Creating the params for ANN_2level

hidden_layer_sizes_1=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 )
hidden_layer_sizes_2=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 )
max_iter=( 1000000 )
activation=( 'tanh' 'relu' 'logistic' )
solver=( 'sgd' 'adam' 'lbfgs' )
alpha=( 1e-5 0.00001 0.0001 0.001 0.01 0.05 )
learning_rate=( 'constant' 'adaptive' )

echo "hidden_layer_sizes parameters are: $hidden_layer_sizes_1"
echo "hidden_layer_sizes parameters are: $hidden_layer_sizes_2"
echo "max_iter parameters are: $max_iter"
echo "activation parameters are: $activation"
echo "solver parameters are: $solver"
echo "alpha parameters are: $alpha"
echo "learning_rate parameters are: $learning_rate"
echo ---------------------------------------------------
# ##################################################################################
job5Counter=0
echo "startig point for the jobcouneter for ANN_2level is: $job5Counter"

rm params_ANN_2level.txt

for hidden_layer_sizes_1 in "${hidden_layer_sizes_1[@]}" ; do
for hidden_layer_sizes_2 in "${hidden_layer_sizes_2[@]}" ; do
for max_iter in "${max_iter[@]}" ; do
for activation in "${activation[@]}" ; do 
for solver in "${solver[@]}" ; do
for alpha in "${alpha[@]}" ; do
for learning_rate in "${learning_rate[@]}" ; do
	echo ${hidden_layer_sizes_1} ${hidden_layer_sizes_2} ${max_iter} ${activation} ${solver} ${alpha} ${learning_rate} ${job5Counter} >> params_ANN_2level.txt
	job5Counter=$((job5Counter+1))
done
done
done
done
done
done
done

echo "Number of the parameters created in params_ANN_2level.txt are: $job5Counter"
echo ------------------------------------------------------------------------
# ########################################################################################

step=3999
start=0
echo "The step for submitting the jobs is: $step"
echo "Job counter at the start of: $start"


for (( COUNTER=$start; COUNTER<=$job5Counter; COUNTER+=3999 )); do
    
    end=$((COUNTER+step))
    
    jobID5=$(sbatch --array=$COUNTER-$end  ANN_2level.sh)
    
    echo "Job counter at the end of $end"
    echo "submitted by job id number: $jobID5"
    
    C=$((COUNTER))
    sleep 3600

done

echo "Last Job counter at the start: $C" 
end=$((job5Counter+1))
jobID5_last=$(sbatch --array=$C-$end  ANN_2level.sh)   
echo "Last Job counter at the end $job5Counter"
echo "submitted by job id number: $jobID5_last"
echo ---------------------------------------------------------------------------
echo "End of ANN with two layers"
echo ---------------------------------------------------------------------------
# ###########################################################################################

 
 echo Creating the params for ANN_3level

hidden_layer_sizes_1=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 )
hidden_layer_sizes_2=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 )
hidden_layer_sizes_3=( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 )
max_iter=( 1000000 )
activation=( 'relu' )
solver=( 'lbfgs' )
alpha=( 1e-5 )
learning_rate=( 'adaptive' )

echo "hidden_layer_sizes parameters are: $hidden_layer_sizes_1"
echo "hidden_layer_sizes parameters are: $hidden_layer_sizes_2"
echo "hidden_layer_sizes parameters are: $hidden_layer_sizes_3"
echo "max_iter parameters are: $max_iter"
echo "activation parameters are: $activation"
echo "solver parameters are: $solver"
echo "alpha parameters are: $alpha"
echo "learning_rate parameters are: $learning_rate"
echo ---------------------------------------------------
# ##################################################################################

job6Counter=0
echo "startig point for the jobcouneter for ANN_3level is: $job6Counter"

rm params_ANN_3level.txt

for hidden_layer_sizes_1 in "${hidden_layer_sizes_1[@]}" ; do
for hidden_layer_sizes_2 in "${hidden_layer_sizes_2[@]}" ; do
for hidden_layer_sizes_3 in "${hidden_layer_sizes_3[@]}" ; do
for max_iter in "${max_iter[@]}" ; do
for activation in "${activation[@]}" ; do 
for solver in "${solver[@]}" ; do
for alpha in "${alpha[@]}" ; do
for learning_rate in "${learning_rate[@]}" ; do
	echo ${hidden_layer_sizes_1} ${hidden_layer_sizes_2} ${hidden_layer_sizes_3} ${max_iter} ${activation} ${solver} ${alpha} ${learning_rate} ${job6Counter} >> params_ANN_3level.txt
	job6Counter=$((job6Counter+1))

done
done
done
done
done
done
done
done

echo "Number of the parameters created in params_ANN_3level.txt are: $job6Counter"
echo ------------------------------------------------------------------------
# ########################################################################################

step=3000
start=0
echo "The step for submitting the jobs is: $step"
echo "Job counter at the start of: $start"


for (( COUNTER=$start; COUNTER<=$job6Counter; COUNTER+=3000 )); do
    
    end=$((COUNTER+step))
    
    jobID6=$(sbatch --array=$COUNTER-$end  ANN_3level.sh)
    
    echo "Job counter at the end of $end"
    echo "submitted by job id number: $jobID6"
    
    C=$((COUNTER))
    sleep 3600

done

echo "Last Job counter at the start: $C" 
end=$((job6Counter+1))
jobID6_last=$(sbatch --array=$C-$end  ANN_3level.sh)   
echo "Last Job counter at the end $job6Counter"
echo "submitted by job id number: $jobID6_last"
echo ---------------------------------------------------------------------------
echo "End of ANN with three layers"
echo ---------------------------------------------------------------------------
# ###########################################################################################
 
 