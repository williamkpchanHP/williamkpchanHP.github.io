# https://www.iwantmature.com/popular/gilf/1.html
# https://www.iwantmature.com/popular/pantyhose/17.html

# extract meaty

dirStr = "C:/Users/user/Desktop"
setwd(dirStr)

theFilename = "iwantmature gilf.html"

URLHead = "https://www.iwantmature.com/popular/japanese/"
URLTail = ".html"
newpage = ""

for (i in 1:21){
	cat(i, " ")
	theURL  = paste0(URLHead, i, URLTail)
	thepage = readLines(theURL, warn = F)
   	newpage = c(newpage, thepage)

}

sink(theFilename)
cat(newpage, sep = "\n")
sink()
