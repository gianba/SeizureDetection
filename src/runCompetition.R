# Runs the entire workflow of loading data, extracting features, training classifier and building submission
# The function directly writes a submission.csv file ready for submission to Kaggle
#
#   !!!  RUN setupWorkEnvironment() FIRST  !!!
#
# Parameters:
#   dataPath: path to the folder which contains all the data folders (patients and dogs)
# Returns:
#   allData: A list of data.frames containing the extracted features and labels for every clip of each patient
runCompetition <- function(dataPath) {
  allData <- list()
  
  folders <- list.files(dataPath)
  submission <- foreach(ind=1:length(folders),.combine='rbind') %do% {
    folderPath <- getPath(dataPath,folders[ind])
    if(file.info(folderPath)$isdir) {
      dataSet <- loadDataAndExtractFeatures(folderPath, TRUE)
      allData[[ind]] <- dataSet
      buildClassifier(dataSet)
    } 
  }
  
  write.csv(submission, file="submission.csv", row.names=FALSE)
  return(allData)
}