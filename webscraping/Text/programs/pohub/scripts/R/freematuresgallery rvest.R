# try using rvest to scrape shameless
# http://freematuresgallery.com/?page=16  1~16
# article>
# source("retrieveFile.R")

dirStr = "C:/Users/user/mpg/Text/programs/"
setwd(dirStr)
library(rvest)

thesiteword = "freematuresgallery"
urlHead = "http://freematuresgallery.com/?page="
thekeyword = "freematuresgallery"
thenum = 16
theWholePage = character(0)

  retrieveFile <- function(urlAddr){      
    retryCounter = 1
    while(retryCounter < 5) {
      cat("..try ",retryCounter," ") 
      retriveFile <- tryCatch(read_html(urlAddr, warn=F, encoding = "UTF-8"), 
                              warning = function(w){return("code param error")}, 
                              error = function(e) {
                                if(grepl("Error in open.connection", e)){
                                  return("Error in open.connection")
                                }else{
                                  return("code param error")
                                }
                              }
                     )
      if (grepl("code param error", retriveFile)) {
        cat("Error in connection, try 50 secs later!\n")
        retryCounter <- retryCounter + 1
        retriveFile = ""  # if end of loop this will be returned
        Sys.sleep(22)
      }else if(grepl("Error in open.connection", retriveFile)){
        urlAddr = "http://news.rthk.hk/rthk/ch/latest-news.htm" # unable to connect, so use phantom url to bypass
        # return("")
      }else{
        retryCounter = 20000  # to jump out of loop
      }
    }
    return(retriveFile)
  }

	for(i in 10:thenum){
		cat(i,". ")
		pageHeader = paste0(urlHead, i)
		pagesource <- retrieveFile(pageHeader)
		className = "article"
		keywordList <- html_nodes(pagesource, className)
		content = as.character(keywordList)
		theWholePage = c(theWholePage, content)
	}
	sink(paste0(thekeyword,".html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;    color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(theWholePage, sep="\n")
	sink()

startstr="start launcher.exe --start-fullscreen \""
# note to quote the long filename
# note not to use single quote '
shell(paste0(startstr, dirStr, paste0(thekeyword,".html\"")))
