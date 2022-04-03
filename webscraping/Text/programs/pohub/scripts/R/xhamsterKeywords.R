# ask for xhamster keyword and extract jpg

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

askforKey <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter key words: ")
	if(Selection != "")   {
	  	Selection = tolower(gsub(" ", "+", Selection))
  	}
	return(Selection)		# if empty, calling program handle
}

askforNum <-function(){		
	Selection = readline(prompt="enter max number of page: ")
	return(Selection)		# if empty, calling program handle
}

MakeKey <- function(Selection){
	searchHead = 'https://xhamster.com/search/photos?q='
	# another search header: 
	# https://xhamster.com/photos/search/beautiful+pierced+pussy

	return(paste0(searchHead, Selection))
}

seekkey = '<div class="thumb-list__item gallery-thumb">'
theWholePage = character(0)

boilPages <- function(searchKey){
	for(i in 1:thenum){
	    cat(i," ")
	    if(i%%100 == 0){
		cat("\n")
	    }

		thepage = readLines(paste0(MakeKey(thekeyword), "&p=", i))
		tagLines = seekforkey(thepage, seekkey)
		# total max 56 counts
		addressLines = tagLines + 1
		addressUrl = thepage[addressLines]
		addressUrl = gsub('.*href=' , '', addressUrl)
		addressUrl = gsub('>' , ',', addressUrl)

		countsLines = tagLines + 5
		countsNo = thepage[countsLines]
		countsNo = gsub('.*</i>' , '', countsNo)
		countsNo = as.numeric(gsub('</span>' , '', countsNo))
		pageCount = countsNo%/%60 + 1 # max 60 img per page, this is array

############ not finished
	#chophead: <div id="photo-slider">
	#<a href="https://thumb-p8.xhcdn.com/a/awrrJ1oMlnIn-nPREvFbaQ/000/298/238/778_1000.jpg" data-height="750" data-width="500" id="photo-298238778"></a>
	#choptail: <script type="text/javascript">window.dataPopUnder

		thenewpage = ""
		thepagelen = length(thepage)
		for(n in seq(1,thepagelen,2)){
			temp = paste0("'",thepage[n], thepage[n+1], "',")
			thenewpage = c(thenewpage, temp)
		}
		thepage = thenewpage 

		theWholePage <<- c(theWholePage, boilit(thepage))
	}

#	thekeyword <<- iconv(thekeyword, to = "ASCII", sub = "cx")

	sink(paste0(thekeyword,".html"))
	cat('<!DOCTYPE html>\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width"/>\n<title>shuffle Links</title>\n<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>\n<style>\nbody {background-color: black;}\nhtml {height: 100%;overflow: scroll;}\n::-webkit-scrollbar {width: 0px;background: transparent;}\nbody { margin: auto; width: 100%; background-color: #000000; color: #20C030;}\nimg { width: 50%; display: block; margin-left: auto; margin-right: auto;}\n</style>\n</head>\n<body onkeypress="chkKey()">\n<br><br><br><br><br>\n<div class="imagearea"> </div>\n<script>\nfunction chkKey() {\nvar testkey = getChar(event);\nif(testkey == "b"){ backward();}\nif(testkey == "f"){ foreward();}\nif(testkey == "p"){ pause();}\nif(testkey == "c"){ continU();}\nif(testkey == "s"){ showMov();}}\nfunction getChar(event){if (event.which!=0 && event.charCode!=0) {return String.fromCharCode(event.which)}\n else {return null}}\nvar ImgList = [\n')
	cat(theWholePage, sep="\n")
	cat(']\n var listLen = ImgList.length, timer = 15000\nfunction shuffle(array) { var i = ImgList.length, j = 0, temp\nwhile (i--) { j = Math.floor(Math.random() * (i+1))\ntemp = ImgList[i]\n ImgList[i] = ImgList[j]\n ImgList[j] = temp\n } \nreturn ImgList\n}\nImgList = shuffle(Array.from(Array(ImgList.length).keys()))\nfunction changeImg() { if (listLen >= ImgList.length - 1) { listLen = 0\n }\n else if (listLen < 0) { listLen = ImgList.length - 1\n } \nelse { listLen = listLen + 1\n }\nshowImg()\n}\nfunction backward() { listLen = listLen - 2\nchangeImg()\n}\nfunction foreward() { changeImg()\n}\nfunction pause() { clearInterval(myVar)\n}\nfunction continU() { myVar = setInterval(changeImg, timer)\n foreward()\n}\nfunction showImg() { var thePointerImg = document.querySelector(".imagearea")\n thePointerImg.innerHTML = ImgList[listLen]\n console.log(thePointerImg.innerHTML)\n}\nfunction showMov() { var imgAdr = ImgList[listLen]\n var start = imgAdr.indexOf("=")+1\n var end = imgAdr.indexOf(\'\"\', start+1)\n var list = imgAdr.substring(start+1, end)\n window.open(list)\n}changeImg()\nvar myVar = setInterval(changeImg, timer)\n</script></body></html>\n')
	sink()
}


seekforkey <- function(thepage, seekkey){
	linenum = grep(seekkey, thepage)
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
Sys.setlocale(category = "LC_ALL", locale = "chs")

thekeyword = askforKey()
if(thekeyword == ""){
	break
}

thenum = 10
asknum = askforNum()
if(asknum != "")   {
	thenum = as.numeric(asknum)
} else{
	thenum = 10
}
boilPages()
startstr="start chrome.exe --start-fullscreen "
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0(thekeyword,".html\"")))
# shell(paste0(startstr, "\"file:///",dirstr, outputfileName,"\""))


# http://www.pornhub.com/pornstars?page=15
# http://www.pornhub.com/video?c=96&page=10
