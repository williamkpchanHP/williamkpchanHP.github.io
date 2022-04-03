# https://www.girlsofdesire.org/Pussy/page/1/ ~ 68
setwd("C:/Users/user/mpg/Text/programs/projects/girlsofdesire")
totalpages = 68
pageHeader="https://www.girlsofdesire.org/Pussy/page/"
lineSig = 'width="200" height="300'

theWholepage = ""
for (page in 1:totalpages){
    cat(" ", page)
    thepage = readLines(paste0(pageHeader,page))
    linenum = grep(lineSig, thepage)
    thepage = thepage[linenum]
    theWholepage = c(theWholepage , thepage)
}
sink("girlsofdesire.html")
cat(theWholepage, sep="\n")
sink()

#======