# given gallery TOC in consecutive nos, extract gallery pageURLs and counts
 # 'pageURL', "editURL

 # to extract gallery images, grep the only line 'window.initials'
 # break at 'imageURL'
 # grep the only useful
 # cut height afterwards
 # add '
 # same in output file
 #163 sets, 30 set per page = 6 pages
# init
 dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
 setwd(dirStr)

 seekkey = 'window.initials'
 chopkey = 'pageURL":"'
 urlHead = ""
 imgchopkey = 'imageURL'


 thefileName = "nipman"

 urlHead = "https://xhamster.com/users/nipman11/photos/" # remember the "/" at end
 lenList = 3

 theExtractURL = vector('character')
 thePagePhotoNoList = vector('numeric')
# support functions
 # collectTOCPages()
  collectTOCPages <- function(theURL){
	thepage = readLines(theURL, warn = F)
	linenum = grep(seekkey, thepage)
	thepage = thepage[linenum]
	thepage = unlist(strsplit(thepage, chopkey))
	thepage = thepage[-1]
	return(thepage)
  }
 # extractURL
  extractURL <- function(thepage){
	thepage = gsub('.*pageURL":"' , '', thepage)

	thepage = gsub('","editURL.*' , '', thepage) 
	thepage = gsub('[\\]' , '', thepage) 

	return(thepage)
  }
 # extractCntNo
  extractCntNo <- function(thepage){
	thepage = gsub('.*"quantity":' , '', thepage) 
	thepage = gsub(',"views".*' , '', thepage) 
	return(thepage)
  }

# loop all TOC URLs
 for(i in 1:lenList){
	cat(i, " ")
	theURL = paste0(urlHead, i)
	thepage = collectTOCPages(theURL)

	# note that the first line contain the "quantity" parameter but without URL
	# the structure is "quantity" comes first and URL comes later
	linenum = grep('","retired', thepage)
	theURLpage = thepage[-linenum]

	theExtractURL = c(theExtractURL, extractURL(theURLpage))
	thepage = thepage[-length(thepage)]

	thePagePhotoNoList = c(thePagePhotoNoList, extractCntNo(thepage))
 }

# processPages second part collect wholeData
  processPages <- function(theURL){
	thepage <- tryCatch(readLines(theURL, warn=F), error = function (e) NULL)
	if (is.null(thepage)) {
		return("")
	}

	linenum = grep(seekkey, thepage)
	thepage = thepage[linenum]
	thepage = unlist(strsplit(thepage, imgchopkey))
	thepage = thepage[-1]

	thepage = gsub(',"height.*' , '>\',', thepage) 
	thepage = gsub('":' , '\'<img src=', thepage) 
	thepage = gsub('[\\]' , '', thepage) 
	return(thepage)
  }

 lentheList = length(theExtractURL)
 theExcludeList = c()

 wholeData = ""
 fullPageNo = 60

# the loop to process pages
 cat("list length: ",lentheList,"\n")
 for(i in 1:lentheList){
	cat("\n", i, ". ")
	photoNos = as.numeric(thePagePhotoNoList[i])

	# load multi pages if > 60
	 lastPageRemainder = photoNos %% fullPageNo
	 allPageNos = photoNos %/% fullPageNo

	 if (lastPageRemainder !=0) {allPageNos = allPageNos +1}

	 theURL = theExtractURL[i]
	 wholeData = c(wholeData, processPages(theURL))

	 if (allPageNos >1) {
		for(k in 2:allPageNos){
			cat(k, " ")
			theURL = paste0(urlHead, theExtractURL[i], "/", k)
			wholeData = c(wholeData, processPages(theURL))
		}
	 }

 }
# gives output
	thepageHead = readLines('picViewerHead.txt', warn = F)
	thepageTail = readLines('picViewerTail.txt', warn = F)
	sink(paste0(thefileName,".html"))
	cat(thepageHead, sep="\n")
	cat(wholeData, sep="\n")
	cat(thepageTail, sep="\n")
	sink()

	startstr="start chrome.exe --start-fullscreen \""
	shell(paste0(startstr, dirStr,"/", paste0(thefileName,".html")))


