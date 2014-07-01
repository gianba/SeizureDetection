getFrequencyFeatures <- function(data, name, nofNonAvgComp=0) {

  freqBounds <- data.frame(min=c(1,4,8,16,32,64),max=c(4,8,16,32,64,100))
  freqSpec <- spectrum(t(data),plot=FALSE)
  meanSpec <- rowMeans(freqSpec$spec)
  meanLogSpec <- log(meanSpec)
  
  nofSamples <- ncol(data)
  nofBounds <- nrow(freqBounds)
  freqs <- freqSpec$freq * nofSamples
  
  nofFeatures <- nofBounds * (nofNonAvgComp+1)
  features <- matrix(nrow=1, ncol=nofFeatures)
  names <- vector(mode='character', length=nofFeatures)
  for(i in 1:nofBounds) {
    containedFreqsInds <- freqBounds$min[i] <= freqs & freqs < freqBounds$max[i]
    if(nofNonAvgComp>0) {
      for(n in 1:nofNonAvgComp) {
        features[1,i*(nofNonAvgComp+1)-n] <- sum(freqSpec$spec[containedFreqsInds,n])/sum(containedFreqsInds)
        names[i*(nofNonAvgComp+1)-n] <- paste(name,'C',n,'B',freqBounds$min[i],sep="")
      }
    }
    features[1,i*(nofNonAvgComp+1)] <- sum(meanLogSpec[containedFreqsInds])/sum(containedFreqsInds)
    names[i*(nofNonAvgComp+1)] <- paste(name,'MeanB',freqBounds$min[i],sep="")
  }
  colnames(features) <- names
  return(data.frame(features))
}
