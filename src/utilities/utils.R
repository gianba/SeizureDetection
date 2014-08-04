getPath <- function(path,file) {
  return(paste(path, file, sep='/'))
}

getWorkerPath <- function(path, file) {
  p <- eval(parse(text='workerDataPath'))
  newpath <- sprintf('%s/%s/%s', p, path, file)
  print(sprintf('Path=%s',newpath))
  return(newpath)
}

logMsg <- function(msg) {
  print(paste(Sys.time(), "---", msg))
}