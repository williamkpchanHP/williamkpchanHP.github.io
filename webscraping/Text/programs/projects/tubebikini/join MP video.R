setwd("C:/Users/user/mpg/Text/programs/projects/tubebikini")
theMPList = readLines("tubebikini MP List.html")
theMPcontrol = readLines("tubebikini MP List control.html")

totalpages = length(theMPList)
theStat = ""
sink("tubebikini MP video.html")
for (catLine in 1:totalpages){
	thepage = paste0(theMPcontrol[catLine], theMPList[catLine],"</video><br>\n")
	cat(thepage)
}
sink()
