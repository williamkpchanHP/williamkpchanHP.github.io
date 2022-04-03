# http://www.pornhub.com/pornstar/gianna-michaels
# http://www.pornhub.com/pornstar/gianna-michaels?page=1

dirStr = "C:/Users/user/mpg/Text/programs/pohub"
setwd(dirStr)

askforKey <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="Enter the name: ")
	if(Selection == "")   {
	  	Selection = gsub(" ", "+", Selection)
  	}
	return(Selection)		# if empty, calling program handle
}

askforNum <-function(){		
	Selection = readline(prompt="enter max number of page: ")
	return(Selection)		# if empty, calling program handle
}

MakeKey <- function(Selection){
	searchHead = 'http://www.pornhub.com/pornstar/'
	theURL = paste0(searchHead, Selection)
}


# pageHead = '<ul class="videos row-5-thumbs search-video-thumbs">'
pageHead = '<h2>Videos uploaded by'
pageHead2 = '<h2>Most Recent'
pageTail = '<div class="sectionWrapper">'
pageTail2 = '<div class="nf-wrapper">'
seekkey = 'view_video.php\\?viewkey='
removkey = 'class="img"'

boilPages <- function(searchKey){
	theWholePage = character(0)

	for(i in 1:thenum){
	    cat(i,". ")
	    thepage=readLines(paste0(MakeKey(thekeyword), "\\?page=", i))
	    thepage = chopHead(thepage, pageHead)
	    thepage = chopTail(thepage, pageTail,pageTail2)
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
	if(length(headlinenum==0)){
		headlinenum = grep(pageHead2, thepage)
	}
    return(thepage[-(1:headlinenum)])
}

chopTail <- function(thepage, pageTail,pageTail2){
    taillinenum = grep(pageTail, thepage)  # chop tail
    if(length(taillinenum==0)){
		taillinenum = grep(thepage2, thepage)
		taillinenum = taillinenum[2]
	}

    return(thepage[-(taillinenum:length(thepage))])
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
thenum = 1
asknum = askforNum()
if(asknum != "")   {
	thenum = as.numeric(asknum)
}
boilPages()
startstr="start chrome.exe --start-fullscreen \""
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0("\"pohub ",thekeyword,".html\"")))
