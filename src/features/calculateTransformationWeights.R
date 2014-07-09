calculateTransformationWeights <- function(folderPath) {
  files <- list.files(folderPath, pattern='*ictal*')
  signal <- foreach(i=1:length(files),.combine='cbind',.export=userFunctions) %dopar% {
    file <- files[i]
    filePath <- getPath(folderPath, file)
    mat <- readMat(filePath)
    nofSamples <- ncol(mat$data)
    if(nofSamples>1000) {
      everyNth <- floor(nofSamples/1000)
      mat$data <- mat$data[,seq(1,nofSamples,everyNth)]
    }
    mat$data
  }
  a <- fastICA(t(signal), n.comp=16, alg.typ='parallel')
  p <- princomp(t(signal),scores=FALSE)
  return(list(ica=a$K %*% a$W, pca=p$loadings))
}