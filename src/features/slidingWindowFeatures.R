getSlidingWindowFeatures <- function(eegData, name, windows) {
  signalMeans <- colMeans(eegData)
  
  means <- lapply(windows, function(w) mean(signalMeans[w[1]:w[2]]))
  names(means) <- paste0(name,'Mean',names(means))
  
  max <- lapply(windows, function(w) max(signalMeans[w[1]:w[2]]))
  names(max) <- paste0(name,'Max',names(max))
  
  min <- lapply(windows, function(w) min(signalMeans[w[1]:w[2]]))
  names(min) <- paste0(name,'Min',names(min))
  
  return(data.frame(append(append(means,max),min)))
}

getWindows <- function(samples) {
  window_size <- samples/10
  window_step <- window_size/2
  windows <- list()
  low_bound <- 1
  high_bound <- window_size
  while (high_bound <= samples) {
    windows[[paste0(low_bound,':',high_bound)]] <- c(low_bound,high_bound)
    low_bound <- low_bound + window_step
    high_bound <- high_bound + window_step
  }
  return(windows)
}
