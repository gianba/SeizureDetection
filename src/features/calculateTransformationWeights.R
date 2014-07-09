calculateTransformationWeights <- function(folderPath) {
  files <- list.files(folderPath, pattern='*ictal*')
  filteredClips <- hash()
  logMsg('Filter and join clips')
  signal <- foreach(i=1:length(files),.combine='cbind',.packages=usedPackages,.export=userFunctions) %dopar% {
    file <- files[i]
    filePath <- getPath(folderPath, file)
    mat <- readMat(filePath)
    nofSamples <- ncol(mat$data)
    if(nofSamples>1000) {
      everyNth <- floor(nofSamples/1000)
      mat$data <- mat$data[,seq(1,nofSamples,everyNth)]
    }
    filteredClip <- getFilteredSignal(mat$data)
    filteredClips$file = filteredClip
    filteredClip
  }
  logMsg('Calculate ICA weights')
  a <- fastICA(t(signal), n.comp=16, alg.typ='parallel')
  logMsg('Calculate PCA weights')
  p <- princomp(t(signal))
  return(list(ica=a$K %*% a$W, pca=p$loadings, original=signal, filteredClips=filteredClips))
}
