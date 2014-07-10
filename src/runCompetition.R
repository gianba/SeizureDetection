# Runs the entire workflow of loading data, extracting features, training classifier and building submission
# The function directly writes a submission.csv file ready for submission to Kaggle
#
#   !!!  RUN setupWorkEnvironment() FIRST  !!!
#
# Parameters:
#   dataPath: path to the folder which contains all the data folders (patients and dogs)
# Returns list with field:
#   allData: A list of data.frames containing the extracted features and labels for every clip of each patient
#   info: Informations about the classification, features relevance, etc. dependent on the classifier used
runCompetition <- function(dataPath, method='svm') {
  if (method != 'logistic' && method != 'svm') stop(paste('Method', method, 'not implemented'))
  allData <- list()
  # global variable that can be written by classifier
  info <<- NULL
  
  folders <- list.files(dataPath)
  submission <- foreach(ind=1:length(folders),.combine='rbind') %do% {
    folderPath <- getPath(dataPath,folders[ind])
    if(file.info(folderPath)$isdir) {
      dataSet <- loadDataAndExtractFeatures(folderPath, TRUE)
      allData[[ind]] <- dataSet
      if (method == 'logistic'){
        prediction <- trainAndPredictLogistic(dataSet)
      } else if (method == 'svm') {
        prediction <- trainAndPredictSVM(dataSet)
      }
      prediction$submission
    } 
  }
  
  write.csv(submission, file="submission.csv", row.names=FALSE)
  return(list(data=allData,info=info))
}