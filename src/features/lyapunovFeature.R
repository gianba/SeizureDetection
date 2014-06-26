getLyapunovFeature <- function(eegData,name){
  lyapunov <-lyapunov(eegData,scale=c(16))
  firstExp <- mean(lyapunov[[1]][[1]])
  result <- data.frame(firstExp)
  colnames(result) <- paste(name,'Lyapunov')
  return(result)
}