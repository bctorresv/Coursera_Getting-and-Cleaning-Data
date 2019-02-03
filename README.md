---
title: "README"
author: "Brenda Torres-Velasquez"
date: "February 2, 2019"
output:
  html_document:
    df_print: paged
---

# Getting and Cleaning Data Final Project

This document provides revelant information about the final project for the Getting and Cleaning course in Coursera. It includes information relevant about:

* Dataset
    + Description of raw data
    + Raw data, source
    + Main variables with a brief description
* Processes performed
    + Libraries used and functions of interested used
    + Brief description of the processes performed
* Deliverables
    + Files produced
    + How to read deliverables 
    + Where the deliverables are available
* Session info


## Dataset

### Description of raw data

The information in this section was taken from the README file in the source link for datasets. This is included here with the expectation to the reader understand more about data used in this final project.


Human Activity Recognition Using Smartphones Dataset
Version 1.0


Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto.
Smartlab - Non Linear Complex Systems Laboratory
DITEN - Università degli Studi di Genova.
Via Opera Pia 11A, I-16145, Genoa, Italy.

```
activityrecognition@smartlab.ws
www.smartlab.ws
```

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

### Raw data and source
Raw dataset was downloaded from:  <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>.

More information about dataset is available in: <http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones>

The working directory for this project is: "C://Users//BrendaCarolina//Desktop//Coursera//CleaningCourse//Datasets"

The sets of data used were:

* subject_train.txt: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

* X_train.txt: This is the training dataset for the 30 subjects in this study

* y_train.txt: Training labels

* subject_test.txt: : Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

* X_test.txt: This is the test dataset for the 30 subjects in this study

* y_test.txt: Training labels

* activity_labels.txt: Links the class labels with their activity name.

* features.txt: List of all features

Datasets were saved in the following dataframes in R:

```{
subject.train   <-  read.table(".//train//subject_train.txt",  header = FALSE)
X.train         <-  read.table(".//train//X_train.txt",        header = FALSE)
y.train         <-  read.table(".//train//y_train.txt",        header = FALSE)

subject.test    <-  read.table(".//test//subject_test.txt", header = FALSE)
X.test          <-  read.table(".//test//X_test.txt",       header = FALSE)
y.test          <-  read.table(".//test//y_test.txt",       header = FALSE)

activity.levels <-  read.table(".//activity_labels.txt", header = FALSE)
features        <-  read.table(".//features.txt",        header = FALSE)

```

### Main variables with a brief description
**ID.subject:** This is the name set for the only column in subject.train and subject.test
**ID.activity:** This is the name set for the V1 column in activity.levels, and for V1 in y.train and y.test datasets
**name.activity:** This is the name set for the V2 column in activity.levels dataframe

features: it is a dataset with two columns, where the second column represent the variable names for X.train and X.test datasets.

## Processes performed
### Libraries used and functions of interested used
* library("dplyr")

### Brief description of the processes performed

**1.- Download dataset:** Using the source provided about, data was downloaded and unzip. 

**2.- Reading dataset in R:** To read in in R, read.table function was used

**3.- Exploring datasets**:  subject.train, X.train, y.traing, subject.test, X.test, y.test, activity levels and features were explored using dim(), table(), ncol() and colnames(), to determine the proper way to name the columns, and ultimately rbind(), cbind(), and merge() to merge datasets and create the first one named **traintest.dat**. To rename the columns in X.train and X.test, colnames() was used with the features dataset which is the one that contain the names of variables for the different measurements taken and provided in raw data. 

**4.- Extract variables of interest to create the second dataset:** Using grep() function, measurements related to mean and standard deviation were targeted to subset the master dataset traintest.dat, and then the **mean.std.dat** dataframe was created.gsub() was used to renaming measurement columns with full names instead of abbreviations.

**5.- Create a tidy dataset as final task:** Using aggregate() function, the mean by subject by activity was computed for all variables that are in  mean.std.dat. This new and final dataset was named as "tidy.means.dat"

**6.- Sorting data in final dataset:** To have a clean reading when exploring tidy.means.dat, data was sorted by subject ID and by activity. Columns were re-ordered also, to have all identifiers at the left of dataset, followed by all the rest of measurements.

## Deliverables

### Files produced
After all the merging requested the first dataset is named as **traintest.dat**.

Next step request to subset this first dataset and keep only the variables that are related to mean and standard deviation measurements. Identifier variables (ID.sub, ID.activity) with variables working as labels (activity.name) were also kept in this second dataset named as mean.std.dat.

Final step is to created a tidy dataset that is the deliverable of this project. The name of this file is: **means.tidy.dat** which was exported as a txt file, using write.table function.

### How to read deliverables 
To read the final product the function read.table is needed. File to read in in R is named "means.tidy.dat" and contains the mean for each measurement that was related to mean or standard deviation in raw data. The mean was computed by subject ID and by Activity ID.

Chunk of code that helps to read the tidy dataset is as follow:

```{
data <- read.table(file_path, header = TRUE) 

View(data)
```

### Where the deliverables are available
Code and deliverables can be accessed in the following repository on GitHub: 

<https://github.com/bctorresv/Getting-and-Cleaning-Data>

# Session Info
sessionInfo()

R version 3.4.3 (2017-11-30)

Platform: x86_64-w64-mingw32/x64 (64-bit)

Running under: Windows >= 8 x64 (build 9200)
