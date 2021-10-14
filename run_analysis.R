##############################################################################################
#This entire course is garbage and everyone involved in it should be ashamed of themselves.
#But hey, it's probably not going to happen, Coursera's got a real good grift going right here
#I mean, this project is impossible to do without spending time googling completed code
#so with that in mind, I looked at these for 'help':
#https://rstudio-pubs-static.s3.amazonaws.com/37290_8e5a126a3a044b95881ae8df530da583.html
#https://rpubs.com/ninjazzle/DS-JHU-3-4-Final
#Anyway, if you can figure out what this code is supposed to do, why it does it, and how
#let me know where you took an actual class in R from so hopefully I can also learn enough
#to do something useful with this. 
#Because I cannot emphasize enough what a fucking waste of time this 'course' is
#########################################hugs and kisses#######################################

#load the library
library(dplyr)
library(plyr)
library(knitr)

#Merges the training and the test sets to create one data set.

#download the data
fileName <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./data")){
    dir.create("./data")
  }
download.file(fileName,destfile="./data/Dataset.zip",method="curl")

#unzip the file -man, sure glad they covered this in the 'course'
#otherwise i would have had to spend an hour on google to figure out how to get it 
#to work. And that'd be silly, because I'm taking a course. 
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#get the list of names, just like they showed us how to do in the 'lectures' hahah
path_rf <- file.path("./data" , "UCI HAR Dataset")
files<-list.files(path_rf, recursive=TRUE)
 
#print files to the console -hey one of these crappy videos actually showed us how to do this!
files

#read the data from the files into variables
dataActivityTest  <- read.table(file.path(path_rf, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "Y_train.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

#look at the properties
str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeaturesTest)
str(dataFeaturesTrain)

#merge the training and test sets to create one data set
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

#Extracts only the measurements on the mean and standard deviation for each measurement. 
#Subset Name of Features by measurements on the mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

#Subset the data frame Data by seleted names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

#Check the structures of the data frame Data
str(Data)

#Uses descriptive activity names to name the activities in the data set
#Read descriptive activity names from “activity_labels.txt”
activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

#facorize Variale activity in the data frame Data using descriptive activity names
head(Data$activity,30)

#Appropriately labels the data set with descriptive variable names. 
#prefix t is replaced by time
#Acc is replaced by Accelerometer
#Gyro is replaced by Gyroscope
#prefix f is replaced by frequency
#Mag is replaced by Magnitude
#BodyBody is replaced by Body
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

#creates a second
#independent tidy data set with the average of each variable
#for each activity and each subject.
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

#creates the codebook
knit2html("//codebook.Rmd")


##########################################################
##############Is it over?#################################
##############At long last, my son########################
##########################################################