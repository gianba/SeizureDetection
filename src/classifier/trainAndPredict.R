trainAndPredict <- function(subjectDataSet, folderPath, method) {
  logMsg(paste('Start training and prediction for subject',folderPath))
  if (method == 'logistic') return(trainAndPredictLogistic(subjectDataSet))
  else if (method == 'svm') return(trainAndPredictSVM(subjectDataSet))
}