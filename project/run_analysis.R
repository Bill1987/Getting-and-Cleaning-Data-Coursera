if(!library(reshape2, logical.return = TRUE)) {
    # It didn't exist, so install the package, and then load it
    install.packages('reshape2')
    library(reshape2)
}

#===============================================================================
# 0.
# read and download file
#===============================================================================

# download data if it hasn't data file
zipURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"
dataPath <- "UCI HAR Dataset"

if(!file.exists(dataPath))
{
    if(!file.exists(zipFile))
    {
        download.file(zipURL, zipFile, method = "curl")
    }
    unzip(zipFile)
}

# 0.
# read data
# read training data 
X_train <- read.table( file.path(dataPath, "train", "X_train.txt") )
y_train <- read.table( file.path(dataPath, "train", "y_train.txt") )
subject_train <- read.table( file.path(dataPath, "train", "subject_train.txt") )

# read test data 
X_test <- read.table( file.path(dataPath, "test", "X_test.txt") )
y_test <- read.table( file.path(dataPath, "test", "y_test.txt") )
subject_test <- read.table( file.path(dataPath, "test", "subject_test.txt") ) 

# read features
features <- read.table( file.path(dataPath, "features.txt")  ,as.is = TRUE)
features <- features[,2]


#===============================================================================
# 1.Merges the training and the test sets to create one data set.
#===============================================================================

# merge data sets.
activityData <- rbind(cbind(subject_train,y_train,X_train),
                      cbind(subject_test,y_test,X_test) )

# remove useless data to release memory
rm(subject_train,X_train,y_train,subject_test,X_test,y_test)

colnames(activityData) <- c("subject", "activity", features)


#===============================================================================
# 2.Extracts only the measurements on the mean and standard deviation for 
# each measurement.
#===============================================================================

# matching mean and standard deviation columns
extracts <- grep("mean|std", colnames(activityData))

# keep columns 1(subject) , 2 (activity) and matching value
activityData <- activityData[,c(1,2,extracts)]


#===============================================================================
# 3.Uses descriptive activity names to name the activities in the data set
#===============================================================================

# read activity labels
activities <- read.table( file.path(dataPath, "activity_labels.txt") )

# replace activity names
activityData$activity <- factor(activityData$activity, 
                              levels = activities[, 1], labels = activities[, 2])
activityData$subject <- as.factor(activityData$subject)


#===============================================================================
# 4.Appropriately labels the data set with descriptive variable names.
#===============================================================================

activityDataNames <- colnames(activityData)

activityDataNames<-gsub("\\()", "", activityDataNames)
activityDataNames<-gsub("Acc", "Accelerometer", activityDataNames)
activityDataNames<-gsub("Gyro", "Gyroscope", activityDataNames)
activityDataNames<-gsub("BodyBody", "Body", activityDataNames)
activityDataNames<-gsub("Mag", "Magnitude", activityDataNames)
activityDataNames<-gsub("^t", "Time", activityDataNames)
activityDataNames<-gsub("^f", "Frequency", activityDataNames)
activityDataNames<-gsub("tBody", "TimeBody", activityDataNames)
activityDataNames<-gsub("-mean", "Mean", activityDataNames, ignore.case = TRUE)
activityDataNames<-gsub("-std", "Standard", activityDataNames, ignore.case = TRUE)
activityDataNames<-gsub("-freq", "Frequency", activityDataNames, ignore.case = TRUE)
activityDataNames<-gsub("angle", "Angle", activityDataNames)
activityDataNames<-gsub("gravity", "Gravity", activityDataNames)


colnames(activityData) <- activityDataNames

#===============================================================================
# 5.From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
#===============================================================================

# a unique row for each combination of subject and acitivites
activityMeanData <- melt(activityData, id = c('subject', 'activity'))

# Cast it getting the mean value
activityMeanData <- dcast(activityMeanData, subject + activity ~ variable, mean)


# output to file "tidy_data.txt"
write.table(activityMeanData, "tidy_data.txt", row.names = FALSE,quote = FALSE)

