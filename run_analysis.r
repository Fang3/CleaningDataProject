
trainingX = read.table('./train/X_train.txt')
trainingY = read.table('./train/y_train.txt')
traingsubject = read.table('./train/subject_train.txt')
dim(trainingX)
dim(trainingY )
dim(traingsubject)

testX = read.table('./test/X_test.txt')
testY = read.table('./test/y_test.txt')
testsubject = read.table('./test/subject_test.txt')
dim(testX)
dim(testY )
dim(testsubject)

traintestX = rbind(trainingX,testX)
dim(traintestX)

traintestY = rbind(trainingY,testY)
dim(traintestY)
colnames(traintestY) = c('ActivityCode')

traintestsub = rbind(traingsubject,testsubject)
dim(traintestsub)
colnames(traintestsub) = c('SubjectCode')

features = read.table('features.txt')
features
#Extract features index with mean() or std() in it
grep('mean\\(\\)|std\\(\\)',features$V2,value=TRUE)
idx = grep('mean\\(\\)|std\\(\\)',features$V2)
names(trainingX[,grep('mean\\(\\)|std\\(\\)',features$V2)])
feature_keep = features[grep('mean\\(\\)|std\\(\\)',features$V2),]

#Clean up feature names to be more descriptive
t1 = gsub('^t','Time',features[grep('mean\\(\\)|std\\(\\)',features$V2),2]) 
t2 = gsub('^f','Freq',t1) 
t3 = gsub('-mean\\(\\)','Mean',t2)
t4 = gsub('-std\\(\\)','Std',t3)
t5 = gsub('-','',t4)
t5

feature_keep = cbind(feature_keep,t5)
feature_keep
#Rename column name to be more descriptive name
traintestX_keep = traintestX[,idx]
colnames(traintestX_keep) = feature_keep[,3]
colnames(traintestX_keep)
#append activity and subjust info
traintestall = cbind(traintestX_keep,traintestY,traintestsub)
head(traintestall)

actlabel = read.table('./activity_labels.txt')
colnames(actlabel) = c('ActivityCode','ActivityLabel')
traintestall = merge(traintestall,actlabel,by ='ActivityCode')
dim(traintestall)
head(traintestall)

#Summarize by activity and subjuect
summarydata = aggregate(subset(traintestall,select=-c(ActivityLabel,SubjectCode,ActivityCode)),by=list(traintestall$ActivityLabel,traintestall$SubjectCode),FUN = mean)
dim(summarydata)
head(summarydata)
names(summarydata)[1:2]
names(summarydata)[1:2] = c("ActivityLabel","SubjectCode")
head(summarydata)

output = write.table(summarydata,file='SummarizedData.txt',row.names = FALSE)