getEntropyFeatures <- function(eegData,name){
    
  nofComponents <- dim(eegData)[1]
  features <- matrix(nrow=1, ncol=nofComponents)
  names <- vector(mode='character', length=nofComponents)
  
  for(i in 1:nofComponents){
    features[1,i] <- approx_entropy(eegData[i,])  
    names[i] <- paste(name,'SampEntrC',i,sep="")
  }
  
  colnames(features) <- names
  return(data.frame(features))
}