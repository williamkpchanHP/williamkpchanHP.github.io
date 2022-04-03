# https://www.tubebikini.com/videos/newest/1/ ~108

setwd("C:/Users/user/mpg/Text/programs/projects/tubebikini")
totalpages = 108
projTitle = "tubebikiniNewest"
URLHeader ="https://www.tubebikini.com/videos/newest/"
ctnStart = "main-content page-content"
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