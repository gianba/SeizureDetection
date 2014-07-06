#!/usr/bin/Rscript
dataHome <- system(command = "echo $SEIZURE_DATA_HOME", intern = T)
print(x = sprintf("SEIZURE_DATA_HOME=%s", dataHome))
if(is.na(dataHome)) stop("No data folder specified. Please set environment variable SEIZURE_DATA_HOME")
if(!file.exists(dataHome)) stop("Specified data folder does not exists")

redisPass=commandArgs(TRUE)[1]
if(is.na(redisPass)) stop("No redis password defined")
#require('doRedis')
library('doRedis')
library('R.matlab')
library('fastICA')
library('foreach')
library('glmnet')
library('tools')
library('fractaldim')
library('fractal')
library('e1071')

redisWorker(host =  "redis.java-adventures.com", port = 6379, queue = "seizure", password = redisPass )