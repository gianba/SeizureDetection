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
runCompetition <- function(dataPath) {
  PATH_TO_TRANSFORMATIONS <- './transformations.RData'
  allData <- list()
  # global variable that can be written by classifier
  info <<- NULL
  
  # load ICA and PCA transformation matrices if they exist
  transformationsPrecomputed <- file.exists(PATH_TO_TRANSFORMATIONS)
  if(transformationsPrecomputed) {
    transformationsList <- load(PATH_TO_TRANSFORMATIONS)
  } else {
    transformationsList <- list()
    transformations <- NULL
  }
  
  folders <- list.files(dataPath)
  submission <- foreach(ind=1:length(folders),.combine='rbind') %do% {
    folderPath <- getPath(dataPath,folders[ind])
    if(file.info(folderPath)$isdir) {
      # if transformations are precomputed, extract the transformation for the given subject
      if(transformationsPrecomputed) {
        transformations <- transformationsList[folders[ind]]
      }
      # load the data, compute transformations if not given, and extract features
      extractedData <- loadDataAndExtractFeatures(folderPath, TRUE, transformations)
      
      # store dataSet (with all features and labels) and the transformations, 
      # if they have not been loaded from the file
      allData[[ind]] <- extractedData$dataSet
      if(!transformationsPrecomputed) {
        transformationsList[folders[ind]] <- extractedData$transformations
      }
      
      # train classifier and make prediction
      prediction <- trainAndPredictLogistic(extractedData$dataSet)
      prediction$submission
    } 
  }
  
  # save transformation matrices to file, if they have been calculated
  if(!transformationsPrecomputed){
    save(transformationsList, PATH_TO_TRANSFORMATIONS)
  }
  
  # write submission file
  write.csv(submission, file="submission.csv", row.names=FALSE)
  
  # return all dataSets (with all features and labels) for further process in trainOnly()
  # and return info list, containing evaluations of the classifier
  return(list(data=allData,info=info))
}