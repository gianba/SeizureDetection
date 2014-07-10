getMaxStepFeatures <- function(eegData, name) {
  time_intervals_ms <- c(5,10,20)
  nofTimeIntervals <- length(time_intervals_ms)
  nChannel <- dim(eegData)[1]
  nSamples <- dim(eegData)[2]
  
  features <- matrix(nrow=1, ncol=nofTimeIntervals)
  names <- vector(mode='character', length=nofTimeIntervals)
  
  for(i in 1:nofTimeIntervals) {
    dataShift <- round(nSamples*time_intervals_ms[i]/1000)
    noShiftData <- cbind(eegData, matrix(0,nrow=nChannel,ncol=dataShift))
    shiftData <- cbind(matrix(0,nrow=nChannel,ncol=dataShift),eegData)
    steps <- shiftData - noShiftData
    validSteps <- abs(steps[,(1+dataShift):(nSamples-dataShift)])
    features[1,i] <- max(validSteps)
    names[i] <- paste('MaxStep',name,time_intervals_ms[i],'ms',sep="")
#    features[1,i*3-1] <- max(validSteps[,1:round((nSamples-2*dataShift)/3)])
#    names[i*3-1] <- paste('MaxStepEarly',name,time_intervals_ms[i],'ms',sep="")
#    features[1,i*3] <- max(validSteps[,round(2*(nSamples-2*dataShift)/3):(nSamples-2*dataShift)])
#    names[i*3] <- paste('MaxStepLate',name,time_intervals_ms[i],'ms',sep="")
  }
  
  colnames(features) <- names
  return(data.frame(features)) 
}