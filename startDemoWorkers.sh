#!/bin/bash
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

for (( i=0; i<$workersToStart; i++)); do
	echo $i
done
#src/doredis/example/demo.R
