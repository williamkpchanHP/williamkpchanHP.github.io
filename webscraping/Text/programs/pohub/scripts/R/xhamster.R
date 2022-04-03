# xhamster searches gives 20 pages only
# https://xhamster.com/search?q=curvy+bodies&p=20
# 56 occurences
# search for:
# <a class="video-thumb__image-container thumb-image-container"
# since thumb video is included, use video without thumb img
# <a class="video-thumb__image-container thumb-image-container" href="https://xhamster.com/videos/curvy-karlie-simon-gives-a-fat-cock-a-pussy-ride-6635349" data-sprite="https://thumb-v9.xhcdn.com/a/T7vn1QCxKvis-gnrLn2dAg/006/635/349/240x135.s.jpg" data-previewvideo="https://thumb-v9.xhcdn.com/a/sGIu0_hJehlSFBH2VXPuUA/006/635/349/240x135.t.mp4">
# <video controls width="500"><source src="https://thumb-v9.xhcdn.com/a/sGIu0_hJehlSFBH2VXPuUA/006/635/349/240x135.t.mp4"></video>

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"

setwd(dirStr)

pageHead = 'https://xhamster.com/search?q=curvy+wife+angel+lynn+fucks+her+latina+twat+with+veggies&p='
seekkey = '<a class="video-thumb__image-container thumb-image-container"'

startNum = 1
endNum = 20
filename = paste0("curvyWife",".html")
theWholePage = character(0)

	for(i in startNum:endNum){
		cat(i,". ")
		thepage = readLines(paste0(pageHead, i))
		thepage = thepage[grep(seekkey, thepage)]
		thepage = gsub('.*href' , '\'<a href', thepage)
		thepage = gsub('data-sprite.*data-previewvideo' , '></a><video controls width="800"><source src', thepage)  
		thepage = gsub('mp4">' , 'mp4"></video>\'\\,', thepage)  

		theWholePage = c(theWholePage, thepage)
	}


pageHeader=c(
'<!DOCTYPE html>',
'<head>',
'<meta charset="utf-8">',
'<meta name="viewport" content="width=device-width"/>',
'<title>Hot Pussy</title>',
'<link rel="stylesheet" href="../projects/projcss.css">',
'<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5/jquery.js"></script>',
'<style>',
'html {height: 100%;overflow: scroll;}',
'::-webkit-scrollbar {width: 0px;background: transparent;}',
'body { margin: auto; width: 100%; background-color: #000000; color: #20C030;}',
'a { text-decoration: none; color: #28B8B8; font-size: inherit; background-color:transparent;-webkit-text-decoration-skip:objects}',
'a:visited { color: #389898;}',
'img { width: 50%; display: block; margin-left: auto; margin-right: auto;}',
'</style>',
'</head>',
'<body onkeypress="chkKey()">',
'<br><br><br>',
'<center>',
'<div class="imagearea"> </div>',
'<script>',
'function chkKey() {',
'var testkey = getChar(event);',
'if(testkey == "b"){ backward();}',
'if(testkey == "f"){ foreward();}',
'if(testkey == "p"){ pause();}',
'if(testkey == "c"){ continU();}',
'if(testkey == "s"){ showMov();}}',
'function getChar(event){if (event.which!=0 && event.charCode!=0) {return String.fromCharCode(event.which)}',
' else {return null}}',
'var ImgList = ['
)

pageTail=c(
']',
'var listLen = ImgList.length, timer = 15000;',
'function shuffle(array) { var i = ImgList.length, j = 0, temp;',
'while (i--) { j = Math.floor(Math.random() * (i+1));',
'temp = ImgList[i]; ImgList[i] = ImgList[j]; ImgList[j] = temp} ',
'return ImgList;}',
'ImgList = shuffle(Array.from(Array(ImgList.length).keys()))',
'function changeImg() { if (listLen >= ImgList.length - 1) { listLen = 0; }',
' else if (listLen < 0) { listLen = ImgList.length - 1;} ',
'else { listLen = listLen + 1}',
'showImg()}',
'function backward() { listLen = listLen - 2;changeImg()}',
'function foreward() { changeImg()}',
'function pause() { clearInterval(myVar)}',
'function continU() { myVar = setInterval(changeImg, timer); foreward()}',
'function showImg() { var thePointerImg = document.querySelector(".imagearea")',
' thePointerImg.innerHTML = ImgList[listLen]; console.log(thePointerImg.innerHTML)}',
'function showMov() { var imgAdr = ImgList[listLen]',
' var start = imgAdr.indexOf(\'="\')+1',
' var end = imgAdr.indexOf(\'"></a>\', start+1)',
' var list = imgAdr.substring(start+1, end)',
' console.log(list)',
' window.open(list)',
'}changeImg()',
'</script></body></html>'
)


	sink(filename)
	cat(pageHeader, sep="\n")
	cat(theWholePage, sep="\n")
	cat(pageTail, sep="\n")
	sink()
