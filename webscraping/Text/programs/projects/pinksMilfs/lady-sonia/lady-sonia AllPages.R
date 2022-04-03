# http://www.pinksmilfs.com/page/7
# 15 x 5 pics
# 75 pages * 75 sets = 5625 sets
# 5625 sets * 15 imgs = 84375 addrs

setwd("C:/Users/user/mpg/Text/programs/projects/pinksMilfs/lady-sonia/")

tocList = readLines("lady-sonia toc.txt")
totalpages = length(tocList)

pageHead = "thumbsContainer"
pageTail = 'div class="clear'

theWholepage = ""
page = 1
while(page <= totalpages){
    cat(" ", page)
    thepage=readLines(tocList[page])
    headlinenum=grep(pageHead, thepage)  # chop head
    thepage=thepage[-(1:headlinenum)]

    taillinenum=grep(pageTail, thepage)  # chop tail
    thepage=thepage[-(taillinenum:length(thepage))]
    theWholepage = c(theWholepage , thepage)
    if(page%%12 == 0){
		sink(paste0("lady-sonia P ", page%/%12, ".html"))
		cat(theWholepage, sep="\n")
		sink()
		theWholepage = ""
	}
	page = page + 1
}
sink(paste0("lady-sonia P ", (page%/%12 + 1), ".html"))
cat(theWholepage, sep="\n")
sink()

#======