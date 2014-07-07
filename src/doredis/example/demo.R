host =  "redis.java-adventures.com"
port = 6379
queue = "test"
password = "kaggle1+"
loadRedis <- function() {
  require('doRedis')
  registerDoRedis(host =  host, port = port, queue = queue, password = password )
}
resetRedis <- function() {
  removeQueue(queue)
}
startWorker <- function() {
  require('doRedis')
  redisWorker(host =  host, port = port, queue = queue, password = password )
}
startLocalWorkert <- function(workerCount) {
  require('doRedis')
  startLocalWorkers(n = workerCound, host =  host, port = port, queue = queue, password = password )
}

calc <- function() {
  p1 <- proc.time()
  Sys.sleep(1)
  print(proc.time() - p1)
  matrix(0,nrow=500,ncol=500)
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


