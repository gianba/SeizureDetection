calculateTransformationWeights <- function(folderPath) {
  files <- list.files(folderPath, pattern='*ictal*')
  signal <- foreach(i=1:length(files),.combine='cbind',.packages=usedPackages,.export=userFunctions) %dopar% {
    mat <- readMat(getPath(folderPath, files[i]))
    nofSamples <- ncol(mat$data)
    if(nofSamples>1000) {
      everyNth <- floor(nofSamples/1000)
      mat$data <- mat$data[,seq(1,nofSamples,everyNth)]
    }
    mat$data
  }
  a <- fastICA(t(signal), n.comp=16, alg.typ='parallel')
  p <- princomp(t(signal),scores=FALSE)
  sdev_limit <- sum(p$sdev)*0.8
  n_components <- 1
  while (sum(p$sdev[1:n_components]) < sdev_limit) n_components <- n_components + 1
  return(list(ica=a$K %*% a$W, pca=p$loadings, n_components=n_components))
}
