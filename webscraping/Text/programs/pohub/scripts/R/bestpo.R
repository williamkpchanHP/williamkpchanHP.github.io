# +9
# crawler
# https://collectionofbestporn.com/video/busty-japanese-milf-washes-dick-before-creampie-2.html

# input address
# input no of pages
# store in queue
# set pointer to 1

# read page
# locate key
# extract address
# append in queue
# remove duplicate
# inc pointer
# next

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

seekkey = 'div class="video-thumb"'

reqURL <-function(){
	Selection = readline(prompt="enter URL: ")
	return(Selection)		# if empty, calling program handle
}

reqPages <-function(){		
	Selection = readline(prompt="enter total number of page: ")
	return(Selection)		# if empty, calling program handle
}

reqName <-function(){		
	Selection = readline(prompt="enter tag name: ")
	return(Selection)		# if empty, calling program handle
}

boilPages <- function(theURL){
	thepage = readLines(theURL, warn = F)
	theaddr = grep(seekkey, thepage)
	theaddr = theaddr +1
	theimgaddr = theaddr +4

	return(paste0(thepage[theaddr],thepage[theimgaddr]))
}

# =========
# crawler entry point
crawlIt <- function(theURL){
	theURL = reqURL()
	if(thefileName == ""){
		break
	}
	
	totalPages = reqPages()
	if(totalPages != "")   {
		totalPages = as.numeric(totalPages)
	}
	
	theQueue = theURL
	addrBook = ""
	
	for(i in 1:totalPages){
		cat(i, " ")
		addrList = boilPages(theQueue[i])
		linkList = gsub('jpg.*', 'jpg">', addrList)
	
		addrBook = c(addrBook, linkList)
	
		queueList = gsub('.*<a href="', '', addrList)
		queueList = gsub('html.*', 'html', queueList)
	
		theQueue = c(theQueue, queueList)
	}
	
	sink("bestporn.html")
	cat(addrBook, sep="\n")
	sink()
}

readkey = function(){
	key = ""
	while(is.na(suppressWarnings(as.numeric(key)))){
		key = readline(prompt="Please choose: ")
	    if(key == "as.raw(27)") {break}
	}
	return(strtoi(key))
}

scrapeIt <- function(theURL){
	# https://collectionofbestporn.com/tag/eva-notty/page/4
	pageHead = "https://collectionofbestporn.com/tag/"
	pageMid = "/page/"
	tagName = reqName()

	if(tagName == ""){
		break
	}
	totalPages = reqPages()
	if(totalPages != "")   {
		totalPages = as.numeric(totalPages)
	}else{
		cat("\nno pages!\n")
		break
	}

	theWholePage = ""
	for(i in 1:totalPages){
		cat(i, " ")
		theURL = paste0(pageHead, tagName, pageMid, i)
		resultPage = gsub('jpg.*', 'jpg"></a>\',', boilPages(theURL))
		resultPage = gsub('.*<a href', '\'<a href', resultPage)
		resultPage = gsub('                        ',"", resultPage)
		theWholePage = c(theWholePage, resultPage)
	}

	sink("bestpornScrap.html")
	cat(theWholePage, sep="\n")
	sink()
}

ParseIt <- function(Selection){
	if(Selection == "1") {crawlIt()}
	if(Selection == "2") {scrapeIt()}
	if(Selection == "3") {break}
	break
}

# =========
# main menu entry point

Selection = "b"
while(Selection != "") 
{
	cat("\n\n\n", 
	"\n", "Main menu",
	"\n", "================",
	"\n", "1 crawler",
	"\n", "2 scrape tags",
	"\n", "3 exit"
	)
	Selection <- readkey()

	if(Selection != "") {
		ParseIt(Selection)
	} else {
		Selection = "3"
		ParseIt(Selection)
	}
}

