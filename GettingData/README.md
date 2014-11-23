# README.md

Set working directory

```r
setwd("~/Dropbox/Coursera/Getting and Cleaning Data/Projects/Data")
```


### Step 1 Merges the training and the test sets to create one data set.

```r
# Read file "X_train.txt" into Xtrain and show its dimension
Xtrain<-read.table("X_train.txt", header=F, stringsAsFactors=F)
dim(Xtrain)
```

```
## [1] 7352  561
```

```r
# Read file "X_test.txt" into Xtest and show its dimension
Xtest<-read.table("X_test.txt", header=F, stringsAsFactors=F)
dim(Xtest)
```

```
## [1] 2947  561
```

```r
# Read file "feature.txt" into feature and show its dimension
feature<-read.table("features.txt", header=F, stringsAsFactors=F)
dim(feature)
```

```
## [1] 561   2
```

```r
# Read file "subject_train.txt" into subtrain and show its dimension
subtrain<-read.table("subject_train.txt", header=F, stringsAsFactors=F)
dim(subtrain)
```

```
## [1] 7352    1
```

```r
# Read file "subject_test.txt" into subtest and show its dimension
subtest<-read.table("subject_test.txt", header=F, stringsAsFactors=F)
dim(subtest)
```

```
## [1] 2947    1
```

```r
# Merge Xtrain and Xtest into mergeX and show its dimension
mergeX<-rbind(Xtrain,Xtest)
dim(mergeX)
```

```
## [1] 10299   561
```

```r
# Merge subtrain and subtest into mergesub and show its dimension
mergesub<-rbind(subtrain,subtest)
dim(mergesub)
```

```
## [1] 10299     1
```

```r
# Read file "y_train.txt" into ytrain and show its dimension
ytrain<-read.table("y_train.txt", header=F, stringsAsFactors=F)
dim(ytrain)
```

```
## [1] 7352    1
```

```r
# Read file "y_test.txt" into ytest and show its dimension
ytest<-read.table("y_test.txt", header=F, stringsAsFactors=F)
dim(ytest)
```

```
## [1] 2947    1
```

```r
# Merge ytrain and ytest into mergey and show its dimension
mergey<-rbind(ytrain,ytest)
dim(mergey)
```

```
## [1] 10299     1
```

```r
# Combine mergeX, mergesub, mergey together, use the features as column names of the data set, and save the data set into "data"
feature1<-as.vector(t(feature[,2]))
feature2<-append(feature1,cbind("subject","activity"),after=length(feature1))
data<-cbind(mergeX,mergesub,mergey)
colnames(data)<-feature2
```


### Step 2 Extracts only the measurements on the mean and standard deviation for each measurement. 

```r
# Select measurements which contains "mean()" and "std()" but avoid those containing "meanFreq"
colNames<-colnames(data)
colNames1 <- (colNames[(grepl("mean()",colNames) | grepl("std()",colNames) | grepl("subject",colNames) | grepl("activity",colNames)) == TRUE])
colNames2 <- (colNames1[(grepl("meanFreq",colNames1)==FALSE)])
data1<-data[colNames2]
```

### Step 4 Appropriately labels the data set with descriptive variable names. 

```r
# Change the variable names
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
```

### Step 3 Uses descriptive activity names to name the activities in the data set.

```r
# Replace numbers 1:6 with descriptive acticity names under the "acticity"" column
data1$activity <- factor(data1$activity,levels=1:6,labels=c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))
```

### Step 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```r
# Create the final tidy data set named "tidydata""
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
## 
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## 
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
data2 <- group_by(data1,subject,activity)
tidydata <- summarise_each(data2,funs(mean))
```
