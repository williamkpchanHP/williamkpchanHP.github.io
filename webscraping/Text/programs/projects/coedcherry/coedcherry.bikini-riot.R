# https://www.coedcherry.com/paysite/bikini-riot?page=8 1~8
setwd("C:/Users/user/mpg/Text/programs/projects/coedcherry")
totalpages = 8
pageHeader="https://www.coedcherry.com/paysite/bikini-riot?page="
lineSig = 'div class="wrapper'
projTitle = "coedcherry.bikini-riot"

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