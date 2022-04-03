#scrape according to a list, remember to change name parameters

Sys.setlocale(category = 'LC_ALL', 'Chinese')	# this must be added to script to show chinese
dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts/shame"
setwd(dirStr)

pageHead = "<h1"
pageTail = "<!-- End Content -->"

notchH = '<div style="text-align:center;padding:10px;">'
notchT = "</div></div><div class='title'></div>"

theFilename = "shameSinglePageList.html"
theExtractList = "shameStdList.txt"

tocpage = readLines(theExtractList, warn = F)
lentocpage = length(tocpage)

newpage = ""

chopHead <- function(thepage, pageHead){
	headlinenum = grep(pageHead, thepage, ignore.case=TRUE)
	return(thepage[-(1:(headlinenum-1))])
}

chopTail <- function(thepage, pageTail){
    taillinenum = grep(pageTail, thepage)  # chop tail
	if(length(taillinenum) != 0){
	    return(thepage[-((taillinenum+1):length(thepage))])
	} else {
		return("")
	}
}

chop_notch <- function(thepage, notchH, notchT){
	notchHlinenum = grep(notchH, thepage, ignore.case=TRUE)
	notchTlinenum = grep(notchT, thepage, ignore.case=TRUE)
	return(thepage[-(notchHlinenum:notchTlinenum)])
}


for(i in 1:lentocpage){
	cat(i, " ")
	theURL = tocpage[i]
	thepage = readLines(theURL, warn = F)
   	thepage = chopHead(thepage, pageHead)
   	thepage = chopTail(thepage, pageTail)
#   	thepage = chop_notch(thepage, notchH, notchT)
   	newpage = c(newpage, thepage)
}

dirStr = "C:/Users/user/mpg/Text/programs/pohub"
setwd(dirStr)

sink(theFilename)
cat(newpage, sep = "\n")
sink()

startstr="start chrome.exe --start-fullscreen \""
# note to quote the long filename
shell(paste0(startstr, dirStr,"/", theFilename))

dirStr = "C:/Users/user/mpg/Text/programs/pohub/scripts/shame"
setwd(dirStr)

#
#add lf and <br>
#<span
#add lf
#<div class="icnt">
#add lf
#<div class="bg anmt">
#remove <div class="bg anmt"> whole line
#locate <nav class='pagination'>
#remove 18 lines
#locate <h1 itemprop="name">
#remove 4 lines


#remove class="icnt"
# itemprop="url"
# class="img"
# itemprop="name"

# onmouseover="KT_rotationStart.*"

#add after</a>
#</div>

#add page header
