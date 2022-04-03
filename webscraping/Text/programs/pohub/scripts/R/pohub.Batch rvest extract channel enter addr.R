# ask for pornhub address for process

# a outfile will be created and open by chrome
# paste0("pohub ",theName,".html")
# htmlHeader.html and htmlTail.html is attached files

# example:
# https://www.pornhub.com/pornstar/veronica-avluv/videos?page=
# veronica-avluv
# 7

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
	Selection = readline(prompt="enter full output file name: ")
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
  out = gsub("\n", " ", out)
  out = gsub(" {1,}", " ", out)
  out = gsub("<a", "\n<a", out)
  removeLine = grep('<a href="javascript', out)
  if(length(removeLine)!=0){
    out = out[-removeLine]
  }

  substword = '<a href="https://www.pornhub.com/embed/'
  out = gsub('<a.* href="/', substword, out)
  out = gsub(' class="lazy".*?>', '>', out)

  out = gsub('<div.*?</a>', '</a>', out)
  out = gsub(' title=".*?<img', '><img', out)
  out = gsub(' title="', '>', out)
  out = gsub('"></a>', '</a>', out)
  out = gsub(' src=.*?data-src', ' class="lazy" data-src', out)
  out = gsub('<img src=', '<img class="lazy" data-src=', out)
  out = gsub(' data-image.*?>', '><br>', out)
  out = gsub(' data-medium.*?>', '><br>', out)
  out = gsub('view_video.php\\?viewkey=', '', out)

  return(out)
}


# =========
# entry point
cat("\n\n\nWarning, may not work after cleanup!\n")
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

classNameArray = c("div.phimage a", ".js-mxp")
cat("1 ", classNameArray[1], "\n2 ",classNameArray[2], "\n")
className = classNameArray[as.numeric(readline(prompt="select classname, 1,2: "))]

allTheList =""

for(i in 1:lentheList){
     theUrlAdr = paste0(theURLHeader, i)
	cat(i, theUrlAdr, "\n")
	allTheList = c(allTheList, boilPages(theUrlAdr))
}
     allTheList = cleanUp(allTheList)
#out = allTheList

	sink(paste0("pohub",theOutName,".html"))
	cat(htmlHeader, sep="\n")
	cat(allTheList, sep="\n")
	cat(htmlTail, sep="\n")
	sink()

shell(paste0('pohub',theOutName, '.html'))

# go back to program folder
setwd(dirStr)

# remidy
# out = readLines("pohubpornstar-index1.html", warn = F)
# removeLine = grep('<span |</span>', out)
# out = out[-removeLine]
# out = gsub("\t", "", out)
# out = gsub(' class=".*?>', '>', out)

# to extract about section: section.aboutMeSection
