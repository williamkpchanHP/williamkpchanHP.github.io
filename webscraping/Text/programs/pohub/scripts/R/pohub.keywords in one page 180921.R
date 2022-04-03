dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

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

MakeKey <- function(Selection){
# https://www.pornhub.com/video/search?search=spread+pussy+close+up
# https://www.pornhub.com/video/search?search=spread+pussy+close+up&page=2
	searchHead = 'https://www.pornhub.com/video/search?search='
	return(paste0(searchHead, Selection))
}

seekkey = 'data-mediumthumb='
theWholePage = character(0)

boilPages <- function(searchKey){
	for(i in 1:thenum){
	    cat(i," ")
	    if(i%%100 == 0){
		cat("\n")
	    }
		thepage = readLines(paste0(MakeKey(thekeyword), "&page=", i))
		thepage = gsub('\t' , '', thepage)
		thepage = seekforkey(thepage, seekkey)
		thepage = gsub('.*viewkey=">' , '<a href ="https://www.pornhub.com/embed/', thepage)  
		thepage = gsub(' title=".*>' , '>', thepage)  
		thepage = gsub('.*data-mediumthumb' , '<img src', thepage)  
		thepage = gsub('jpg.*' , 'jpg"></a>', thepage)  
		theWholePage <<- c(theWholePage, boilit(thepage))
	}
	sink(paste0(thekeyword, ".html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;	color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(theWholePage, sep="\n")
	sink()
}


seekforkey <- function(thepage, seekkey){
	linenum = grep(seekkey, thepage)
	linenum = sort(c(linenum, linenum - 6))
	thepage = thepage[linenum]
}

boilit <- function(thepage){
	rplword = '/view_video.php\\?viewkey='
	substword = 'https://www.pornhub.com/embed/'
	thepage = gsub(rplword, substword, thepage)
	thepage = gsub(' title=.*\">' , '>', thepage)  
	return(paste0(thepage,"\n"))
}

# =========
# entry point
Sys.setlocale(category = "LC_ALL", locale = "chs")

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
# shell(paste0(startstr, dirStr,"/", paste0(thekeyword," P 1.html\"")))
# http://www.pornhub.com/pornstars?page=15
# http://www.pornhub.com/video?c=96&page=10
