#!/bin/bash
# Script to start worker nodes of the Redis example. Run it every minute as a cron job to
# ensure that your workers are still up and running.
#
# Usage: ./startDemoWorkers.sh {number-of-workers} {redis-password}
#
#
FQN=$(readlink -f $0)
DIR_NAME=$(dirname $FQN)

numberOfWorkers="$1"
redisPassword="$2"

if [[ -z "$numberOfWorkers" ]]; then
	echo "number-of-workers not defined"
	exit 1
fi
if [[ -z "$redisPassword" ]]; then
        echo "redis-password not defined"
        exit 1
fi

currentWorkers=$(ps -all | grep -v -e "grep" | grep R$ | wc -l)
echo "currentWorkers=$currentWorkers"
workersToStart=$(( $numberOfWorkers - $currentWorkers ))
echo "workersToStart=$workersToStart"
name=$(hostname)

startTime=$(date +%Y-%m-%d_%H%M)
for (( i=0; i<$workersToStart; i++)); do
	workerName="${name}_${i}_${startTime}"
	logFile=$(readlink -f "${workerName}.log")
	echo "Starting: $workerName. Logfile=$logFile"
	nohup 'src/doredis/example/worker.R' "$workerName" "$redisPassword" &> $logFile &
done
#src/doredis/example/demo.R
