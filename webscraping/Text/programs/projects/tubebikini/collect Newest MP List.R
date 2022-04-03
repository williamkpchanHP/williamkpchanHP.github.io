setwd("C:/Users/user/mpg/Text/programs/projects/tubebikini")
theMPList = readLines("tubebikiniNewest list.txt")

totalpages = length(theMPList)
theStat = ""
sink("tubebikini MP List.html")
for (catLine in 1:totalpages){
	thepage = readLines(theMPList[catLine])
	findout = grep("<source type=", thepage)
	cat("\n", thepage[findout])
}
sink()
