# tubedupe
# https://tubedupe.com/video/137260/
# https://tubedupe.com/embed/137260/
# 
# https://tubedupe.com/video/164237/sexy-doctor-adventures/
# https://tubedupe.com/embed/164237
# 
# https://tubedupe.com/2/
# https://tubedupe.com/2017/
# 
# https://tubedupe.com/categories/mature/
# https://tubedupe.com/categories/mature/51/
# 
# start addr
# end addr
# collect
# <div class="block-video">

dirStr = "D:/Dropbox/MyDocs/R misc Jobs/webscraping/Text/programs/projects"
setwd(dirStr)

theFilename = "tubedupe mature.html"

URLHead = "https://tubedupe.com/categories/mature/"
URLTail = "/"
newpage = ""

for (i in 1:51){
	cat(i, " ")
	theURL  = paste0(URLHead, i, URLTail)
	thepage = readLines(theURL, warn = F)
   	newpage = c(newpage, thepage)

}

sink(theFilename)
cat(newpage, sep = "\n")
sink()
