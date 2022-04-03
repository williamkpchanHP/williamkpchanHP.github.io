# http://www.momshere.com/
# http://www.momshere.com/st/archives/archive0.shtml
# http://www.momshere.com/st/archives/archive19.shtml


dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/projects"
setwd(dirStr)

theFilename = "momshere.html"

URLHead = "http://www.momshere.com/st/archives/archive"
tocpage = character(0)

for (i in 1:20){
	tocpage[i] = paste0(URLHead, i, ".shtml")
}

lentocpage = length(tocpage)

newpage = ""

for(i in 1:lentocpage){
	cat(i, " ")
	theURL = tocpage[i]
	thepage = readLines(theURL, warn = F)
   	newpage = c(newpage, thepage)

}
theURL = "http://www.momshere.com/"
thepage = readLines(theURL, warn = F)
newpage = c(newpage, thepage)
sink(theFilename)
cat(newpage, sep = "\n")
sink()
