#
cat(yellow(format(Sys.time(), "%H:%M:%OSs"),"\n"))
library(rvest)
library(crayon)

folderAddr = "C:/Users/User/Desktop/"
setwd(folderAddr)

thefileName = "webscrape.html"
# ask for urlHeader
  urlHeader <- readline(prompt="Please enter urlHeader: ")
	if(urlHeader == "") { stop() }

# ask for urlTail
  urlTail <- readline(prompt="Please enter urlTail: ")

# ask for className
  className <- readline(prompt="Please enter className: ")
	if(className == "") { stop() }

# ask for startNum
  startNum <- as.numeric(readline(prompt="start page number: "))
	if(startNum == "") { stop() }

# ask for endNum
  endNum <- as.numeric(readline(prompt="end page number: "))
	if(endNum == "") { stop() }

wholePage = character()

cleanNmerge <- function(thepage){
  cat("clean P",i, ", ",sep="")
  if ((i %% 100) == 0 ){
       now_time <- unclass(as.POSIXlt(Sys.time()))
       nowTS <- now_time[3]$hour*100 + now_time[2]$min
       cat(yellow("\nNow the time is: ",nowTS,"\n"))
  }

  keywordList <- thepage %>% html_nodes(className) %>% as.character()
  # itemPointer = grep('<a',keywordList)
  # keywordList = keywordList[itemPointer]
  wholePage <<- c(wholePage, keywordList)
}


for(i in startNum:endNum){
  cat("P",i,". ")
  urlheader2 = paste0(urlHeader, i, urlTail)
  thepage <- read_html(urlheader2)
  cleanNmerge(thepage)
}

sink(thefileName)
cat(wholePage, sep="\n")
sink()

cat("\n",format(Sys.time(), "%H:%M:%OS"),"\n")
cat(red("Job completed! file saved on deskto as webscrape.html\n"))