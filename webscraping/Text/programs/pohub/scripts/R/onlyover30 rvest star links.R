# https://onlyover30.com/page/59/    1~59 pages

setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts")

library(rvest)
pageHeader = "https://onlyover30.com/page/"
wholePage = character()
totalPages = 59
outputFilename = "onlyover30"

for(i in 1:totalPages){
 cat(i, " ")
 pagesource <- read_html(paste0(pageHeader,i))
 className = ".post>a"
 keywordList <- html_nodes(pagesource, className)
 wholePage = c(wholePage,as.character(keywordList))
}

sink(outputFilename)
cat(paste(wholePage), sep="\n")
sink()
