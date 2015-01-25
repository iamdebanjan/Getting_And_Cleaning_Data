The run_analysis.R script is straight forward and single script to generate the tidy data from the raw data. 
It expects the below things:
1. The raw data is already downloaded and unzipped so that it does not has to download and unzip it each time the script is run.
2. No directory structure is changed after unzipping the files. The run_analysis.R script could be placed directly in the main direcory of unzipped files. It could be placed any other place also. However, in that case it would be expect that path the raw directory is set using setwd() command.

Below steps explains the steps followed by the script to generate the tidy data from raw data

1. Load the libraries
2. Declare and reset some of the variables used in the script
3. Load different data files such as features.txt, activity_labels.txt, X_train.txt, y_train.txt, X_test.txt, y_test.txt, subject_train.txt amd subject_test.txt
4. It names the variables in the data set immediately after the data is loaded. It renames some of the variables from the feature list to make it more readable and later replaceable
5. Adds new column to show the activity labels for each of the activity id in the y_train and y_test data
6. Binds the Subject_Id, Acitivity Id, Activity Labels and all the feature variables for the training and test data
7. Merge the training and test data to create the merge data set
8. Grep for the feature list for mean and standard deviation and apply a subset to retrieve only these data in addition to subject_Id and activity_Labels
9. Create the tidy data set. This will create a table of data for each subject and activity labels and
show the average of all the feature list
10. Write the table of tidy data set into the current working directory with a name 'averaged_tidy_data.txt' and the values are separated by tab
