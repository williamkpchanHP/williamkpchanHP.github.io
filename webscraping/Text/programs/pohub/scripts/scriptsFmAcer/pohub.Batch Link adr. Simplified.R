
dirStr = "C:/Users/user/mpg/Text/programs/pohub"
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
	
	substword = '<a href ="https://www.pornhub.com/embed/'
	allTheList = paste0(substword, allTheList, '">',allTheList,"</a><br>\n")

	sink(paste0("pohub ",theName,".html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;    color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(allTheList, sep="\n")
	sink()
	startstr="start chrome.exe --start-fullscreen \""
	# note to quote the long filename
	shell(paste0(startstr, dirStr,"/", paste0("\"pohub ",theName,".html\"")))

