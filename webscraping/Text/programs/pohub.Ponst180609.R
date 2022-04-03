# http://www.pornhub.com/pornstar/gianna-michaels
# http://www.pornhub.com/pornstar/gianna-michaels?page=1
# https://www.pornhub.com/pornstar/darla-crane
# seekkey = 'data-mediumthumb='

# view_video.php?viewkey
# 2530 - 2535

dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts"
setwd(dirStr)


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
seekkey = 'data-mediumthumb='

boilPages <- function(searchKey){
	theWholePage = character(0)

	for(i in 1:thenum){
		cat(i,". ")
		thepage=readLines(paste0(MakeKey(thekeyword), "\\?page=", i))
		thepage = gsub('\t' , '', thepage) 
		thepage = seekforkey(thepage, seekkey)
		thepage = gsub('.*viewkey=">' , '<a href ="https://www.pornhub.com/embed/', thepage)  
		thepage = gsub(' title=".*>' , '>', thepage)  
		thepage = gsub('.*data-mediumthumb' , '<img src', thepage)  
		thepage = gsub('jpg.*' , 'jpg"></a>', thepage)  

		thenewpage = ""
		thepagelen = length(thepage)
		for(n in seq(1,thepagelen,2)){
			temp = paste0("'",thepage[n], thepage[n+1], "',")
			thenewpage = c(thenewpage, temp)
		}
		thepage = thenewpage 
#<a href="/view_video.php?viewkey=ph589b342e0fe95" title="Horny Mom Gives Son-in-Law a Lesson" class="img" data-related-url="/video/ajax_related_video?vkey=ph589b342e0fe95" >
#data-mediumthumb="https://ci.phncdn.com/videos/201702/08/105376592/original/(m=ecuK8daaaa)6.jpg"

# <a href ="https://www.pornhub.com/embed/1048321684">1048321684</a><br>


		theWholePage = c(theWholePage, boilit(thepage))
	}
	sink(paste0(thekeyword,".html"))
	cat('<!DOCTYPE html>\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width"/>\n<title>shuffle Links</title>\n<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>\n<style>\nbody {background-color: black;}\nhtml {height: 100%;overflow: scroll;}\n::-webkit-scrollbar {width: 0px;background: transparent;}\nbody { margin: auto; width: 100%; background-color: #000000; color: #20C030;}\nimg { width: 50%; display: block; margin-left: auto; margin-right: auto;}\n</style>\n</head>\n<body onkeypress="chkKey()">\n<br><br><br><br><br>\n<div class="imagearea"> </div>\n<script>\nfunction chkKey() {\nvar testkey = getChar(event);\nif(testkey == "b"){ backward();}\nif(testkey == "f"){ foreward();}\nif(testkey == "p"){ pause();}\nif(testkey == "c"){ continU();}\nif(testkey == "s"){ showMov();}}\nfunction getChar(event){if (event.which!=0 && event.charCode!=0) {return String.fromCharCode(event.which)}\n else {return null}}\nvar ImgList = [\n')
	cat(theWholePage, sep="\n")
	cat(']\n var listLen = ImgList.length, timer = 15000\nfunction shuffle(array) { var i = ImgList.length, j = 0, temp\nwhile (i--) { j = Math.floor(Math.random() * (i+1))\ntemp = ImgList[i]\n ImgList[i] = ImgList[j]\n ImgList[j] = temp\n } \nreturn ImgList\n}\nImgList = shuffle(Array.from(Array(ImgList.length).keys()))\nfunction changeImg() { if (listLen >= ImgList.length - 1) { listLen = 0\n }\n else if (listLen < 0) { listLen = ImgList.length - 1\n } \nelse { listLen = listLen + 1\n }\nshowImg()\n}\nfunction backward() { listLen = listLen - 2\nchangeImg()\n}\nfunction foreward() { changeImg()\n}\nfunction pause() { clearInterval(myVar)\n}\nfunction continU() { myVar = setInterval(changeImg, timer)\n foreward()\n}\nfunction showImg() { var thePointerImg = document.querySelector(".imagearea")\n thePointerImg.innerHTML = ImgList[listLen]\n console.log(thePointerImg.innerHTML)\n}\nfunction showMov() { var imgAdr = ImgList[listLen]\n var start = imgAdr.indexOf("=")+1\n var end = imgAdr.indexOf(\'\"\', start+1)\n var list = imgAdr.substring(start+1, end)\n window.open(list)\n}changeImg()\nvar myVar = setInterval(changeImg, timer)\n</script></body></html>\n')
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
startstr="start chrome.exe --start-fullscreen "
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", paste0(thekeyword,".html\"")))
