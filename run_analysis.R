##Load library
library(dplyr)

#1. Download and unzip the Dataset:
URL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFile <- "UCI HAR Dataset.zip"

if (!file.exists(zipFile)) {
   download.file(URL, zipFile, mode = "wb")
}
dataset <- "UCI HAR Dataset"
if(!file.exists(dataset)) {unzip(zipFile)}

#2. Read  in the files: 
  
 #2.1 Test Set Files: 
 TestValues <- read.table("./UCI HAR Dataset/test/X_test.txt")
 
 TestActivities <- read.table("./UCI HAR Dataset/test/y_test.txt")
 
 TestSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
 
 #2.2 Training Set Files:
 TrainingValues <- read.table("./UCI HAR Dataset/train/X_train.txt")
 
 TrainingActivities <- read.table("./UCI HAR Dataset/train/y_train.txt")
 
 TrainingSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
 
 #2.3 Read in Features: 
 features <- read.table("./UCI HAR Dataset/features.txt", as.is = TRUE)
 
 #2.4 Read  in Activites: 
 activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
 colnames(activities) <- c("ActivityID", "ActivityName")
 activities[,2] <- as.character(activities[,2])
 
 
#3. Merge the data into one dataset: 
 Activity <- rbind(cbind(TrainingSubjects, TrainingActivities, TrainingValues), cbind(TestSubjects, TestActivities, TestValues))
 
 #3.1 Assign column names to "Activity":
 colnames(Activity) <- c("Subjects", "Activities", features[,2])

  
#4.  Extract mean and standard deviation measurements:
ExtractColumns <- grep("Subject|Activities|mean\\(\\)|std\\(\\)", colnames(Activity), value = TRUE )
 #4.1 Save these columns to "Activity":
Activity <- Activity[, ExtractColumns]



#5. Substitute variable names with descriptive names:

 #5.1 Remove special characters
colnames(Activity) <- gsub("[\\(\\)-]", "", colnames(Activity))

colnames(Activity) <- gsub("^t", "timeDomain", colnames(Activity))
colnames(Activity) <- gsub("^f", "frequencyDomain", colnames(Activity))
colnames(Activity) <- gsub("Acc", "Accelerometer", colnames(Activity))
colnames(Activity) <- gsub("Gyro", "Gyroscope", colnames(Activity))
colnames(Activity) <- gsub("Mag", "Magnitude", colnames(Activity))
colnames(Activity) <- gsub("mean", "Mean", colnames(Activity))
colnames(Activity) <- gsub("std", "StandardDeviation", colnames(Activity))


 #5.2 Fix Typo:
colnames(Activity) <- gsub("BodyBody", "Body", colnames(Activity))
   

#6. Create second data set with the average of each variable for each activity and each subject:
Tidydata <- Activity %>%
group_by(Subjects, Activities) %>%
summarise_all(.funs = mean)

#6.1 Use descriptive activity names to name the activities in the data
#          set:
Tidydata$Activities <- factor(Tidydata$Activities, levels = activities[,1], labels = activities[,2])

# output "Tidydata.txt"
write.table(Tidydata, "Tidydata.txt", row.names = FALSE, 
            quote = FALSE)
