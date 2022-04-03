
dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts"
setwd(dirStr)

askforURL <-function(){
	Selection = readline(prompt="enter Batch Filename without extension: ")
	return(Selection)		# if empty, calling program handle
}

pageHead = 'ul class="videos row-5-thumbs search-video-thumbs" id=' 
pageTail  = '<form autocomplete="off" action'
seekkey = '<li class="js-pop videoblock videoBox" id='
imgkey = '<textarea name="caption" placeholder'

boilListPages <- function(theURL){

	thepage = readLines(theURL, warn = F)
	thepage = chopHead(thepage, pageHead)
	thepage = chopTail(thepage, pageTail)
	thepage = gsub('\t' , '', thepage) 

	thepage = seekforkey(thepage)
	thepage = gsub('.*wkey=', '<a href ="https://www.pornhub.com/embed/', thepage)
	thepage = gsub('&pkey.*>', '">', thepage)  
	thepage = gsub('.*data-image' , '<img src', thepage)  
	thepage = gsub('.*data-mediumthumb' , '<img src', thepage)  
	thepage = gsub('jpg.*' , 'jpg"></a>', thepage)
	return(thepage)
}

seekforkey <- function(thepage){
	linenum = grep(seekkey, thepage)
	linenum = sort(c(linenum + 7, linenum + 12))
	thepage = thepage[linenum]
}


chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)  # chop head
	return(thepage[-(1:headlinenum)])
}

chopTail <- function(thepage, pageTail){
    taillinenum = grep(pageTail, thepage)  # chop tail
    if(length(taillinenum)== 0){
    	taillinenum = 0
    }
    return(thepage[-(taillinenum[1]:length(thepage))])
}

# =========
# entry point
thefileName = askforURL()
if(thefileName == ""){
	break
}
thefile = paste0(thefileName, ".txt")
theList = readLines(thefile, warn = F)
lentheList = length(theList)

wholeData = ""
for(i in 1:lentheList){
	cat(i, " ")
	wholeData = c(wholeData, boilListPages(theList[i]))
}
#	wholeData = sort(unique(wholeData)) this cause problem
	sink(paste0(thefileName,".html"))
	cat("<base target=_blank>\n")
	cat("<style>html {height: 100%; overflow: scroll;}::-webkit-scrollbar { width: 0px; background: transparent;}body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;    color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")

	cat(wholeData, sep="\n")
	sink()

	startstr="start chrome.exe --start-fullscreen \""
	# note to quote the long filename
	shell(paste0(startstr, dirStr,"/", paste0("\"",thefileName,".html\"")))
