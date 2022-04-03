
# the javascript can only work for same paysite!!!
# https://www.coedcherry.com/paysite/ftv-milfs?page=4 1~4
# https://content4.coedcherry.com/ftv-milfs/148439/content_015jpg

setwd("C:/Users/user/mpg/Text/programs/projects/coedcherry")
totalpages = 4
pageHeader = "https://www.coedcherry.com/paysite/ftv-milfs?page="
lineSig = 'div class="wrapper'
projTitle = "coedcherryftv-milfs"

theWholepage = ""
for (page in 1:totalpages){
    cat(" ", page)
    thepage = readLines(paste0(pageHeader,page))
    linenum = grep(lineSig, thepage)
    thepage = thepage[linenum]
    theWholepage = c(theWholepage , thepage)
}
sink(paste0(projTitle, "Toc.html"))
cat(theWholepage, sep="\n")
sink()

#======