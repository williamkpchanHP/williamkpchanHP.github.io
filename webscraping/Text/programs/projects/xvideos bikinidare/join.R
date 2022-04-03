setwd("C:/Users/user/mpg/Text/programs/projects/xvideos bikinidare")
theImg = readLines("AllimgList.txt")
theahref = readLines("xvideos bikinidareAllitems.txt")
totalpages = length(theImg)
lineHeader="<div><a href="
linetail="</div>"
projTitle = "xvideos bikinidare"
sink(paste0(projTitle, "AllVideo.html"))
for (catLine in 1:totalpages){
	thepage = paste0(lineHeader, theahref[catLine], theImg[catLine],linetail)
	cat(thepage, "\n")
}
sink()

#======
