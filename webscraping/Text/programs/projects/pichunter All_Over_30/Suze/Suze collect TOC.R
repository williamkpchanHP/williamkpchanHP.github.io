# pichunter All_Over_30
# http://www.pichunter.com/sites/all/Suze/10
# <a class="thumb" 

setwd("C:/Users/user/mpg/Text/programs/projects/pichunter All_Over_30/Suze")
totalpages = 10
pageHeader="http://www.pichunter.com/sites/all/Suze/"
lineSig = '<a class="thumb"'
projTitle = "Suze"

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