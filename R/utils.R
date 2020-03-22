message_go = function(x, msg, verbose = TRUE) {
  if (verbose) message(msg)
  return(x)
}
date_seq = function(start, end) {
  if (start==end){
    result = start
  } else {
    result = seq(start, end, by = 1)
  }
  return(result)
}
