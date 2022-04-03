# http://ftvmilfs.net/page/9/
# http://cdn.ftvmilfs.net/wp-content/uploads/beneath-the-shades5.jpg
# http://cdn.ftvmilfs.net/wp-content/uploads/beneath-the-shades15-300x451.jpg
# http://cdn.ftvmilfs.net/wp-content/uploads/beneath-the-shades1-300x451.jpg

Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese

setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts")

pageHeader="http://ftvmilfs.net/page/"
pageTail="/"
theFilename = "ftvmilfs.html"
# addr = c()
# lentocpage = length(addr)
lentocpage = 9
theWholepage = ""
cat("\nlentocpage: ",lentocpage,"\n")
pageHead = '<h1'

pageEnd = '<div class="paginator">'

theWholepage = ""

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
	thepage=readLines(paste0(pageHeader, page, pageTail))

#	thepage=breakArticle(thepage, pageHead, pageEnd)
	thepage = chopTail(chopHead(thepage, pageHead), pageEnd)
	theWholepage = c(theWholepage , "<div class='topic'>\n",thepage, "\n</div>\n")
}


sink(theFilename)
cat(theWholepage, sep = "\n")
sink()

