getPath <- function(path,file) {
  return(paste(path, file, sep='//'))
}

logMsg <- function(msg) {
  print(paste(Sys.time(), "---", msg))
}