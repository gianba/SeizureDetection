getCrossCorrelationFeatures <- function(eegData) {
  sample_cc_dist_perc <- c(1,2,4,6,10,15,20,40,70,100)
  nof_CC <- length(sample_cc_dist_perc)
  
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
  ccLength <- length(sortedCC)
  for(n in 1:nof_CC) {
    ind <- round(ccLength * sample_cc_dist_perc[n] / 100)
    features[1,n] <- sortedCC[ind]
    names[n] <- paste('CrossCor',n,sep="")
  }
  features[1,nof_CC+1] <- mean(abs(cc),na.rm=TRUE)
  names[nof_CC+1] <- 'CrossCorMean'
  
  colnames(features) <- names
  return(data.frame(features))  
}