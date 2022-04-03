# use rvest to extract xhamster pages for videos
# remove friends only
cat(format(Sys.time(), "%H:%M:%OSs"),"\n")
library(rvest)
library(crayon)
AChoice = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/"
setwd(AChoice)
thefileName = "meine.html"
# ask for urlHeader
  urlHeader <- readline(prompt="Please enter urlHeader: ")
	if(urlHeader == "") { stop() }

#urlHeader = "https://xhamster.com/channels/mommy-in-control/"
#urlHeader = "https://xhamster.com/pornstars/haley-cummings"
#urlHeader = "https://xhamster.com/tags/big-nipple/hd/"
#urlHeader = "https://xhamster.com/best/monthly/"
#urlHeader = "https://xhamster.com/users/chevybelair1957/videos/"  # replace user name
#urlHeader = "https://xhamster.com/search/shay+foxx?quality=hd&page="
# https://xhamster.com/channels/candy-girl-video/hd/

# ask for lentocpage
  lentocpage <- readline(prompt="Total pages: ")
	if(lentocpage == "") { stop() }
#lentocpage = 8
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

   if(lentocpage==1){
     urlAddr = urlHeader
   } else{urlAddr = paste0(urlHeader, page)}
   pagesource <- retrieveFile(urlAddr)
   # className = ".thumb-list__item a.video-thumb__image-container"
   className = ".width-wrap a.video-thumb__image-container"

   keywordList <- html_nodes(pagesource, className)
   keywordList = as.character(keywordList)
   #writeClipboard(keywordList)
   keywordList = gsub('>.*', '', keywordList)
   uselessIdx = grep('data-sprite=""', keywordList)  # don't add >, won't work
   if(length(uselessIdx)!=0) keywordList = keywordList[-c(uselessIdx)]

   keywordList = gsub('<a.*?href=', '', keywordList)
   keywordList = gsub(' data-sprite.*', ',', keywordList)

   theWholepage = c(theWholepage, keywordList)
   #cat(str(theWholepage))
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

