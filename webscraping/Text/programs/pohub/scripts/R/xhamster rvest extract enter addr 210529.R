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
  keywordList <- as.character(html_nodes(pagesource, className))
  return(keywordList)
}

# cleanUp
cleanUp <- function(out){
  out = gsub('<div.*?>|<i.*?</i>|<span.*?</span>|</div>|\\n</a>', "", out)
  out = gsub(' class=".*?"', "", out)
  out = gsub('\\n {1,}', "", out)
  out = gsub(' data-sprite.*?>', ">", out)
  out = gsub(' onload=".*?>', "></a>", out)
  out = gsub('img src', 'img class="lazy" data-src' , out)
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

classNameArray = c(".video-thumb__image-container",
    ".channel-thumb-container__image-container a",
    ".pornstar-thumb-container a")

  cat("1 ", classNameArray[1], "\n2 ",classNameArray[2], "\n3 ", classNameArray[3], "\n")
  className = classNameArray[as.numeric(readline(prompt="select classname, 1,2,3: "))]

allTheList =""

for(i in 1:lentheList){
     theUrlAdr = paste0(theURLHeader, i)
	cat(i, theUrlAdr, "\n")
	allTheList = c(allTheList, boilPages(theUrlAdr))
}
     allTheList = cleanUp(allTheList)
#out = allTheList

	sink(paste0("xham",theOutName,".html"))
	cat(htmlHeader, sep="\n")
	cat(allTheList, sep="\n")
	cat(htmlTail, sep="\n")
	sink()

shell(paste0('xham',theOutName, '.html'))

# go back to program folder
setwd(dirStr)



