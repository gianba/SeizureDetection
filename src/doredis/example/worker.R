#!/usr/bin/Rscript

main <- function(password) {
  host =  "redis.java-adventures.com"
  port = 6379
  queue = "test"
  if(is.na(password)) stop("Please provide redis password")

  library('doRedis')
  redisWorker(host =  host, port = port, queue = queue, password = password )
}

password=commandArgs(TRUE)[1]
main(password = password)