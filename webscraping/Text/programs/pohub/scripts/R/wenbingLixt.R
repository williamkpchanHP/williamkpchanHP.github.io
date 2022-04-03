
Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese

dirStr = "D:/KPC/Dropbox/MyDocs/R misc Jobs/Extracts by R/puji"
setwd(dirStr)

pageHead = "<h1"
pageTail = "/html>"

notchH = '<div style="text-align:center;padding:10px;">'
notchT = "</div></div><div class='title'></div>"

theFilename = "wenbingLixt.html"
theExtractList = "wenbingLixt.txt"

tocpage = readLines(theExtractList, warn = F)
lentocpage = length(tocpage)

newpage = ""

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage, ignore.case=TRUE)
	return(thepage[-(1:(headlinenum-1))])
}

chopTail <- function(thepage, pageTail){
    taillinenum = grep(pageTail, thepage)  # chop tail
	if(length(taillinenum) != 0){
	    return(thepage[-((taillinenum+1):length(thepage))])
	} else {
		return("")
	}
}

chop_notch <- function(thepage, notchH, notchT){
	notchHlinenum = grep(notchH, thepage, ignore.case=TRUE)
	notchTlinenum = grep(notchT, thepage, ignore.case=TRUE)
	return(thepage[-(notchHlinenum:notchTlinenum)])
}


for(i in 1:lentocpage){
	cat(i, " ")
	theURL = tocpage[i]
	thepage = readLines(theURL, warn = F)
   	thepage = chopHead(thepage, pageHead)
   	thepage = chopTail(thepage, pageTail)
#   	thepage = chop_notch(thepage, notchH, notchT)
   	newpage = c(newpage, thepage)
}

sink(theFilename)
cat(newpage, sep = "\n")
sink()
