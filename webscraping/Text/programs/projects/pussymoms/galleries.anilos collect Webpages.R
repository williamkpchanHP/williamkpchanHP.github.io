#<a href="http://images.anilos.com/galleries/adriana_blue/anilos_pussy/adriana_blue-6_003.jpg">
setwd("C:/Users/user/mpg/Text/programs/projects/pussymoms/")

pageList = readLines("galleries.anilos.list.txt")
totalpages = length(pageList)
template = readLines("Template.html")

lineSig = 'http://images.anilos.com/galleries/'
projTitle = "anilosmomspread"

theWholepage = ""
for (page in 1:totalpages){
	cat("\n", page)

	thepage = readLines(pageList[page])
	linenum = grep(lineSig, thepage)
	thepage = thepage[linenum]
	thepage = unlist(strsplit(thepage, ">"))
	linenum = grep('<a href="http://images.anilos.com/galleries', thepage)
	thepage = thepage[linenum]
	thepage = paste0(thepage, ">")
	thepage = gsub('.*href', "<img src", thepage)

	theWholepage = c(theWholepage , thepage)
}
	sink(paste0(projTitle, " P ",page, ".html"))
	cat(template, sep="\n")
	cat(theWholepage, sep="\n")
	sink()
#======
