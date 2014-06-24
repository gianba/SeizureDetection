runCompetition <- function(dataPath) {
  allData <- list()
  
  folders <- list.files(dataPath)
  submission <- foreach(ind=1:length(folders),.combine='rbind') %do% {
    folderPath <- getPath(dataPath,folders[ind])
    if(file.info(folderPath)$isdir) {
      dataSet <- loadData(folderPath, TRUE)
      allData[[ind]] <- dataSet
      buildClassifier(dataSet)
    } 
  }
  
  write.csv(submission, file="submission.csv", row.names=FALSE)
  return(allData)
}