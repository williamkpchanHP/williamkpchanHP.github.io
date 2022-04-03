# D:\Dropbox\MyDocs\R misc Jobs\webscraping\Text\programs\testvideo.html

library(rvest)
dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)
wholePage = ""

# retrieveFile
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
    cat("Error in connection, try 5 secs later!\n")
    retryCounter <- retryCounter + 1
    retriveFile = ""  # if end of loop this will be returned
    }else if(grepl("Error in open.connection", retriveFile)){
    urlAddr = "http://news.rthk.hk/rthk/ch/latest-news.htm" # unable to connect, so use phantom url to bypass
    # return("")
    }else{
    retryCounter = 200  # to jump out of loop
    }
  }
  return(retriveFile)
  }

titleName = "evolved fights"

cat(titleName, " .. ")
pageNo = 3
titleName_ = unlist(strsplit(titleName, " "))
titleName_ = capture.output(cat(titleName_, sep="-")) 

pageHeader = paste0("https://www.pornhub.com/channels/", titleName_, "/videos?page=", pageNo)
pagesource <- retrieveFile(pageHeader)

className = ".phimage a"
keywordList <- html_nodes(pagesource, className)

hrefList = html_attr(keywordList, "href")
titleList = html_attr(keywordList, "title")

className = ".phimage img"
keywordList <- html_nodes(pagesource, className)

thumbList = html_attr(keywordList, "data-thumb_url")
srcList = html_attr(keywordList, "data-src")
# imageList = html_attr(keywordList, "data-image") may not available
mediaList = html_attr(keywordList, "data-mediabook")


put image as a background for div and then display video with correct position:
  background-image: url('images/tv.png'); 

<div>
  <video onmouseover="this.play()" onmouseout="this.pause();"  controls="controls">
  <source src="https://cw.phncdn.com/videos/201810/09/186637051/180P_225K_186637051.webm?MCw2uBGXQJJ04wKDkB0yXVtdQVJ5TVKHU4vgoVl9rwHFoyQqTnHVqkbKsqv3kW0me2Y9iH3B949QFIgv8LzizELOqOMIgTnHRj9MEtBEQPRayuVvWHKVQy_oiccJRjoaXoeyq0M-jOLxCbWIOr6XbN-lcsS_8TEyNtcwcu0_5LZXNfZQQTgsCRGJQ28w4vdA4_EnFxNvEKE" type="video/ogg"></source>
  </video>  
</div>
