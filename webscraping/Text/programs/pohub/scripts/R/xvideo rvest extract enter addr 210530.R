# ask for a filename containing xhamster address for process
# a outfile will be created and open by chrome
# paste0("pohub ",theName,".html")
# htmlHeader.html and htmlTail.html is attached files

# example:
# https://xhamster.com/pornstars/terry-nova/
# terry-nova
# 3

library(crayon)
cat(yellow(format(Sys.time(), "%H:%M:%OSs"),"\n"))
library(rvest)

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/R"
setwd(dirStr)

htmlHeader = readLines("htmlHeader.html", warn = F)
htmlTail = readLines("htmlTail.html", warn = F)

outDirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(outDirStr)

askforURL <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter url address header ")
	return(Selection)		# if empty, calling program handle
}
askforOutName <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter output file name: ")
	return(Selection)		# if empty, calling program handle
}
askforPages <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter number of pages: ")
	return(Selection)		# if empty, calling program handle
}

boilPages <- function(theURL){
  pagesource <- read_html(theURL, warn=F, encoding = "UTF-8")
  className = ".thumb a"
  keywordList <- as.character(html_nodes(pagesource, className))
  return(keywordList)
}

# cleanUp
cleanUp <- function(out){
  out = gsub('<a href="/', '<a href="https://www.xvideos.com/', out)
  out = gsub('<script>.*?<img', '<img', out)
  out = gsub(' id=".*$', '></a>', out)
  out = gsub('<img src', '<img class="lazy" data-src', out)
  return(out)
}


# =========
# entry point
cat("\n\n\n")
theURLHeader = askforURL()
if(theURLHeader == ""){
	break
}
theOutName = askforOutName()
if(theOutName == ""){
	break
}
lentheList = askforPages()
if(lentheList == ""){
	break
}
lentheList = as.numeric(lentheList)
startnum = as.numeric(readline(prompt="enter start number: "))

allTheList =""

for(i in startnum:lentheList){
     theUrlAdr = paste0(theURLHeader, i)
	cat(i, theUrlAdr, "\n")
	allTheList = c(allTheList, boilPages(theUrlAdr))
}
     allTheList = cleanUp(allTheList)
#out = allTheList

	sink(paste0("xvideo",theOutName,".html"))
	cat(htmlHeader, sep="\n")
	cat(allTheList, sep="\n")
	cat(htmlTail, sep="\n")
	sink()

shell(paste0('xvideo',theOutName, '.html'))

# go back to program folder
setwd(dirStr)



