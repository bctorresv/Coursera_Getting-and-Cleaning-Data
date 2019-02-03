# Author: Brenda C Torres-Velasquez
# Created on: Feb 2, 2019

# General description
# This is the main script written to produce the analysis requested in the course of Getting and Cleaning data from
# Coursera. Dataset will be read in, merge, subset, rename, grep, gsub, aggregate, mean(), and select functions 
# were used to get a tidy dataset as deliverable.
  
# Libraries 


library("dplyr", lib.loc="~/R/win-library/3.4")

# ***********************************************************************
# Preliminary assessment:  making sense of datasets
#    Reading data, exploring dimentions, and assigning column names
# ***********************************************************************

# Note: according README document, we should work with the following datasets
# - 'train/X_train.txt': Training set.
# - 'train/y_train.txt': Training labels.
# - 'test/X_test.txt': Test set.
# - 'test/y_test.txt': Test labels.

# Also there is some information available that describe data/variables/columns
# - 'features_info.txt': Shows information about the variables used on the feature vector.
# - 'features.txt': List of all features.
# - 'activity_labels.txt': Links the class labels with their activity name.

# And finally, subjects:
# - 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
 
# Reading in training datasets
subject.train <-  read.table(".//Datasets//train//subject_train.txt",  header = FALSE)
X.train       <-  read.table(".//Datasets//train//X_train.txt", header = FALSE)
y.train       <-  read.table(".//Datasets//train//y_train.txt", header = FALSE)


# Reading in test datasets
subject.test <-  read.table(".//Datasets//test//subject_test.txt", header = FALSE)
X.test       <-  read.table(".//Datasets//test//X_test.txt",       header = FALSE)
y.test       <-  read.table(".//Datasets//test//y_test.txt",       header = FALSE)

# Reading in additional info
activity.levels <-  read.table(".//Datasets//activity_labels.txt", header = FALSE)
features        <-  read.table(".//Datasets//features.txt",        header = FALSE)

# Exploring dimension of datasets

dim(subject.train)   #[1] 7352    1
dim(X.train)         #[1] 7352  561
dim(y.train )        #[1] 7352    1

dim(subject.test )   #[1] 2947    1
dim(X.test)          #[1] 2947  561
dim(y.test )         #[1] 2947    1

dim(activity.levels) #[1]    6    2
dim(features)        #[1]  561    2

# Assigning column names to X.train and X.test
# Explanation: 
# "feature" set has 561 rows that are measures taking in a raw dataset, for example: tBodyAcc-mean()-X, tBodyAcc-mean()-Y, etc. These names are in column 2 of set
# "X.test and X.train dataset have 561 columns
# It makes sense that the 561 rows in features are the names for the 561 variables in X.train and X.test datasets

colnames(X.train) <- features[,2]
colnames(X.test)  <- features[,2]

# Assigning column names to subject.traing and subject.test, as they are only the ID of subjects
colnames(subject.train) <- "ID.sub"
colnames(subject.test)  <- "ID.sub"

# Assigning column names to y.train and y.test sets.
table(y.train)
y.train
#    1    2    3    4    5    6 
# 1226 1073  986 1286 1374 1407 
table(y.test)
# y.test
#   1   2   3   4   5   6 
# 496 471 420 491 532 537 

# After exploring the values in y.train and y.test, then we can infer that the activity levels are the names of the activities in y.train and y.test

colnames(activity.levels) <- c("ID.activity", "name.activity")

colnames(y.train) <- "ID.activity"
colnames(y.test)  <- "ID.activity"

# Adding the name of activity in a new colum to y.train and y.test
y.train <- merge(y.train, activity.levels, by="ID.activity")
y.test  <- merge(y.test, activity.levels,  by="ID.activity")

# *******************************************************************************************
# Task 1: Merges the training and the test sets to create one data set.
# *******************************************************************************************

# Merging/clipping train-sets and test-sets

train.dat <- cbind(subject.train,X.train, y.train )
test.dat  <- cbind(subject.test, X.test,  y.test )

# Cheking dimention of sets
dim(train.dat) #[1] 7352  564
dim(test.dat)  #[1] 2947  564

# Doing the final clipping to create one dataset with train and test data. This is the first task completed: create one dataset
traintest.dat <- rbind(train.dat,test.dat)
dim(traintest.dat) #[1] 10299   564

# *******************************************************************************************
# Task 2: Extracts only the measurements on the mean and standard deviation for each measurement.
# *******************************************************************************************

