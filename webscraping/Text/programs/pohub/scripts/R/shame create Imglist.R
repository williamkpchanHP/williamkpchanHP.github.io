
dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts/shame"
setwd(dirStr)

maxImgNum = 101
askforURL <-function(){
	Selection = readline(prompt="enter URL: ")
	return(Selection)	# if empty, calling program handle
}

# =========
# entry point
theURL = askforURL()
if(theURL == ""){
	break
}
thewordlist = unlist(strsplit(theURL, "/"))
thelast = thewordlist[length(thewordlist)]
theHead = gsub(thelast, "", theURL)

theName = thelast
sink(paste0("pohub ",theName,".html"))
cat("<style>html {overflow: scroll;}::-webkit-scrollbar {width: 0px;background: transparent;}body { font-size: 24px; background-color: #000000; color: #109030;}a { text-decoration: none;    color: #28B8B8;}a:visited { color: #389898;}A:hover {   color: yellow;}A:focus {   color: red;}img{width:800px;}</style>\n")
for(i in 1:maxImgNum){
	cat(paste0("<img src='",theHead,i,".jpg'>\n"))
}
sink()

startstr="start chrome.exe --start-fullscreen \""
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0("\"pohub ",theName,".html\"")))

