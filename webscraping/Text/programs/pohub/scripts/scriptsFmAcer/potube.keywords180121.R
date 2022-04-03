dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts"
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

#https://www.porntube.com/search?q=persia-monir&p=5
MakeKey <- function(Selection){
	searchHead = 'https://www.porntube.com/search?q='
	return(paste0(searchHead, Selection))
}

# http://www.pornhub.com/video/search?search=busty+mom&page=1
# http://www.pornhub.com/video/search?search=busty+mom&page=10

splitkey= 'div class="col thumb_video"'

seekkey = 'view_video.php\\?viewkey='
removkey = 'class="img"'

boilPages <- function(searchKey){
	theWholePage = character(0)

	for(i in 1:thenum){
	cat(i,". ")
	thepage=readLines(paste0(MakeKey(thekeyword), "&p=", i))
	thepage = thepage[2]
	thepage = unlist(strsplit(thepage,splitkey))
	thepage = thepage[-1]
	thepage = gsub('.*/button>' , '', thepage)  
	thepage = gsub('<a href=\"' , '<a href=\"https://www.porntube.com', thepage)  
	thepage = gsub('><a href=\"' , '\n<a href=\"', thepage)  
	thepage = gsub(' class=\"thumb-link\" title.*div class=\"thumb\">' , '>', thepage)  
	thepage = gsub(' data-original.*' , '>', thepage)  
	thepage = gsub('data-master' , 'src', thepage)  
	thepage = gsub('</li>.*' , '', thepage)  
	thepage = gsub('<ul class.*' , '', thepage)  

	theWholePage = c(theWholePage, thepage)
	}

#	thekeyword <<- iconv(thekeyword, to = "ASCII", sub = "cx")

	sink(paste0(thekeyword," potub", ".html"))
	cat("<base target=_blank>\n<style>html {height: 100%; overflow: scroll;}::-webkit-scrollbar { width: 0px; background: transparent;}body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;    color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(theWholePage, sep="\n")
	sink()
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
shell(paste0(startstr, dirStr,"/", paste0("\"",thekeyword," potub",".html\"")))
# http://www.pornhub.com/pornstars?page=15
# http://www.pornhub.com/video?c=96&page=10
