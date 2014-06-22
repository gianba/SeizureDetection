extractFeatures <- function(erpData, icaWeights) {
  icaData <- t(t(erpData-rowMeans(erpData)) %*% icaWeights)
  features <- getFrequencyFeatures(erpData,'SpecRaw')
  features <- cbind(getFrequencyFeatures(icaData,'SpecICA',FALSE), features)
  return(features)
}