#http://www.tacamateurs.com/refer/devlynn-wears-green/3185/000616/tgp4/
#<a href="/tgps/
#website will detect frequent connection
setwd("C:/Users/user/mpg/Text/programs/projects/pussymoms/")

pageList = readLines("tacamateursMomSpreadList.txt")
totalpages = length(pageList)
template = readLines("Template.html")

lineSig = '<a href="/tgps/'
projTitle = "tacamateursMomSpread"

theWholepage = ""
for (page in 1:15){
	cat("\n", page)

	thepage = readLines(pageList[page])
	linenum = grep(lineSig, thepage)
	thepage = thepage[linenum]
	thepage = gsub('.*href', "<img src", thepage)

	theWholepage = c(theWholepage , thepage)
}
	sink(paste0(projTitle, "P 1.html"))
	cat(template, sep="\n")
	cat(theWholepage, sep="\n")
	sink()
#======
for (page in 16:totalpages){
	cat("\n", page)

	thepage = readLines(pageList[page])
	linenum = grep(lineSig, thepage)
	thepage = thepage[linenum]
	thepage = gsub('.*href', "<img src", thepage)

	theWholepage = c(theWholepage , thepage)
}
	sink(paste0(projTitle, "P 2.html"))
	cat(template, sep="\n")
	cat(theWholepage, sep="\n")
	sink()
