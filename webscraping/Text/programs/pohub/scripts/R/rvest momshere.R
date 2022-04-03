# use rvest to extract xhamster pages for photos

cat(format(Sys.time(), "%H:%M:%OSs"),"\n")

library(rvest)
AChoice = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/R"
setwd(AChoice)
textHeader = readLines("composeListHeader.txt")
textTailer = readLines("composeListTailer.txt")

AChoice = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/"
setwd(AChoice)

thefileName = "momshereTOC.html"
urlHeader = "http://www.momshere.com/st/archives/archive"
urlTail = ".shtml"
lentocpage = 19
theWholepage = ""

# retrieveFile
  retrieveFile <- function(urlAddr){
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
                            cat("Error in open.connection ")
                            return("Error in open.connection")
                          }else if(grepl("Error in doc_parse_raw", e)){
                            cat("Error in open.connection ")
                            return(read_html(urlAddr, warn=F))
                          }else{
                            cat("code param error ")
                            return("code param error")
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
for (page in 0:lentocpage){
   cat(" page ", page)

   if(lentocpage==1){ urlAddr = urlHeader}
   else{urlAddr = paste0(urlHeader, page, urlTail)}
   pagesource <- retrieveFile(urlAddr)
   className = "td > a"

   keywordList <- html_nodes(pagesource, className)
   keywordList = as.character(keywordList)
   #writeClipboard(keywordList)
   keywordList = gsub('<a.*?status=', '>', keywordList)
   keywordList = gsub('; ', ',', keywordList)
#   keywordList = gsub('<span class="hd">HD</span>', '', keywordList)
#   keywordList = gsub('pop-execute', 'lazy', keywordList)
#   keywordList = gsub(' alt=".*?">', '>', keywordList)
#   keywordList = gsub('\\s{2,}', ' ', keywordList)
#   keywordList = gsub('<a.*?src=', '', keywordList)
#   keywordList = gsub('_.*', '_",', keywordList)
#   keywordList = gsub('""></a>', '', keywordList)
#   keywordList = gsub('https://cdn.pichunter.com/', '', keywordList)

   theWholepage = c(theWholepage, keywordList)
}
sink(thefileName)
#cat(format(Sys.time(), "%H:%M:%OSs  %a %d %b %Y"),"\n")
#cat(textHeader, sep="\n")
cat(theWholepage, sep="\n")
#cat(textTailer, sep="\n")
sink()
cat("\n",format(Sys.time(), "%H:%M:%OS"),"\n")

#startstr="start chrome.exe --start-fullscreen \""
#startstr="start launcher.exe --start-fullscreen \""
#shell(paste0(startstr, AChoice,"/", paste0(thefileName)))

