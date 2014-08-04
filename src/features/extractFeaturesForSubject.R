# Loads all the data from a folder and extracts the features for each file
#
# Parameters:
#   folderPath:           Path to the folder where the data (.mat files) of a subject is located
#   loadTestData:         Flag indicating if test data should be loaded as well
#   transformations:      Precalculated ICA/PCA transformations for the current subject
# 
# Returns a list with fields: 
#   dataSet:              Matrix with extracted subject features and labels arranged in rows
#   transformations:      ICA/PCA transformations used for the current subject. Same as the input ones if provided.
extractFeaturesForSubject <- function(folderPath, loadTestData, transformations) {  
  logMsg(sprintf('extractFeaturesForSubject. folderPath=%s', folderPath))
  if(is.null(transformations)) print(system.time(transformations <- calculateTransformationWeights(folderPath)))
  logMsg(paste('Extract features from subject',folderPath))
  files <- list.files(folderPath)
  tokens <- strsplit(folderPath, '/')[[1]]
  dir <- tokens[length(tokens)]
  print(system.time(folderData <-foreach(i=1:length(files),.combine='rbind',.packages=usedPackages,.export=userFunctions) %dopar% {
    if(loadTestData | !grepl('_test_', files[i])) {
      extractFeaturesForClip(getWorkerPath(dir,files[i]), transformations)
    }
  }))
  
  return(list(dataSet=folderData,transformations=transformations))
}

extractFeaturesForClip <- function(filePath, transformations) {
  print('readmat')
  mat <- readMat(filePath)
  print('extractFeatures')
  features <- extractFeatures(mat$data, transformations$ica, transformations$pca)
  print('grepl')
  lat <- if(grepl('_ictal_', filePath)) mat$latency else NA
  seizure <- NA
  if(grepl('_ictal_', filePath)) seizure <- "ictal"
  else if(grepl('_interictal_', filePath)) seizure <- "interictal"
  return(data.frame(features,label=factor(seizure,levels=c('ictal','interictal',NA),exclude=NULL),latency=lat,clipID=basename(filePath)))
}