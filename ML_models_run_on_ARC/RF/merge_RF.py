
'''

1- creating a list of file names 
2- Open file_final in write mode
3- merge the context of the files 
4 write the results in the file_final
5- delete all the files
'''
import os
files_dir="RF/"
# Creating a list of filenames
file_list=os.listdir("RF/")
file_list=[file for file in file_list if (len(file.split('.'))>1) and file.split('.')[1]=='csv' ]


# Open file_final in write mode
with open('RF_results.csv', 'w') as outfile:
    outfile.write('bootstrap,max_depth,max_features,min_samples_leaf,min_samples_split,n_estimators,criterion,roc_auc, F1,recall,precision')
    outfile.write("\n")
    # Iterate through list
    for names in file_list:

        # Open each file in read mode
        with open(files_dir+names) as infile:

            # read the data from file1 and
            # file2 and write it in file3
            outfile.write(infile.read())

        # Add '\n' to enter data of file2
        # from next line
        outfile.write("\n")

for file in file_list:
    os.remove(files_dir+file)        
