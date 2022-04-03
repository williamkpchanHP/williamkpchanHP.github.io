# https://xhamster.com/channels/61
# <div class="channel-thumb-container__image-container">
# <a href="https://xhamster.com/channels/girls-way/most-viewed" class="channel-thumb-container__image-container-image" style="background-image: url(https://thumb-v-cl2.xhcdn.com/a/rBJuMl_p9DXN52FYrlGoMQ/010/613/086/320x180.c.jpg.v1544106782)">

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

pageHead = 'class="channels-thumbs">'
pageEnd = '<div class="pager-section">'
itemSig = '<div class="channel-thumb-container__image-container">'

theWholepage = ""

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage)
	cat(" ", headlinenum[1])
	return(thepage[-(1:(headlinenum[1]))])
}

chopTail <- function(thepage, pageTail){
	taillinenum = grep(pageEnd, thepage)  # chop tail
	cat( " ", taillinenum[1], "\n")
	if(length(taillinenum) != 0){
		return(thepage[-((taillinenum[1]):length(thepage))])
	} else {
		return("")
	}
}

extractIt <- function(thepage){
	sigLine = grep(itemSig, thepage)
	theLine = sigLine + 1
     ahref = 
	thepage = gsub("    ","",thepage)
	thepage = gsub(' class="video-thumb__image-container thumb-image-container"',"",thepage)
	thepage = gsub(' data-sprite','><img src',thepage)
	thepage = gsub(' data-previewvideo',"><video autoplay controls><source src",thepage)
	thepage = gsub('t.mp4">','t.mp4"></video>',thepage)
	thepage = gsub('class="thumb-image-container__image" ',"",thepage)
	thepage = gsub(' onerror.*"',"",thepage)
	thepage = gsub('(<a class[^>]*>)','<h2>',thepage)
	edLines = grep("<h2>", thepage)
	thepage[edLines] = gsub('</a>','</h2>',thepage[edLines])
	rmvLines = grep("^$", thepage)
	thepage = thepage[-rmvLines]
	return(thepage)
}


askforAddr <-function(){		# "abc def" -> "abc+def"
	Selection = readline(prompt="enter address header: ")
	if(Selection == "")   { 
		cat("\nblank address! exited!\n")
		break
	}
	return(Selection)		# if empty, calling program handle
}

askforNum <-function(){		
	Selection = readline(prompt="enter max number of page: ")
	return(Selection)		# if empty, calling program handle
}

askforFilename <-function(){		
	Selection = readline(prompt="enter output filename without extension, press enter for default: ")
	if(Selection == "")   { 
		Selection = "result.html"
	}
	return(paste0(Selection,".html"))
}
askforAppendFile <-function(){		
	Selection = readline(prompt="do u want to append results? press enter if no: ")
	if(Selection == "")   { 
		theFilename = "result.html"
		file.rename(theFilename, paste0(format(Sys.Date(), format="%m%d")," ",format(Sys.time(), "%H%M")," ",theFilename))
	}	
}
pageHeader = askforAddr()
lentocpage = askforNum()
theFilename = askforFilename()
askforAppendFile()
cat("\nlentocpage: ",lentocpage,"\n")

for (page in 1:lentocpage){
	cat(" ", page)
	thepage = readLines(paste0(pageHeader, page))
	thepage = chopTail(chopHead(thepage, pageHead), pageEnd)
	theWholepage = c(theWholepage , thepage)
}
theWholepage = cleanUp(theWholepage)

write(theWholepage, theFilename, append=TRUE)
