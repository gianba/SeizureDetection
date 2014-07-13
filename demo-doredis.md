# doRedis demos

## whoIsOutThere?

A simple ``%dopar%`` block that asks for the workers name. A unique list with all workers that responded will be printed out at the end. Note that the worker name is read from a variable on the worker side and is not passed from the master to the worker within the dopar block. So every worker has it's own value of the ``workerName`` variable!

Usage: ./demo-doredis-whoIsOutThere.R {redis-password}

- redis-password: The password for the redis database


Workers are started with the script ``./startDemoWorkers.sh``

## matrix calculation

A ``%dopar%`` block that calls a function for a matrix calclation. No real calculation will be done. The simulated 
calculation time can be specified as well as the result size. The matrix will be filled with zeros.

The trick is to find the balance between number of workers, calculation time and the size of the matrixed that
get sent back over the wire.

Usage: ./demo-doredis-matrix-calculation.R {calculations} {calculation-time} {matrix-size} {redis-password}

- calculations: The amount of matrixes to calculate
- calculation-time: The simulated time it takes to calculate a matrix in seconds
- matrix-size: The size of the resulting matrixes. matrix-size = nrows = ncols, filled with 0
- redis-password: The password for the redis database

## startDemoWorkers.sh

This scripts start max n workers on the current machine. It checks if there are already some running workers around and will 
not start more than the given number of workers.

Usage: ./startDemoWorkers.sh {number-of-workers} {redis-password}

## Redis

``doRedis`` uses Redis as synchronization backend. It stores the jobs (the code from the ``%dopar%`` block) into
the database. Workers will listen for new jobs, run jobs and store the result back into the database. The master collects
the results from redis database.

For this demo we use:

- server: redis.java-adventures.com
- port: 6379
- queue: test

There should only be one master sending jobs to a queue or doRedis will start messing around. A worker can only listen to one queue.