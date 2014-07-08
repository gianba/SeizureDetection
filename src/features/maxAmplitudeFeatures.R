getMaxAmplitudeChangeFeatures <- function(data, name) {
  NOF_LARGEST_CHANGES <- 4
  nChannel <- dim(data)[1]
  nSamples <- dim(data)[2]
  
  features <- matrix(nrow=1, ncol=nChannel*NOF_LARGEST_CHANGES)
  names <- vector(mode='character', length=nChannel*NOF_LARGEST_CHANGES)
  
  for(c in 1:nChannel) {
    ampChanges <- vector()
    smoothed <- smooth.spline(x=1:nSamples,y=data[c,],spar=0.5)$y
    prevVal <- smoothed[1]
    extVal <- prevVal
    direction <- 1
    for(s in 2:nSamples) {
      if((smoothed[s]-prevVal)*direction > 0) {
        ampChanges <- c(ampChanges, abs(prevVal-extVal))
        extVal <- prevVal
        direction <- -direction
      }
      prevVal <- smoothed[s]
    }
    sortedChanges <- sort(ampChanges, decreasing=TRUE)
    for(l in 1:NOF_LARGEST_CHANGES) {
      features[1,c*3-l+1] <- sortedChanges[l]
      names[c*3-l+1] <- paste('AmpChange',l,name,'C',c,sep="")
    }
  }
  
  colnames(features) <- names
  return(data.frame(features)) 
}