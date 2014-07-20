trainAndPredictLogistic <- function(dataSet) {
  PROB_EARLY_WITHOUT_TRAINING = 0.5
  
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
  seizureInd <- seizure == 'ictal'
  seizureInd[is.na(seizure)] <- FALSE
  hasEarlyTrainingSamples <- length(unique(early[seizureInd]))>1
  if(hasEarlyTrainingSamples) {
    fit <- cv.glmnet(features[seizureInd,],early[seizureInd],family='binomial',type.measure="auc")
    earlyAssessment <- accessQuality(fit,'Early',colnames(featureSet))
    earlyProb <- predict(fit, newx=features[testInd,],s='lambda.min',type='response') 
    submission$early <- earlyProb * submission$seizure
  } else {
    # if no early seizure is contained in the training set, use default value
    submission$early <- PROB_EARLY_WITHOUT_TRAINING * submission$seizure
    earlyAssessment <- list(auc=0)
  }
  
  # correct impossible classifications, i.e., if prob. for early is higher than for seizure
#  impossibleInds <- submission$early > submission$seizure
#  submission$early[impossibleInds] <- submission$seizure[impossibleInds]
  
  if(is.null(info)) {
    info <<- list()
    info$seizureFAct <<- seizureAssessment$fAct
    info$seizureFRank <<- seizureAssessment$fRank
    if(hasEarlyTrainingSamples) {
      info$earlyFAct <<- earlyAssessment$fAct
      info$earlyFRank <<- earlyAssessment$fRank
    } else {
      info$earlyFAct <<- seizureAssessment$fAct
      info$earlyFRank <<- seizureAssessment$fRank
    }
  } else {
    info$seizureFAct <<- rbind.fill(info$seizureFAct,seizureAssessment$fAct)
    info$seizureFRank <<- rbind.fill(info$seizureFRank,seizureAssessment$fRank)
    if(hasEarlyTrainingSamples) {
      info$earlyFAct <<- rbind.fill(info$earlyFAct,earlyAssessment$fAct)
      info$earlyFRank <<- rbind.fill(info$earlyFRank,earlyAssessment$fRank)
    } 
  }  
  
  return(list(submission=submission,performance=c(seizureAssessment$auc,earlyAssessment$auc)))
}


accessQuality <- function(fit, classifierName, featureNames) {
  lambdaInd <- match(fit$lambda.min,fit$lambda)
  beta <- fit$glmnet.fit$beta
  AUC <- fit$cvm[lambdaInd]
  logMsg(paste(classifierName,'AUC =',AUC))
  
  fActivation <- data.frame(matrix(abs(beta[,lambdaInd]),nrow=1))
  colnames(fActivation) <- featureNames
  
  firstOcc <- apply(beta,1,FUN=function(x){min(which(abs(x)>0))})
  fRank <- data.frame(matrix(rank(firstOcc),nrow=1))
  colnames(fRank) <- featureNames

  return(list(fAct=fActivation,fRank=fRank,auc=AUC))
}