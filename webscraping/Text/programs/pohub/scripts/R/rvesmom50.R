# use rvest to extract xhamster pages for videos
cat(format(Sys.time(), "%H:%M:%OSs"),"\n")
library(rvest)
library(crayon)
AChoice = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/"
setwd(AChoice)
thefileName = "mom50.html"

#http://mom50.com/index10.shtml
urlHeader = "http://mom50.com/"
urlending = ".shtml"
addr = c("index.shtml", paste0("index", c(2:10),urlending))

className = ".thumb"

#lentocpage = 9
theWholepage = character()
cat("\nurlHeader: ",urlHeader,"\n")
# retrieveFile
  retrieveFile <- function(urlAddr){
    # Sys.sleep(3)
    retryCounter = 1
    while(retryCounter < 5) {
      cat("...try ",retryCounter) 
      retriveFile <- tryCatch(read_html(urlAddr, warn=F, encoding = "UTF-8"), 
                        warning = function(w){
                         cat("code param error ");
                         return("code param error")
                        }, 
                        error = function(e) {
                          if(grepl("Error in open.connection", e)){
                            cat(" Error in open.connection ", urlAddr)
                            return("Error in open.connection")
                          }else if(grepl("Error in doc_parse_raw", e)){
                            cat(" Error in doc_parse_raw ", urlAddr)
                            return(read_html(urlAddr, warn=F))
                          }else{
                            cat("code param error ")
                            return(" code param error ", urlAddr)
                          }
                        }
                     )
      if (grepl("code param error", retriveFile)) {
        cat("Error in connection, try 5 secs later!\n")
        retryCounter <- retryCounter + 1
        retriveFile = ""  # if end of loop this will be returned
      }else if(grepl("Error in open.connection", retriveFile)){
        cat("unable to connect!\n")
        urlAddr = "http://news.rthk.hk/rthk/ch/latest-news.htm" # unable to connect, so use phantom url to bypass
        # return("")
      }else{
        retryCounter = 200  # to jump out of loop
      }
    }
    return(retriveFile)
  }

# cleanup <span
  cleanupspan <- function(msg){
    msg = gsub("<span.*?>|</span>","",msg)
    msg = gsub("<svg*?</svg>","",msg)
    msg = gsub("<div.*?>|</div>","",msg)
    msg = gsub("<p.*?>|</p>","",msg)
  }

cat("\nlentocpage: ",lentocpage,"\n")
for (page in 1:lentocpage){
   cat(" page ", page)
   urlAddr = paste0(urlHeader, addr[page])
   pagesource <- retrieveFile(urlAddr)

   keywordList <- html_nodes(pagesource, className)
   keywordList = as.character(keywordList)
   #writeClipboard(keywordList)
   keywordList = gsub('<a href.*url=', '<a href="', keywordList)
   keywordList = gsub('width.*src', 'class="lazy" data-src', keywordList)
   keywordList = gsub('</div>| alt=""', '', keywordList)

   theWholepage = c(theWholepage, keywordList)
}
#sink(thefileName)
#cat(format(Sys.time(), "%H:%M:%OSs  %a %d %b %Y"),"\n")
#cat(theWholepage, sep="\n")
#sink()
#cat("\n",format(Sys.time(), "%H:%M:%OS"),"\n")
writeClipboard(theWholepage)
cat(red("\n ...to Clipboard\n"))
#startstr="start launcher.exe --start-fullscreen \""
#shell(paste0(startstr, AChoice,"/", paste0(thefileName)))

