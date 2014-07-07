setupWorkEnvironment <- function(createCluster = TRUE, dir = getwd()) {
  library('R.matlab')
  library('fastICA')
  library('foreach')
  library('doSNOW')
  library('glmnet')
  library('tools')
  library('fractaldim')
  library('fractal')
  library('e1071')

  sourceDir(sprintf('%s/src', dir))
  
  if (createCluster) {
    NUMBER_OF_CORES = 4
    cl <- makeCluster(NUMBER_OF_CORES)
    registerDoSNOW(cl)
  }
}

sourceDir <- function(dir) {
  for (f in list.files(dir, pattern=".+.R$", recursive=TRUE, full.names=TRUE)) {
    print(paste("---> Sourcing", f))
    source(f)
  }
}

