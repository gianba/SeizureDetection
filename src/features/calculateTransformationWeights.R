calculateTransformationWeights <- function(folderPath) {
  signal <- NULL
  files <- list.files(folderPath)
  for(file in files) {
    if(!grepl('_test_', file)) {
      filePath <- getPath(folderPath, file)
      mat <- readMat(filePath)
      nofSamples <- ncol(mat$data)
      if(nofSamples>1000) {
        everyNth <- floor(nofSamples/1000)
        mat$data <- mat$data[,seq(1,nofSamples,everyNth)]
      }
      if(is.null(signal)){
        signal = mat$data
      } else {
        signal = cbind(signal, mat$data)
      }
    }
  }
  a <- fastICA(t(signal), n.comp=16, alg.typ='parallel')
  p <- princomp(t(signal))
  return(list(ica=a$K %*% a$W, pca=p$loadings, original=signal))
}
