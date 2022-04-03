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
	cat('<!DOCTYPE html><head><meta charset="utf-8"><title>shuffle images</title><script src="http://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script><style>body {  background-color: black;}html {height: 100%;  overflow:   scroll;}::-webkit-scrollbar {    width: 0px;    background: transparent; /* make scrollbar transparent */}body { margin: auto; width: 100%; background-color: #000000; color: #20C030;}img { width: 700px; display: block; margin-left: auto; margin-right: auto;}</style></head><body onkeypress="chkKey()"><div class="imagearea"> </div><script>\nfunction chkKey() {  var testkey = getChar(event);\n  if(testkey == "b"){ backward();\n}  if(testkey == "f"){ foreward();\n}  if(testkey == "p"){ pause();\n}  if(testkey == "c"){ continU();\n}}function getChar(event) {  if (event.which!=0 && event.charCode!=0) {    return String.fromCharCode(event.which) \n} else {    return null\n}}\nvar ImgList = [\n')

	for(i in 2:maxImgNum-1){
		cat(paste0('\'<img src="',theHead,i,'.jpg">\'',',\n'))
	}
	cat(paste0('\'<img src="',theHead,maxImgNum,'.jpg">\'\n'))

	cat('];\nvar listLen = ImgList.length, timer = 15000;\nfunction changeImg() { if (listLen < ImgList.length) {  listLen = listLen + 1;\n } else {  listLen = 0;\n };\n showImg();\n};\nfunction foreward() { if (listLen < ImgList.length) {  listLen = listLen + 1;\n  showImg();\n };\n}function backward() { if (listLen > 0) {  listLen = listLen - 1;\n  showImg();\n };\n}function pause() { clearInterval(myVar);\n}function continU() { myVar = setInterval(changeImg, timer);\n foreward();\n}function showImg() { var thePointerImg = document.querySelector(".imagearea");\n thePointerImg.innerHTML = ImgList[listLen];\n}changeImg();\nvar myVar = setInterval(changeImg, timer);\n</script></body></html>\n')
	sink()
	cat(theName)
	startstr="start chrome.exe --start-fullscreen \""
	shell(paste0(startstr, dirStr,"/", paste0("\"",theName,".html\"")))
	pause()
}

