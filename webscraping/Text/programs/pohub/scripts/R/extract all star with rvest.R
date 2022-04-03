# just drag out the div blocks
setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts")

library(rvest)

pageHeader = "https://xhamster.com/pornstars/all/categories/eating-pussy/"
allText = character()

for(i in 1:45){
 cat(i, " ")
 pagesource <- read_html(paste0(pageHeader,i))

 className = ".pornstar-thumb-container"
 keywordList <- html_nodes(pagesource, className)

 allText = c(allText,as.character(keywordList))

}

sink("eating-pussyStarList.html")
cat(paste(allText), sep="\n")
sink()

