# to extract gallery pages use 'window.initials>'
# remember to change file name and address base
# 'pageURL', "editURL

# to extract gallery images, grep the only line 'window.initials'
# break at 'imageURL'
# grep the only useful
# cut height afterwards
# add '
# same in output file

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

seekkey = 'window.initials'
chopkey = 'imageURL'
boilPages <- function(theURL){
	thepage = readLines(theURL, warn = F)
	linenum = grep(seekkey, thepage)
	thepage = thepage[linenum]
	thepage = unlist(strsplit(thepage, chopkey))
	thepage = thepage[-1]

	thepage = gsub(',"height.*' , '>\',', thepage) 
	thepage = gsub('":' , '\'<img src=', thepage) 
	thepage = gsub('[\\]' , '', thepage) 
	return(thepage)
}


askforFilename <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter Filename without extension: ")
	return(Selection)		# if empty, let the caller handle
}
askforURL <-function(){		# "abc def" -> "abc+def"
	yrChoice = readline(prompt="single URL or use URL List? 1 or m: ")
	if(yrChoice=="1"){
		Selection = readline(prompt="enter URL: ")
		return(Selection)		# if empty, let the caller handle
	} else {
		URLList <- file.choose()
		Selection = readLines(URLList)
		return(Selection)
	}
}

# =========
# entry point
thefileName = askforFilename()
if(thefileName == ""){
	break
}
thefileName = paste0(thefileName,".html")
theList = ""
# theList = c('https://xhamster.com/photos/gallery/asian-delights-12924845')
theList = askforURL()
if(theList == ""){
	break
}

urlHead = ""
lentheList = length(theList)

wholeData = ""
for(i in 1:lentheList){
	cat(i, " ")
	theURL = paste0(urlHead, theList[i])
	wholeData = c(wholeData, boilPages(theURL))
}

	thepageHear = readLines('picViewerHead.txt', warn = F)
	thepageTail = readLines('picViewerTail.txt', warn = F)
	sink(thefileName)
	cat(thepageHear, sep="\n")
	cat(wholeData, sep="\n")
	cat(thepageTail, sep="\n")
	sink()

	startstr="start chrome.exe --start-fullscreen \""
	shell(paste0(startstr, dirStr,"/", thefileName))

