library(tidyverse)

#Download zip file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "getting_cleaning_data.zip")

#Unzip
unzip("getting_cleaning_data.zip")

#Set wd
setwd("UCI HAR Dataset")

#List files
list.files(recursive = TRUE)

#Read activity labels
activity_labels <- read.table("activity_labels.txt")
activity_labels

#Read features
features <- read.table("features.txt")

#Get only mean and stddev features
selected_features <- grep(x = features[,2], pattern = "mean[(][)]|-std[(][)]")
feature_names <- gsub(x = features[selected_features,2], pattern = "[(][)]|-[(][)]", replacement = "")

#Load datasets

#Train
y_train <- read.table("train/y_train.txt", col.names = "activity")
X_train <- read.table("train/X_train.txt")[,selected_features]
colnames(X_train) <- feature_names
subject_train <- read.table("train/y_train.txt", col.names = "subject")

train_set <- cbind(subject_train, y_train, X_train)
    
#Test
y_test <- read.table("test/y_test.txt", col.names = "activity")
X_test <- read.table("test/X_test.txt")[,selected_features]
colnames(X_test) <- feature_names
subject_test <- read.table("test/y_test.txt", col.names = "subject")

test_set <- cbind(subject_test, y_test, X_test)

    
#Join train and test
full_set <- rbind(train_set, test_set)

#Label activities and convert to factors
activity_labels <- read.table("activity_labels.txt")
full_set$activity <- factor(full_set$activity, levels = activity_labels[,1], labels = activity_labels[,2])
full_set$subject <- factor(full_set$subject)    

#creates a second, independent tidy data set with the average of each variable for each activity and each subject    

tidy_set <-  
    full_set %>%
        group_by(subject, activity) %>%
            summarize_all(funs(mean))

#Write table
write.table(tidy_set, "tidy_set.txt", row.names = FALSE)








    
    
