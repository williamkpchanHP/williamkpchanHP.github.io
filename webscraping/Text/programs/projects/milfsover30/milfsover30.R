# http://milfsover30.com/page/3/ ~27
# http://cdn.milfsover30.com/wp-content/uploads/2017/02/vel0010390062690011-230x345.jpg
# http://cdn.milfsover30.com/wp-content/uploads/2017/02/vel001039006269001-195x260.jpg
# http://cdn.milfsover30.com/wp-content/uploads/2017/02/vel001039006269001.jpg

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping"
setwd(dirStr)

theFilename = "milfsover30.html"
theHeader = "http://milfsover30.com/page/"

newpage = ""

for(i in 1:27){
	cat(i, " ")
	theURL = paste0(theHeader, i)
	thepage = readLines(theURL, warn = F)
   	newpage = c(newpage, thepage)
}
sink(theFilename)
cat(newpage, sep = "\n")
sink()
