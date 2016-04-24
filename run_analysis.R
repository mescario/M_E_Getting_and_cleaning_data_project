##Miguel Escario
##Getting adn cleaning data course Project



library(reshape2)

filename <- "getdata_dataset.zip"

## Download and unzip the dataset:
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
  download.file(fileURL, filename, method="curl")
}  
unzip(filename)
# Load files
actLab <- read.table("UCI HAR Dataset/activity_labels.txt")
actLab[,2] <- as.character(actLab[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# only take the data on mean and standard deviation
featuresW <- grep(".*mean.*|.*std.*", features[,2])
featuresW.n <- features[featuresW,2]
featuresW.n = gsub('-mean', 'Mean', featuresW.n)
featuresW.n = gsub('-std', 'Std', featuresW.n)
featuresW.n <- gsub('[-()]', '', featuresW.n)


# Load the datasets
exe <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresW]
exeAct <- read.table("UCI HAR Dataset/train/Y_train.txt")
exeSub <- read.table("UCI HAR Dataset/train/subject_train.txt")
exe <- cbind(exeSub, exeAct, exe)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresW]
testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

# merging datasets and add labels and create factors
allData <- rbind(exe, test)
colnames(allData) <- c("subject", "activity", featuresW.n)
allData$activity <- factor(allData$activity, levels = actLab[,1], labels = actLab[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "SolutionTidy.txt", row.names = FALSE, quote = FALSE)

View(allData.mean)