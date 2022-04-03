
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
	page = page + 1
}
sink(paste0("lady-sonia All Img.html"))
cat(theWholepage, sep="\n")
sink()

#======