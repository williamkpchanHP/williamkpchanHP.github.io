# https://www.pornhub.com/channels?o=rk
# https://www.pornhub.com/channels?o=rk&page=67

# seekkey = 'div class="imgWrapper'

# +1	ahref
# +2	img
# <div class="imgWrapper">
# 		<a href="/channels/charlee-chase">
# 			<img src="https://bi.phncdn.com/pics/users/037/249/441/cover1406260895/(m=eOfacbaxcWaKb)(mh=AXuLNouk7U023aLa)1323x270.jpg" />

dirStr = "C:/Users/user/mpg/Text/programs/pohub"
setwd(dirStr)

askforKey <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="Enter the name: ")
  	Selection = gsub(" ", "-", Selection)
	return(Selection)		# if empty, calling program handle
}

askforNum <-function(){		
	Selection = readline(prompt="enter max number of page: ")
	return(Selection)		# if empty, calling program handle
}


seekkey = 'div class="imgWrapper'

boilPages <- function(searchKey){
	theWholePage = character(0)

	for(i in 1:67){
		cat(i,". ")
		thepage = readLines(paste0("https://www.pornhub.com/channels?o=rk&page=", i))
		thepage = gsub('\t' , '', thepage) 
		thepage = seekforkey(thepage, seekkey)
		thepage = gsub('jpg.*' , 'jpg"></a>', thepage)  
		theWholePage = c(theWholePage, boilit(thepage))
	}
	sink(paste0("pohub AllChannels.html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;	color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(theWholePage, sep="\n")
	sink()

}

seekforkey <- function(thepage, seekkey){
	linenum = grep(seekkey, thepage)
	linenum = sort(c(linenum + 1, linenum + 2))
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
boilPages()
startstr="start chrome.exe --start-fullscreen \""
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0("\"pohub AllChannels.html\"")))
