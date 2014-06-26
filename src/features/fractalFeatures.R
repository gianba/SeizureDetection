getFractalDimFeatures <- function(eegData, name, nofNonAvgComp=0) {

  fracDim <-apply(eegData, 1, FUN=function(x){fracDim <- fd.estimate(x); c(fracDim$fd,fracDim$scale)})
  
  features <- matrix(nrow=1, ncol=2*(nofNonAvgComp+1))
  names <- vector(mode='character', length=2*(nofNonAvgComp+1))
  
  if(nofNonAvgComp>0) {
    for(n in 1:nofNonAvgComp) {
      features[1,2*(nofNonAvgComp+1-n)+1] <- fracDim[1,n]
      names[2*(nofNonAvgComp+1-n)+1] <- paste(name,'FracDimC',n,sep="")
      features[1,2*(nofNonAvgComp+1-n)+2] <- fracDim[2,n]
      names[2*(nofNonAvgComp+1-n)+2] <- paste(name,'FracScaleC',n,sep="")
    }
  }
  features[1,1] <- mean(fracDim[1,])
  names[1] <- paste(name,'FracDimMean',sep="")
  features[1,2] <- mean(fracDim[2,])
  names[2] <- paste(name,'FracScaleMean',sep="")
  
  colnames(features) <- names
  return(data.frame(features))
}