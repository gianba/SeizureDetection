# All packages and user defined functions used in the loadFile function (i.e., all 
# feature extraction function, etc. need to be specified here.)
userFunctions <- c('getPath', 'loadFile', 'extractFeatures', 'getFrequencyFeatures')
usedPackages <- c('R.matlab')

# Loads all the data from a folder and extracts the features for each file
# Parameters:
#   folderPath:       path to the folder where the data (.mat files) is located
#   loadTrainingData: flag indicating if test data should be loaded as well
# It returns a data.frame containing 
#   clip ID
#   all features 
#   label ('ictal', 'interictal', NA), where NA represents the test set
#   latency of the seizure, which is NA for all interictal and test clips
loadDataAndExtractFeatures <- function(folderPath, loadTestData) {
  print(paste('Load data and extract features from',folderPath))
  print('Start ICA')
  print(system.time(icaWeights <- calculateICAWeights(folderPath)))
  files <- list.files(folderPath)
  print('Start feature extraction')
  print(system.time(folderData <-foreach(i=1:length(files),.combine='rbind',.packages=usedPackages,.export=userFunctions) %dopar% {
    if(loadTestData | !grepl('_test_', files[i])) {
      filePath <- getPath(folderPath, files[i])
      fileData <- loadFileAndExtractFeatures(filePath, icaWeights)
      fileData$clipID = files[i]
      fileData
    }
  }))
  return(folderData)
}

loadFileAndExtractFeatures <- function(filePath, icaWeights) {
  mat <- readMat(filePath)
  features <- extractFeatures(mat$data, icaWeights)
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

getPath <- function(path,file) {
  return(paste(path, file, sep='//'))
}
