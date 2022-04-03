# http://www.tubebikini.com/search/bikini+dare/1 ~ 12

setwd("C:/Users/user/mpg/Text/programs/projects/tubebikini")
totalpages = 12
projTitle = "tubebikini"
URLHeader ="http://www.tubebikini.com/search/bikini+dare/"
ctnStart = "bannersearch"
ctnEnd = 'div class="pagination"'

theWholepage = ""
for (page in 1:totalpages){
    cat(" ", page)
    thepage = readLines(paste0(URLHeader ,page))
    headlinenum = grep(ctnStart, thepage)  # chop head
    thepage = thepage[-(1:headlinenum)]

    taillinenum=grep(ctnEnd, thepage)  # chop tail
    thepage = thepage[-(taillinenum:length(thepage))]
    theWholepage = c(theWholepage , thepage)
}
sink(paste0(projTitle, " TOC.txt"))
cat(theWholepage, sep="\n")
sink()

#======