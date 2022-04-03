#http://milfsover30.com/page/2/
#http://milfsover30.com/page/29/
#<a href="http://milfsover30.com/page/2/" class="inactive">2</a>
#<a href="http://milfsover30.com/page/30/">

#<div class="content">	line 88
#<div class="paginator">	line 91
#content line 90

Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese
setwd("D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts")

pageHeader="http://milfsover30.com/page/"
pageTail=""

theWholepage = ""
theFilename = "milfsover30.html"
#addr = c('default','default_page2','default_page3','default_page4','default_page5','default_page6','default_page7','default_page8')

lentocpage = 29
# keepHeadContent = '<div class="howtocontainer">'
pageHead = '<div class="content">'
pageEnd = '<div class="paginator">'
theWholepage = ""

keepHead <- function(thepage, pageHead){
	keepheadlinenum = grep(keepHeadContent, thepage)
	cat(thepage[keepheadlinenum],"\n")
	return(thepage[keepheadlinenum])
}

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)
	cat(" headline: ", headlinenum)
	return(thepage[-(1:(headlinenum-1))])
}

chopTail <- function(thepage, pageTail){
	taillinenum = grep(pageTail, thepage)  # chop tail
	cat( " tailline: ", taillinenum, "\n")
	if(length(taillinenum) != 0){
		return(thepage[-(taillinenum:length(thepage))])
	} else {
		return("")
	}
}
for (page in 1:lentocpage){
	cat("\nPage ", page,"reading... ")
	thepage=readLines(paste0(pageHeader, page))
	cat("loaded OK! ")
#	theHead = keepHead(thepage, keepHeadContent)

	thepage = chopTail(chopHead(thepage, pageHead), pageEnd)
	theWholepage = c(theWholepage , thepage)
}
sink(theFilename)
cat(theWholepage, sep = "\n")
sink()

#http://cdn.milfsover30.com/wp-content/uploads/2018/12/slim-tiny-tits-milf-abi-shows-her-perfect-ass-in-stockings1-230x345.jpg"
#http://cdn.milfsover30.com/wp-content/uploads/2018/12/slim-tiny-tits-milf-abi-shows-her-perfect-ass-in-stockings1.jpg
#1-16

