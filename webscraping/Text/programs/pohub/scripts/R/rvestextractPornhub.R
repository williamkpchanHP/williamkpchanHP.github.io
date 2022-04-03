# use rvest to extract xhamster pages

cat(format(Sys.time(), "%H:%M:%OSs"),"\n")

library(rvest)
AChoice = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/"
setwd(AChoice)

thefileName = "pornhub.html"
urlHeader = "https://www.pornhub.com/pornstar/danica-collins?page="
theWholepage = ""

lentocpage = 6

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
   className = ".phimage a, var.duration"

   keywordList <- html_nodes(pagesource, className)
   keywordList = as.character(keywordList)
   keywordList = gsub(' title=".*data-related.*?">', '><br>', keywordList)
   keywordList = gsub(' {2,}', '', keywordList)

   keywordList = gsub('<img src.*data-image|<img src.*data-src', '<img src', keywordList)
   keywordList = gsub(' data-mediabook.*?title="| data-mediumthumb.*?title="', '> </a><br>\n<h2>', keywordList) # note a space put before </a> to avoid clean up next line
   keywordList = gsub('"></a>', '', keywordList)
   keywordList = gsub('<var class="duration">', '', keywordList)
   keywordList = gsub('</var>', '</h2>', keywordList)
   keywordList = gsub('/view_video.php\\?viewkey=', 'https://www.pornhub.com/embed/', keywordList)
   #writeClipboard(keywordList)

   theWholepage = c(theWholepage, keywordList)
}
sink(thefileName)
cat(format(Sys.time(), "%H:%M:%OSs  %a %d %b %Y"),"\n")
cat(theWholepage, sep="\n")
sink()
cat("\n",format(Sys.time(), "%H:%M:%OS"),"\n")

startstr="start launcher.exe --start-fullscreen \""
shell(paste0(startstr, AChoice,"/", paste0(thefileName)))

