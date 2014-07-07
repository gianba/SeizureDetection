# Extracts the features from the eegData
extractFeatures <- function(eegData, icaWeights, pcaWeights) {
  # calculate ica components
  NOF_ICA_COMPONENTS <- 6
  NOF_PCA_COMPONENTS <- 5
  icaData <- t(t(eegData-rowMeans(eegData)) %*% icaWeights[,1:NOF_ICA_COMPONENTS])
  pcaData <- t(t(eegData) %*% pcaWeights[,1:NOF_PCA_COMPONENTS])

  # Every getXXXFeatures function has to return a data.frame with one row and several columns as features.
  # The columns should be named after the extracted feature.
  # The features can be appended to the returning "features" data.frame using cbind()
  # features <- cbind(getXXXFeatures(...), features)
  features <- getFrequencyFeatures(eegData,'SpecRaw')
  features <- cbind(getFrequencyFeatures(icaData,'SpecICA',NOF_ICA_COMPONENTS), features)
  features <- cbind(getFrequencyFeatures(pcaData,'SpecPCA',NOF_PCA_COMPONENTS), features)
  features <- cbind(getFractalDimFeatures(eegData[c(1,5,9,13),],'Raw'), features)
  features <- cbind(getFractalDimFeatures(icaData,'ICA'), features)
  features <- cbind(getFractalDimFeatures(pcaData,'PCA'), features)
  features <- cbind(getLyapunovFeature(icaData,'ICA'),features)
  features <- cbind(getLyapunovFeature(pcaData[1:4,],'PCA'),features)
  features <- cbind(getPCAFeatures(eegData),features)
  features <- cbind(getCrossCorrelationFeatures(eegData),features)
#  features <- cbind(getMaxStepFeatures(eegData),features)
#  features <- cbind(getMaxStepFeatures(pcaData),features)
  
  return(features)
}