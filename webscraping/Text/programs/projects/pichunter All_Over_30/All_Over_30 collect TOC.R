# pichunter All_Over_30
# http://www.pichunter.com/sites/all/All_Over_30/120
# <a class="thumb" 

setwd("C:/Users/user/mpg/Text/programs/projects/pichunter All_Over_30")
totalpages = 120
pageHeader="http://www.pichunter.com/sites/all/All_Over_30/"
lineSig = '<a class="thumb"'
projTitle = "pichunter All_Over_30"

theWholepage = ""

for (page in 1:totalpages){
    cat(" ", page)
    thepage = readLines(paste0(pageHeader,page))
    linenum = grep(lineSig, thepage)
    linenum = sort(c(linenum, linenum+2))

    thepage = thepage[linenum]
    theWholepage = c(theWholepage , thepage)
}
sink(paste0(projTitle, "Toc.html"))
cat(theWholepage, sep="\n")
sink()

#======