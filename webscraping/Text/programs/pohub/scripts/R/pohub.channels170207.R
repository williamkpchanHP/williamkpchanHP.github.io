# http://www.pornhub.com/channels/auntjudys/videos?o=ra&page=18

dirStr = "C:/Users/user/mpg/Text/programs/pohub"
setwd(dirStr)

askforKey <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter key words: ")
	if(Selection != "")   {
	  	Selection = gsub(" ", "+", Selection)
  	}
	return(Selection)		# if empty, calling program handle
}

askforNum <-function(){		
	Selection = readline(prompt="enter max number of page: ")
	return(Selection)		# if empty, calling program handle
}

MakeKey <- function(Selection){
	searchHead = 'http://www.pornhub.com/channels/'
	theURL = paste0(searchHead, Selection)
}

# http://www.pornhub.com/video/search?search=busty+mom&page=1
# http://www.pornhub.com/video/search?search=busty+mom&page=10

pageHead = '<div class="widgetContainer">'
pageTail = '<div class="pagination3">'
seekkey = 'view_video.php\\?viewkey='
removkey = 'class="img"'

boilPages <- function(searchKey){
	theWholePage = character(0)

	for(i in 1:thenum){
	    cat(i,". ")
	    thepage=readLines(paste0(MakeKey(thekeyword), "/videos?o=ra&page=", i))
	    thepage = chopHead(thepage, pageHead)
	    thepage = chopTail(thepage, pageTail)
	    thepage = gsub('\t' , '', thepage) 
	    thepage = seekforkey(thepage, seekkey)
	    thepage = removekey(thepage, removkey)
	    theWholePage = c(theWholePage, boilit(thepage))
	}
	sink(paste0("pohub ",thekeyword,".html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;    color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(theWholePage, sep="\n")
	sink()

}

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)  # chop head
    return(thepage[-(1:headlinenum)])
}

chopTail <- function(thepage, pageHead){
    taillinenum = grep(pageTail, thepage)  # chop tail
    return(thepage[-(taillinenum[1]:length(thepage))])
}

seekforkey <- function(thepage, seekkey){
    targetlinenum = grep(seekkey, thepage)
    thepage = thepage[targetlinenum]
}

removekey <- function(thepage, removkey){
    targetlinenum=grep(removkey, thepage)
    thepage = thepage[-targetlinenum]
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
thekeyword = askforKey()
if(thekeyword == ""){
	break
}
thenum = 10
asknum = askforNum()
if(asknum != "")   {
	thenum = as.numeric(asknum)
}
boilPages()
startstr="start chrome.exe --start-fullscreen \""
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0("\"pohub ",thekeyword,".html\"")))

# http://www.pornhub.com/pornstars?page=15
# http://www.pornhub.com/video?c=96&page=10
