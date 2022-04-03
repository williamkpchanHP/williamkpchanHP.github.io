# chop file into many block files

library(crayon)
cat(yellow(format(Sys.time(), "%H:%M:%OSs"),"\n"))
library(rvest)

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts/R"
setwd(dirStr)

htmlHeader = readLines("htmlHeader.html", warn = F)
htmlTail = readLines("htmlTail.html", warn = F)

outDirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(outDirStr)

cat(red("\n\n\nTo chop big file to small files!\n\n"))
dataFile = readLines(readline(prompt="enter data filename: "), warn = F)
outFile = readline(prompt="enter output filename without extension: ")
outputPageNum = readline(prompt="enter number of pages to output: ")
outputPageNum = as.numeric(outputPageNum)

dataLength = length(dataFile)
blockSize = dataLength %/% outputPageNum

for(i in 0:(outputPageNum-1)){
   if(i != (outputPageNum-1)){
     block = dataFile[(i*blockSize+1):((i+1)*blockSize)]
   }else{
     block = dataFile[(i*blockSize+1):dataLength]
   }
     outfileName = paste0(outFile,i,".html")
# debug code to check details
#cat("\n",i, (i*blockSize+1), ((i+1)*blockSize), length(block))
	sink(outfileName)
	cat(htmlHeader, sep="\n")
	cat(block, sep="\n")
	cat(htmlTail, sep="\n")
	sink()
     cat(pink("\n",outfileName, "completed!"))
}
