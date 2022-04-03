# ask for a filename containing pornhub address for process
# that is a txt file
# a outfile will be created and open by chrome
# paste0("pohub ",theName,".html")
# htmlHeader.html and htmlTail.html is attached files

library(crayon)
cat(yellow(format(Sys.time(), "%H:%M:%OSs"),"\n"))
library(rvest)

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/R"
setwd(dirStr)

htmlHeader = readLines("htmlHeader.html", warn = F)
htmlTail = readLines("htmlTail.html", warn = F)

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

askforURL <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter Batch Filename without extension: ")
	return(Selection)		# if empty, calling program handle
}

boilPages <- function(theURL){
  cat(theURL, "\n")
  pagesource <- read_html(theURL, warn=F, encoding = "UTF-8")

  className = "div.phimage a"

  keywordList <- as.character(html_nodes(pagesource, className))
  return(keywordList)
}

# cleanUp
cleanUp <- function(out){
  out = gsub("\n", " ", out)
  out = gsub(" {1,}", " ", out)
  out = gsub("<a", "\n<a", out)
  removeLine = grep('<a href="javascript', out)
 # if(length(removeLine)!=0){
 #   out = out[-removeLine]
 # }
  substword = '<a href="https://www.pornhub.com/embed/'
  out = gsub('<a href="/', substword, out)
  out = gsub('<div.*?</a>', '</a>', out)
  out = gsub(' title=".*?<img', '><img', out)
  out = gsub(' title="', '>', out)
  out = gsub('"></a>', '</a>', out)
  out = gsub(' src=.*?data-src', ' class="lazy" data-src', out)
  out = gsub(' data-image.*?>', '><br>', out)
  out = gsub(' data-medium.*?>', '><br>', out)
  out = gsub('view_video.php\\?viewkey=', '', out)

  return(out)
}


# =========
# entry point
theName = askforURL()
if(theName == ""){
	break
}

thefile = paste0(theName, ".txt")
theList = readLines(thefile, warn = F)
lentheList = length(theList)

allTheList =""

for(i in 1:lentheList){
	cat(i, " ")
	allTheList = c(allTheList, boilPages(theList[i]))
}
     allTheList = cleanUp(allTheList)
#out = allTheList

	sink(paste0("pohub",theName,".html"))
	cat(htmlHeader, sep="\n")
	cat(allTheList, sep="\n")
	cat(htmlTail, sep="\n")
	sink()

shell(paste0('pohub',theName, '.html'))



