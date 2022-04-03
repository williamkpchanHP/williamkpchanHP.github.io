setwd("C:/Users/user/mpg/Text/programs/projects/pinksMilfs")
totalpages = 100
theCatList = readLines("pinksMilfs P 47 stat.txt")
theChkList = readLines("pinksMilfs P 47.html")
theStat = ""
sink("pinksMilfs P 47 Stat.txt")
for (catLine in 1:totalpages){

	findout = grep(theCatList[catLine], theChkList)
	cat("\n", theCatList[catLine], "\t", length(findout))
}
sink()
#======