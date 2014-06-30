trainOnly <- function(data){ 
  info <<- NULL
  submission <- foreach(ind=1:length(data),.combine='rbind') %do% {
    trainAndPredictSVM(data[[ind]])
  } 
  
  write.csv(submission, file="submission.csv", row.names=FALSE)
}