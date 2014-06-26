trainAndPredictLogistic <- function(dataSet) {
  PROB_EARLY_WITHOUT_TRAINING = 0.3
  
  featureSet <- subset(dataSet,select=-c(label,latency,clipID))
  features <- as.matrix(featureSet)
  seizure <- dataSet$label
  early <- dataSet$latency <= 15
  early[is.na(early)] <- FALSE
  testInd <- is.na(seizure)
  
  submission <- data.frame(clip=dataSet$clipID[testInd])
  
  # predicting probability of seizure
  fit <- cv.glmnet(features[!testInd,],seizure[!testInd],family='binomial',type.measure="auc")
  seizureAssessment <- accessQuality(fit,'Seizure',colnames(featureSet))
  submission$seizure <- 1-predict(fit, newx=features[testInd,],s='lambda.min',type='response')
  
  # predicting probability of early seizure
  hasEarlyTrainingSamples <- length(unique(early[!testInd]))>1
  if(hasEarlyTrainingSamples) {
    fit <- cv.glmnet(features[!testInd,],early[!testInd],family='binomial',type.measure="auc")
    earlyAssessment <- accessQuality(fit,'Early',colnames(featureSet))
    submission$early <- predict(fit, newx=features[testInd,],s='lambda.min',type='response')
  } else {
    # if no early seizure is contained in the training set, use default value
    submission$early <- PROB_EARLY_WITHOUT_TRAINING * submission$seizure
  }
  
  # correct impossible classifications, i.e., if prob. for early is higher than for seizure
  impossibleInds <- submission$early > submission$seizure
  submission$early[impossibleInds] <- submission$seizure[impossibleInds]
  
  if(is.null(info)) {
    info <<- list()
    info$seizureFAct <<- seizureAssessment$fAct
    info$seizureFRank <<- seizureAssessment$fRank
    info$earlyFAct <<- earlyAssessment$fAct
    info$earlyFRank <<- earlyAssessment$fRank
  } else {
    info$seizureFAct <<- rbind(info$seizureFAct,seizureAssessment$fAct)
    info$seizureFRank <<- rbind(info$seizureFRank,seizureAssessment$fRank)
    if(hasEarlyTrainingSamples) {
      info$earlyFAct <<- rbind(info$earlyFAct,earlyAssessment$fAct)
      info$earlyFRank <<- rbind(info$earlyFRank,earlyAssessment$fRank)
    }
  }  
  
  return(submission)
}


accessQuality <- function(fit, classifierName, featureNames) {
  lambdaInd <- match(fit$lambda.min,fit$lambda)
  beta <- fit$glmnet.fit$beta
  print(paste(classifierName,'AUC =',fit$cvm[lambdaInd]))
  
  fActivation <- data.frame(matrix(abs(beta[,lambdaInd]),nrow=1))
  colnames(fActivation) <- featureNames
  
  firstOcc <- apply(beta,1,FUN=function(x){min(which(abs(x)>0))})
  fRank <- data.frame(matrix(rank(firstOcc),nrow=1))
  colnames(fRank) <- featureNames

  return(list(fAct=fActivation,fRank=fRank))
}