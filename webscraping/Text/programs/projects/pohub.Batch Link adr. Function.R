dirStr = "C:/Users/user/mpg/Text/programs/projects"
setwd(dirStr)

askforURL <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter Batch Filename without extension: ")
	return(Selection)		# if empty, calling program handle
}

seekkey = 'view_video.php\\?viewkey='

boilPages <- function(theURL){

	thepage=readLines(theURL, warn = F)
    targetlinenum = grep(seekkey, thepage)
	thepage = thepage[targetlinenum]

	thepage = gsub('.*viewkey=|\".*', "", thepage)
	thepage = gsub('&.*', "", thepage)
	thepage = gsub("\'.*", "", thepage)
	thepage = gsub('<.*', "", thepage)
	thepage = unique(thepage)
	return(thepage)
}


# =========
# entry point
theName = askforURL()
if(theName == ""){
	break
}

thefile = paste0(theName, ".txt")
theList = readLines(thefile, warn = F)
lentheList = length(theList)

allTheList =""

for(i in 1:lentheList){
	cat(i, " ")
	allTheList = c(allTheList, boilPages(theList[i]))
}

	allTheList = unique(allTheList)
	allTheList = sort(allTheList)

	substword = '<b onclick=sCt("'
	allTheList = paste0(substword, allTheList, '")>',allTheList,"</b> . \n")

	sink("function.html", append = T)
	cat("<br><br>\n")
	cat(allTheList, sep="\n")
	sink()
	startstr="start chrome.exe --start-fullscreen "
	# note to quote the long filename
	shell(paste0(startstr, dirStr,"/", "function.html"))

