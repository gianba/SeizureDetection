calculateTransformationWeights <- function(folderPath) {
  logMsg(paste('Calculate transformation weights for subject',folderPath))
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
  a <- fastICA(t(signal), n.comp=8, maxit=5000,tol=1e-05,w.init=diag(8), alg.typ='parallel')
  p <- princomp(t(signal),scores=FALSE)
  return(list(ica=a$K %*% a$W, pca=p$loadings))
}