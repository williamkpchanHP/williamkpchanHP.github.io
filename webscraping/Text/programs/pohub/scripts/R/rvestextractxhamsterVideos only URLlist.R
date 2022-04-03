# use rvest to extract xhamster pages for videos
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
   keywordList = gsub(' {2,}|<div>', '<br>', keywordList)
   keywordList = gsub('</div>', '', keywordList)
   keywordList = gsub('jpg">', 'jpg"><br>', keywordList)
   keywordList = gsub('\\n', '', keywordList)
   keywordList = gsub("'", "\\\\'", keywordList)
   keywordList = gsub('<img src', '<img class="lazy" data-src', keywordList)
   keywordList = gsub('<video controls', '<video class="lazy" controls', keywordList)
   keywordList = gsub('<source src', '<source data-src', keywordList)

   keywordList = gsub('\\(', '', keywordList)
   keywordList = gsub('\\)', '', keywordList)

   keywordList = unlist(lapply(keywordList, function(x){
     titlename = gsub('.*</video>.*?">',"",x)  # extract title
     titlename = gsub('\\d\\d:.*$',"",titlename)
     x = gsub(titlename,"",x)        # remove title
     return(paste0("'<h2>",titlename,"</h2>",x,"',")) # construct new line
   }))

   keywordList = gsub("<h2><br>","<h2>",keywordList)
   keywordList = gsub("<br></h2>","</h2>",keywordList)

   theWholepage = c(theWholepage, keywordList)
}
theWholepage = gsub("^.*?href=", "", theWholepage)
theWholepage = gsub(">.*", ",", theWholepage)

#sink(thefileName)
#cat(format(Sys.time(), "%H:%M:%OSs  %a %d %b %Y"),"\n")
#cat(theWholepage, sep="\n")
#sink()
#cat("\n",format(Sys.time(), "%H:%M:%OS"),"\n")
writeClipboard(theWholepage)
cat(red("\n ...to Clipboard\n"))
#startstr="start launcher.exe --start-fullscreen \""
#shell(paste0(startstr, AChoice,"/", paste0(thefileName)))

