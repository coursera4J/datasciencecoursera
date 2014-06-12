library(plyr)
#store the working directory
backupDir = getwd();

#assume the data is avilable in the working directory
setwd("UCI HAR Dataset")
features<-read.table("features.txt")
labelMapping<-read.table("activity_labels.txt")

#reading train dataset
setwd("train")

XTrain<-read.table("X_train.txt")
names(XTrain)<-features$V2

YTrain<-read.table("y_train.txt")
YTrain<-join(YTrain, labelMapping)
names(YTrain)<-c("label", "activity")

sTrain<-read.table("subject_train.txt")
names(sTrain)<-c("subject")

##reading test dataset
setwd("../test")
XTest<-read.table("X_test.txt")
names(XTest)<-features$V2

YTest<-read.table("y_test.txt")
YTest<-join(YTest, labelMapping)
names(YTest)<-c("label", "activity")

sTest<-read.table("subject_test.txt")
names(sTest)<-c("subject")

##Combine train and test data together
XCombo<-rbind(XTrain, XTest)
YCombo<-rbind(YTrain, YTest)
sCombo<-rbind(sTrain, sTest)

##Extracts only the measurements on the mean each measurement.
meanXCombo<-XCombo[, grep("mean", names(XCombo))]

##Extracts only the measurements on standard deviation for each measurement.
stdXCombo<-XCombo[, grep("std", names(XCombo))]

##combine mean and standard deviation together
mean_stdXCombo<-cbind(meanXCombo, stdXCombo)

outputData<-cbind(mean_stdXCombo, YCombo)
outputData<-cbind(outputData, sCombo)

#write the first tidy dataset to the working direcotry
setwd(backupDir)
write.table(outputData, file="tidyData1.txt", row.names=FALSE)


##generate the second tidy dataset
##
##assume the data is available in the working directory
setwd("UCI HAR Dataset")
features<-read.table("features.txt")
labelMapping<-read.table("activity_labels.txt")

#reading train dataset
setwd("train")

XTrain<-read.table("X_train.txt")
names(XTrain)<-features$V2

YTrain<-read.table("y_train.txt")
YTrain<-join(YTrain, labelMapping)
names(YTrain)<-c("label", "activity")

sTrain<-read.table("subject_train.txt")
names(sTrain)<-c("subject")

##reading test dataset
setwd("../test")
XTest<-read.table("X_test.txt")
names(XTest)<-features$V2

YTest<-read.table("y_test.txt")
YTest<-join(YTest, labelMapping)
names(YTest)<-c("label", "activity")

sTest<-read.table("subject_test.txt")
names(sTest)<-c("subject")

##Combine train and test data together
XCombo<-rbind(XTrain, XTest)
YCombo<-rbind(YTrain, YTest)
sCombo<-rbind(sTrain, sTest)


outputData<-cbind(XCombo, YCombo)
outputData<-cbind(outputData, sCombo)


agg <-aggregate(outputData[1:561], list(outputData$activity, outputData$subject), mean)
names(agg)[1] = "activity"
names(agg)[2] = "subject"

#write the second tidy dataset
setwd(backupDir)
write.table(agg, file="tidyData2.txt", row.names=FALSE)

