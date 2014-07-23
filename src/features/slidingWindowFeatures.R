getSlidingWindowFeatures <- function(eegData, name) {
  fs <- ncol(eegData)
  window_size <- ceiling(fs/5)
  window_step <- ceiling(window_size/2)
  low_bound <- 1
  high_bound <- window_size
  while(high_bound <= fs) {
    print(paste(low_bound,':',high_bound))
    low_bound <- low_bound + window_step
    high_bound <- high_bound + window_step
  }
  while(low_bound <= fs) {
    print(paste(low_bound,':',fs))
    low_bound <- low_bound + window_step
  }
}
