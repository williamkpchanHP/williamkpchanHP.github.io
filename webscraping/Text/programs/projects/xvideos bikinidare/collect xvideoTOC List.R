# http://www.xvideos.com/?k=bikini+dare
# http://www.xvideos.com/?k=bikini+dare&p=83

setwd("C:/Users/user/mpg/Text/programs/projects/xvideos bikinidare")
totalpages = 83
pageHeader="http://www.xvideos.com/?k=bikini+dare&p="
lineSig = 'div class="thumb-inside'
projTitle = "xvideos bikinidare"

thepage = readLines("http://www.xvideos.com/?k=bikini+dare")
linenum = grep(lineSig, thepage)
theWholepage = thepage[linenum]

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