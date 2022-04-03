
setwd("C:/Users/user/mpg/Text/programs/projects/pussymoms/")

pageList = readLines("momsfightforcockLst.txt")
totalpages = length(pageList)

template = readLines("Template.html")

lineSig = '<video '
projTitle = "momsfightforcock"

theWholepage = ""
for (page in 1:totalpages){
	cat(" ", page)
	thepage = readLines(pageList[page])
	linenum = grep(lineSig, thepage)

	thepage = thepage[linenum]
	theWholepage = c(theWholepage , thepage)
}
sink("momsfightforcockVidTOC.html")
cat(template, sep="\n")
cat(theWholepage, sep="\n")
sink()

#======