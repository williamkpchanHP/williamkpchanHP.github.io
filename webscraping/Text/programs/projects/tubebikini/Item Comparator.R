setwd("C:/Users/user/mpg/Text/programs/projects/tubebikini")
theChkList = readLines("checklist.txt")
theDataList = readLines("tubebikini TOC.txt")
totalpages = length(theChkList)
theStat = ""
sink("tubebikini TOC Stat.txt")
for (catLine in 1:totalpages){
	findout = grep(theChkList[catLine], theDataList)
	cat("\n", theChkList[catLine], "\t", length(findout))
}
sink()
#======