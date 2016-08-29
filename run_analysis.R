# setwd upon script source
this.dir <- dirname(parent.frame(2)$ofile)
setwd(this.dir)

# Load libraries
library(dplyr)
library(tidyr)

# get data
data_dirname <- "./input" 
if (!file.exists(data_dirname)){
  dir.create(data_dirname)
}

url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

temp <- tempfile(tmpdir = data_dirname, fileext = ".zip")
download.file(url, temp)
unzip(temp, exdir = data_dirname)
unlink(temp)

path_to_activity_labels <- paste(data_dirname, "UCI HAR Dataset", "activity_labels.txt", sep="/")
path_to_feature_names <- paste(data_dirname, "UCI HAR Dataset", "features.txt", sep="/")
path_to_train_X <- paste(data_dirname, "UCI HAR Dataset", "train", "X_train.txt", sep="/")
path_to_train_Y <- paste(data_dirname, "UCI HAR Dataset", "train", "Y_train.txt", sep="/")
path_to_train_subject <- paste(data_dirname, "UCI HAR Dataset", "train", "subject_train.txt", sep="/")
path_to_test_X <- paste(data_dirname, "UCI HAR Dataset", "test", "X_test.txt", sep="/")
path_to_test_Y <- paste(data_dirname, "UCI HAR Dataset", "test", "Y_test.txt", sep="/")
path_to_test_subject <- paste(data_dirname, "UCI HAR Dataset", "test", "subject_test.txt", sep="/")

# Step 1. Merge the training and the test sets to create one data set

# Read/import data

train_data_X <- read.table(path_to_train_X)
test_data_X <- read.table(path_to_test_X)

train_data_Y <- read.table(path_to_train_Y)
test_data_Y <- read.table(path_to_test_Y)

# Replace Y values with descriptive activity labels (covers Step 3 of assignment)
activity_labels <- read.table(path_to_activity_labels)
descriptive_train_activities <- merge(train_data_Y, activity_labels, by = "V1", all=TRUE, sort=F) %>%
  rename(Activity = V2)
descriptive_test_activities <- merge(test_data_Y, activity_labels, by = "V1", all=TRUE, sort=F) %>%
  rename(Activity = V2)

train_data_subject <- read.table(path_to_train_subject) %>%
  rename(SubjectID = V1 )
test_data_subject <- read.table(path_to_test_subject) %>%
  rename(SubjectID = V1 )

features_df <- read.table(path_to_feature_names) %>%
  select(V2) %>%
  rename(Feature = V2)
features_vect <- as.vector(features_df$Feature)


# set "features" as variable names of X data sets
colnames(train_data_X) <- features_vect
colnames(test_data_X) <- features_vect

# bind train Y data (activity) to train X data
train_data_X <- cbind(descriptive_train_activities, train_data_X)
train_data_X$V1 <- NULL # delete unnecessary column 

# bind subject data to train X data
train_data_X <- cbind(train_data_subject, train_data_X)

# bind test Y (activity)to test X
test_data_X <- cbind(descriptive_test_activities, test_data_X)
test_data_X$V1 <- NULL # delete unnecessary column 

# bind subject data to test X data
test_data_X <- cbind(test_data_subject, test_data_X)

# merge tables
merged_data <- rbind(train_data_X, test_data_X)

# fix names according to variable restrictions:
valid_column_names <- make.names(names=names(merged_data), unique=TRUE, allow_ = TRUE)
names(merged_data) <- valid_column_names

# Step 2: Extract only the measurements on the mean and standard deviation for each measurement.

# get the names of all variables in table
merged_var_names <- names(merged_data)

# match only those with mean or std in the variable name (assuming MeanFreq is distinct from mean())
mean_std_vars <- grep("\\.(mean|std)(?!Freq)", merged_var_names, perl = TRUE)
mean_std_only_df <- select(merged_data, SubjectID, Activity, mean_std_vars[1:66])

# Step 3 - done, addressed early in data processing (on line 43)

# Step 4 - add descriptive label names
names(mean_std_only_df) <- sub("tBodyAcc", "TimeBodyAccelerometer", names(mean_std_only_df))
names(mean_std_only_df) <- sub("tGravityAcc", "TimeGravityAccelerometer", names(mean_std_only_df))
names(mean_std_only_df) <- sub("tBodyGyro", "TimeBodyGyroscope", names(mean_std_only_df))
names(mean_std_only_df) <- sub("fBodyAcc", "FrequencyBodyAccelerometer", names(mean_std_only_df))
names(mean_std_only_df) <- sub("fBodyGyro", "FrequencyBodyGyroscope", names(mean_std_only_df))
names(mean_std_only_df) <- sub("fBodyBodyAcc", "FrequencyBodyAccelerometer", names(mean_std_only_df))
names(mean_std_only_df) <- sub("Mag\\.", "Magnitude\\.", names(mean_std_only_df))
names(mean_std_only_df) <- sub("fBodyBody", "fBody", names(mean_std_only_df))
names(mean_std_only_df) <- sub("fBodyGyroMagnitude", "FrequencyBodyGyroscopeMagnitude", names(mean_std_only_df))
names(mean_std_only_df) <- sub("fBodyGyroJerkMagnitude", "FrequencyBodyGyroscopeJerkMagnitude", names(mean_std_only_df))
names(mean_std_only_df) <- sub("\\.mean\\.\\.", "_Mean", names(mean_std_only_df))
names(mean_std_only_df) <- sub("\\.std\\.\\.", "_Std", names(mean_std_only_df))
names(mean_std_only_df) <- sub("\\.", "_", names(mean_std_only_df))

Step_4_final_dataset <- mean_std_only_df

# Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Create new intermediate dataset and tidy it up

# Gather data ...
tidier_mean_std_only_df <- mean_std_only_df %>%
  gather(Variable_Name, Value, -SubjectID, -Activity)

# Recast data so we have columns for Measurement, Stat_Type
tidier2_mean_std_only_df <- tidier_mean_std_only_df %>%
  separate(Variable_Name, into = c("Measurement", "Stat_Type", "Axis"), sep = "_")
tidier2_mean_std_only_df$Measurement <- paste(tidier2_mean_std_only_df$Measurement, tidier2_mean_std_only_df$Axis, sep = "") 
tidier2_mean_std_only_df$Measurement <- sub("NA", "", tidier2_mean_std_only_df$Measurement) 
tidier2_mean_std_only_df <- select(tidier2_mean_std_only_df, -Axis)

# use dplyr to groupby and then summarize data

tidy_averages <- tidier2_mean_std_only_df %>%
  group_by(SubjectID, Activity, Measurement, Stat_Type) %>%
  summarize(Average = mean(Value))

# clean up variable names
tidy_averages$Stat_Type <- sub("Mean", "Average Mean", tidy_averages$Stat_Type)
tidy_averages$Stat_Type <- sub("Std", "Average Std", tidy_averages$Stat_Type)

# spread mean and std into their own columns
Step_5_final_dataset <- spread(tidy_averages, Stat_Type, Average)

# Write Step 4 and Step 5 final data sets to file 

# create folder for output
output_dirname <- "./output" 
if (!file.exists(output_dirname)){
  dir.create(output_dirname)
}
# save dataset to file for Step 4 of Assignment
write.table(Step_4_final_dataset, paste(output_dirname, "step_4_data.txt", sep="/"), row.name=FALSE)

# save dataset to file for Step 5 of Assignment
write.table(Step_5_final_dataset, paste(output_dirname, "step_5_data.txt", sep="/"), row.name=FALSE)

