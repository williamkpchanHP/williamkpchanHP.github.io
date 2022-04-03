
dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts"
setwd(dirStr)

askforURL <-function(){
	Selection = readline(prompt="enter Batch Filename without extension: ")
	return(Selection)		# if empty, calling program handle
}


# =========
# entry point
thefileName = askforURL()
if(thefileName == ""){
	break
}
thefile = paste0(thefileName, ".html")
theList = readLines(thefile, warn = F)

theIndex = gsub('<img.*>', '', theList)  
theNewIndex = unique(theIndex)
theNumIdx = match(theNewIndex, theIndex)
theList = theList[theNumIdx]
lentheList = length(theList)

sink(paste0(thefileName," N.html"))
for(i in 1:lentheList){
	cat(theList[i])
	cat("\n")
}
	sink()

	startstr="start chrome.exe --start-fullscreen \""
	# note to quote the long filename
	shell(paste0(startstr, dirStr,"/", paste0("\"",thefileName," N.html\"")))
