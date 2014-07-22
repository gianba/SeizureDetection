#!/usr/bin/Rscript
workerDataPath <- '/home/celli/sources/git/SeizureDetection/data/mini'
main <- function(password) {
  if(is.na(workerName)) stop("Please define a name for this worker")
  if(is.na(password)) stop("Please provide the redis password")
  
  host =  "redis.java-adventures.com"
  port = 6379
  queue = "Seizure"
  if(is.na(password)) stop("Please provide redis password")

  library('doRedis')
  print(workerDataPath)
  redisWorker(host =  host, port = port, queue = queue, password = password )
}

workerName=commandArgs(TRUE)[1]

password=commandArgs(TRUE)[2]

main(password = password)