library(reshape2)

#Initialize some of the variables that would be used so that across multiple times running we start 
#with cleared variables
X_train_Subjects_labels = NULL
X_test_Subjects_labels = NULL
mergedDataSet = NULL

#First Load the data files and create data frames. At the same time we will assign names for the 
#columns as this gives clarity and helps during debugging

features <- read.table("features.txt", header = FALSE)

#Make the names simpler so that subsequent replacement becomes easier
features[,2] = gsub('-mean', 'Mean', features[,2])
features[,2] = gsub('-std', 'Std', features[,2])
features[,2] = gsub('[-()]', '', features[,2])

activity_labels <- read.table("activity_labels.txt", header = FALSE)

#Load the training data
X_train <- read.table("train/X_train.txt", header = FALSE)
y_train <- read.table("train/y_train.txt", header = FALSE)
 
#Load the test data
X_test <- read.table("test/X_test.txt", header = FALSE)
y_test <- read.table("test/y_test.txt", header = FALSE)

#Assign column names from the feature list
names(X_train) <- features$V2
names(X_test) <- features$V2

#This column names represent activity id, which will be identified with the activity labels
names(y_train) <- c("Activity_Id")
names(y_test) <- c("Activity_Id")

#Load the subject files and add the column names
subject_train <- read.table("train/subject_train.txt", header = FALSE)
colnames(subject_train) <- c("Subject_Id")
subject_test <- read.table("test/subject_test.txt", header = FALSE)
colnames(subject_test) <- c("Subject_Id")

#y has one column representing the activity id. Find the corresponding activity label and add as
#a new column to y. This is done to 'Uses descriptive activity names to name the activities in the data set'
#i.e. basically 3rd part of the question
y_train$Activity_Labels <- activity_labels[y_train$Activity_Id, "V2"]
y_test$Activity_Labels <- activity_labels[y_test$Activity_Id, "V2"]

#Make the training data full. Basically add SubjectId, Activity Id, Activity Label and all the features
#together to create full training data frame. These gets added as columns
X_train_Subjects_labels <- cbind(subject_train, y_train, X_train)

#Make the test data full. Basically add SubjectId, Activity Id, Activity Label and all the features
#together to create full test data frame. These gets added as columns
X_test_Subjects_labels <- cbind(subject_test, y_test, X_test)

#Now add the training and test data to create a master record. Adding the rows
mergedDataSet <- rbind(X_train_Subjects_labels, X_test_Subjects_labels)

# By this step we completed merging of all the data (step 1), added 'descriptive activity names' 
# (step 3) and added 'Appropriately labels the data set with descriptive variable names. ' as and
# when they are loaded (step 4)

##################Now part 2 #####################################
# Identify the columns names that has mean or standard deviation to filter out the additional info
col_Std_Mean <- grep(".*Mean.*|.*Std.*", names(mergedDataSet))

#Build a new data set with this. Keep the subject Id (column no:1) and activity labels (column nos:3)
#with this in the new data set
mergedDataSet_meanStd <- mergedDataSet[, c(1, 3, col_Std_Mean)]

################# Now part 5 #####################################
#Create the tidy data set. This will create a table of data for each subject and activity labels and
#show the average of all the feature list
averaged_tidy_data <- aggregate(mergedDataSet_meanStd[,3:ncol(mergedDataSet_meanStd)], 
                          by = list(Subject_ID = mergedDataSet_meanStd$Subject_Id,
                          Activity_Label = mergedDataSet_meanStd$Activity_Labels), mean)

#Write the tidy data into a table
write.table(averaged_tidy_data, "averaged_tidy_data.txt", sep = "\t")
