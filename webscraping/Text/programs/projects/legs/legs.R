# last page:
# http://www.between-legs.com/298
# main directory thumb image
# http://www.between-legs.com/content/galleries/65/7165/thumbs/011.jpg
# destination image: 011-016
# http://www.between-legs.com/content/galleries/65/7165/full/015.jpg

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping"
setwd(dirStr)

theFilename = "leg.html"
theHeader = "http://www.between-legs.com/"

newpage = ""

for(i in 185:298){
	cat(i, " ")
	theURL = paste0(theHeader, i)
	thepage = readLines(theURL, warn = F)
   	newpage = c(newpage, thepage)
}
sink(theFilename)
cat(newpage, sep = "\n")
sink()
