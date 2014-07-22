#!/usr/bin/Rscript
calculations=as.numeric(commandArgs(TRUE)[1])
calculationTime=as.numeric(commandArgs(TRUE)[2])
matrixSize=as.numeric(commandArgs(TRUE)[3])
password=commandArgs(TRUE)[4]

if(is.na(calculations)) stop("Please provide the calculations count. e.g. 10")
if(is.na(calculationTime)) stop("Please provide the calculationTimeSeconds (Simulated calculation time for calculating one matrix) e.g. 1") 
if(is.na(matrixSize)) stop("Please provide the matrixSize (The size of the resulting matrix that will be sent back over the wire. matrixSize x matrixSize) e.g. 100")
if(is.na(password)) stop("Please provide the redis password")

source('./src/logMsg.R')
source('./src/doredis/example/demo.R')

logMsg(sprintf('calculations=%s, calculationTime=%s, matrixSize=%s', class(calculations), class(calculationTime), class(matrixSize)))
logMsg(sprintf('calculations=%s, calculationTime=%s, matrixSize=%s', calculations, calculationTime, matrixSize))

initRedis(password = password)
resetRedis()
runInParallel(calculations = calculations, matrixSize = matrixSize, calculationTime = calculationTime)
