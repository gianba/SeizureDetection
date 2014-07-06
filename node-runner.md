# Node Runner
This scripts adds the current machine to the cluster. The script waits for jobs after launching.

## Usage

```bash
export SEIZURE_DATA_HOME={yourPathTo}/SeizureDetection/data/Volumes/Seagate/seizure_detection/competition_data/clips
./node-runner.R {redis-password}
```
## Environment variables

### SEIZURE_DATA_HOME

``SEIZURE_DATA_HOME`` is where your data is located. As this might be different on every node, you need to specify that. We currently use a environment variable because I couldn't figure out how to lazy load variables in the %dopar% block. Somehow I always get the 
value of the master and not the node specific value. Whith the ``system()`` call it's working.

