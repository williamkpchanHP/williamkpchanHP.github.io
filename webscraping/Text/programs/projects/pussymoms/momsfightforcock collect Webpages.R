
setwd("C:/Users/user/mpg/Text/programs/projects/pussymoms/")

pageList = readLines("momsfightforcockLst.txt")
totalpages = length(pageList)

template = readLines("Template.html")

lineSig = '<h2><a href="http://momsfightforcock.com'
projTitle = "momsfightforcock"

theWholepage = ""
for (page in 1:totalpages){
	cat(" ", page)
	thepage = readLines(pageList[page])
	linenum = grep(lineSig, thepage)
	linenum = sort(c(linenum, linenum+1))

	thepage = thepage[linenum]
	theWholepage = c(theWholepage , thepage)
}
sink("momsfightforcockTOC.html")
cat(template, sep="\n")
cat(theWholepage, sep="\n")
sink()

#======