# this is exactly same as xhamsterUsers.R, same to pornstar

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

theFilename = "british.html"
theWholepage = ""
	thepage = readLines(theFilename)
	thepage = gsub("<h2>", "'<h2>",thepage)
	firstline = seq(1, 167178, 4)
	secondline = firstline + 1
	thirdline = secondline + 1
	forthline = thirdline + 1
	theWholepage = paste0(thepage[forthline],thepage[firstline],thepage[secondline],thepage[thirdline],"',")

sink("temp.txt")
cat(theWholepage, sep = "\n")
sink()

#theHline = grep("<h2>",thepage)
#theHlineQ = theHline/4
#which(theHlineQ%%1!=0)
