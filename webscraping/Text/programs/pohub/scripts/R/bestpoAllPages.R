# https://collectionofbestporn.com/most-recent/page/804

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

seekkey = 'div class="video-thumb"'

boilPages <- function(theURL){
	thepage = readLines(theURL, warn = F)
	theaddr = grep(seekkey, thepage)
	theaddr = theaddr +1
	theimgaddr = theaddr +4

	return(paste0(thepage[theaddr],thepage[theimgaddr]))
}

# =========
# entry point
totalPages = 804

theURLHead = 'https://collectionofbestporn.com/most-recent/page/'
addrBook = ""

for(i in 1:totalPages){
	cat(i, " ")
	addrList = boilPages(paste0(theURLHead,i))
	linkList = gsub('jpg.*', 'jpg">', addrList)

	addrBook = c(addrBook, linkList)

	queueList = gsub('.*<a href="', '', addrList)
	queueList = gsub('html.*', 'html', queueList)

	theQueue = c(theQueue, queueList)
}

sink("bestpornAllPages.html")
cat(addrBook, sep="\n")
sink()
thepage = readLines(theQueue[1], warn = F)
