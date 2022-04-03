# use rvest to extract xhamster photo
# given a list or toc URLs, extract all URLs and Qty from each toc URL

cat(format(Sys.time(), "%H:%M:%OSs"),"\n")

library(rvest)
AChoice = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/"
setwd(AChoice)

thefileName = "URLsandQty.html"
urlHeader = "https://xhamster.com/photos/search/stretch+pussy+lips?page="
theWholepage = ""

lentocpage = 20

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
   className = ".thumb-list__item a"
   keywordList <- html_nodes(pagesource, className)

   keywordList = as.character(keywordList)
   #writeClipboard(keywordList)
   keywordList = gsub('class="gallery-thumb__link thumb-image-container" ', '', keywordList)
   keywordList = gsub('\\s{2,}<img class="thumb-image-container__image" data-lazy', '<img src', keywordList)
   keywordList = gsub('jpg".*?>', 'jpg"></a>', keywordList)
# the following line may change
   keywordList = gsub('<div class="gallery-thumb-info__name">', '<br>', keywordList)
   keywordList = gsub('<div class="gallery-thumb-info">', '', keywordList)
   keywordList = gsub('</div>', '<br>', keywordList)
   keywordList = gsub('<span.*?photo-camera.*counter">', ' ', keywordList)
   keywordList = gsub('</span>', '<br>', keywordList)
   keywordList = gsub('<span.*', '', keywordList)
   keywordList = gsub('<a', '<div><a', keywordList)
   keywordList = gsub('<br><br>', '</div>', keywordList)

   theWholepage = c(theWholepage, keywordList)
}
sink(thefileName)
cat(format(Sys.time(), "%H:%M:%OSs  %a %d %b %Y"),"\n<br>")
cat('<base target="_blank"><style>body{font-size:16px;background-color:black; color:gray;}div{display:inline-block; padding:5px; overflow: hidden; text-overflow:ellipsis; width: 240px; }</style>')
cat(theWholepage, sep="\n")
sink()
cat("\n",format(Sys.time(), "%H:%M:%OS"),"\n")
#writeClipboard(theWholepage)
#cat("to Clipboard")
startstr="start launcher.exe --start-fullscreen \""
shell(paste0(startstr, AChoice,"/", paste0(thefileName)))

