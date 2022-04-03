setwd("C:/Users/user/mpg/Text/programs/projects/tubebikini")
theMPList = readLines("tubebikini Newest MP List.html")
theMPcontrol = readLines("tubebikini Newest MP control.txt")

totalpages = length(theMPList)
theStat = ""
sink("tubebikini MP Newest video.html")
cat("<base href=http://www.tubebikini.com/>\n")
for (catLine in 1:totalpages){
	thepage = paste0(theMPcontrol[catLine], theMPList[catLine],"</video>\n")
	cat(thepage)
}
sink()
