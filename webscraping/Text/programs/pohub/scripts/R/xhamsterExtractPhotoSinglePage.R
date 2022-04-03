# askfor address
# read total pages

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/"
setwd(dirStr)
library("jsonlite")

askforAddr <-function(){
	Selection = readline(prompt="enter first page address: ")
	if(Selection == "")   { 
		cat("\nblank address! exited!\n")
		break
	}
	return(Selection)		# if empty, calling program handle
}

askforFilename <-function(){		
	Selection = readline(prompt="enter output filename without extension, press enter for default: ")
	if(Selection == "")   { 
		Selection = "result.html"
	}
	return(paste0(Selection,".html"))
}

askforKey <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter key words: ")
	if(Selection != "")   {
	  	Selection = tolower(gsub(" ", "+", Selection))
  	}
	return(Selection)		# if empty, calling program handle
}

askforNum <-function(){		
	Selection = readline(prompt="enter max number of page: ")
	return(Selection)		# if empty, calling program handle
}

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

extractJson <- function(thepage){
	contentLineNum = grep(pageKey, thepage)
	thepage = thepage[contentLineNum]
	thepage =  gsub(pageKey,'',thepage)

	result <- fromJSON(substr(thepage, 1, (nchar(thepage)-1)))
	# use str(result) to list out the structure and copy all details in sublime text for analysis
	# names(result$photosGalleryModel$photos$imageURL)
	# str(result$photosGalleryModel$photos$imageURL)
	result = result$photosGalleryModel$photos$imageURL
	result = paste0("'<img src=\"", result, "\">',")
	imgArray <<- c(imgArray, result)
}

seekkey = '<div class="thumb-list__item gallery-thumb">'
theWholePage = character(0)

boilPages <- function(){
	# judge total no of pages
	thepage = readLines(pageHeader)

	paginHead = '<div class="pager-section">'
	paginEnd = '<i class="xh-icon arrow-right white">'

	paginPart = chopTail(chopHead(thepage, paginHead), paginEnd)
	paginKey = '<a class="xh-paginator-button "'
	paginlinenum = grep(paginKey, paginPart)
	lastItem = length(paginlinenum)
	paginPart = paginPart[(paginlinenum[lastItem]+1)] # that data in next line
	paginPart = gsub('.*data-page="','',paginPart)
	paginPart = gsub('">.*','',paginPart)
	totalPageNo = as.numeric(paginPart)
	extractJson(thepage) # the first page data here

	# loop for other pages 
	if(totalPageNo>1){
		for (page in 2:totalPageNo){
			cat(" ", page)
			thepage = readLines(paste0(pageHeader, "\\",page))
			extractJson(thepage)
		}
	}
}

seekforkey <- function(thepage, seekkey){
	linenum = grep(seekkey, thepage)
}

boilit <- function(thepage){
	rplword = '/view_video.php\\?viewkey='
	substword = 'https://www.pornhub.com/embed/'
	thepage = gsub(rplword, substword, thepage)
	thepage = gsub(' title=.*\">' , '>', thepage)  
	return(paste0(thepage,"\n"))
}

# =============================================
# entry point
Sys.setlocale(category = "LC_ALL", locale = "chs")

pageHeader = askforAddr()
if(pageHeader == ""){ break }

imgArray = character()
pageKey = 'window.initials = '
thefilename = askforFilename()

boilPages()

sink(paste0(thefilename,".html"))
cat('<!DOCTYPE html>\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width"/>\n<title>shuffle Links</title>\n<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>\n<style>\nbody {background-color: black;}\nhtml {height: 100%;overflow: scroll;}\n::-webkit-scrollbar {width: 0px;background: transparent;}\nbody { margin: auto; width: 100%; background-color: #000000; color: #20C030;}\nimg { width: 100%; display: block; margin-left: auto; margin-right: auto;}\n</style>\n</head>\n<body onkeypress="chkKey()">\n<div class="imagearea"> </div>\n<script>\nfunction chkKey() {\nvar testkey = getChar(event);\nif(testkey == "b"){ backward();}\nif(testkey == "f"){ foreward();}\nif(testkey == "p"){ pause();}\nif(testkey == "c"){ continU();}\nif(testkey == "s"){ showMov();}}\nfunction getChar(event){if (event.which!=0 && event.charCode!=0) {return String.fromCharCode(event.which)}\n else {return null}}\nvar ImgList = [\n')
cat(imgArray, sep="\n")
cat(']\n var listLen = ImgList.length, timer = 150000\nfunction shuffle(array) { var i = ImgList.length, j = 0, temp\nwhile (i--) { j = Math.floor(Math.random() * (i+1))\ntemp = ImgList[i]\n ImgList[i] = ImgList[j]\n ImgList[j] = temp\n } \nreturn ImgList\n}\nImgList = shuffle(Array.from(Array(ImgList.length).keys()))\nfunction changeImg() { if (listLen >= ImgList.length - 1) { listLen = 0\n }\n else if (listLen < 0) { listLen = ImgList.length - 1\n } \nelse { listLen = listLen + 1\n }\nshowImg()\n}\nfunction backward() { listLen = listLen - 2\nchangeImg()\n}\nfunction foreward() { changeImg()\n}\nfunction pause() { clearInterval(myVar)\n}\nfunction continU() { myVar = setInterval(changeImg, timer)\n foreward()\n}\nfunction showImg() { var thePointerImg = document.querySelector(".imagearea")\n thePointerImg.innerHTML = ImgList[listLen]\n console.log(thePointerImg.innerHTML)\n}\nfunction showMov() { var imgAdr = ImgList[listLen]\n var start = imgAdr.indexOf("=")+1\n var end = imgAdr.indexOf(\'\"\', start+1)\n var list = imgAdr.substring(start+1, end)\n window.open(list)\n}changeImg()\nvar myVar = setInterval(changeImg, timer)\n</script></body></html>\n')
sink()

startstr="start chrome.exe --start-fullscreen "
# note to quote the long filename
#shell(paste0(startstr, dirStr,"/", paste0(thefilename,".html\"")))
shell(paste0(startstr, "\"file:///",dirStr, paste0(thefilename,".html\"")))

# http://www.pornhub.com/pornstars?page=15
# http://www.pornhub.com/video?c=96&page=10
