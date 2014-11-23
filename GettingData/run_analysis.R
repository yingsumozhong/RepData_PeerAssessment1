
setwd("~/Dropbox/Coursera/Getting and Cleaning Data/Projects/Data")

# Step 1
Xtrain<-read.table("X_train.txt", header=F, stringsAsFactors=F)
dim(Xtrain)
Xtest<-read.table("X_test.txt", header=F, stringsAsFactors=F)
dim(Xtest)
feature<-read.table("features.txt", header=F, stringsAsFactors=F)
dim(feature)
subtrain<-read.table("subject_train.txt", header=F, stringsAsFactors=F)
dim(subtrain)
subtest<-read.table("subject_test.txt", header=F, stringsAsFactors=F)
dim(subtest)
mergeX<-rbind(Xtrain,Xtest)
dim(mergeX)
mergesub<-rbind(subtrain,subtest)
dim(mergesub)
ytrain<-read.table("y_train.txt", header=F, stringsAsFactors=F)
dim(ytrain)
ytest<-read.table("y_test.txt", header=F, stringsAsFactors=F)
dim(ytest)
mergey<-rbind(ytrain,ytest)
dim(mergey)
feature1<-as.vector(t(feature[,2]))
feature2<-append(feature1,cbind("subject","activity"),after=length(feature1))
data<-cbind(mergeX,mergesub,mergey)
colnames(data)<-feature2

# Step 2
colNames<-colnames(data)
colNames1 <- (colNames[(grepl("mean()",colNames) | grepl("std()",colNames) | grepl("subject",colNames) | grepl("activity",colNames)) == TRUE])
colNames2 <- (colNames1[(grepl("meanFreq",colNames1)==FALSE)])
data1<-data[colNames2]

# Step 4
for (i in 1:length(colNames2))
{
    temp <- colNames2[i]
    temp<-gsub("Acc","Accelerometer",temp)
    temp<-gsub("Gyro","Gyroscope",temp)
    temp<-gsub("-","",temp)
    temp<-gsub('^t','Time',temp)
    temp<-gsub('^f','Frequancy',temp)
    temp<-gsub("mean()","Mean",temp)
    temp<-gsub("std()","StandardDeviation",temp)
    temp<-gsub("\\(|\\)","",temp)
    colNames2[i]<-temp
}  
colnames(data1)<-colNames2

# Step 3
data1$activity <- factor(data1$activity,levels=1:6,labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))

# Step 5
library(dplyr)
data2 <- group_by(data1,subject,activity)
tidydata <- summarise_each(data2,funs(mean))

