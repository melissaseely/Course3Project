#prep tidy data
#submit
#    1  tidy data set
#    2  link to Github with R script
#    3  code book that described variables, data, transformations...called CodeBook.md
#    4  README.md in the repo with scripts

#You should create one R script called run_analysis.R that does the following. 
# 1   Merges the training and the test sets to create one data set.
# 2   Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3   Uses descriptive activity names to name the activities in the data set
# 4   Appropriately labels the data set with descriptive variable names. 
# 5   From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#clear memory in R console
rm(list=ls())
#PART 1
# Merges the training and the test sets to create one data set.
#
#install and open packages
#install.packages("data.table")
#install.packages("dplyr")
library(data.table)
library(dplyr)

#read in data
features <- read.table("./UCI HAR Dataset/features.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", col.names=features[,2])
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", col.names=features[,2])

#merge files
alldata <- rbind(X_test, X_train)



##PART 2
#
# Extracts only the measurements on the mean and standard deviation for each measurement
colmeanSTD <- features[grep("(mean|std)\\(", features[,2]),]
meanstd <- alldata[,colmeanSTD[,1]]


## PART 3
#
# Uses descriptive activity names to name the activities in the data set
#read in values and combine
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c('activity'))
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c('activity'))
y <- rbind(y_test, y_train)
#read in descriptive labels
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
#assign descriptive labels to data
for (i in 1:nrow(labels)) {
  code <- as.numeric(labels[i, 1])
  name <- as.character(labels[i, 2])
  y[y$activity == code, ] <- name
}


##PART 4 Appropriately label the data set with descriptive variable names. 
xlabels <- cbind(y, alldata)
meanstdlabel <- cbind(y, meanstd)

## PART 5
#
#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c('subject'))
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c('subject'))
subject <- rbind(subject_test, subject_train)
averages <- aggregate(alldata, by = list(activity = y[,1], subject = subject[,1]), mean)

write.table(averages, file='assignment/result.txt', row.names=FALSE)

