# Runs the entire workflow of loading data, extracting features, training classifier and building submission
# The function directly writes a submission.csv file ready for submission to Kaggle
# If transformations.RData containing the ICA and PCA transformation weights is present in
# the working directory, it is loaded and ICA and PCA is not computed. Otherwise PCA and ICA
# are computed and stored in submission.csv.
#
#   !!!  RUN setupWorkEnvironment() FIRST  !!!
#
# Parameters:
#   dataPath:           Path to the folder which contains all the data folders (patients and dogs)
#   method:             Training method
#   existingDataSet:    Optional list of data.frames containing previously computed features and labels for all subjects.
#                       If provided, the extracted features are appended (or overwritten) to this dataset.
#
# Returns list with fields:
#   allData:            A list of data.frames containing the extracted features and labels for every clip of each patient
#   info:               Informations about the classification, features relevance, etc. dependent on the classifier used
runCompetition <- function(dataPath, method='svm', existingDataSet=NULL) {
  PATH_TO_TRANSFORMATIONS <- './transformations.RData'
  if (method != 'logistic' && method != 'svm') stop(paste('Method', method, 'not implemented'))
  allData <- list()
  # global variable that can be written by classifier
  info <<- NULL
  
  # load ICA and PCA transformation matrices if they exist
  transformationsPrecomputed <- file.exists(PATH_TO_TRANSFORMATIONS)
  if(transformationsPrecomputed) {
    logMsg('Using precomputed transformations')  
    transformationsList <- readRDS(file=PATH_TO_TRANSFORMATIONS)
  } else {
    transformationsList <- list()
    transformations <- NULL
  }
  
  folders <- list.files(dataPath)
  submission <- foreach(ind=1:length(folders),.combine='rbind') %do% {
    folder <- folders[ind]
    folderPath <- getPath(dataPath,folder)
    if(file.info(folderPath)$isdir) {
      # if transformations are precomputed, extract the transformation for the given subject
      if(transformationsPrecomputed) {
        transformations <- transformationsList[[folder]]
      }

      # load the data, compute transformations if not given, and extract features
      extractedData <- extractFeaturesForSubject(folderPath=folderPath, loadTestData=TRUE, transformations=transformations)

      # store dataSet (potentially merging it with an existing one) and the transformations (if not previously provided)
      if(is.null(existingDataSet)) {
        finalDataSet <- extractedData$dataSet
      } else {
        finalDataSet <- mergeDataSets(existingDataSet[[folder]],extractedData$dataSet)
      }
      allData[[folder]] <- finalDataSet
      if(!transformationsPrecomputed) {
        transformationsList[[folder]] <- extractedData$transformations
      }
      
      # train classifier and make prediction
      if (method == 'logistic'){
        prediction <- trainAndPredictLogistic(finalDataSet)
      } else if (method == 'svm') {
        prediction <- trainAndPredictSVM(finalDataSet)
      }
      prediction$submission
    } 
  }
  
  # save transformation matrices to file, if they have been calculated
  if(!transformationsPrecomputed){
    saveRDS(transformationsList, file=PATH_TO_TRANSFORMATIONS)
  }
  
  # write submission file
  write.csv(submission, file="submission.csv", row.names=FALSE)
  
  # return all dataSets (with all features and labels) for further process in trainOnly()
  # and return info list, containing evaluations of the classifier
  return(list(data=allData,info=info))
}

mergeDataSets <- function(existingDataSet,extractedDataSet) {
  extractedFeatures <- subset(extractedDataSet,select=-c(label,latency,clipID))
  featureNames <- colnames(extractedFeatures)
  for(f in featureNames) {
    existingDataSet[f] <- extractedFeatures[f]
  }
  return(existingDataSet)
}