#!/usr/bin/Rscript
password=commandArgs(TRUE)[1]
if(is.na(password)) stop("Please provide the redis password")

source('./src/doredis/example/demo.R')

initRedis(password = password)
whoIsOutThere()
