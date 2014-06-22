getFrequencyFeatures <- function(erpData, name, avgOnly=TRUE) {
  firstNComp <- 4
  if(avgOnly) {
    firstNComp <- 0
  }
  freqBounds <- data.frame(min=c(1,4,8,16,32),max=c(4,8,16,32,64))
  freqSpec <- spectrum(t(erpData),plot=FALSE)
  meanSpec <- rowMeans(freqSpec$spec)
  meanLogSpec <- log(meanSpec)
  
  nofSamples <- ncol(erpData)
  nofBounds <- nrow(freqBounds)
  freqs <- freqSpec$freq * nofSamples
    
  features <- matrix(nrow=1, ncol=nofBounds * (firstNComp+1))
  names <- vector(mode='character', length=nofBounds * (firstNComp+1))
  for(i in 1:nofBounds) {
    containedFreqsInds <- freqBounds$min[i] <= freqs & freqs < freqBounds$max[i]
    if(!avgOnly) {
      for(n in 1:firstNComp) {
        features[1,i*(firstNComp+1)-n] <- sum(freqSpec$spec[containedFreqsInds,n])/sum(containedFreqsInds)
        names[i*(firstNComp+1)-n] <- paste(name,'C',n,'B',freqBounds$min[i],sep="")
      }
    }
    features[1,i*(firstNComp+1)] <- sum(meanLogSpec[containedFreqsInds])/sum(containedFreqsInds)
    names[i*(firstNComp+1)] <- paste(name,'MeanB',freqBounds$min[i],sep="")
  }
  colnames(features) <- names
  return(data.frame(features))
}