# Extracts the features from the eegData
extractFeatures <- function(eegData, icaWeights) {
  # calculate ica components
  NOF_COMPONENTS <- 4
  icaData <- t(t(eegData-rowMeans(eegData)) %*% icaWeights[,1:NOF_COMPONENTS])

  # Every getXXXFeatures function has to return a data.frame with one row and several columns as features.
  # The columns should be named after the extracted feature.
  # The features can be appended to the returning "features" data.frame using cbind()
  # features <- cbind(getXXXFeatures(...), features)
  features <- getFrequencyFeatures(eegData,'SpecRaw')
  features <- cbind(getFrequencyFeatures(icaData,'SpecICA',NOF_COMPONENTS), features)
  features <- cbind(getFractalDimFeatures(eegData,'Raw'), features)
  features <- cbind(getFractalDimFeatures(icaData,'ICA',NOF_COMPONENTS), features)
#  features <- cbind(getEntropyFeatures(eegData,'Raw'), features)
#  features <- cbind(getEntropyFeatures(icaData,'ICA',NOF_COMPONENTS), features)
  features <- cbind(getLyapunovFeature(icaData,'ICA'),features)
  
  return(features)
}