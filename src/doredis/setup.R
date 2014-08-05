redisHost <- "redis.java-adventures.com"
redisPort <- 6379
redisQueue <- "Seizure"


setupDoRedisEnvironment <- function(host =  redisHost, port = redisPort, queue = redisQueue, password) {
  if(is.na(password)) stop("Please provide redis password")
  library('doRedis')
  registerDoRedis(host =  host, port = port, queue = queue, password = password )
}

resetRedis <- function(queue=redisQueue) {
  removeQueue(queue)
}

startWorkerAndWait <- function(host =  redisHost, port = redisPort, queue = redisQueue, password) {
  if(is.na(password)) stop("Please provide redis password")
  require('doRedis')
  redisWorker(host =  host, port = port, queue = queue, password = password )
}
startWorkersAndContinue <- function(workerCount, host =  redisHost, port = redisPort, queue = redisQueue, password) {
  if(is.na(password)) stop("Please provide redis password")
  require('doRedis')
  startLocalWorkers(n = workerCount, host =  host, port = port, queue = queue, password = password )
}

whoIsOutThere <- function() {
  allnames <- foreach(1:50, .verbose = TRUE) %dopar% {
    sprintf("%s_%s", system(command = "hostname", intern = TRUE), Sys.getpid())
  }
  uniqueNames <- sort(unique(unlist(allnames)))
  print(sprintf('There are %s workers out there.', length(uniqueNames)))
  print(paste(uniqueNames))
}