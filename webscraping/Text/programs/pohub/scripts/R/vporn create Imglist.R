
dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts/vporn"
setwd(dirStr)

maxImgNum = 75
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
theHead = paste0(gsub(thelast, "", theURL), "d")

theName = thelast
theHtml = paste0(thewordlist[length(thewordlist)-1],theName,".html")
sink(theHtml)
	cat('<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style>html { overflow: scroll;}::-webkit-scrollbar { width: 0px; background: transparent; }body { margin: auto; width: 100%; background-color: #000000; color: #20C030;}img { width: 500px; position: absolute; top: 0px; left:0; margin:0 auto; opacity:0; animation: imgOut 2s;}@keyframes imgOut {0% {opacity:0;} 2% {opacity:1;} 98% {opacity:1;}}100% {opacity:0;}}</style><script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script></head><body><center>\n')
for(i in 0:maxImgNum){
	cat(paste0("<img src='",theHead,(i*2+1),".jpg'>\n"))
}
	cat('<script>$(document).ready(function(){$("img").each(function(i) {var thisImg = $(this);timelag= i * 2 + "s";thisImg.css("animation-delay", timelag);});});</script>\n')
sink()
cat(theHtml)
startstr="start chrome.exe --start-fullscreen \""
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0("\"",theHtml,"\"")))


#https://th-us2.vporn.com/t/44/2166144/d64.jpg