# Now, we are going to create a subset of main dataset, with only the variables that identify subject and activity and 
# the ones that represent mean or std. We are going to do this looking the column names of traintest.dat

# Using grep function we are making a list with column names that suggest measurements of mean or standard deviation
mean.std.vars <- grep("mean|std",colnames(traintest.dat), value = TRUE, ignore.case = TRUE)

# Now we are subsetting 
mean.std.dat <- subset(traintest.dat, select=c("ID.sub", "ID.activity", "name.activity", mean.std.vars))
dim(mean.std.dat) #[1] 10299    89

# *******************************************************************************************
# Task 3: Uses descriptive activity names to name the activities in the data set
# *******************************************************************************************
# This was already done in the section of "Preliminary assessment" in lines 90-91, when activity_names was merged with
# y.train and y.test sets. So, the assignment of names for activities was carried out since there, hence that variable is already in this subset.
ncol(mean.std.dat)#[1] 89

# Proof:
table(mean.std.dat$name.activity)
#LAYING            SITTING           STANDING            WALKING WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
#1944               1777               1906               1722               1406               1544 

# Nevertheless, just for the sake of following instructions, let's drop that variable and do the merge one more time
mean.std.dat$name.activity <- NULL
ncol(mean.std.dat) #[1] 88

table(mean.std.dat$ID.activity)
#   1    2    3    4    5    6 
#1722 1544 1406 1777 1906 1944 

# Doing the merge to add the names of activities to the dataset one more time
mean.std.dat <- merge(mean.std.dat, activity.levels, by="ID.activity")
ncol(mean.std.dat)#[1] 89

table(mean.std.dat$name.activity)
#LAYING            SITTING           STANDING            WALKING WALKING_DOWNSTAIRS   WALKING_UPSTAIRS 
#1944               1777               1906               1722               1406               1544 

# *******************************************************************************************
# Task 4: Appropriately labels the data set with descriptive variable names.
# *******************************************************************************************

# This was also done in the preliminary assessment, at the begining of code. 
# These are the lines:

# Line 65: colnames(X.train) <- features[,2]
# Line 66: colnames(X.test)  <- features[,2]
# Line 69: colnames(subject.train) <- "ID.sub"
# Line 70: colnames(subject.test)  <- "ID.sub"
# Line 84: colnames(activity.levels) <- c("ID.activity", "name.activity")
# Line 86: colnames(y.train) <- "ID.activity"
# Line 87: colnames(y.test)  <- "ID.activity"

# After doing the merges/clippings, those names kept in main dataset, and also in the subset

