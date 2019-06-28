# Coursera assignment - Getting And Cleaning Data

repository for getting and cleaning data assignment

Download the original uncleaned dataset from [a link](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

Load the R-script 'run_analysis.R' and run the 'loadAllDatasetsAndClean()' function for getting and cleaning data.

## Following are the things carried out by the script: <a name="workflow"></a>

* Load the features and acticity info from respective files.
* Loads both, train and test dataset, by keeping ONLY those columns which reflect either 'mean' or 'standard deviation' for a measurement.
* Load the activity labels and subject information, and merge it into corresponding datasets (train/test)
* Merge both the datasets together.
* Create a new (tidy) dataset consisting of mean values of each filtered variables for each subject and activity pair.
* final tidy data is stored in 'tidy_dataset.txt'
