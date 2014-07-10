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
  tunectr <- tune.control(nrepeat=1,repeat.aggregate=mean)
  
  features <- as.matrix(sFeatureSet)
  tuned <- tune.svm(features[!testInd,], seizure[!testInd], kernel='radial', gamma=c(3^{-6:-3}), cost=c(3^{0:4}), probability=TRUE,tunecontrol=tunectr)
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
    tuned <- tune.svm(features[seizureInd,], as.factor(early[seizureInd]), kernel='radial', gamma=c(3^{-6:-3}), cost=c(3^{-1:3}), probability=TRUE,tunecontrol=tunectr)
    earlyPerf <- tuned$best.performance
    print(paste('Early Perf. =',earlyPerf ,' with gamma:',tuned$best.parameters$gamma,', cost:',tuned$best.parameters$cost))
    fit <- tuned$best.model
    pred <- predict(fit, features[testInd,], probability=TRUE)
    earlyProb <- attr(pred,'probabilities')[,1]
    submission$early <- earlyProb * submission$seizure
  } else {
    # if no early seizure is contained in the training set, use default value
    print(paste('No non-early training samples found. Using',PROB_EARLY_WITHOUT_TRAINING,'* seizure'))
    submission$early <- PROB_EARLY_WITHOUT_TRAINING * submission$seizure
    earlyPerf <- 0
  }
  
  return(list(submission=submission,performance=c(seizurePerf,earlyPerf)))
}