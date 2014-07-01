# Extracts the features from the eegClipData
extractFeatures <- function(eegClipData, icaWeights, pcaWeights) {
  NOF_COMPONENTS <- 5
  # Project data into first NOF_COMPONENTS components for ICA and PCA. Components are arranged in rows
  icaData <- t(t(eegClipData-rowMeans(eegClipData)) %*% icaWeights[,1:NOF_COMPONENTS])
  pcaData <- t(t(eegClipData) %*% pcaWeights[,1:NOF_COMPONENTS])

  # Every getXXXFeatures function has to return a data.frame with one row and several columns as features.
  # The columns should be named after the extracted feature.
  # The features can be appended to the returning "features" data.frame using cbind()
  # features <- cbind(getXXXFeatures(...), features)
  features <- getFrequencyFeatures(eegClipData,'SpecRaw')
  features <- cbind(getFrequencyFeatures(icaData,'SpecICA',NOF_COMPONENTS), features)
  features <- cbind(getFrequencyFeatures(pcaData,'SpecPCA',NOF_COMPONENTS), features)
  #features <- cbind(getFractalDimFeatures(eegClipData[c(1,5,9,13),],'Raw'), features)
  #features <- cbind(getFractalDimFeatures(icaData,'ICA'), features)
  #features <- cbind(getFractalDimFeatures(pcaData,'PCA'), features)
  #features <- cbind(getLyapunovFeature(icaData,'ICA'),features)
  #features <- cbind(getLyapunovFeature(pcaData[1:4,],'PCA'),features)
  
  return(features)
}
