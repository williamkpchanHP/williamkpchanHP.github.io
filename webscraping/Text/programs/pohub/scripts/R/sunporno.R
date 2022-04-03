https://www.sunporno.com/channels/233/japanese/
https://www.sunporno.com/channels/233/japanese/page186.html
<p class="btime">
+3 +5
            <p class="btime">03:10</p>
            
            <a
                href="https://www.sunporno.com/videos/83236/asian-fuck-hard-dick"
                class="com-link changeThumb"
                data-preview="1113/2_96640.mp4"
# https://jizzbunker.com/en/channel/big-tits/1256
# search for:
# <li><figure>  +1 +2
# <a href="https://jizzbunker.com/cn/juicy.html" class="img
# data-animation="https://v0.cdn3x.com/t/0000165604/p_0000165604_240_25_10_2.mp4"
# <video controls width="800"><source src="https://thumb-v9.xhcdn.com/a/sGIu0_hJehlSFBH2VXPuUA/006/635/349/240x135.t.mp4"></video>

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"

setwd(dirStr)

pageHead = 'https://jizzbunker.com/en/channel/pornstars/'
seekkey = '<li><figure>'

# https://jizzbunker.com/en/channel/sexy/460
# https://jizzbunker.com/en/channel/milf/1066
# https://jizzbunker.com/en/channel/lingerie/477

startNum = 1
endNum = 526
cat("\nTotal pages: ", (endNum-startNum), "\n")
filename = paste0("jizzbunkerPornstars",".html")
theWholePage = character(0)

	for(i in startNum:endNum){
		cat(i,". ")
		thepage = readLines(paste0(pageHead, i))
		linenum = grep(seekkey, thepage)

		thepage = paste0(thepage[linenum+1], thepage[linenum+2])
		thepage = gsub('.*href' , '\'<a href', thepage)
		thepage = gsub(' class.*data-animation' , '></a><video controls width="800"><source src', thepage)  
		thepage = gsub('mp4".*' , 'mp4"></video>\'\\,', thepage)  

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
