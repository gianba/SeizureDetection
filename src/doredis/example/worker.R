#!/usr/bin/Rscript
host =  "redis.java-adventures.com"
port = 6379
queue = "test"
password = "kaggle1+"

startWorker <- function() {
  library('doRedis')
  redisWorker(host =  host, port = port, queue = queue, password = password )
}

startWorker()