set("C:\\UCI HAR Dataset")

features<-read.table("features.txt")["V2"]
indices<-grep("mean|std",features$V2)
activitylabels<-read.table("activity_labels.txt")["V2"]

testdata<-read.table("./test/X_test.txt")
names(testdata)<-features$V2

testlabels<-read.table("./test/y_test.txt")
names(testlabels)<-"labels"

testsub<-read.table("./test/subject_test.txt")
names(testsub)<-"subjects"

traindata<-read.table("./train/X_train.txt")
names(traindata)<-features$V2

trainlabels<-read.table("./train/y_train.txt")
names(trainlabels)<-"labels"

trainsub<-read.table("./train/subject_train.txt")
names(trainsub)<-"subjects"

mean_std_col1<-colnames(testdata)[indices]
mean_std_col2<-colnames(traindata)[indices]

test_subject<-cbind(testsub,testlabels,subset(testdata,select=mean_std_col1))
train_subject<-cbind(trainsub,trainlabels,subset(traindata,select=mean_std_col2))

mergedata<-rbind(test_subject,train_subject)

tidy<-aggregate(mergedata[,3:ncol(mergedata)],list(Subject=mergedata$subjects,Activity=mergedata$labels),mean)

tidy<-tidy[order(tidy$Subject),]

tidy$Activity<-activity_labels[tidy$Activity,]

write.table(tidy, file="./tidydata.txt", sep="\t", row.names=FALSE)
