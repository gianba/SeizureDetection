setupWorkEnvironment <- function() {
  library('R.matlab')
  library('fastICA')
  library('foreach')
  library('doSNOW')
  library('glmnet')
  library('fractaldim')
  #library('pracma')
  library('fractal')
  
  NUMBER_OF_CORES = 4
  cl <- makeCluster(NUMBER_OF_CORES)
  registerDoSNOW(cl)
}
