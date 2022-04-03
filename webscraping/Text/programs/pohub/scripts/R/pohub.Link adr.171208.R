
dirStr = "C:/Users/user/mpg/Text/programs/pohub"
setwd(dirStr)

askforURL <-function(){
	Selection = readline(prompt="enter URL: ")
	return(Selection)	# if empty, calling program handle
}

seekkey = '<div class="preloadLine"></div>'
imgkey = '<textarea name="caption" placeholder'

boilPages <- function(){

	thepage = readLines(theURL, warn = F)
	thepage = gsub('\t' , '', thepage) 

	theImg = grep(imgkey, thepage)
	theImg = thepage[theImg + 2]
	theembedURL = gsub('.*wkey=', '<a href ="https://www.pornhub.com/embed/', theURL)  
	theembedURL = paste0(theembedURL ,'">', theImg)  

	thepage = seekforkey(thepage)
	thepage = gsub('.*wkey=', '<a href ="https://www.pornhub.com/embed/', thepage)
	thepage = gsub(' title=".*>', '>', thepage)  
	thepage = gsub('.*data-image' , '<img src', thepage)  
	thepage = gsub('.*data-mediumthumb' , '<img src', thepage)  
	thepage = gsub('jpg.*' , 'jpg"></a>', thepage)  
	sink(paste0("pohub ",theName,".html"))
	cat("<base target=_blank>\n")
	cat("<style>body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;    color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}</style>\n")

	cat(theembedURL)
	cat(thepage, sep="\n")
	sink()

}


seekforkey <- function(thepage){
	linenum = grep(seekkey, thepage)
	linenum = sort(c(linenum + 4, linenum + 9))
	thepage = thepage[linenum]
}

# =========
# entry point
theURL = askforURL()
if(theURL == ""){
	break
}
theName = gsub(".*=", "",theURL)

boilPages()
startstr="start chrome.exe --start-fullscreen \""
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0("\"pohub ",theName,".html\"")))

