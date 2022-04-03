
Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese

dirStr = "C:/Users/user/mpg/Text/programs/pohub/extracts"
setwd(dirStr)

pageHead = '<div id="icnt">'
pageTail = "<nav class='pagination'>"

#pageHead2 = '<nav class='pagination'>'
#pageHead3 = '<TABLE cellSpacing=0 cellPadding=0 width=500 border=0>'


theFilename = "shamelesspussyList.html"
theExtractList = "shamelesspussyList.txt"

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
	    return(thepage[-(taillinenum:length(thepage))])
	} else {
		return("")
	}
}

for(i in 1:lentocpage){
	cat(i, " ")
	theURL = tocpage[i]
	thepage = readLines(theURL, warn = F)
   	thepage = chopHead(thepage, pageHead)
   	thepage = chopTail(thepage, pageTail)
   	newpage = c(newpage, thepage)
}

sink(theFilename)
cat(newpage, sep = "\n")
sink()
