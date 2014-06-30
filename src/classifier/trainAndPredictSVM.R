trainAndPredictSVM <- function(dataSet) {
  PROB_EARLY_WITHOUT_TRAINING = 0.5
  
  featureSet <- subset(dataSet,select=-c(label,latency,clipID))
  features <- as.matrix(featureSet)
  seizure <- dataSet$label
  early <- dataSet$latency <= 15
  early[is.na(early)] <- FALSE
  testInd <- is.na(seizure)
  
  submission <- data.frame(clip=dataSet$clipID[testInd])
  
  tuned <- tune.svm(features[!testInd,], seizure[!testInd], kernel='radial', gamma=c(2^{-10:-4}), cost=c(2^{0:4}), probability=TRUE)
  print(paste('Seizure Perf. =',tuned$best.performance,' with gamma:',tuned$best.parameters$gamma,', cost:',tuned$best.parameters$cost))
  fit <- tuned$best.model
  pred <- predict(fit, features[testInd,], probability=TRUE)
  submission$seizure <- attr(pred,'probabilities')[,1]
  
  # predicting probability of early seizure
  seizureInd <- seizure == 'ictal'
  seizureInd[is.na(seizure)] <- FALSE
  hasEarlyTrainingSamples <- length(unique(early[seizureInd]))>1
  if(hasEarlyTrainingSamples) {
    tuned <- tune.svm(features[seizureInd,], as.factor(early[seizureInd]), kernel='radial', gamma=c(2^{-10:-4}), cost=c(2^{0:4}), probability=TRUE)
    print(paste('Early Perf. =',tuned$best.performance,' with gamma:',tuned$best.parameters$gamma,', cost:',tuned$best.parameters$cost))
    fit <- tuned$best.model
    pred <- predict(fit, features[testInd,], probability=TRUE)
    earlyProb <- attr(pred,'probabilities')[,1]
    submission$early <- earlyProb * submission$seizure
  } else {
    # if no early seizure is contained in the training set, use default value
    submission$early <- PROB_EARLY_WITHOUT_TRAINING * submission$seizure
  }
  
  return(submission)
}