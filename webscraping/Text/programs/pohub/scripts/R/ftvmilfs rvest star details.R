# https://onlyover30.com/page/59/    1~59 pages, 4675 topics

setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts")

library(audio)
library(rvest)
pageHeader = "http://ftvmilfs.net/"
wholePage = character()
theList = readLines("./R/ftvmilfs.txt")
outputFilename = "ftvmilfs details.html"

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")

finishBeep <- function(rptCnt){ # beep count
    while(rptCnt>0){
        play(sin(1:6000/10))
        Sys.sleep(0.2)
     rptCnt = rptCnt-1
    }
}

for(i in 1:length(theList)){
 cat(i, " ")
 pagesource <- read_html(paste0(pageHeader,theList[i]))
 className = "h1"
 keywordList <- html_nodes(pagesource, className)
 pagetitle = html_text(keywordList)

 className = ".grid-item img"
 imgList <- html_nodes(pagesource, className)
 imgList = as.character(imgList)
 imgList = gsub('<img width="300.*>', '', imgList)

 imgList = gsub('height="\\d{3}.*>', '>', imgList)
 imgList = gsub('-\\d{3}x\\d{3}.jpg', '.jpg', imgList) # convert thumb to big img
 imgList = paste("'<h2>",pagetitle, "</h2>",paste(imgList, collapse = '<br>'), "',",collapse = '')
 wholePage = c(wholePage, imgList)
}

sink(outputFilename)
cat(paste(wholePage), sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("loop time: ",LoopTime,"\n")
finishBeep(4)
