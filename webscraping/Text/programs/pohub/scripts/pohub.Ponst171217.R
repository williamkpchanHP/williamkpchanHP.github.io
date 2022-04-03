# http://www.pornhub.com/pornstar/gianna-michaels
# http://www.pornhub.com/pornstar/gianna-michaels?page=1
# https://www.pornhub.com/pornstar/darla-crane
# seekkey = 'data-mediumthumb='

# view_video.php?viewkey
# 2530 - 2535

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)
cat("dir: ", dirStr,"\n")
cat("key words space will be replaced by '-'' \n")
askforKey <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="Enter the name: ")
  	Selection = gsub(" ", "-", Selection)
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
seekkey = '<div class="img fade fadeUp videoPreviewBg">'

boilPages <- function(searchKey){
	theWholePage = character(0)

	for(i in 1:thenum){
		cat(i,". ")
		thepage=readLines(paste0(MakeKey(thekeyword), "\\?page=", i))
		thepage = gsub('\t' , '', thepage) 
		linenum = grep(seekkey, thepage)

		theImgLine = thepage[linenum +3]
		theImgLine1 = thepage[linenum +4]
		theImgpage = paste0(theImgLine,theImgLine1)
		theApage = thepage[linenum+1]

		theApage = gsub('.*viewkey=">' , '<a href ="https://www.pornhub.com/embed/', theApage)  
		theApage = gsub(' title=".*>' , '>', theApage)
		theImgpage = gsub('.*<img' , '<img', theImgpage)  
		theImgpage = gsub('jpg.*' , 'jpg"></a>', theImgpage)
		theImgpage = gsub('                    ' , ' ', theImgpage)

		thepage = paste0(theApage,theImgpage)
#<a href="/view_video.php?viewkey=ph589b342e0fe95" title="Horny Mom Gives Son-in-Law a Lesson" class="img" data-related-url="/video/ajax_related_video?vkey=ph589b342e0fe95" >
#data-mediumthumb="https://ci.phncdn.com/videos/201702/08/105376592/original/(m=ecuK8daaaa)6.jpg"

# <a href ="https://www.pornhub.com/embed/1048321684">1048321684</a><br>


		theWholePage = c(theWholePage, boilit(thepage))
	}
	sink(paste0(thekeyword,".html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;	color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")
	cat(theWholePage, sep="\n")
	sink()

}

seekforkey <- function(thepage, seekkey){
	linenum = grep(seekkey, thepage)
	linenum = sort(c(linenum, linenum - 5))
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
cat(paste0(startstr, dirStr,"/", paste0(thekeyword,".html\"")))
shell(paste0(startstr, dirStr,"/", paste0(thekeyword,".html\"")))
