host =  "redis.java-adventures.com"
port = 6379
queue = "test"

initRedis <- function(password) {
  if(is.na(password)) stop("Please provide redis password")
  
  library('doRedis')
  registerDoRedis(host =  host, port = port, queue = queue, password = password )
}
resetRedis <- function() {
  removeQueue(queue)
}
startWorkerAndWait <- function(password) {
  if(is.na(password)) stop("Please provide redis password")
  require('doRedis')
  redisWorker(host =  host, port = port, queue = queue, password = password )
}
startLocalWorker <- function(workerCount, password) {
  if(is.na(password)) stop("Please provide redis password")
  require('doRedis')
  startLocalWorkers(n = workerCount, host =  host, port = port, queue = queue, password = password )
}

calc <- function() {
  p1 <- proc.time()
  Sys.sleep(1)
  print(proc.time() - p1)
  matrix(0,nrow=100,ncol=100)
}

runInParallel <- function() {
  start <- proc.time()
  foreach(bla=1:10, .verbose = TRUE, .export = c('calc')) %dopar% {
    calc()
  }
  print("-------------------")
  print(proc.time() - start)
  print("===================")
}

run <- function() {
  start <- proc.time()
  foreach(bla=1:10) %do% {
    calc()
  }
  print("-------------------")
  print(proc.time() - start)
  print("===================")
}




test <- function() {
  print(sprintf("Available workers: %s", getDoParWorkers()))
  run()
  runInParallel()
}

whoIsOutThere <- function() {
  allnames <- foreach(1:50, .verbose = TRUE) %dopar% {
    eval(parse(text='workerName'))
  }
  uniqueNames <- unique(unlist(allnames))
  print(sprintf('There are %s workers out there.', length(uniqueNames)))
  print(paste(uniqueNames))
  
}


