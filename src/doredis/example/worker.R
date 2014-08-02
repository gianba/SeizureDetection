#!/usr/bin/Rscript

main <- function(password) {
  host =  "redis.java-adventures.com"
  port = 6379
  queue = "test"
  if(is.na(password)) stop("Please provide redis password")

  library('doRedis')
  redisWorker(host =  host, port = port, queue = queue, password = password )
}

workerName=commandArgs(TRUE)[1]
if(is.na(workerName)) stop("Please define a name for this workder")

password=commandArgs(TRUE)[2]
if(is.na(password)) stop("Please provide the redis password")
main(password = password)