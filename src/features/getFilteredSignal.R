getFilteredSignal <- function(eegClipData) {
  fs <- ncol(eegClipData)
  ch <- signal::cheby2(5, 5, 70*2/fs, "low")
  eegClipFileteredData <- data.frame()
  for(row in 1:nrow(eegClipData)) {
    eegClipFileteredData <- rbind(eegClipFileteredData, signal::filter(ch, eegClipData[row,]))
  }
  return(data.matrix(eegClipFileteredData))
}
