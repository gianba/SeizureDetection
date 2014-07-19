# Loads all the data from a folder and extracts the features for each file
#
# Parameters:
#   folderPath:           Path to the folder where the data (.mat files) of a subject is located
#   loadTestData:         Flag indicating if test data should be loaded as well
#   transformations:      Precalculated ICA/PCA transformations for the current subject
# 
# Returns a list with fields: 
#   dataSet:              Matrix with extracted subject features and labels arranged in rows
#   transformations:      ICA/PCA transformations for the current subject. Same as the input ones if provided.
loadDataAndExtractFeatures <- function(folderPath, loadTestData, transformations) {  
  logMsg(paste('Load data and extract features from',folderPath))  
  
  # compute ICA and PCA transformation matrices, if they are not provided
  transformationsPrecomputed <- !is.null(transformations)
  if(!transformationsPrecomputed) {
    logMsg('Start ICA/PCA weight calculations')
    print(system.time(transformations <- calculateTransformationWeights(folderPath)))
  }
  
  # extract features for each file
  files <- list.files(folderPath)
  logMsg('Start feature extraction')
  print(system.time(folderData <-foreach(i=1:length(files),.combine='rbind',.packages=usedPackages,.export=userFunctions) %dopar% {
    if(loadTestData | !grepl('_test_', files[i])) {
      filePath <- getPath(folderPath, files[i])
      fileData <- loadFileAndExtractFeatures(filePath, transformations$ica, transformations$pca)
      fileData$clipID = files[i]
      fileData
    }
  }))
  
  return(list(dataSet=folderData,transformations=transformations))
}

loadFileAndExtractFeatures <- function(filePath, icaWeights, pcaWeights) {
  mat <- readMat(filePath)
  features <- extractFeatures(mat$data, icaWeights, pcaWeights)
  seizure <- NA
  lat <- NA
  if(grepl('_ictal_', filePath)) {
    seizure <- "ictal"
    lat <- mat$latency
  } else if(grepl('_interictal_', filePath)) {
    seizure <- "interictal"
  }
  extractedData <- data.frame(features,label=factor(seizure,levels=c('ictal','interictal',NA),exclude=NULL),latency=lat)
  return(extractedData)
}