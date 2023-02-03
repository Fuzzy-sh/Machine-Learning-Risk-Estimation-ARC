'''
1- import the liberaries
2- return_train_test_set: read the files and create the treain and test sets
3- confusion_AUC_Return : calculate the metrics "roc_auc, F1,recall,precision"
4- train_model: train the model
5- main : call the functions

'''
##########################################################################

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import PowerTransformer
import imblearn
from imblearn.over_sampling import RandomOverSampler
from sklearn.metrics import confusion_matrix, accuracy_score, classification_report, roc_auc_score, f1_score,precision_score, recall_score,roc_curve
from xgboost import XGBClassifier
from sklearn.neural_network import MLPClassifier,MLPRegressor,BernoulliRBM
from sklearn import svm
from sklearn.svm import SVC
from sklearn.model_selection import GridSearchCV,RandomizedSearchCV
import os
import sys

#############################################################################

def return_train_test_set(df_name,key):
    # read the database from the computer 
    data_final=pd.read_hdf(df_name,key=key)

    # to expand the number of columns and rows that we can see while dispalying a datafram
    pd.set_option('display.max_columns', data_final.columns.shape[0]+1)
    pd.set_option('display.max_rows', 200)

    # these are the features that we have finilized to give the model 

    feature_list_for_training=[
    'spec_pat_num_age',
    # Gender-male
    'patient_gender_M',
    # Specimen Collection location
    'collected_in_ed', 'collected_in_hospital', 'collected_in_dsl',
    # Resident During Collection
    'dsl_resident_during_collection',
    # Symptomatic During Collection
    'symptomatic_during_collection_U', 'symptomatic_during_collection_Y',
    # Result of the covid test
    'interp_result_Positive',
    # Specimen year-month collection
    'y_m__2020-10',
    'y_m__2020-11', 'y_m__2020-12', 'y_m__2020-3', 'y_m__2020-4',
    'y_m__2020-5', 'y_m__2021-3', 'y_m__2020-7', 'y_m__2020-8',
    'y_m__2020-9', 'y_m__2021-1', 'y_m__2021-2', 
    # Num of Elixhauser 
    'chf_2_years_full_1', 'htn_unc_2_years_full_1',
    'cancer_mets_2_years_full_1', 'fluid_elec_dis_2_years_full_1',
    'card_arrh_2_years_full_1', 'valv_dis_2_years_full_1',
    'pcd_2_years_full_1', 'pvd_2_years_full_1', 'htn_c_2_years_full_1',
    'paral_2_years_full_1', 'oth_neur_dis_2_years_full_1',
    'cpd_2_years_full_1', 'diab_2_years_full_1',
    'hypothyroidism_2_years_full_1', 'ren_fail_2_years_full_1',
    'liver_dis_2_years_full_1', 'pep_ulc_exc_bld_2_years_full_1',
    'aids_hiv_2_years_full_1', 'lymph_2_years_full_1',
    'tumour_no_mets_2_years_full_1', 'rheum_col_vasc_dis_2_years_full_1',
    'coag_2_years_full_1', 'obes_2_years_full_1', 'wt_loss_2_years_full_1',
    'anemia_2_years_full_1', 'alc_abuse_2_years_full_1',
    'drug_abuse_2_years_full_1', 'psych_2_years_full_1',
    'depress_2_years_full_1',
    #Num of Admits for 1 year
    'num_admits_1_year', 'num_scu_admits_1_year',
    #Num Procedures for 1 year
    'num_procs_dad_1_year', 'num_procs_nacrs_1_year',
    ]

    # select the features and normalize them 
    X=data_final[feature_list_for_training]
    scaler_PT = PowerTransformer() 
    X = pd.DataFrame(scaler_PT.fit_transform(X), columns=X.columns)
    # target
    y=data_final['died_within_60_days']
    # split the data into test and training 
    x_train, x_test, y_train,  y_test=  train_test_split(X,y,test_size=0.1, random_state=42)
    # oversampling with Random over sampler  technique 
    over_sampler = RandomOverSampler(random_state=42)
    X_res, y_res = over_sampler.fit_resample(x_train, y_train)
    
    return X_res, y_res , x_test, y_test

##############################################################################################

# drawing the results for hyper-parameterization
def confusion_AUC_Return(x_test,y_test,model,params):
    # comparing original and predicted values of y
    y_pred = model.predict(x_test)
#     prediction = list(map(round, y_pred))

    # Find prediction to the dataframe applying threshold
    prediction = pd.Series(y_pred).map(lambda x: 1 if x > 0.5 else 0)
    
    # confusion matrix
    cm = confusion_matrix(y_test, prediction)


    # accuracy score of the model
    roc_auc = roc_auc_score(y_test, prediction)
    F1=f1_score(y_test, prediction)
    precision=precision_score(y_test, prediction)
    recall=recall_score(y_test, prediction)
    return (roc_auc, F1,recall,precision)

##################################################################################################

def train_model( subsample,n_estimators,max_depth,learning_rate,colsample_bytree,colsample_bylevel,X_res, y_res , x_test, y_test):
     # define the model with hyper parameters
    xgboost_model = XGBClassifier(
    subsample= subsample,
    n_estimators= n_estimators,
    max_depth= max_depth,
    learning_rate= learning_rate,
    colsample_bytree= colsample_bytree,
    colsample_bylevel= colsample_bylevel)

    xgboost_model.fit(X_res, y_res, )

    # show the results
    roc_auc, F1,recall,precision=confusion_AUC_Return(x_test,y_test,xgboost_model,2)
    return roc_auc, F1,recall,precision
    #     print('AUC: {:.2f} | F1: {:.2f} | recall: {:.2f} | precision: {:.2f}'.format(roc_auc, F1,recall,precision))

#####################################################################################################

def main(subsample,n_estimators,max_depth,learning_rate,colsample_bytree,colsample_bylevel,file_num,model_name):   
    
    X_res, y_res , x_test, y_test=return_train_test_set(df_name='data_final.h5',key='data_final')    

    roc_auc, F1,recall,precision=train_model (subsample,n_estimators,max_depth,learning_rate,colsample_bytree,colsample_bylevel,X_res, y_res , x_test, y_test)
    
    data='{},{},{},{},{},{},{:.3f},{:.3f},{:.3f},{:.3f}'.format(subsample,n_estimators,max_depth,learning_rate,colsample_bytree,colsample_bylevel,roc_auc, F1,recall,precision)
    with open (model_name+ str(file_num)+'.csv', 'w') as fp:
        fp.write(data)

###################################################################################

if __name__ == "__main__":
    
    max_depth=int(sys.argv[1])
    learning_rate=float(sys.argv[2])
    subsample=float(sys.argv[3])
    colsample_bytree=float(sys.argv[4])
    colsample_bylevel=float(sys.argv[5])
    n_estimators=int(sys.argv[6])
    file_num=int(sys.argv[7])
    model_name='xGBoost/'
    
    main(subsample,n_estimators,max_depth,learning_rate,colsample_bytree,colsample_bylevel,file_num,model_name)