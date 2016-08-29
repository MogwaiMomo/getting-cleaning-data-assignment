# Assignment CodeBook

This assignment is comprised of a single R script called 'run_analysis.R', which, upon sourcing, will retrieve Human Activity Recognition Data from the Input Data source (see 'Input Data' section below) and completes the following assignment steps:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script automatically saves a descriptive-but-not-yet-tidy data file called 'Step_4_data.txt'  and a tidy summary data file called 'Step_5_data.txt' to the 'output' folder (See 'Output Data' section for details.)

### Input Data

The details and context about the data processed in this assignment can be found here: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data itself can be downloaded here: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Output Data

IMPORTANT NOTE: Of the original 561 features in the raw 'features.txt' file, run_analysis.R only extracts those that had the terms "mean()" or "std()" in them. Close-but-not-exact variants, such as "MeanFreq" or "GravityMean", etc. have been omitted from the analysis. 

#### Variables for the 'Step_5_data.txt':

"SubjectID" - Number ID of the volunteer    
"Activity" - One of 6 activity types the volunteer was doing while being measured: 
  WALKING
  WALKING_UPSTAIRS
  WALKING_DOWNSTAIRS
  SITTING
  STANDING
  LAYING
  
"Measurement" - the type of measurement taken

"Average Mean" - Average of the mean values taken for the measurements

"Average Std" - Average of the std values taken for the measurements