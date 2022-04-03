
dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

askforURL <-function(){
	Selection = readline(prompt="enter Batch Filename without extension: ")
	return(Selection)		# if empty, calling program handle
}

seekkey = '<div class="preloadLine"></div>'
imgkey = '<textarea name="caption" placeholder'

boilPages <- function(theURL){

	thepage = readLines(theURL, warn = F)
	thepage = gsub('\t' , '', thepage) 

	theImg = grep(imgkey, thepage)
	theImg = thepage[theImg + 2]
	theembedURL = gsub('.*wkey=', '<a href ="https://www.pornhub.com/embed/', theURL)  
	theembedURL = paste0(theembedURL ,'">', theImg, "</a>")  

	thepage = seekforkey(thepage)
	thepage = gsub('.*wkey=', '<a href ="https://www.pornhub.com/embed/', thepage)
	thepage = gsub(' title=".*>', '>', thepage)  
	thepage = gsub('.*data-image' , '<img src', thepage)  
	thepage = gsub('.*data-mediumthumb' , '<img src', thepage)  
	thepage = gsub('jpg.*' , 'jpg"></a>', thepage)
	thepage = c(theembedURL, thepage)
	return(thepage)
}


seekforkey <- function(thepage){
	linenum = grep(seekkey, thepage)
	linenum = sort(c(linenum + 4, linenum + 9))
	thepage = thepage[linenum]
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
	wholeData = c(wholeData, boilPages(theList[i]))
}
#	wholeData = sort(unique(wholeData)) this cause problem
	sink(paste0(thefileName,".html"))
	cat("<base target=_blank>\n")
	cat("<style>\nhtml {height: 100%; overflow: scroll;}\n::-webkit-scrollbar { width: 0px; background: transparent;}\nbody { font-size: 24px; background-color: #000000; color: #109030;}\na { text-decoration: none;    color: #28B8B8;}\na:visited { color: #389898;}\nA:hover {   color: yellow;}\nA:focus {   color: red;}\nimg {width:32%;}\n</style>\n")

	cat(wholeData, sep="\n")
	sink()

	startstr="start chrome.exe --start-fullscreen \""
	# note to quote the long filename
	shell(paste0(startstr, dirStr,"/", paste0("\"",thefileName,".html\"")))
