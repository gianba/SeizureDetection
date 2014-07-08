trainAndPredictSVM <- function(dataSet, sFeatInds=NULL, eFeatInds=NULL) {
  PROB_EARLY_WITHOUT_TRAINING = 0.5
  
  featureSet <- subset(dataSet,select=-c(label,latency,clipID))
  if(is.null(sFeatInds)) {
    sFeatureSet <- featureSet
  } else {
    sFeatureSet <- featureSet[,sFeatInds]
  }
  if(is.null(eFeatInds)) {
    eFeatureSet <- featureSet
  } else {
    eFeatureSet <- featureSet[,eFeatInds]
  }
  
  seizure <- dataSet$label
  early <- dataSet$latency <= 15
  early[is.na(early)] <- FALSE
  testInd <- is.na(seizure)
  
  submission <- data.frame(clip=dataSet$clipID[testInd])
  
  features <- as.matrix(sFeatureSet)
  tuned <- tune.svm(features[!testInd,], seizure[!testInd], kernel='radial', gamma=c(2^{-10:-3}), cost=c(2^{0:5}), probability=TRUE)
  seizurePerf <- tuned$best.performance
  print(paste('Seizure Perf. =',seizurePerf,' with gamma:',tuned$best.parameters$gamma,', cost:',tuned$best.parameters$cost))
  fit <- tuned$best.model
  pred <- predict(fit, features[testInd,], probability=TRUE)
  submission$seizure <- attr(pred,'probabilities')[,1]
  
  # predicting probability of early seizure
  seizureInd <- seizure == 'ictal'
  seizureInd[is.na(seizure)] <- FALSE
  hasEarlyTrainingSamples <- length(unique(early[seizureInd]))>1
  if(hasEarlyTrainingSamples) {
    features <- as.matrix(eFeatureSet)
    tuned <- tune.svm(features[seizureInd,], as.factor(early[seizureInd]), kernel='radial', gamma=c(2^{-9:-2}), cost=c(2^{-1:4}), probability=TRUE)
    earlyPerf <- tuned$best.performance
    print(paste('Early Perf. =',earlyPerf ,' with gamma:',tuned$best.parameters$gamma,', cost:',tuned$best.parameters$cost))
    fit <- tuned$best.model
    pred <- predict(fit, features[testInd,], probability=TRUE)
    earlyProb <- attr(pred,'probabilities')[,1]
    submission$early <- earlyProb * submission$seizure
  } else {
    # if no early seizure is contained in the training set, use default value
    submission$early <- PROB_EARLY_WITHOUT_TRAINING * submission$seizure
    earlyPerf <- 0
  }
  
  return(list(submission=submission,performance=c(seizurePerf,earlyPerf)))
}