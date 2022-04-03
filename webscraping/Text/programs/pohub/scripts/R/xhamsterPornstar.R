
dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

seekkey = '<div class="pornstar-thumb-container">'

boilPages <- function(theURL){
	thepage = readLines(theURL, warn = F)
	thepage = seekforkey(thepage)
	return(thepage)
}


seekforkey <- function(thepage){
	linenum = grep(seekkey, thepage) + 1
	thepage = thepage[linenum]
}


# =========
# entry point
thefileName = "xhamsterPornstar"

urlHead = "https://xhamster.com/pornstars/"
lentheList = 286

wholeData = ""
for(i in 1:lentheList){
	cat(i, " ")
	theURL = paste0(urlHead, i)
	wholeData = c(wholeData, boilPages(theURL))
}

	sink(paste0(thefileName,".html"))
	cat(wholeData, sep="\n")
	sink()

	# startstr="start chrome.exe --start-fullscreen \""
	# note to quote the long filename
	# shell(paste0(startstr, "'",dirStr,"/", paste0(thefileName,".html\'")))
