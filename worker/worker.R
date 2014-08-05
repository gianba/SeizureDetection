#!/usr/bin/Rscript
main <- function(password, workerDataPath) {
  if(is.na(workerDataPath)) stop("Please define workerDataPath for this worker")
  if(is.na(password)) stop("Please provide the redis password")
  
  host =  "redis.java-adventures.com"
  port = 6379
  queue = "Seizure"
  if(is.na(password)) stop("Please provide redis password")

  library('doRedis')
  print(workerDataPath)
  redisWorker(host =  host, port = port, queue = queue, password = password )
}

workerDataPath=commandArgs(TRUE)[1]

password=commandArgs(TRUE)[2]

main(password = password, workerDataPath = workerDataPath)