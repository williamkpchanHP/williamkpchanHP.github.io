# http://www.tubebikini.com/search/bikini+dare/1 ~ 12

setwd("C:/Users/user/mpg/Text/programs/projects/tubebikini")
totalpages = 12
projTitle = "tubebikini"
URLHeader ="http://www.tubebikini.com/search/bikini+dare/"
linsig = '<img src="/videos'
template = readLines("Template.html")

theWholepage = ""
for (page in 1:totalpages){
	cat(" ", page)
	thepage = readLines(paste0(URLHeader ,page))
	linenum = grep(linsig, thepage)
	linenum = sort(c(linenum, linenum -1, linenum +1))
	thepage = thepage[linenum]
	theWholepage = c(theWholepage , thepage)
}
sink(paste0(projTitle, ".html"))
cat(template, sep="\n")
cat(theWholepage, sep="\n")
sink()

#======