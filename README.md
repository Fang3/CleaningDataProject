## Getting and Cleaning Data Course Project
Objective:  Prepare a tidy dataset for future analysis

Data Source:  Human Activity Recognition Using Smartphones Data Set
(http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

Output Dataset:  A summarized tidy dataset at subject and activity level (180 rows) with average of 66 variables (please see codebook.md for variables descriptions).

Method: Use following R script to create a summarized tidy dataset

1. Read in training, test files and corresponding label, subject and activity files. Then use rbind() to concatenate training and test data. Rename the column name for easier match later. 

trainingX = read.table('./train/X_train.txt')
trainingY = read.table('./train/y_train.txt')
traingsubject = read.table('./train/subject_train.txt')

testX = read.table('./test/X_test.txt')
testY = read.table('./test/y_test.txt')
testsubject = read.table('./test/subject_test.txt')

traintestX = rbind(trainingX,testX)
traintestY = rbind(trainingY,testY)

colnames(traintestY) = c('ActivityCode')
traintestsub = rbind(traingsubject,testsubject)
colnames(traintestsub) = c('SubjectCode')
features = read.table('features.txt')

2. Extract only the measurements with mean and standard deviation. Use grep() to get the index then create a subset to only include required variables. Use gsub() to rename variable name to be more descriptive. 

idx = grep('mean\\(\\)|std\\(\\)',features$V2)
names(trainingX[,grep('mean\\(\\)|std\\(\\)',features$V2)])
feature_keep = features[grep('mean\\(\\)|std\\(\\)',features$V2),]

t1 = gsub('^t','Time',features[grep('mean\\(\\)|std\\(\\)',features$V2),2]) 
t2 = gsub('^f','Freq',t1) 
t3 = gsub('-mean\\(\\)','Mean',t2)
t4 = gsub('-std\\(\\)','Std',t3)
t5 = gsub('-','',t4)

feature_keep = cbind(feature_keep,t5)
traintestX_keep = traintestX[,idx]
colnames(traintestX_keep) = feature_keep[,3]

3. Merge with activity label file to get a descriptive name for activities in the dataset

traintestall = cbind(traintestX_keep,traintestY,traintestsub)
actlabel = read.table('./activity_labels.txt')
colnames(actlabel) = c('ActivityCode','ActivityLabel')
traintestall = merge(traintestall,actlabel,by ='ActivityCode')

4. Use aggregate() to summarize the data for each subject and activity and taking average of each variables

summarydata = aggregate(subset(traintestall,select=-c(ActivityLabel,SubjectCode,ActivityCode)),by=list(traintestall$ActivityLabel,traintestall$SubjectCode),FUN = mean)
dim(summarydata)
names(summarydata)[1:2] = c("ActivityLabel","SubjectCode")
head(summarydata)

5. Output the file and upload for peer review.

output = write.table(summarydata,file='SummarizedData.txt',row.names = FALSE)


