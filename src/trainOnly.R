trainOnly <- function(data){ 
  info <<- NULL
  submission <- foreach(ind=1:length(data),.combine='rbind') %do% {
  #submission <- foreach(ind=1:length(data),.combine='rbind',.packages=c('e1071'),.export=c('trainAndPredictSVM')) %dopar% {
    result <- trainAndPredictSVM(data[[ind]])
    result$submission
  } 
  
  write.csv(submission, file="submission.csv", row.names=FALSE)
}