# Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese
# https://www.porn.com/channels/olderwomanfun?p=71

setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs")

pageHeader="https://www.porn.com/channels/olderwomanfun?p="

theWholepage = ""
theFilename = "porncom channels olderwomanfun.html"
# addr = c()
# lentocpage = length(addr)

lentocpage = 71
pageHead = 'meta http-equiv="X-UA-Compatible'
# note if not found, Error in 1:(headlinenum - 1) : argument of length 0
# pageEnd = '<ol id="page-nav">'
theWholepage = ""

grepHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)
	return(thepage[headlinenum])
}

for (page in 1:lentocpage){
	cat(" ", page)
	thepage = readLines(paste0(pageHeader, page))
	theWholepage = c(theWholepage , grepHead(thepage, pageHead))
}

sink(theFilename)
cat(theWholepage, sep = "\n")
sink()

