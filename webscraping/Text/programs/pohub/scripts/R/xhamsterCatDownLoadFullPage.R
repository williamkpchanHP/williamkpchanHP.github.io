# https://xhamster.com/photos/gallery/vaginas-11771386/17 1~17
# download all full pages
dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/pohub/scripts"
setwd(dirStr)

pageHeader="https://xhamster.com/photos/gallery/vaginas-11771386/"
theFilename = "vaginas.html"

lentocpage = 17

theWholepage = ""
cat("\nlentocpage: ",lentocpage,"\n")

for (page in 1:lentocpage){
	cat(" ", page)
	thepage=readLines(paste0(pageHeader, page))
	theWholepage = c(theWholepage , thepage)
}

sink(theFilename)
cat(theWholepage, sep = "\n")
sink()
