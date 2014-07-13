SeizureDetection
================


### Run from command line
`./terminal-runner <data> <cores>`
- `data` is the folder containing all the data
- `cores` is the number of cores used during feature extraction

Example: `./terminal-runner ../data 4`

### Debugging parallel execution
It is possible to log workers' work by making use of the socket calls defined in the R utils package: `http://stat.ethz.ch/R-manual/R-devel/library/utils/html/00Index.html`

The `write.socket` function is probably non thread-safe, so it is a good idea to split the logs across several ports.

Steps:
- Choose the ports you are gonna use for logging, e.g. `4000` and `4001`
- Spawn as many listeners as ports you chose, e.g. `nc -vv -k -l 4000` and `nc -vv -k -l 4001`
- For every message you want to log, use the following three lines:
  ```
  log.socket <- make.socket(port=sample(4000:4001, 1, replace=T))
  write.socket(log.socket, sprintf(paste0(as.character(Sys.time()), ": ", 'message', "\n")))
  close.socket(log.socket)
  ```
