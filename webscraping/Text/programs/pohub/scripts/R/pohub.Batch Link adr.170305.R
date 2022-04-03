

dirStr = "C:/Users/user/mpg/Text/programs/pohub"
setwd(dirStr)

askforURL <-function(){
	Selection = readline(prompt="enter Batch Filename without extension: ")
	return(Selection)		# if empty, calling program handle
}

pageHead = 'relatedVideosVPage'
pageTail = 'under-player-comments'

seekkey = 'view_video.php\\?viewkey='
removkey = 'class="img"'

boilPages <- function(theURL){

	    thepage=readLines(theURL, warn = F)
	    thepage = chopHead(thepage, pageHead)
	    thepage = chopTail(thepage, pageTail)
	    thepage = gsub('\t' , '', thepage) 
	    thepage = seekforkey(thepage, seekkey)
	    thepage = removekey(thepage, removkey)
	    thepage = removekey(thepage, "<li>")
	    thepage = removekey(thepage, "urlShare")
	    thepage = removekey(thepage, "var flashvars")
	    
	    thepage = boilit(thepage)
	sink(paste0("pohub ",theName,".html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;    color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(thepage, sep="\n")
	sink()

}

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)  # chop head
    return(thepage[-(1:headlinenum)])
}

chopTail <- function(thepage, pageHead){
    taillinenum = grep(pageTail, thepage)  # chop tail
    if(length(taillinenum)== 0){
    	taillinenum = 0
    }
    return(thepage[-(taillinenum[1]:length(thepage))])
}

seekforkey <- function(thepage, seekkey){
    targetlinenum = grep(seekkey, thepage)

    return(thepage[targetlinenum])
}

removekey <- function(thepage, removkey){
    targetlinenum=grep(removkey, thepage)
    return(thepage[-targetlinenum])
}

boilit <- function(thepage){
	rplword = '/view_video.php\\?viewkey='
	substword = 'https://www.pornhub.com/embed/'
	thepage = gsub(rplword, substword, thepage)
	thepage = gsub(' title=.*\">' , '>', thepage)  
	return(paste0(thepage,"<br>\n"))
}

# =========
# entry point
thefile = askforURL()
if(thefile == ""){
	break
}
thefile = paste0(thefile, ".txt")
theList = readLines(thefile, warn = F)
lentheList = length(theList)

for(i in 1:lentheList){
	cat(i, " ")
	theName = gsub(".*=", "",theList[i])
	boilPages(theList[i])

	startstr="start chrome.exe --start-fullscreen \""
	# note to quote the long filename
	shell(paste0(startstr, dirStr,"/", paste0("\"pohub ",theName,".html\"")))

}
