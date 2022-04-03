# https://onlyover30.com/page/59/    1~59 pages, 4675 topics

setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts")

library(rvest)
pageHeader = "https://onlyover30.com/"
wholePage = character()
theList = readLines("./R/onlyover30 star List.txt")
outputFilename = "onlyover30 details.html"

ProcessStartTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")

for(i in 1:length(theList)){
 cat(i, " ")
 pagesource <- read_html(paste0(pageHeader,theList[i]))
 className = ".gallery-icon img"
 keywordList <- html_nodes(pagesource, className)
 keywordList = as.character(keywordList)
 keywordList = gsub('width="230" height="300" | class=.*"', '', keywordList)
 keywordList = gsub('-\\d{3}x\\d{3}.jpg', '.jpg', keywordList) # convert thumb to big img
 keywordList = paste("'<h2>",theList[i], "</h2><br>",paste(keywordList, collapse = '<br>'), "',",collapse = '')
 wholePage = c(wholePage, keywordList)
}

sink(outputFilename)
cat(paste(wholePage), sep="\n")
sink()

ProcessEndTime = Sys.time()
cat(format(Sys.time(), "%H:%M:%OS"),"\n")
LoopTime = trunc(as.numeric(ProcessEndTime - ProcessStartTime, units="secs"))
cat("loop time: ",LoopTime,"\n")
