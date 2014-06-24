# Extracts the features from the eegData
extractFeatures <- function(eegData, icaWeights) {
  # calculate ica components
  icaData <- t(t(erpData-rowMeans(eegData)) %*% icaWeights)

  # Every getXXXFeatures function has to return a data.frame with one row and several columns as features.
  # The columns should be named after the extracted feature.
  # The features can be appended to the returning "features" data.frame using cbind()
  # features <- cbind(getXXXFeatures(...), features)
  features <- getFrequencyFeatures(eegData,'SpecRaw')
  features <- cbind(getFrequencyFeatures(icaData,'SpecICA',FALSE), features)
    
  return(features)
}