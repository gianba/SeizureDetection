getFractalDimFeatures <- function(eegData, name) {

  nofComponents <- dim(eegData)[1]
  fracDim <-apply(eegData, 1, FUN=function(x){fracDim <- fd.estimate(x); c(fracDim$fd,fracDim$scale)})
  
  features <- matrix(nrow=1, ncol=2*nofComponents)
  names <- vector(mode='character', length=2*nofComponents)
  
  for(n in 1:nofComponents) {
    features[1,2*n-1] <- fracDim[1,n]
    names[2*n-1] <- paste(name,'FracDimC',n,sep="")
    features[1,2*n] <- fracDim[2,n]
    names[2*n] <- paste(name,'FracScaleC',n,sep="")
  }
  
  features[1,is.na(features[1,])] <- 0
  colnames(features) <- names
  return(data.frame(features))
}