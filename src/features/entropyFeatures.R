getEntropyFeatures <- function(eegData, name, nofNonAvgComp=0) {
  
  fracDim <-apply(eegData, 1, FUN=function(x){sample_entropy(x)})
  
  features <- matrix(nrow=1, ncol=nofNonAvgComp+1)
  names <- vector(mode='character', length=nofNonAvgComp+1)
  
  if(nofNonAvgComp>0) {
    for(n in 1:nofNonAvgComp) {
      features[1,nofNonAvgComp+2-n] <- fracDim[n]
      names[nofNonAvgComp+2-n] <- paste(name,'SampEntrC',n,sep="")
    }
  }
  features[1,1] <- mean(fracDim)
  names[1] <- paste(name,'SampleEntrMean',sep="")
  
  colnames(features) <- names
  return(data.frame(features))
}