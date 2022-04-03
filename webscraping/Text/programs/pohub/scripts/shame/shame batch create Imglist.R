# ==========
# functions

readkey = function(){
	key = ""
	while(is.na(suppressWarnings(as.numeric(key)))){
		key = readline(prompt="Enter your choice: ")
		if(key == "as.raw(27)") {break}
	}

	return(strtoi(key))
}

askforFile <-function(){

	cat("\nAvailable Lists.\n")
	cat("==========================\n\n")

	for(listNo in 1:length(mainMenu)){
		cat(listNo, mainMenu[listNo], "\n")
	}

	keyin <- length(mainMenu) +1

	while(keyin >length(mainMenu) | keyin<1){
		cat("\nSelect the list you want to run: \n")
		keyin <- readkey()
	}

	cat("\n\nSelected: ", mainMenu[keyin],"\n\n")

	theSeleted = paste0(mainMenu[keyin], ".txt")
	return(theSeleted)
}

pause = function(){
	if (interactive())
	{
		invisible(readline(prompt = "Press <Enter> to continue..."))
	}
	else
	{
		cat("Press <Enter> to continue...")
		invisible(readLines(file("stdin"), 1))
	}
}

# ==========
# init entry point

mainMenu = c("boobimglist", "titsImgList", "pusImgList")
maxImgNum = 101

dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts/shame"
setwd(dirStr)

theFile = askforFile()
if(theFile == ""){
	break
}

theList = readLines(theFile, warn = F)
lentheList = length(theList)

v <- 1:lentheList
v <- sample(v)

theList = theList[v]

for(file in 1:length(theList)){
	theURL = theList[file]
	thewordlist = unlist(strsplit(theURL, "/"))
	thelast = thewordlist[length(thewordlist)]
	theHead = gsub(thelast, "", theURL)

	theName = paste0(thewordlist[length(thewordlist)-2],thelast)

	sink(paste0(theName,".html"))
	cat('<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"><style>html { overflow: scroll;}::-webkit-scrollbar { width: 0px; background: transparent; }body { margin: auto; width: 100%; background-color: #000000; color: #20C030;}img { width: 600px; position: absolute; top: 0px; left:0; margin:0 auto; opacity:0; animation: imgOut 2s;}@keyframes imgOut {0% {opacity:0;} 2% {opacity:1;} 98% {opacity:1;}}100% {opacity:0;}}</style><script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script></head><body><center>\n')
	for(i in 1:maxImgNum){
		cat(paste0("<img src='",theHead,i,".jpg'>\n"))
	}
	cat('<script>$(document).ready(function(){$("img").each(function(i) {var thisImg = $(this);timelag= i * 2 + "s";thisImg.css("animation-delay", timelag);});});</script>\n')
	sink()
	cat(theName)
	startstr="start chrome.exe --start-fullscreen \""
	shell(paste0(startstr, dirStr,"/", paste0("\"",theName,".html\"")))
	pause()
}

