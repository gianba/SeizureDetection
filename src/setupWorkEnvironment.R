setupWorkEnvironment <- function(createCluster = TRUE) {
  library('R.matlab')
  library('fastICA')
  library('foreach')
  library('doSNOW')
  library('glmnet')
  library('tools')
  library('fractaldim')
  library('fractal')
  library('e1071')

  if (createCluster) {
    NUMBER_OF_CORES = 4
    cl <- makeCluster(NUMBER_OF_CORES)
    registerDoSNOW(cl)
  }
}
