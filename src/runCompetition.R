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
#   data:               A list of data.frames containing the extracted features and labels for every clip of each patient
#   info:               Informations about the classification, features relevance, etc. dependent on the classifier used
runCompetition <- function(dataPath, method='svm', existingDataSet=NULL) {
  if (method != 'logistic' && method != 'svm') stop(paste('Method', method, 'not implemented'))
  PATH_TO_TRANSFORMATIONS <- './transformations.RData'
  dataSets <- list()
  info <<- NULL
  
  transformationsList <- if(file.exists(PATH_TO_TRANSFORMATIONS)) readRDS(file=PATH_TO_TRANSFORMATIONS) else list()
  folders <- list.files(dataPath)
  submission <- foreach(ind=1:length(folders),.combine='rbind') %do% {
    folder <- folders[ind]
    print(folder)
    folderPath <- getPath(dataPath,folder)
    print(sprintf('folderPath=%s', folderPath))
    if(file.info(folderPath)$isdir) {
      extractedData <- extractFeaturesForSubject(folderPath, TRUE, transformationsList[[folder]])
      subjectDataSet <- if(is.null(existingDataSet)) extractedData$dataSet else mergeDataSets(existingDataSet[[folder]],extractedData$dataSet)
      dataSets[[folder]] <- subjectDataSet
      if(!file.exists(PATH_TO_TRANSFORMATIONS)) transformationsList[[folder]] <- extractedData$transformations
      trainAndPredict(subjectDataSet, folderPath, method)$submission
    }
  }
  
  if(!file.exists(PATH_TO_TRANSFORMATIONS)) saveRDS(transformationsList, file=PATH_TO_TRANSFORMATIONS)  
  write.csv(submission, file="submission.csv", row.names=FALSE)
  return(list(data=dataSets,info=info))
}

mergeDataSets <- function(existingDataSet,extractedDataSet) {
  extractedFeatures <- subset(extractedDataSet,select=-c(label,latency,clipID))
  featureNames <- colnames(extractedFeatures)
  for(f in featureNames) {
    existingDataSet[f] <- extractedFeatures[f]
  }
  return(existingDataSet)
}