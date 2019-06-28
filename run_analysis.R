# Script for getting and cleaning data for wearable computing:
library(dplyr)
#--------------------------------------------------------------
# Get dataset directory:
#--------------------------------------------------------------
getDatasetDir <- function(){
        x <- file.path(".", "UCI_HAR_Dataset")
        x
}

#--------------------------------------------------------------
# Train directory
#--------------------------------------------------------------
getTrainDir <- function(){
        x <- file.path(getDatasetDir(),"train")
        x
}

#--------------------------------------------------------------
# Test directory
#--------------------------------------------------------------
getTestDir <- function(){
        x <- file.path(getDatasetDir(),"test")
        x
}
#--------------------------------------------------------------
# Load the activity labels (output labels) :
#--------------------------------------------------------------
loadActivityLabels <- function() {
        filepath <- file.path(getDatasetDir(), "activity_labels.txt")
        labels <- read.table(filepath, header = FALSE)
        labels[,2] <- as.character(labels[,2])
        labels
}

#--------------------------------------------------------------
# Load the feature names:
#--------------------------------------------------------------
loadFeatureNames <- function(filepath) {
        filepath <- file.path(getDatasetDir(),"features.txt")
        featureNames <- read.table(filepath, header = FALSE)
        featureNames[,2] <- as.character(featureNames[,2])
        featureNames
}

#--------------------------------------------------------------
# Filter ONLY relevant attribute names:
#--------------------------------------------------------------
getRelevantFeatures <- function(){
        feats <- loadFeatureNames()
        filterMask <- grepl(".*mean\\(\\).*|.*std\\(\\).*|mean\\(\\)|.*std\\(\\)", feats[,2]) #only containg mean or std dev
        feats <- as.character(feats[filterMask,2]) # vector retruning relevant names
        feats
}

#--------------------------------------------------------------
# Load data sets
#--------------------------------------------------------------
loadAllDatasetsAndClean <- function(){
        
        colNamesFeat <- loadFeatureNames()[,2]
        
        trainData <- read.table(file.path(getTrainDir(), "X_train.txt"))
        colnames(trainData) <- colNamesFeat
        
        testData <- read.table(file.path(getTestDir(), "X_test.txt"))
        colnames(testData) <- colNamesFeat
        
        trainLabels <- read.table(file.path(getTrainDir(), "Y_train.txt"))
        colnames(trainLabels) <- c("activity")
        testLabels <- read.table(file.path(getTestDir(), "Y_test.txt"))
        colnames(testLabels) <- c("activity")
        
        trainSubject <- read.table(file.path(getTrainDir(), "subject_train.txt"))
        colnames(trainSubject) <- c("subject")
        testSubject <- read.table(file.path(getTestDir(), "subject_test.txt"))
        colnames(testSubject) <- c("subject")
        
        # Combine that data :
        trainFullData <- cbind(trainSubject, trainLabels, trainData)
        testFullData <- cbind(testSubject, testLabels, testData)
        DataFull <- rbind(trainFullData, testFullData)
        
        # Free after usage
        rm(trainFullData, testFullData, trainData, testData, trainLabels, testLabels, trainSubject, testSubject)
        
        relevantFeat <- getRelevantFeatures()
        relevantFeat <- c("subject", "activity", relevantFeat)
        DataFull <- DataFull[relevantFeat]
        
        # Descriptive naming:
        # 1. Replacing "-mean()-" with "Mean"
        # 2. Repalcing "-std()-" with "StdDev"
        relevantFeat = gsub('-mean\\(\\)','Mean', relevantFeat)
        relevantFeat = gsub('-std\\(\\)','StdDev', relevantFeat)
        colnames(DataFull) <- relevantFeat # new column names
        
        # Need to group by subject and activity:
        activityLabels <- loadActivityLabels()
        DataFull$activity <- factor(DataFull$activity, levels = c(1:nrow(activityLabels)), labels = activityLabels[,1])
        DataFull$subject <- as.factor(DataFull$subject)
        
        Data_final <- DataFull %>% group_by(subject, activity) %>% summarise_each(list(mean))
        #print(dim(Data_final))
        write.table(Data_final, "tidy_dataset.txt", row.names = FALSE, quote = FALSE)
        #write(colnames(Data_final), "temp.txt")
}
