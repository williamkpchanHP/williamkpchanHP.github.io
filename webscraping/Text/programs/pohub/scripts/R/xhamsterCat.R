# this is exactly same as xhamsterUsers.R except pageHead last character

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

pageHeader="https://xhamster.com/categories/british/"

pageHead = '<div class="thumb-list__item video-thumb"'
pageEnd = '<div class="pager-section">'
theFilename = "british.html"

lentocpage = 747

theWholepage = ""
cat("\nlentocpage: ",lentocpage,"\n")

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)
	cat(" ", headlinenum[1])
	return(thepage[-(1:(headlinenum[1]))])
}

chopTail <- function(thepage, pageTail){
	taillinenum = grep(pageEnd, thepage)  # chop tail
	cat( " ", taillinenum[1], "\n")
	if(length(taillinenum) != 0){
		return(thepage[-((taillinenum[1]):length(thepage))])
	} else {
		return("")
	}
}

for (page in 1:lentocpage){
	cat(" ", page)
	thepage=readLines(paste0(pageHeader, page))
	thepage = chopTail(chopHead(thepage, pageHead), pageEnd)
	theWholepage = c(theWholepage , thepage)
}

sink(theFilename)
cat(theWholepage, sep = "\n")
sink()
