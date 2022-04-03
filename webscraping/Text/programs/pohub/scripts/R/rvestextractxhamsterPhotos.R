# use rvest to extract xhamster pages for photos

cat(format(Sys.time(), "%H:%M:%OSs"),"\n")

library(rvest)
AChoice = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/"
setwd(AChoice)

thefileName = "horniest.html"
urlHeader = "https://xhamster.com/channels/step-lesbians"
theWholepage = ""

lentocpage = 1

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
for (page in 1:lentocpage){
   cat(" page ", page)

   if(lentocpage==1){ urlAddr = urlHeader}
   else{urlAddr = paste0(urlHeader, page)}
   pagesource <- retrieveFile(urlAddr)
   className = ".thumb-list__item a.video-thumb__image-container"

   keywordList <- html_nodes(pagesource, className)
   keywordList = as.character(keywordList)
   #writeClipboard(keywordList)
   keywordList = gsub(' class="video-thumb__image-container thumb-image-container"', '', keywordList)
   keywordList = gsub(' data-sprite', '><br><img src', keywordList)
   keywordList = gsub(' data-previewvideo', '><br><br><video controls loop autoplay><source src', keywordList)
# the following line may change
   keywordList = gsub('"><div class="thumb-image-container__duration"', '<div', keywordList)
   keywordList = gsub('mp4">', 'mp4"></video><br><br>', keywordList)
   keywordList = gsub('\\s<i class=.*"></i>\\n\\n', '', keywordList)
   keywordList = gsub('class="thumb-image-container__image" ', '', keywordList)
   keywordList = gsub(' onerror.*alt="', '>', keywordList)
   keywordList = gsub(' {2,}|<div>', ' ', keywordList)
   keywordList = gsub('</div>', '</h2>', keywordList)

   theWholepage = c(theWholepage, keywordList)
}
sink(thefileName)
cat(format(Sys.time(), "%H:%M:%OSs  %a %d %b %Y"),"\n")
cat(theWholepage, sep="\n")
sink()
cat("\n",format(Sys.time(), "%H:%M:%OS"),"\n")

startstr="start launcher.exe --start-fullscreen \""
shell(paste0(startstr, AChoice,"/", paste0(thefileName)))

