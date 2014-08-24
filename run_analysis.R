library(plyr)
library(reshape2)

## Load in, combine, and extract the record data
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt")
testData <- read.table("./UCI HAR Dataset/test/X_test.txt")
allData <- rbind(trainData, testData)
features <- read.table("./UCI HAR Dataset/features.txt", colClasses = c("numeric", "character"))
extractedFeatures <- features[grepl("mean()", features$V2, fixed = TRUE) | grepl("std()", features$V2, fixed = TRUE), ]
extractedData <- allData[, extractedFeatures$V1]
names(extractedData) <- extractedFeatures$V2

## Load in and combine the activity label ID
trainLabel <- read.table("./UCI HAR Dataset/train/y_train.txt")
testLabel <- read.table("./UCI HAR Dataset/test/y_test.txt")
allLabel <- rbind(trainLabel, testLabel)
names(allLabel) <- "activity_label_id"

## Transform the activity label ID into activity name
activity <- cut(allLabel[, 1], breaks = 0:6, 
                labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
activity <- as.data.frame(activity)

## Load in and combine the subject ID
trainSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
allSubject <- rbind(trainSubject, testSubject)
names(allSubject) <- "subject_id"

## Combine all components to form the tidy dataset
combinedData <- cbind(allSubject, activity, extractedData)
meltedData <- melt(combinedData, id.vars = c("subject_id", "activity"))
tidyData <- ddply(meltedData, c("subject_id", "activity", "variable"), summarize, mean = mean(value))

## Output the tidy dataset to a file
write.table(tidyData, file = "./tidy.txt", row.names = FALSE)
