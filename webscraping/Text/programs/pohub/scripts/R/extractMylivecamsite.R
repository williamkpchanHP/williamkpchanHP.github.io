Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese

setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts")

pageHeader="https://www.mylivecamsite.com/female-cams/?page="
pageTail=""

theWholepage = ""
theFilename = "mylivecamsiteAll.html"

lentocpage = 24
cat("\nlentocpage: ",lentocpage,"\n")
pageHead = '<ul id="room_list" class="list">'
pageEnd = '<ul class="paging">'
theWholepage = ""

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)
	cat(" ", headlinenum)
	return(thepage[-(1:(headlinenum-1))])
}

chopTail <- function(thepage, pageTail){
	taillinenum = grep(pageTail, thepage)  # chop tail
	cat( " ", taillinenum[1], "\n")
	if(length(taillinenum) != 0){
		return(thepage[-((taillinenum[1]+1):length(thepage))])
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

