getCrossCorrelationFeatures <- function(eegData) {
  selected_top_cc <- c(1,5,25,120)
  nof_CC <- length(selected_top_cc)
  
  features <- matrix(nrow=1, ncol=nof_CC+1)
  names <- vector(mode='character', length=nof_CC+1)
  nChannel <- dim(eegData)[1]
  cc <- matrix(nrow=nChannel-1,ncol=nChannel-1)
  
   for(i in 1:(nChannel-1)){
     for(j in (i+1):nChannel){
       cc[i,j-1] <- ccf(eegData[i,],eegData[j,],lag.max=0,plot=FALSE)$acf[1]
     }
   }
  sortedCC <- sort(abs(cc), decreasing=TRUE)
  for(n in 1:nof_CC) {
    features[1,n] <- sortedCC[selected_top_cc[n]]
    names[n] <- paste('CrossCor',n,sep="")
  }
  features[1,nof_CC+1] <- mean(abs(cc),na.rm=TRUE)
  names[nof_CC+1] <- 'CrossCorMean'
  
  colnames(features) <- names
  return(data.frame(features))  
}