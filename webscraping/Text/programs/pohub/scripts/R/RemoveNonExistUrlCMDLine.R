# filter and remove non exist URL links
# read file
# seek for key <img
# 
# for loop
# extract url
# test exist
# if not exist mark the indexnumber
# 
# remove marks
# write back
args = commandArgs(trailingOnly=TRUE)

library(httr)
dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

seekkey = '<img'

# =========
# entry point
Sys.setlocale(category = "LC_ALL", locale = "chs")

theFileName = args[1]

thepage = readLines(theFileName)
linenum = grep(seekkey, thepage)
cat("total URL lines: ", length(linenum),"\n")

revoveList <- vector(mode="numeric", length=0)

for(i in 1:length(linenum)){
	cat(i," ")
	if(i%%100 == 0){
		cat("\n")
	}

	theline = thepage[linenum[i]]
	theUrl = gsub('.*src="' , '', theline)  
	theUrl = gsub('jpg.*' , 'jpg', theUrl)

	if(http_error(theUrl)){
		cat("\nURL not exist, line: ",linenum[i],"\n")
		revoveList = c(revoveList, i) # this is the i index, ie the linenum index
	}
}
thepage = thepage[-linenum[revoveList]]

cat("\ntotal removed lines:", length(revoveList))
sink(theFileName)
cat(thepage, sep="\n")
sink()
cat(" completed")
