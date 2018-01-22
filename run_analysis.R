#1.	Merges the training and the test sets to 
# Url
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# destination file data1
#training - x_train, y_train, subject_train
#test - x_test, y_test, subject_test
#futures, activityLables
#------------------------------
# DOWNLOADING

if(!file.exists("data1")){dir.create("data1")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="data1/Dataset.zip")
# Unzip dataSet to /data directory

unzip(zipfile="data1/Dataset.zip",exdir="data1")

# Reading trainings tables:
x_train <- read.table("data1/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("data1/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("data1/UCI HAR Dataset/train/subject_train.txt")
# Reading testing:
x_test <- read.table("data1/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("data1/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("data1/UCI HAR Dataset/test/subject_test.txt")

# Reading feature:
features <- read.table('data1/UCI HAR Dataset/features.txt')

# Reading activity:
activityLabels = read.table('data1/UCI HAR Dataset/activity_labels.txt')
#----------------------------------------
#column names:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"ActivityID"
colnames(subject_train) <- "SubjectID"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "ActivityID"
colnames(subject_test) <- "SubjectID"

colnames(activityLabels) <- c('ActivityID','activityType')
#-------------------------------------------
#Merging training and test
bind_training <- cbind(y_train,subject_train, x_train)
bind_test <- cbind(y_test, subject_test, x_test)
MergeAll <- rbind(bind_training,bind_test)
#-----------------------------------------
#Mean and standard devation 
# Reading column names 
colNames <- colnames(MergeAll)
#==========================
mean_std  <- (grepl("ActivityID" , colNames)|
                    grepl("SubjectID" , colNames)|
                    grepl("mean" , colNames)| 
                    grepl("std" , colNames) 
)

#===========================
#subseting MergeAll

MeanandStd <- MergeAll[, mean_std == TRUE]
#--------------------------------------
# Naming activity in data set:
ActivityNames <- merge(MeanandStd, activityLabels, 
                       by = 'ActivityID',
                       all.x= TRUE)
#==========================
#Independent Tidy data set
IndpTidyset <- aggregate(.~SubjectID + ActivityID, ActivityNames, mean)
IndpTidyset <- IndpTidyset[order(IndpTidyset$SubjectID, IndpTidyset$ActivityID) , ]
#================
#Writing the second indpendent data set txt file
write.table(IndpTidyset, "IndpsecondTidyset.txt", row.names= FALSE)




             
             