colnames(mean.std.dat)
# [1] "ID.activity"                          "ID.sub"                               "tBodyAcc-mean()-X"                    "tBodyAcc-mean()-Y"                   
# [5] "tBodyAcc-mean()-Z"                    "tBodyAcc-std()-X"                     "tBodyAcc-std()-Y"                     "tBodyAcc-std()-Z"                    
# [9] "tGravityAcc-mean()-X"                 "tGravityAcc-mean()-Y"                 "tGravityAcc-mean()-Z"                 "tGravityAcc-std()-X"                 
# [13] "tGravityAcc-std()-Y"                  "tGravityAcc-std()-Z"                  "tBodyAccJerk-mean()-X"                "tBodyAccJerk-mean()-Y"               
# [17] "tBodyAccJerk-mean()-Z"                "tBodyAccJerk-std()-X"                 "tBodyAccJerk-std()-Y"                 "tBodyAccJerk-std()-Z"                
# [21] "tBodyGyro-mean()-X"                   "tBodyGyro-mean()-Y"                   "tBodyGyro-mean()-Z"                   "tBodyGyro-std()-X"                   
# [25] "tBodyGyro-std()-Y"                    "tBodyGyro-std()-Z"                    "tBodyGyroJerk-mean()-X"               "tBodyGyroJerk-mean()-Y"              
# [29] "tBodyGyroJerk-mean()-Z"               "tBodyGyroJerk-std()-X"                "tBodyGyroJerk-std()-Y"                "tBodyGyroJerk-std()-Z"               
# [33] "tBodyAccMag-mean()"                   "tBodyAccMag-std()"                    "tGravityAccMag-mean()"                "tGravityAccMag-std()"                
# [37] "tBodyAccJerkMag-mean()"               "tBodyAccJerkMag-std()"                "tBodyGyroMag-mean()"                  "tBodyGyroMag-std()"                  
# [41] "tBodyGyroJerkMag-mean()"              "tBodyGyroJerkMag-std()"               "fBodyAcc-mean()-X"                    "fBodyAcc-mean()-Y"                   
# [45] "fBodyAcc-mean()-Z"                    "fBodyAcc-std()-X"                     "fBodyAcc-std()-Y"                     "fBodyAcc-std()-Z"                    
# [49] "fBodyAcc-meanFreq()-X"                "fBodyAcc-meanFreq()-Y"                "fBodyAcc-meanFreq()-Z"                "fBodyAccJerk-mean()-X"               
# [53] "fBodyAccJerk-mean()-Y"                "fBodyAccJerk-mean()-Z"                "fBodyAccJerk-std()-X"                 "fBodyAccJerk-std()-Y"                
# [57] "fBodyAccJerk-std()-Z"                 "fBodyAccJerk-meanFreq()-X"            "fBodyAccJerk-meanFreq()-Y"            "fBodyAccJerk-meanFreq()-Z"           
# [61] "fBodyGyro-mean()-X"                   "fBodyGyro-mean()-Y"                   "fBodyGyro-mean()-Z"                   "fBodyGyro-std()-X"                   
# [65] "fBodyGyro-std()-Y"                    "fBodyGyro-std()-Z"                    "fBodyGyro-meanFreq()-X"               "fBodyGyro-meanFreq()-Y"              
# [69] "fBodyGyro-meanFreq()-Z"               "fBodyAccMag-mean()"                   "fBodyAccMag-std()"                    "fBodyAccMag-meanFreq()"              
# [73] "fBodyBodyAccJerkMag-mean()"           "fBodyBodyAccJerkMag-std()"            "fBodyBodyAccJerkMag-meanFreq()"       "fBodyBodyGyroMag-mean()"             
# [77] "fBodyBodyGyroMag-std()"               "fBodyBodyGyroMag-meanFreq()"          "fBodyBodyGyroJerkMag-mean()"          "fBodyBodyGyroJerkMag-std()"          
# [81] "fBodyBodyGyroJerkMag-meanFreq()"      "angle(tBodyAccMean,gravity)"          "angle(tBodyAccJerkMean),gravityMean)" "angle(tBodyGyroMean,gravityMean)"    
# [85] "angle(tBodyGyroJerkMean,gravityMean)" "angle(X,gravityMean)"                 "angle(Y,gravityMean)"                 "angle(Z,gravityMean)"                
# [89] "name.activity"  

# Finally, doing some editing to the names that came with the "raw" data
names(mean.std.dat)<-gsub("^t", "Time", names(mean.std.dat))
names(mean.std.dat)<-gsub("^f", "Frequency", names(mean.std.dat))
names(mean.std.dat)<-gsub("std()", "SD", names(mean.std.dat))
names(mean.std.dat)<-gsub("mean()", "Mean", names(mean.std.dat))
names(mean.std.dat)<-gsub("Freq()", "Frequency", names(mean.std.dat))
names(mean.std.dat)<-gsub("Acc", "Accelerometer", names(mean.std.dat))
names(mean.std.dat)<-gsub("Gyro", "Gyroscope", names(mean.std.dat))
names(mean.std.dat)<-gsub("Mag", "Magnitude", names(mean.std.dat))
names(mean.std.dat)<-gsub("BodyBody", "Body", names(mean.std.dat))
names(mean.std.dat)<-gsub("gravity", "Gravity", names(mean.std.dat))
names(mean.std.dat)<-gsub("-", "_", names(mean.std.dat))

colnames(mean.std.dat)

# *******************************************************************************************
# Task 5: From the data set in step 4, creates a second, independent tidy data set with the 
#         average of each variable for each activity and each subject.
# *******************************************************************************************

# I am taking out the column ID.activity, in order to be more descriptive in dataset
means.tidy.dat <- aggregate(. ~ID.sub + name.activity, mean.std.dat[,-1], mean)

# As final touch I am adding back the ID.activity, 
means.tidy.dat <- merge(means.tidy.dat , activity.levels, by="name.activity")

# Sorting by subject and by activity ID
means.tidy.dat <- means.tidy.dat[order(means.tidy.dat$ID.sub, means.tidy.dat$ID.activity),]

# ...and ordering columns
means.tidy.dat <- means.tidy.dat %>% select(ID.sub, ID.activity, name.activity, everything())

# Exporting final tidy dataset requested
write.table(means.tidy.dat, ".//deliverables//means.tidy.dat.txt", row.name=FALSE)

# End of project
