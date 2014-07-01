getLyapunovFeature <- function(eegData,name){
  
  lyapunov <- list()
  dataDim <- dim(eegData)
  nofSamples <- dataDim[2]
  nofComponents <- dataDim[1]
  dimension <- 4 #round(log(nofSamples)/1.7)
  for(i in 1:nofComponents) {
    scale <- 16# min(round(30/i), 12)
    lyapunov[[i]] <- lyapunov(eegData[i,],dimension=dimension,scale=scale)
  }
  
  features <- matrix(nrow=1, ncol=nofComponents)
  names <- vector(mode='character', length=nofComponents)
  
  for(n in 1:nofComponents) {
    features[1,n] <- mean(lyapunov[[n]][[1]][[1]])
    names[n] <- paste(name,'LyapunovC',n,sep="")
  }
  
  colnames(features) <- names
  return(data.frame(features))
}