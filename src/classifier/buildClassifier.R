buildClassifier <- function(dataSet) {
  PROB_EARLY_WITHOUT_TRAINING = 0.05
  
  features <- as.matrix(subset(dataSet,select=-c(label,latency,clipID)))
  seizure <- dataSet$label
  early <- dataSet$latency <= 15
  early[is.na(early)] <- FALSE
  testInd <- is.na(seizure)
  
  submission <- data.frame(clip=dataSet$clipID[testInd])
  
  fit <- cv.glmnet(features[!testInd,],seizure[!testInd],family='binomial')#,type.measure="class")
  #plot(fit)
  submission$seizure <- 1-predict(fit, newx=features[testInd,],s='lambda.min',type='response')
  
  if(length(unique(early[!testInd]))>1) {
    fit <- cv.glmnet(features[!testInd,],early[!testInd],family='binomial')#,type.measure="class")
    submission$early <- predict(fit, newx=features[testInd,],s='lambda.min',type='response')
  } else {
    submission$early <- PROB_EARLY_WITHOUT_TRAINING
  }
  
  return(submission)
}