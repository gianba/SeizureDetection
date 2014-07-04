getPCAFeatures <- function(eegData) {
  NOF_COMPONENTS <- 4
  pc <- princomp(t(eegData),scores=FALSE)
  totalSD <- sum(pc$sdev)
  
  features <- matrix(nrow=1, ncol=2*NOF_COMPONENTS)
  names <- vector(mode='character', length=2*NOF_COMPONENTS)
  
  for(n in 1:NOF_COMPONENTS) {
    features[1,2*n-1] <- pc$sdev[n]
    names[2*n-1] <- paste('PCATotVarC',n,sep="")
    features[1,2*n] <- pc$sdev[n] / totalSD
    names[2*n] <- paste('PCARelVarC',n,sep="")
  }
  
  colnames(features) <- names
  return(data.frame(features))
}