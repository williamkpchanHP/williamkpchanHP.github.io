readStockqUrl = function(code, idx){
  urlTail = "_dev.js"
  if(idx == 2){
    urlHead = "https://www.stockq.org/commodity/js/"
  }else if(idx == 3){
    urlHead = "https://www.stockq.org/forex/js/"
    urlTail = "_sma.js"
  }else{
    urlHead = "https://www.stockq.org/index/js/"
  }

  url = paste0(urlHead, code, urlTail)
  cat("\n",url, "\n")
  dataArray = readLines(url)
  indexline = grep("Time', 'Price", dataArray) +1
  dataArray = dataArray[-(1:indexline)]
  indexline = grep("]);", dataArray)
  dataArray = dataArray[-(indexline:length(dataArray))]
  dataArray = gsub("^.*?', ", "", dataArray)
  dataArray = as.numeric(gsub(", .*", "", dataArray))
  return(dataArray)
}
